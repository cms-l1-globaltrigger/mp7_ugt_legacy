#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"

//hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 57
#define N_LAYER_2 32
#define N_LAYER_5 16
#define N_LAYER_8 4
#define N_LAYER_10 4
#define KL_LOSS_12 1

//hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<8,8> model_default_t;
typedef ap_fixed<8,8,AP_RND_CONV,AP_SAT> input_t;
typedef ap_fixed<16,6> q_dense_12_accum_t;
typedef ap_fixed<16,6> layer2_t;
typedef ap_fixed<8,1> weight2_t;
typedef ap_fixed<8,2> bias2_t;
typedef ap_fixed<8,8,AP_RND,AP_SAT> layer3_t;
typedef ap_fixed<8,1,AP_RND,AP_SAT> layer4_t;
typedef ap_fixed<16,6> q_dense_13_accum_t;
typedef ap_fixed<16,6> layer5_t;
typedef ap_fixed<8,2> weight5_t;
typedef ap_fixed<8,1> bias5_t;
typedef ap_fixed<8,8,AP_RND,AP_SAT> layer6_t;
typedef ap_fixed<8,1,AP_RND,AP_SAT> layer7_t;
typedef ap_fixed<16,6> q_dense_14_accum_t;
typedef ap_fixed<16,6> layer8_t;
typedef ap_fixed<8,3> weight8_t;
typedef ap_fixed<8,1> bias8_t;
typedef ap_fixed<8,8,AP_RND,AP_SAT> layer9_t;
typedef ap_fixed<16,6> q_dense_15_accum_t;
typedef ap_fixed<16,6> layer10_t;
typedef ap_fixed<8,2> weight10_t;
typedef ap_fixed<8,1> bias10_t;
typedef ap_fixed<8,8,AP_RND,AP_SAT> layer11_t;
typedef ap_fixed<16,6> kl_loss_1_accum_t;
typedef ap_fixed<16,6,AP_RND,AP_SAT> result_t;

#endif
