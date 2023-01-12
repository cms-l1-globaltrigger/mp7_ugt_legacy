//Numpy array shape [16]
//Min -3.125000000000
//Max 1.625000000000
//Number of zeros 1

#ifndef B4_H_
#define B4_H_

#ifndef __SYNTHESIS__
bias4_t b4[16];
#else
bias4_t b4[16] = {0.875, 0.125, -0.500, -0.125, -0.250, 0.125, 0.500, -3.125, 0.375, 0.500, 0.000, 0.750, 1.625, 0.500, 0.500, -0.875};
#endif

#endif
