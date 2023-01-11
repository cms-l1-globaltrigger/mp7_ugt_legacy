#ifndef __ADT_SCALES_H
#define __ADT_SCALES_H

#include "anomaly_detection.h"

static const int32_t ad_shift[AD_NNNINPUTS] = {
    4, 4, 0, 3, 2, 4, 2, 2, 3, 1, 1, 3, 1, 1, 3, 1, 1,
    3, -1, -1, 1, -3, -3, -1, -5, -5, -3, 5, 5, 8, 4, 4, 7, 4,
    4, 7, 3, 3, 6, 3, 3, 5, 2, 2, 5, 2, 2, 4, 1, 1, 4,
    1, 1, 3, 0, 0, 2};

typedef ap_fixed<3, 3> ad_offset_t;
static const ad_offset_t ad_offsets[AD_NNNINPUTS] = {
    -3, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0,
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0};

#endif