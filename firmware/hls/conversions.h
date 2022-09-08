#include "data_types.h"

/* ---
 * Conversion functions from GT interface objects to ML interface objects
 * Some code should be shared across the objects with same scales (muons and calos)
 * --- */
PxPyPz MuonToCartesian(Muon x);
PxPyPz JetToCartesian(Jet x);
PxPyPz CaloCommonToCartesian(CaloCommon x);
PxPyPz EGammaToCartesian(EGamma x);
PxPyPz TauToCartesian(Tau x); 
PxPyPz METToCartesian(ETMiss x); 