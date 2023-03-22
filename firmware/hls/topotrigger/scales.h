#ifndef __TPT_SCALES_H
#define __TPT_SCALES_H

#include "topo_trigger.h"

static const int32_t tpt_shift[TPT_NNNINPUTS] = {7,5,6,5,5,6,5,5,5,5,5,4,5,5,5,5,7,3,5,6,5,4,5,3,4,5};

typedef ap_fixed<8, 7> tpt_offset_t;
static const tpt_offset_t tpt_offsets[TPT_NNNINPUTS] = {56,72,89, 0,70,60, 0,67,43, 0,62,32, 0,55,14, 0,57, 1, 0,16,13, 0,60, 5,
  0,44};

#endif