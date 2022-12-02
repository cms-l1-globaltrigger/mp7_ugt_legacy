#include "conversions.h"
#include "anomaly_detection/anomaly_detection.h"
#include "anomaly_detection/NN/VAE_HLS.h"
#include <vector>
#include <cassert>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

// 'bridge' function for Python binding (not for firmware)
std::vector<double> physical_to_pxpypz(std::vector<double> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    PxPyPz pxpypz[3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)];

    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    ETMiss etMiss = ETMiss::initFromPhysicalDoubles(in[0], in[2]);
    pxpypz[0] = METToCartesian(etMiss);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        EGamma egamma = EGamma::initFromPhysicalDoubles(in[1 + i + 0],
                                                        in[1 + i + 1],
                                                        in[1 + i + 2]);
        pxpypz[1+i] = EGammaToCartesian(egamma);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        Muon muon = Muon::initFromPhysicalDoubles(in[(1+AD_NEGAMMAS) + i + 0],
                                                  in[(1+AD_NEGAMMAS) + i + 1],
                                                  in[(1+AD_NEGAMMAS) + i + 2]);
        pxpypz[1 + AD_NEGAMMAS + i] = MuonToCartesian(muon);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        Jet jet = Jet::initFromPhysicalDoubles(in[(1+AD_NEGAMMAS+AD_NMUONS) + i + 0],
                                               in[(1+AD_NEGAMMAS+AD_NMUONS) + i + 1],
                                               in[(1+AD_NEGAMMAS+AD_NMUONS) + i + 2]);
        pxpypz[1 + AD_NEGAMMAS + AD_NMUONS + i] = JetToCartesian(jet);
    }

    // write output
    std::vector<double> out;
    for(int i = 0; i < AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1; i++){
        out.push_back(pxpypz[i].px);
        out.push_back(pxpypz[i].py);
        out.push_back(pxpypz[i].pz);
    }
    return out;
}

void hwint_to_GTobjects(std::vector<int> in, ETMiss& etMiss, EGamma egammas[AD_NEGAMMAS], Muon muons[AD_NMUONS], Jet jets[AD_NJETS]){
    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    etMiss.clear();
    etMiss.et.V = in[0];
    etMiss.phi.V = in[2];

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        egammas[i].clear();
        egammas[i].et.V = in[3*(1 + i) + 0];
        egammas[i].eta.V = in[3*(1 + i) + 1];
        egammas[i].phi.V = in[3*(1 + i) + 2];
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        muons[i].clear();
        muons[i].pt.V = in[3*(1+AD_NEGAMMAS+i) + 0];
        muons[i].eta_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 1];
        muons[i].phi_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 2];
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        jets[i].clear();
        jets[i].et.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 0];
        jets[i].eta.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 1];
        jets[i].phi.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 2];
    }
}

