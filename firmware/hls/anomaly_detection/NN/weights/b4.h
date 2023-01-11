//Numpy array shape [16]
//Min -0.500000000000
//Max 2.125000000000
//Number of zeros 0

#ifndef B4_H_
#define B4_H_

#ifndef __SYNTHESIS__
bias4_t b4[16];
#else
bias4_t b4[16] = {0.875, 2.125, 0.625, 1.375, 1.375, 1.875, 1.000, 1.125, 0.625, -0.250, 0.875, 0.875, -0.500, 1.000, 0.875, 0.875};
#endif

#endif
