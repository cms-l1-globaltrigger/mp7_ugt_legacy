#ifndef __ADT_SCALES_H
#define __ADT_SCALES_H

#include "anomaly_detection.h"

static const int32_t ad_shift[AD_NNNINPUTS] = {
    5, 0, 5, 3, 5, 6, 2, 5, 6, 1, 5, 6, 1, 5, 5, 1, 6, 7, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 5, 5, 6, 4, 5, 6, 4, 5, 6, 4, 4, 6, 4, 4, 5, 3, 4,
    5, 3, 3, 5, 2, 0, 4, 0, 0, 0, 0, 0, 0};

typedef ap_fixed<8, 8> ad_offset_t;
static const ad_offset_t ad_offsets[AD_NNNINPUTS] = {
    42, 0, 72, 10, 0, 68, 6, 0, 67, 4, 1, 64, 3,
    -6, 62, 4, 1, 160, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 53, 0, 70, 31, 0, 68, 24, 1, 68, 20, 1, 66,
    17, 0, 64, 14, 1, 58, 10, 1, 48, 6, 0, 30, 0,
    0, 0, 0, 0, 0};

#endif