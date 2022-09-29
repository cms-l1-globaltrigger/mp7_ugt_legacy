#include "anomaly_detection.h"

void anomaly_detection_nn(AD_NN_IN_T nn_inputs[AD_NNNINPUTS], AD_NN_OUT_T &anomaly_score){
  // TODO - this function is a placeholder that does some operation on the inputs, 
  // so that the module can be synthesized without being optimized away
  // It should be replaced with the function call to the real Neural Network
  AD_NN_OUT_T nn_out = 0;
  for(int i = 0; i < AD_NNNINPUTS; i++){
    #pragma HLS unroll
    nn_out += nn_inputs[i];
  }
  anomaly_score = nn_out;
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

  // TODO this is only here while the computation is dummy
  // to force the generated HDL to include a clock port
  #pragma HLS latency min=2 max=2

  // pipeline everything
  #pragma HLS pipeline II=1

  // inline everything so there are no function call overheads
  #pragma HLS inline off

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
  #pragma HLS array_partition variable=nn_inputs complete

  for(int i = 0; i < AD_NNNPARTICLES; i++){
    #pragma HLS unroll
    nn_inputs[3*i + 0] = cartesians[i].px;
    nn_inputs[3*i + 1] = cartesians[i].py;
    nn_inputs[3*i + 2] = cartesians[i].pz;
  }
 

  anomaly_detection_nn(nn_inputs, anomaly_score);

}