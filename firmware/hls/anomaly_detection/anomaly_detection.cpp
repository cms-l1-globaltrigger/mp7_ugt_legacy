#include "anomaly_detection.h"
#include <stddef.h>
#include "NN/VAE_HLS.h"

AD_NN_OUT_T computeLoss(AD_NN_OUT_T score[AD_NNNOUTPUTS]){
  
  AD_NN_OUT_T loss = 0;

  for (int i = 1; i <= AD_NNNOUTPUTS; i++){
      #pragma HLS unroll
      loss += (score[i] * score[i]);  
    }
  return loss;
}

void anomaly_detection(Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS], Tau taus[NTAUS],
                       ET et, HT ht, ETMiss etmiss, HTMiss htmiss, ETHFMiss ethfmiss, HTHFMiss hthfmiss,
                       AD_NN_OUT_T &anomaly_score){
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
  int iNNIn = 0;
  for(int i = 0; i < AD_NJETS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = JetToCartesian(jets[i]);
  }
  for(int i = 0; i < AD_NEGAMMAS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = EGammaToCartesian(egammas[i]);
  }
  for(int i = 0; i < AD_NMUONS; i++, iNNIn++){
    #pragma HLS unroll
    cartesians[iNNIn] = MuonToCartesian(muons[i]);
  }
  // TODO include taus in training
  // for(int i = 0; i < AD_NTAUS; i++, iNNIn++){
  //   #pragma HLS unroll
  //   cartesians[iNNIn] = TauToCartesian(taus[i]);
  // }
   cartesians[AD_NNNPARTICLES-1] = METToCartesian(etmiss);

  // 'unroll' particles (px, py, pz) to flat array of NN inputs
  AD_NN_IN_T nn_inputs[AD_NNNINPUTS];
  // TODO Vitis HLS complains if the array_partition pragma is left in. Why?
  //#pragma HLS array_partition variable=nn_inputs complete

  for(int i = 0; i < AD_NNNPARTICLES; i++){
    #pragma HLS unroll
    nn_inputs[3*i + 0] = cartesians[i].px;
    nn_inputs[3*i + 1] = cartesians[i].py;
    nn_inputs[3*i + 2] = cartesians[i].pz;
  }

  AD_NN_OUT_T nnout[AD_NNNOUTPUTS];
  #pragma HLS array_partition variable=nnout complete
  VAE_HLS(nn_inputs, nnout);
  anomaly_score = computeLoss(nnout);
}