#include "anomaly_detection.h"
#include <stddef.h>
#include "NN/VAE_HLS.h"
#include "NN/nnet_utils/nnet_common.h"
#include "scales.h"

AD_NN_OUT_SQ_T computeLoss(AD_NN_OUT_T score[AD_NNNOUTPUTS]){
  #pragma HLS pipeline
  //#pragma HLS inline off
  AD_NN_OUT_SQ_T squares[AD_NNNOUTPUTS];
  #pragma HLS array_partition variable=squares complete
  AD_NN_OUT_SQ_T square_sum;


  for (int i = 0; i < AD_NNNOUTPUTS; i++){
    #pragma HLS unroll
    AD_NN_OUT_SQ_T sq = score[i] * score[i];  
    #pragma hls bind_op variable=sq op=mul impl=fabric
    squares[i] = sq;
  }

  nnet::Op_max<AD_NN_OUT_SQ_T> op;
  square_sum = nnet::reduce<AD_NN_OUT_SQ_T, AD_NNNOUTPUTS, nnet::Op_max<AD_NN_OUT_SQ_T>>(squares, op);
  return square_sum;
}

void scaleNNInputs(pxpypz_t unscaled[AD_NNNINPUTS], AD_NN_IN_T scaled[AD_NNNINPUTS]){
  #pragma HLS pipeline
  //#pragma HLS array_partition variable=unscaled complete
  //#pragma HLS array_partition variable=scaled complete
  //#pragma HLS inline off
  for(int i = 0; i < AD_NNNINPUTS; i++){
    #pragma HLS unroll
    AD_NN_IN_T tmp0 = unscaled[i] - ad_offsets[i];
    AD_NN_IN_T tmp1 = tmp0 * ad_scales[i];
    #pragma hls bind_op variable=tmp1 op=mul impl=fabric
    scaled[i] = tmp1;
  }
}

void anomaly_detection(Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS], Tau taus[NTAUS],
                       ET et, HT ht, ETMiss etmiss, HTMiss htmiss, ETHFMiss ethfmiss, HTHFMiss hthfmiss,
                       AD_NN_OUT_SQ_T &anomaly_score){
  // define the interface                                                            
  #pragma HLS aggregate variable=muons compact=bit
  #pragma HLS aggregate variable=jets compact=bit
  #pragma HLS aggregate variable=egammas compact=bit
  #pragma HLS aggregate variable=taus compact=bit 
  #pragma HLS aggregate variable=et compact=bit
  #pragma HLS aggregate variable=ht compact=bit
  #pragma HLS aggregate variable=etmiss compact=bit
  #pragma HLS aggregate variable=htmiss compact=bit
  #pragma HLS aggregate variable=ethfmiss compact=bit
  #pragma HLS aggregate variable=hthfmiss compact=bit
  #pragma HLS array_partition variable=muons complete
  #pragma HLS array_partition variable=jets complete
  #pragma HLS array_partition variable=egammas complete
  #pragma HLS array_partition variable=taus complete 

  // pipeline everything
  #pragma HLS pipeline II=1

  // inline everything so there are no function call overheads
  #pragma HLS inline recursive

  PxPyPz cartesians[AD_NNNPARTICLES];
  #pragma HLS array_partition variable=cartesians complete

  // TODO: implement all these ObjToCartesian functions
  for(int i = 0; i < AD_NNNPARTICLES; i++){
    cartesians[i].clear();
  }
  int iNNIn = 1;
  cartesians[0] = METToCartesian(etmiss);
  for(int i = 0; i < AD_NEGAMMAS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = EGammaToCartesian(egammas[i]);
  }
  for(int i = 0; i < AD_NMUONS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = MuonToCartesian(muons[i]);
  }
  for(int i = 0; i < AD_NJETS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = JetToCartesian(jets[i]);
  }
  // TODO include taus in training
  // for(int i = 0; i < AD_NTAUS; i++, iNNIn++){
  //   #pragma HLS unroll
  //   cartesians[iNNIn] = TauToCartesian(taus[i]);
  // }

  // 'unroll' particles (px, py, pz) to flat array of NN inputs
  pxpypz_t nn_inputs_unscaled[AD_NNNINPUTS];
  AD_NN_IN_T nn_inputs[AD_NNNINPUTS];
  // TODO Vitis HLS complains if the array_partition pragma is left in. Why?
  //#pragma HLS array_partition variable=nn_inputs_unscaled complete
  //#pragma HLS array_partition variable=nn_inputs complete

  for(int i = 0; i < AD_NNNPARTICLES; i++){
    #pragma HLS unroll
    nn_inputs_unscaled[3*i + 0] = cartesians[i].px;
    nn_inputs_unscaled[3*i + 1] = cartesians[i].py;
    nn_inputs_unscaled[3*i + 2] = cartesians[i].pz;
  }

  scaleNNInputs(nn_inputs_unscaled, nn_inputs);

  AD_NN_OUT_T nnout[AD_NNNOUTPUTS];
  #pragma HLS array_partition variable=nnout complete
  VAE_HLS(nn_inputs, nnout);
  anomaly_score = computeLoss(nnout);
}