#ifndef L1GT_TOPO_TRIGGER
#define L1GT_TOPO_TRIGGER

#include "data_types.h"
#include "ap_fixed.h"

// Only the top N of each object are taken
// Assume that they arrive ordered
static const int TPT_NMUONS = 2;
static const int TPT_NEGAMMAS = 2;
static const int TPT_NJETS = 4;

static const int TPT_NNNPARTICLES = 9;                     // this is 4 jets, 2 muons, 2 electrons and one "met"
static const int TPT_NNNINPUTS = 26;                       // total inputs are 26: 2 from MET and 8 * 3 = 24 from particles
static const int TPT_NNNOUTPUT = 1;                        // we only have a single output node

static short unsigned int TPT_SIZE_IN = 26;
static short unsigned int TPT_SIZE_OUT = 1;

// Assumed type for NN inputs (px, py, pz in GeV)
typedef ap_fixed<16, 6> TPT_NN_IN_T; 
typedef ap_fixed<16, 6, AP_RND, AP_SAT> TPT_NN_OUT_T;

void topo_trigger( Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS],
                        Tau taus[NTAUS], ET et, HT ht, ETMiss etmiss, HTMiss htmiss,
                        ETHFMiss ethfmiss, HTHFMiss hthfmiss, TPT_NN_OUT_T &nn_score);

#endif