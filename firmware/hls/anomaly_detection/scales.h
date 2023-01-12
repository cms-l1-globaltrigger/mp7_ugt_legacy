#ifndef __ADT_SCALES_H
#define __ADT_SCALES_H

#include "anomaly_detection.h"

static const int32_t ad_shift[AD_NNNINPUTS] = {
    5, 0, 6, 3, 5, 6, 2, 5, 6, 2, 5, 6, 2, 5, 6, 2, 6,
    7, 0, 5, 6, -1, 3, 4, -3, 1, 2, 5, 5, 6, 5, 5, 6, 5,
    5, 6, 4, 5, 6, 4, 5, 6, 4, 4, 6, 3, 4, 5, 3, 4, 5,
    2, 3, 5, 2, 2, 4};

typedef ap_fixed<8, 8> ad_offset_t;
static const ad_offset_t ad_offsets[AD_NNNINPUTS] = {
    36, 0, 74, 9, -1, 64, 5, -2, 51, 3, 1, 37, 2, -1, 24, 1, 0,
    32, 0, 0, 4, 0, 0, 0, 0, 0, 0, 49, 1, 69, 32, 0, 63, 22,
    1, 53, 14, 0, 41, 9, 0, 29, 5, 0, 19, 3, 0, 11, 1, 0, 6,
    1, 0, 3, 0, 0, 1};

#endif