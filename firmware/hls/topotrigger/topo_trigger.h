#ifndef L1GT_TOPO_TRIGGER
#define L1GT_TOPO_TRIGGER

#include "data_types.h"
#include "ap_fixed.h"

// Only the top N of each object are taken
// Assume that they arrive ordered
static const int TPT_NMUONS = 2;
static const int TPT_NJETS = 4;
static const int TPT_NEGAMMAS = 2;

static const int TPT_NNNPARTICLES = 19;                     //TODO
static const int TPT_NNNINPUTS = 26;                        //TODO
static const int TPT_NNNOUTPUT = 1;                       //TODO

// Assumed type for NN inputs (px, py, pz in GeV)
typedef ap_fixed<8, 6, AP_RND_CONV, AP_SAT> TPT_NN_IN_T;    //TODO
typedef ap_fixed<10, 7> TPT_NN_OUT_T;                       //TODO

void topo_trigger( Muon muons[NMUONS], Jet jets[NJETS], EGamma egammas[NEGAMMAS],
                        Tau taus[NTAUS], ET et, HT ht, ETMiss etmiss, HTMiss htmiss,
                        ETHFMiss ethfmiss, HTHFMiss hthfmiss, TPT_NN_OUT_T &nn_score);

#endif