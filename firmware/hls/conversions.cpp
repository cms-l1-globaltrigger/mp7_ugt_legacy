#include "conversions.h"

/* ---
 * Conversion functions from GT interface objects to ML interface objects
 * Some code should be shared across the objects with same scales (muons and calos)
 * --- */
PxPyPz MuonToCartesian(Muon x){
  PxPyPz y;
  y.clear();
  // TODO real implementation
  y.px = x.pt; y.py = x.pt; y.pz = x.pt;
  return y;
}

PxPyPz JetToCartesian(Jet x){
  PxPyPz y;
  y.clear();
  // TODO real implementation
  y.px = x.et; y.py = x.et; y.pz = x.et;
  return y;
}

PxPyPz CaloCommonToCartesian(CaloCommon x){
  PxPyPz y;
  y.clear();
  // TODO real implementation
  y.px = x.et; y.py = x.et; y.pz = x.et;
  return y;
}

PxPyPz EGammaToCartesian(EGamma x){
  return CaloCommonToCartesian(x);
}

PxPyPz TauToCartesian(Tau x){
  return CaloCommonToCartesian(x);
}