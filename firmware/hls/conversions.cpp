#include "conversions.h"
#include <hls_math.h>
/* ---
 * Conversion functions from GT interface objects to ML interface objects
 * Some code should be shared across the objects with same scales (muons and calos)
 * --- */

//  Look-up-tables: Muon
template<class data_T, class table_T, int N>
void init_sinphi_muon_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::MUON_PHI_LSB;
        table_T sin_x = std::sin(x);
        table_out[i] = sin_x;
    }
}
template<class in_t, class table_t, int N>
table_t sine_with_conversion_muon(ap_uint<10> phi){
    table_t sin_table[N];
    init_sinphi_muon_table<in_t, table_t, N>(sin_table);
    table_t out = sin_table[phi];
    return out; 
}

template<class data_T, class table_T, int N>
void init_sinh_muon_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::MUON_ETA_LSB;
        table_T sinh_x = std::sinh(x);
        table_out[i] = sinh_x;
    }
}
template<class in_t, class table_t, int N>
table_t sinh_with_conversion_muon(ap_int<9> eta){
    table_t sinh_table[N];
    init_sinh_muon_table<in_t, table_t, N>(sinh_table);
    table_t out = sinh_table[eta];
    return out; 
}

//  Look-up-tables: Jet
template<class data_T, class table_T, int N>
void init_sinphi_jet_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::CALO_PHI_LSB;
        table_T sin_x = std::sin(x);
        table_out[i] = sin_x;
    }
}
template<class in_t, class table_t, int N>
table_t sine_with_conversion_jet(ap_uint<8> phi){
    table_t sin_table[N];
    init_sinphi_jet_table<in_t, table_t, N>(sin_table);
    table_t out = sin_table[phi];
    return out; 
}

// Sinh table
template<class data_T, class table_T, int N>
void init_sinh_jet_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::CALO_ETA_LSB;
        table_T sinh_x = std::sinh(x);
        table_out[i] = sinh_x;
    }
}
template<class in_t, class table_t, int N>
table_t sinh_with_conversion_jet(ap_int<8> eta){
    table_t sinh_table[N];
    init_sinh_jet_table<in_t, table_t, N>(sinh_table);
    table_t out = sinh_table[eta];
    return out; 
}

//  Look-up-tables: EGamma
template<class data_T, class table_T, int N>
void init_sinphi_egamma_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::CALO_PHI_LSB;
        table_T sin_x = std::sin(x);
        table_out[i] = sin_x;
    }
}
template<class in_t, class table_t, int N>
table_t sine_with_conversion_egamma(ap_uint<8> phi){
    table_t sin_table[N];
    init_sinphi_egamma_table<in_t, table_t, N>(sin_table);
    table_t out = sin_table[phi];
    return out; 
}

// Sinh table
template<class data_T, class table_T, int N>
void init_sinh_egamma_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::CALO_ETA_LSB;
        table_T sinh_x = std::sinh(x);
        table_out[i] = sinh_x;
    }
}
template<class in_t, class table_t, int N>
table_t sinh_with_conversion_egamma(ap_int<8> eta){
    table_t sinh_table[N];
    init_sinh_egamma_table<in_t, table_t, N>(sinh_table);
    table_t out = sinh_table[eta];
    return out; 
}

//  Look-up-tables: MET
template<class data_T, class table_T, int N>
void init_sinphi_MET_table(table_T table_out[N]){
    for(int i = 0; i < N; i++){
        float x = i*Scales::CALO_PHI_LSB;
        table_T sin_x = std::sin(x);
        table_out[i] = sin_x;
    }
}
template<class in_t, class table_t, int N>
table_t sine_with_conversion_MET(ap_uint<8> phi){
    table_t sin_table[N];
    init_sinphi_MET_table<in_t, table_t, N>(sin_table);
    table_t out = sin_table[phi];
    return out; 
}


PxPyPz MuonToCartesian(Muon x){
  #pragma HLS inline off
  PxPyPz y;
  y.clear();

  bool sign_eta = x.eta_extrapolated.sign();
  
  ap_uint<10> phi =  x.phi_extrapolated; //Only store values for positive phi, pick up sign later
  ap_int<9> eta   =  hls::abs(x.eta_extrapolated); //Only store values for positive eta, pick up sign later

  cossin_t sinphi = sine_with_conversion_muon<ap_uint<10>, cossin_t, N_TABLE>(phi);
  cossin_t cosphi = sine_with_conversion_muon<ap_uint<10>, cossin_t, N_TABLE>(phi+90*2);
  sinh_t  sinheta = sinh_with_conversion_muon<ap_int<9>  , sinh_t  , N_TABLE>(eta);

  sinheta = (sign_eta > 0) ? (sinh_t) (-sign_eta*sinheta) : sinheta; // Change sign bit if eta is negative, sinh(-x)=-sin(x)

  y.py = x.pt * sinphi;
  y.px = x.pt * cosphi;
  y.pz = x.pt * sinheta;
  
  return y;
}

PxPyPz JetToCartesian(Jet x){
  #pragma HLS inline off
  PxPyPz y;
  y.clear();

  bool sign_eta = x.eta.sign();
  
  ap_uint<8> phi =  x.phi;
  ap_int<8> eta   =  hls::abs(x.eta); //Only store values for positive eta, pick up sign later

  cossin_t sinphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi);
  cossin_t cosphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi+90*2);
  sinh_t  sinheta = sinh_with_conversion_jet<ap_int<8>, sinh_t  , N_TABLE>(eta);

  sinheta = (sign_eta > 0) ? (sinh_t) (-sign_eta*sinheta) : sinheta; // Change sign bit if eta is negative, sinh(-x)=-sin(x)

  y.py = x.et * sinphi;
  y.px = x.et * cosphi;
  y.pz = x.et * sinheta;
  
  return y;
}

PxPyPz CaloCommonToCartesian(CaloCommon x){
  #pragma HLS inline off
  PxPyPz y;
  y.clear();

  bool sign_phi = x.phi.sign();
  bool sign_eta = x.eta.sign();
  
  ap_uint<8> phi =  x.phi; //Only store values for positive phi, pick up sign later
  ap_int<8> eta   =  hls::abs(x.eta); //Only store values for positive eta, pick up sign later
  cossin_t sinphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi);
  cossin_t cosphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi+90*2);
  sinh_t  sinheta = sinh_with_conversion_jet<ap_int<8>  , sinh_t  , N_TABLE>(eta);

  sinheta = (sign_eta > 0) ? (sinh_t) (-sign_eta*sinheta) : sinheta; // Change sign bit if eta is negative, sinh(-x)=-sin(x)

  y.py = x.et * sinphi;
  y.px = x.et * cosphi;
  y.pz = x.et * sinheta;
  
  return y;
}

PxPyPz EGammaToCartesian(EGamma x){
  return CaloCommonToCartesian(x);
}

PxPyPz TauToCartesian(Tau x){
  return CaloCommonToCartesian(x);
}

PxPyPz METToCartesian(ETMiss x){
  #pragma HLS inline off
  PxPyPz y;
  y.clear();
  
  ap_uint<8> phi =  x.phi; //Only store values for positive phi, pick up sign later
  cossin_t sinphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi);
  cossin_t cosphi = sine_with_conversion_jet<ap_uint<8>, cossin_t, N_TABLE>(phi+90*2);
  
  y.py = x.et * sinphi;
  y.px = x.et * cosphi;
  y.pz = 0.;
  
  return y;
}