void packed_to_GTObjects(std::vector<uint64_t> in, ETMiss& etMiss, EGamma egammas[AD_NEGAMMAS], Muon muons[AD_NMUONS], Jet jets[AD_NJETS]){
    assert((void("Wrong number of inputs"), in.size() == (AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    etMiss.initFromBits(in[0]);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        egammas[i].initFromBits(in[1 + i]);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        muons[i].initFromBits(in[1+AD_NEGAMMAS+i]);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        jets[i].initFromBits(in[1+AD_NEGAMMAS+AD_NMUONS+i]);
    }
}

// 'bridge' function for Python binding (not for firmware)
std::vector<double> hwint_to_pxpypz(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    PxPyPz pxpypz[3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)];

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[AD_NEGAMMAS];
    Muon muons[AD_NMUONS];
    Jet jets[AD_NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    pxpypz[0] = METToCartesian(etMiss);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        pxpypz[1+i] = EGammaToCartesian(egammas[i]);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        pxpypz[1 + AD_NEGAMMAS + i] = MuonToCartesian(muons[i]);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        pxpypz[1 + AD_NEGAMMAS + AD_NMUONS + i] = JetToCartesian(jets[i]);
    }

    // write output
    std::vector<double> out;
    for(int i = 0; i < AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1; i++){
        out.push_back(pxpypz[i].px);
        out.push_back(pxpypz[i].py);
        out.push_back(pxpypz[i].pz);
    }
    return out;
}

// 'bridge' function for Python binding (not for firmware)
std::vector<double> hwint_to_physical(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    std::vector<double> phys;

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[AD_NEGAMMAS];
    Muon muons[AD_NMUONS];
    Jet jets[AD_NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    phys.push_back(etMiss.et);
    phys.push_back(0.);
    phys.push_back(etMiss.phi * Scales::CALO_PHI_LSB);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        phys.push_back(egammas[i].et);
        phys.push_back(egammas[i].eta * Scales::CALO_ETA_LSB);
        phys.push_back(egammas[i].phi * Scales::CALO_PHI_LSB);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        phys.push_back(muons[i].pt);
        phys.push_back(muons[i].eta_extrapolated * Scales::MUON_ETA_LSB);
        phys.push_back(muons[i].phi_extrapolated * Scales::MUON_PHI_LSB);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        phys.push_back(jets[i].et);
        phys.push_back(jets[i].eta * Scales::CALO_ETA_LSB);
        phys.push_back(jets[i].phi * Scales::CALO_PHI_LSB);
    }
    return phys;
}

// 'bridge' function for Python binding (not for firmware)
std::vector<uint64_t> hwint_to_packed(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    // return their packed bits

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[AD_NEGAMMAS];
    Muon muons[AD_NMUONS];
    Jet jets[AD_NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    std::vector<uint64_t> out;

    out.push_back(etMiss.pack());
    // write EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        out.push_back(egammas[i].pack());
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        out.push_back(muons[i].pack());
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        out.push_back(jets[i].pack());
    }
    return out;
}

// 'bridge' function for Python binding (not for firmware)
std::vector<int> packed_to_hwint(std::vector<uint64_t> in){

    assert((void("Wrong number of inputs"), in.size() == (AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read packed integers for each of (in order): MET, electrons, muons, jets
    // return their packed bits

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[AD_NEGAMMAS];
    Muon muons[AD_NMUONS];
    Jet jets[AD_NJETS];
    packed_to_GTObjects(in, etMiss, egammas, muons, jets);

    std::vector<int> out;

    out.push_back(etMiss.et.V);
    out.push_back(0);
    out.push_back(etMiss.phi.V);

    // write EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        out.push_back(egammas[i].et.V);
        out.push_back(egammas[i].eta.V);
        out.push_back(egammas[i].phi.V);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        out.push_back(muons[i].pt.V);
        out.push_back(muons[i].eta_extrapolated.V);
        out.push_back(muons[i].phi_extrapolated.V);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        out.push_back(jets[i].et.V);
        out.push_back(jets[i].eta.V);
        out.push_back(jets[i].phi.V);
    }
    return out;
}

// 'bridge' function for Python binding (not for firmware)
double anomaly_score(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[NEGAMMAS];
    Muon muons[NMUONS];
    Jet jets[NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    AD_NN_OUT_SQ_T score;
    anomaly_detection(muons, jets, egammas, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, score);
    return (double) score;
}

std::vector<double> scale_nn_inputs(std::vector<double> pxpypz){
    assert((void("Wrong number of inputs"), pxpypz.size() == AD_NNNINPUTS));
    pxpypz_t unscaled[AD_NNNINPUTS];
    AD_NN_IN_T scaled[AD_NNNINPUTS];
    for(int i = 0; i < AD_NNNINPUTS; i++){
        unscaled[i] = pxpypz[i];
    }
    scaleNNInputs(unscaled, scaled);
    std::vector<double> out;
    out.resize(AD_NNNINPUTS);
    for(int i = 0; i < AD_NNNINPUTS; i++){
        out[i] = scaled[i];
    }
    return out;
}

std::vector<double> nn(std::vector<double> in){
    assert((void("Wrong number of inputs"), in.size() == AD_NNNINPUTS));
    AD_NN_IN_T nn_inputs[AD_NNNINPUTS];
    for(int i = 0; i < AD_NNNINPUTS; i++){
        nn_inputs[i] = in[i];
    }
    AD_NN_OUT_T nn_outputs[AD_NNNOUTPUTS];
    VAE_HLS(nn_inputs, nn_outputs);
    std::vector<double> out(AD_NNNOUTPUTS);
    for(int i = 0; i < AD_NNNOUTPUTS; i++){
        out[i] = nn_outputs[i];
    }
    return out;
}

double nn_loss(std::vector<double> in){
    assert((void("Wrong number of inputs"), in.size() == AD_NNNOUTPUTS));
    AD_NN_OUT_T nn_outputs[AD_NNNOUTPUTS];
    for(int i = 0; i < AD_NNNOUTPUTS; i++){
        nn_outputs[i] = in[i];
    }
    AD_NN_OUT_SQ_T loss = computeLoss(nn_outputs);
    return (double) loss;
}

namespace py = pybind11;
PYBIND11_MODULE(anomaly_detection_emulation, m){
  m.doc() = "Python bindings for Anomaly Detection at L1T HLS for emulation. Most methods assume an object ordering: ETMiss, 4*EGamma, 4*Muon, 10*Jet";
  m.def("physical_to_pxpypz", &physical_to_pxpypz, "GT inputs (in physical units) to (px, py, pz)");
  m.def("hwint_to_pxpypz", &hwint_to_pxpypz, "GT inputs (in integer hardware units) to (px, py, pz)");
  m.def("hwint_to_physical", &hwint_to_physical, "GT inputs (in integer hardware units) to physical units");
  m.def("hwint_to_packed", &hwint_to_packed, "GT inputs to packed integers");
  m.def("packed_to_hwint", &packed_to_hwint, "Packed into GT inputs to (pt, eta, phi)");
  m.def("anomaly_score", &anomaly_score, "GT inputs (in integer hardware units) to anomaly score");
  m.def("scale_nn_inputs", &scale_nn_inputs, "(px, py, pz) to scaled NN inputs (in doubles");
  m.def("nn", &nn, "Scaled (px, py, pz) NN inputs (in doubles) to NN outputs (in doubles)");
  m.def("nn_loss", &nn_loss, "NN outputs (in doubles) to NN loss score from computeLoss (in doubles)");
}