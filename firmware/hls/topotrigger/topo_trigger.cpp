#include "topo_trigger.h"
#include <stddef.h>
#include "NN/TOPO_HLS.h"
#include "NN/nnet_utils/nnet_common.h"
#include "scales.h"

void scaleNNInputs(unscaled_t unscaled[TPT_NNNINPUTS], TPT_NN_IN_T scaled[TPT_NNNINPUTS])
{
#pragma HLS pipeline
  // #pragma HLS array_partition variable=unscaled complete
  // #pragma HLS array_partition variable=scaled complete
  // #pragma HLS inline off
  for (int i = 0; i < TPT_NNNINPUTS; i++)
  {
#pragma HLS unroll
    unscaled_t tmp0 = unscaled[i] - tpt_offsets[i];
    TPT_NN_IN_T tmp1 = tmp0 >> tpt_shift[i];
    // #pragma hls bind_op variable=tmp1 op=shl impl=fabric
    scaled[i] = tmp1;
  }
}

void topo_trigger(Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS], Tau taus[NTAUS],
                       ET et, HT ht, ETMiss etmiss, HTMiss htmiss, ETHFMiss ethfmiss, HTHFMiss hthfmiss,
                       AD_NN_OUT_SQ_T &nn_score)
{

// define the interface
#pragma HLS aggregate variable = muons compact = bit
#pragma HLS aggregate variable = jets compact = bit
#pragma HLS aggregate variable = egammas compact = bit
#pragma HLS aggregate variable = taus compact = bit
#pragma HLS aggregate variable = et compact = bit
#pragma HLS aggregate variable = ht compact = bit
#pragma HLS aggregate variable = etmiss compact = bit
#pragma HLS aggregate variable = htmiss compact = bit
#pragma HLS aggregate variable = ethfmiss compact = bit
#pragma HLS aggregate variable = hthfmiss compact = bit
#pragma HLS array_partition variable = muons complete
#pragma HLS array_partition variable = jets complete
#pragma HLS array_partition variable = egammas complete
#pragma HLS array_partition variable = taus complete

// pipeline everything
#pragma HLS pipeline II = 1

// ask for 2 cycles latency
#pragma HLS latency min=2 max=2                                     // TODO check whether this is correct

// inline everything so there are no function call overheads
#pragma HLS inline recursive

    // 'unroll' particles to flat array of NN inputs
    unscaled_t nn_inputs_unscaled[TPT_NNNINPUTS];
    AD_NN_IN_T nn_inputs[TPT_NNNINPUTS];

    nn_inputs_unscaled[0] = etmiss.et;
    nn_inputs_unscaled[1] = etmiss.phi;

    int iNNIn = 0;
    for (int i = 0; i < AD_NJETS; ++i, ++iNNIn) {
#pragma HLS unroll
        nn_inputs_unscaled[3 * iNNIn + 2] = jets[i].et;
        nn_inputs_unscaled[3 * iNNIn + 3] = jets[i].eta;
        nn_inputs_unscaled[3 * iNNIn + 4] = jets[i].phi;
    }
    for (int i = 0; i < AD_NMUONS; ++i, ++iNNIn) {
#pragma HLS unroll
        nn_inputs_unscaled[3 * iNNIn + 2] = muons[i].pt;
        nn_inputs_unscaled[3 * iNNIn + 3] = muons[i].eta_extrapolated;
        nn_inputs_unscaled[3 * iNNIn + 4] = muons[i].phi_extrapolated;
    }
    for (int i = 0; i < AD_NEGAMMAS; ++i, ++iNNIn) {
#pragma HLS unroll
        nn_inputs_unscaled[3 * iNNIn + 2] = egammas[i].et;
        nn_inputs_unscaled[3 * iNNIn + 3] = egammas[i].eta;
        nn_inputs_unscaled[3 * iNNIn + 4] = egammas[i].phi;
    }

    scaleNNInputs(nn_inputs_unscaled, nn_inputs);
    TPT_NN_OUT_T nnout[TPT_NNNOUTPUT];
#pragma HLS array_partition variable = nnout complete
    TOPO_HLS(nn_inputs, nnout);
    nn_score = nnout[0];                                                // TODO double-check this

}