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

#ifndef NNET_DENSE_LATENCY_H_
#define NNET_DENSE_LATENCY_H_

#include "nnet_common.h"
#include "nnet_mult.h"
#include "nnet_helpers.h"
#include "hls_stream.h"
#include <math.h>

namespace nnet {

template<class data_T, class res_T, typename CONFIG_T>
void dense_latency(
    data_T    data[CONFIG_T::n_in],
    res_T     res[CONFIG_T::n_out],
    typename CONFIG_T::weight_t  weights[CONFIG_T::n_in*CONFIG_T::n_out],
    typename CONFIG_T::bias_t    biases[CONFIG_T::n_out])
{
    data_T cache;
    typename CONFIG_T::accum_t mult[CONFIG_T::n_in*CONFIG_T::n_out];
    typename CONFIG_T::accum_t acc[CONFIG_T::n_out];

    // Use a function_instantiate in case it helps to explicitly optimize unchanging weights/biases
    #pragma HLS function_instantiate variable=weights,biases

    // Do the matrix-multiply
    Product1: for(int ii = 0; ii < CONFIG_T::n_in; ii++) {
        #pragma HLS PIPELINE
        cache = data[ii];
        Product2: for(int jj = 0; jj < CONFIG_T::n_out; jj++) {
            if (CONFIG_T::io_type == io_serial) {
                int multiplier_limit  = ceil(float(CONFIG_T::n_out) / float(CONFIG_T::reuse_factor));
                CONFIG_T::template product<data_T, typename CONFIG_T::weight_t, typename CONFIG_T::accum_t>::limit(multiplier_limit);
            }
        int index = ii*CONFIG_T::n_out+jj;
        mult[index] = CONFIG_T::template product<data_T, typename CONFIG_T::weight_t, typename CONFIG_T::accum_t>::product(cache, weights[index]);
        }
    }

    // Initialize accumulator with input biases
    ResetAccum: for(int iacc = 0; iacc < CONFIG_T::n_out; iacc++) {
        acc[iacc] = (typename CONFIG_T::accum_t) biases[iacc];
    }

    // Accumulate multiplication result
    Accum1: for(int ii = 0; ii < CONFIG_T::n_in; ii++) {
        Accum2: for(int jj = 0; jj < CONFIG_T::n_out; jj++) {
        int index = ii*CONFIG_T::n_out+jj;
        acc[jj] += mult[index];
        }
    }

    // Cast to "res_t" type
    Result: for(int ires = 0; ires < CONFIG_T::n_out; ires++){
        //res[ires] = (res_T) (acc[ires]);
        res[ires] = cast<data_T, res_T, CONFIG_T>(acc[ires]);
    }
}

template<class data_T, class res_T, typename CONFIG_T, int P>
void mult_line_buffer(
    data_T    data[P][CONFIG_T::n_in],
    res_T     res[P][CONFIG_T::n_out],
    typename CONFIG_T::weight_t  weights[CONFIG_T::n_in*CONFIG_T::n_out],
    typename CONFIG_T::bias_t    biases[CONFIG_T::n_out])
{
    #pragma HLS INLINE

    data_T cache[P];
    typename CONFIG_T::accum_t mult[P][CONFIG_T::n_in*CONFIG_T::n_out];
    typename CONFIG_T::accum_t acc[P][CONFIG_T::n_out];

    #pragma HLS PIPELINE II=CONFIG_T::reuse_factor

    #pragma HLS ARRAY_PARTITION variable=weights complete
    #pragma HLS ARRAY_PARTITION variable=biases complete
    #pragma HLS ARRAY_PARTITION variable=cache complete
    #pragma HLS ARRAY_PARTITION variable=mult complete dim=0
    #pragma HLS ARRAY_PARTITION variable=acc complete dim=0

    constexpr unsigned multiplier_limit = DIV_ROUNDUP(CONFIG_T::n_in*CONFIG_T::n_out, CONFIG_T::reuse_factor) - (CONFIG_T::n_zeros / CONFIG_T::reuse_factor);
    #pragma HLS ALLOCATION instances=product limit=multiplier_limit function

    Product1: for(int ii = 0; ii < CONFIG_T::n_in; ii++) {
        for(int p = 0; p < P; p++) {
            #pragma HLS UNROLL
            cache[p] = data[p][ii];
        }
        Product2: for(int jj = 0; jj < CONFIG_T::n_out; jj++) {
            int index = ii*CONFIG_T::n_out+jj;
            for(int p = 0; p < P; p++) {
                #pragma HLS UNROLL
                cache[p] = data[p][ii];
                mult[p][index] = CONFIG_T::template product<data_T, typename CONFIG_T::weight_t, typename CONFIG_T::accum_t>::product(cache[p], weights[index]);
            }
        }
    }

    // Initialize accumulator with input biases
    ResetAccum: for(int iacc = 0; iacc < CONFIG_T::n_out; iacc++) {
        for(int p = 0; p < P; p++) {
            #pragma HLS UNROLL
            acc[p][iacc] = (typename CONFIG_T::accum_t) biases[iacc];
        }
    }

    // Accumulate multiplication result
    Accum1: for(int ii = 0; ii < CONFIG_T::n_in; ii++) {
        Accum2: for(int jj = 0; jj < CONFIG_T::n_out; jj++) {
            int index = ii*CONFIG_T::n_out+jj;
            for(int p = 0; p < P; p++) {
                #pragma HLS UNROLL
                acc[p][jj] += mult[p][index];
            }
        }
    }

    // Cast to "res_t" type
    Result: for(int ires = 0; ires < CONFIG_T::n_out; ires++){
        for(int p = 0; p < P; p++) {
            #pragma HLS UNROLL
            res[p][ires] = cast<data_T, res_T, CONFIG_T>(acc[p][ires]);
        }
    }
}

}

#endif
