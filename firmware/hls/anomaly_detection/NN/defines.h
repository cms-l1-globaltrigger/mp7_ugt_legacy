#ifndef DEFINES_H_
#define DEFINES_H_

#include "ap_int.h"
#include "ap_fixed.h"
#include <cstddef>
#include <cstdio>

//hls-fpga-machine-learning insert numbers
#define N_INPUT_1_1 57
#define N_LAYER_3 32
#define N_LAYER_5 16
#define N_LAYER_7 13

//hls-fpga-machine-learning insert layer-precision
typedef ap_fixed<13,8> model_default_t;
typedef ap_fixed<13,8> input_t;
typedef ap_fixed<13,8> layer3_t;
typedef ap_fixed<6,3> weight3_t;
typedef ap_fixed<13,7> bias3_t;
typedef ap_uint<1> layer3_index;
typedef ap_fixed<13,8> layer4_t;
typedef ap_fixed<18,8> q_dense_quantized_relu_table_t;
typedef ap_fixed<13,8> layer5_t;
typedef ap_fixed<6,3> weight5_t;
typedef ap_fixed<13,7> bias5_t;
typedef ap_uint<1> layer5_index;
typedef ap_fixed<13,8> layer6_t;
typedef ap_fixed<18,8> q_dense_1_quantized_relu_table_t;
typedef ap_fixed<13,8> result_t;
typedef ap_fixed<6,3> weight7_t;
typedef ap_fixed<10,7> bias7_t;
typedef ap_uint<1> layer7_index;

#endif
