//
//    rfnoc-hls-neuralnet: Vivado HLS code for neural-net building blocks
//
//    Copyright (C) 2017 EJ Kreinar
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#include <iostream>

#include "myproject.h"
#include "parameters.h"

void myproject(
    input_t input_7[N_INPUT_1_1],
    result_t layer12_out[KL_LOSS_12],
    unsigned short &const_size_in_1,
    unsigned short &const_size_out_1
) {

    //hls-fpga-machine-learning insert IO
    #pragma HLS ARRAY_RESHAPE variable=input_7 type=complete dim=0
    #pragma HLS ARRAY_PARTITION variable=layer12_out type=complete dim=0
    #pragma HLS INTERFACE ap_vld port=input_7,layer12_out 
    #pragma HLS PIPELINE 

    const_size_in_1 = N_INPUT_1_1;
    const_size_out_1 = KL_LOSS_12;

#ifndef __SYNTHESIS__
    static bool loaded_weights = false;
    if (!loaded_weights) {
        //hls-fpga-machine-learning insert load weights
        nnet::load_weights_from_txt<weight2_t, 1824>(w2, "w2.txt");
        nnet::load_weights_from_txt<bias2_t, 32>(b2, "b2.txt");
        nnet::load_weights_from_txt<weight5_t, 512>(w5, "w5.txt");
        nnet::load_weights_from_txt<bias5_t, 16>(b5, "b5.txt");
        nnet::load_weights_from_txt<weight8_t, 64>(w8, "w8.txt");
        nnet::load_weights_from_txt<bias8_t, 4>(b8, "b8.txt");
        nnet::load_weights_from_txt<weight10_t, 64>(w10, "w10.txt");
        nnet::load_weights_from_txt<bias10_t, 4>(b10, "b10.txt");
        loaded_weights = true;
    }
#endif

    // ****************************************
    // NETWORK INSTANTIATION
    // ****************************************

    //hls-fpga-machine-learning insert layers

    layer2_t layer2_out[N_LAYER_2];
    #pragma HLS ARRAY_PARTITION variable=layer2_out type=complete dim=0
    nnet::dense<input_t, layer2_t, config2>(input_7, layer2_out, w2, b2); // q_dense_12

    layer4_t layer4_out[N_LAYER_2];
    #pragma HLS ARRAY_PARTITION variable=layer4_out type=complete dim=0
    nnet::relu<layer2_t, layer4_t, relu_config4>(layer2_out, layer4_out); // q_activation_6

    layer5_t layer5_out[N_LAYER_5];
    #pragma HLS ARRAY_PARTITION variable=layer5_out type=complete dim=0
    nnet::dense<layer4_t, layer5_t, config5>(layer4_out, layer5_out, w5, b5); // q_dense_13

    layer7_t layer7_out[N_LAYER_5];
    #pragma HLS ARRAY_PARTITION variable=layer7_out type=complete dim=0
    nnet::relu<layer5_t, layer7_t, relu_config7>(layer5_out, layer7_out); // q_activation_7

    layer8_t layer8_out[N_LAYER_8];
    #pragma HLS ARRAY_PARTITION variable=layer8_out type=complete dim=0
    nnet::dense<layer7_t, layer8_t, config8>(layer7_out, layer8_out, w8, b8); // q_dense_14

    layer10_t layer10_out[N_LAYER_10];
    #pragma HLS ARRAY_PARTITION variable=layer10_out type=complete dim=0
    nnet::dense<layer7_t, layer10_t, config10>(layer7_out, layer10_out, w10, b10); // q_dense_15

    nnet::klloss<layer8_t, layer10_t, result_t, config12>(layer8_out, layer10_out, layer12_out); // kl_loss_1

}
