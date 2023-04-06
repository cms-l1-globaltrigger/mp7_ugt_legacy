#ifndef __TPT_SCALES_H
#define __TPT_SCALES_H

#include "topo_trigger.h"

static const int32_t tpt_shift[TPT_NNNINPUTS] = {8,5,7,5,5,6,5,5,5,5,5,5,5,5,5,6,7,3,5,6,6,4,5,4,4,5};

static const int32_t tpt_offsets[TPT_NNNINPUTS] = { 90, 72,138,  0, 71, 89,  0, 68, 61,  0, 64, 44,  0, 58, 15,  0, 71,  1,
   0, 20, 29,  0, 62,  9,  0, 49};

#endif