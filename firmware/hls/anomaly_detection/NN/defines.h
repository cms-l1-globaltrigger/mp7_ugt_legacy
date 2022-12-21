#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"
#include "nnet_utils/nnet_types.h"
#include <cstddef>
#include <cstdio>

// hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 57
#define N_LAYER_2 32
#define N_LAYER_4 16
#define N_LAYER_6 13

// hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<11, 6> input_3_accum_t;
typedef ap_fixed<8, 6, AP_RND_CONV, AP_SAT> input_t;
typedef ap_fixed<13, 8> q_dense_accum_t;
typedef ap_fixed<12, 8> layer2_t;
typedef ap_fixed<6, 3> weight2_t;
typedef ap_fixed<11, 7> bias2_t;
typedef ap_uint<1> layer2_index;
typedef ap_fixed<13, 8> model_default_t;
typedef ap_ufixed<11, 7> layer3_t;
typedef ap_fixed<18, 8> q_dense_quantized_relu_table_t;
typedef ap_fixed<14, 9> q_dense_1_accum_t;
typedef ap_fixed<13, 9> layer4_t;
typedef ap_fixed<6, 3> weight4_t;
typedef ap_fixed<11, 7> bias4_t;
typedef ap_uint<1> layer4_index;
typedef ap_ufixed<11, 7> layer5_t;
typedef ap_fixed<18, 8> q_dense_1_quantized_relu_table_t;
typedef ap_fixed<12, 8> mu_accum_t;
typedef ap_fixed<11, 8> layer6_t;
typedef ap_fixed<6, 3> weight6_t;
typedef ap_fixed<10, 7> bias6_t;
typedef ap_uint<1> layer6_index;
typedef ap_fixed<10, 7> result_t;
typedef ap_fixed<18, 8> mu_quantized_bits_table_t;

#endif
