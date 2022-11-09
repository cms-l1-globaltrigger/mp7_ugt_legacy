#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"
#include "nnet_utils/nnet_types.h"
#include <cstddef>
#include <cstdio>

//hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 57
#define N_LAYER_3 32
#define N_LAYER_5 16
#define N_LAYER_7 13

//hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<16,6> model_default_t;
typedef ap_fixed<13,8> input_t;
typedef ap_fixed<10,6,AP_RND_CONV,AP_SAT> layer2_t;
typedef ap_fixed<18,8> q_activation_table_t;
typedef ap_fixed<25,16> q_dense_accum_t;
typedef ap_fixed<25,16> layer3_t;
typedef ap_fixed<6,3> weight3_t;
typedef ap_fixed<13,7> bias3_t;
typedef ap_uint<1> layer3_index;
typedef ap_ufixed<13,6,AP_RND_CONV,AP_SAT> layer4_t;
typedef ap_fixed<18,8> q_dense_quantized_relu_table_t;
typedef ap_fixed<27,15> q_dense_1_accum_t;
typedef ap_fixed<27,15> layer5_t;
typedef ap_fixed<6,3> weight5_t;
typedef ap_fixed<13,7> bias5_t;
typedef ap_uint<1> layer5_index;
typedef ap_ufixed<13,6,AP_RND_CONV,AP_SAT> layer6_t;
typedef ap_fixed<18,8> q_dense_1_quantized_relu_table_t;
typedef ap_fixed<26,14> mu_accum_t;
typedef ap_fixed<26,14> layer7_t;
typedef ap_fixed<6,3> weight7_t;
typedef ap_fixed<10,7> bias7_t;
typedef ap_uint<1> layer7_index;
typedef ap_fixed<10,7,AP_RND_CONV,AP_SAT> result_t;
typedef ap_fixed<18,8> mu_quantized_bits_table_t;

#endif
