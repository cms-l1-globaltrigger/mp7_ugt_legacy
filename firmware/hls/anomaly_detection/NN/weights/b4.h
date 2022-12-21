//Numpy array shape [16]
//Min -0.125000000000
//Max 1.750000000000
//Number of zeros 1

#ifndef B4_H_
#define B4_H_

#ifndef __SYNTHESIS__
bias4_t b4[16];
#else
bias4_t b4[16] = {1.0000, 1.3125, 0.7500, 0.3750, 0.5625, 1.5000, 0.0000, -0.0625, 1.1250, 0.6875, 1.5625, 1.2500, -0.1250, 0.0625, 1.7500, 0.9375};
#endif

#endif
