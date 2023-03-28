#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"
#include "nnet_utils/nnet_types.h"
#include <cstddef>
#include <cstdio>

//hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 26
#define N_LAYER_2 64
#define N_LAYER_5 1

//hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<16,6> model_default_t;
typedef ap_fixed<16,6> input_t;
typedef ap_fixed<16,6> layer2_t;
typedef ap_fixed<6,2> weight2_t;
typedef ap_fixed<6,2> bias2_t;
typedef ap_fixed<16,6,AP_RND,AP_SAT> layer3_t;
typedef ap_ufixed<8,0,AP_RND,AP_SAT> layer4_t;
typedef ap_fixed<16,6> layer5_t;
typedef ap_fixed<6,2> weight5_t;
typedef ap_fixed<6,2> bias5_t;
typedef ap_fixed<16,6,AP_RND,AP_SAT> layer6_t;
typedef ap_fixed<16,6> bothchannel_small_compressed_hw_bitshiftscaler0_sigmoid_default_t;
typedef ap_fixed<16,6,AP_RND,AP_SAT> result_t;

#endif
