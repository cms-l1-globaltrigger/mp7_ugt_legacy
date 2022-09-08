#ifndef L1GT_ANOMALY_DETECTION
#define L1GT_ANOMALY_DETECTION

#include "data_types.h"
#include "conversions.h"
#include "ap_fixed.h"

// Only the top N of each object are taken
// Assume that they arrive ordered
static const int AD_NMOUNS = 4;
static const int AD_NJETS = 10;
static const int AD_NEGAMMAS = 4;
static const int AD_NTAUS = 4;

static const int AD_NNNPARTICLES = 19;
static const int AD_NNNINPUTS = 57;

// Assumed type for NN inputs (px, py, pz in GeV)
typedef ap_fixed<12,10> AD_NN_IN_T;
// Assumed type for the NN output (anomaly score)
typedef ap_fixed<16,6> AD_NN_OUT_T;

void anomaly_detection(Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS], Tau taus[NTAUS],
                      ET et, HT ht, ETMiss etmiss, HTMiss htmiss, ETHFMiss ethfmiss, HTHFMiss hthfmiss,
                      AD_NN_OUT_T &anomaly_score);

#endif                       