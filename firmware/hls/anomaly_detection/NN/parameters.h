#ifndef PARAMETERS_H_
#define PARAMETERS_H_

#include "ap_int.h"
#include "ap_fixed.h"

#include "nnet_utils/nnet_helpers.h"
// #include "nnet_utils/nnet_code_gen.h"
//hls-fpga-machine-learning insert includes
#include "nnet_utils/nnet_activation.h"
// #include "nnet_utils/nnet_activation_stream.h"
#include "nnet_utils/nnet_dense.h"
// #include "nnet_utils/nnet_dense_compressed.h"
// #include "nnet_utils/nnet_dense_stream.h"
 
//hls-fpga-machine-learning insert weights
#include "weights/w3.h"
#include "weights/b3.h"
#include "weights/w5.h"
#include "weights/b5.h"
#include "weights/w7.h"
#include "weights/b7.h"

//hls-fpga-machine-learning insert layer-config
// q_activation
struct linear_config2 : nnet::activ_config {
    static const unsigned n_in = 57;
    static const unsigned table_size = 1024;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned reuse_factor = 1;
    typedef q_activation_table_t table_t;
};

// q_dense
struct config3 : nnet::dense_config {
    static const unsigned n_in = 57;
    static const unsigned n_out = 32;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned strategy = nnet::latency;
    static const unsigned reuse_factor = 1;
    static const unsigned n_zeros = 1095;
    static const unsigned n_nonzeros = 729;
    static const bool store_weights_in_bram = false;
    typedef q_dense_accum_t accum_t;
    typedef bias3_t bias_t;
    typedef weight3_t weight_t;
    typedef layer3_index index_t;
    template<class x_T, class y_T>
    using product = nnet::product::mult<x_T, y_T>;
};

// q_dense_quantized_relu
struct relu_config4 : nnet::activ_config {
    static const unsigned n_in = 32;
    static const unsigned table_size = 1024;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned reuse_factor = 1;
    typedef q_dense_quantized_relu_table_t table_t;
};

// q_dense_1
struct config5 : nnet::dense_config {
    static const unsigned n_in = 32;
    static const unsigned n_out = 16;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned strategy = nnet::latency;
    static const unsigned reuse_factor = 1;
    static const unsigned n_zeros = 145;
    static const unsigned n_nonzeros = 367;
    static const bool store_weights_in_bram = false;
    typedef q_dense_1_accum_t accum_t;
    typedef bias5_t bias_t;
    typedef weight5_t weight_t;
    typedef layer5_index index_t;
    template<class x_T, class y_T>
    using product = nnet::product::mult<x_T, y_T>;
};

// q_dense_1_quantized_relu
struct relu_config6 : nnet::activ_config {
    static const unsigned n_in = 16;
    static const unsigned table_size = 1024;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned reuse_factor = 1;
    typedef q_dense_1_quantized_relu_table_t table_t;
};

// mu
struct config7 : nnet::dense_config {
    static const unsigned n_in = 16;
    static const unsigned n_out = 13;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned strategy = nnet::latency;
    static const unsigned reuse_factor = 1;
    static const unsigned n_zeros = 51;
    static const unsigned n_nonzeros = 157;
    static const bool store_weights_in_bram = false;
    typedef mu_accum_t accum_t;
    typedef bias7_t bias_t;
    typedef weight7_t weight_t;
    typedef layer7_index index_t;
    template<class x_T, class y_T>
    using product = nnet::product::mult<x_T, y_T>;
};

// mu_quantized_bits
struct linear_config8 : nnet::activ_config {
    static const unsigned n_in = 13;
    static const unsigned table_size = 1024;
    static const unsigned io_type = nnet::io_parallel;
    static const unsigned reuse_factor = 1;
    typedef mu_quantized_bits_table_t table_t;
};


#endif
