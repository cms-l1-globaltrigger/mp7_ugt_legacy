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

// 'bridge' function for Python binding (not for firmware)
std::vector<double> hwint_to_pxpypz(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    PxPyPz pxpypz[3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)];

    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    ETMiss etMiss;
    etMiss.et.V = in[0];
    etMiss.phi.V = in[2];
    pxpypz[0] = METToCartesian(etMiss);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        EGamma egamma;
        egamma.et.V = in[3*(1 + i) + 0];
        egamma.eta.V = in[3*(1 + i) + 1];
        egamma.phi.V = in[3*(1 + i) + 2];
        pxpypz[1+i] = EGammaToCartesian(egamma);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        Muon muon;
        muon.pt.V = in[3*(1+AD_NEGAMMAS+i) + 0];
        muon.eta_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 1];
        muon.phi_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 2];
        pxpypz[1 + AD_NEGAMMAS + i] = MuonToCartesian(muon);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        Jet jet;
        jet.et.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 0];
        jet.eta.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 1];
        jet.phi.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 2];
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

// 'bridge' function for Python binding (not for firmware)
std::vector<double> hwint_to_physical(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets
    std::vector<double> phys;

    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    ETMiss etMiss;
    etMiss.et.V = in[0];
    etMiss.phi.V = in[2];
    phys.push_back(etMiss.et);
    phys.push_back(0.);
    phys.push_back(etMiss.phi * Scales::CALO_PHI_LSB);

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        EGamma egamma;
        egamma.et.V = in[3*(1 + i) + 0];
        egamma.eta.V = in[3*(1 + i) + 1];
        egamma.phi.V = in[3*(1 + i) + 2];
        phys.push_back(egamma.et);
        phys.push_back(egamma.eta * Scales::CALO_ETA_LSB);
        phys.push_back(egamma.phi * Scales::CALO_PHI_LSB);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        Muon muon;
        muon.pt.V = in[3*(1+AD_NEGAMMAS+i) + 0];
        muon.eta_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 1];
        muon.phi_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 2];
        phys.push_back(muon.pt);
        phys.push_back(muon.eta_extrapolated * Scales::MUON_ETA_LSB);
        phys.push_back(muon.phi_extrapolated * Scales::MUON_PHI_LSB);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        Jet jet;
        jet.et.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 0];
        jet.eta.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 1];
        jet.phi.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 2];
        phys.push_back(jet.et);
        phys.push_back(jet.eta * Scales::CALO_ETA_LSB);
        phys.push_back(jet.phi * Scales::CALO_PHI_LSB);
    }
    return phys;
}

// 'bridge' function for Python binding (not for firmware)
double anomaly_score(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets

    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    ETMiss etMiss;
    etMiss.et.V = in[0];
    etMiss.phi.V = in[2];

    // convert EGamma
    EGamma egamma[NEGAMMAS];
    for(int i = 0; i < AD_NEGAMMAS; i++){
        egamma[i].et.V = in[3*(1 + i) + 0];
        egamma[i].eta.V = in[3*(1 + i) + 1];
        egamma[i].phi.V = in[3*(1 + i) + 2];
    }

    // convert Muon
    Muon muon[NMUONS];
    for(int i = 0; i < AD_NMUONS; i++){
        muon[i].pt.V = in[3*(1+AD_NEGAMMAS+i) + 0];
        muon[i].eta_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 1];
        muon[i].phi_extrapolated.V = in[3*(1+AD_NEGAMMAS+i) + 2];
    }

    // convert Jet
    Jet jet[NJETS];
    for(int i = 0; i < AD_NJETS; i++){
        jet[i].et.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 0];
        jet[i].eta.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 1];
        jet[i].phi.V = in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 2];
    }

    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    AD_NN_OUT_T score;
    anomaly_detection(muon, jet, egamma, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, score);
    return score;
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
    AD_NN_OUT_T loss = computeLoss(nn_outputs);
    return (double) loss;
}

namespace py = pybind11;
PYBIND11_MODULE(anomaly_detection_emulation, m){
  m.doc() = "Python bindings for Anomaly Detection at L1T HLS for emulation";
  m.def("physical_to_pxpypz", &physical_to_pxpypz, "GT inputs (in physical units) to (px, py, pz)");
  m.def("hwint_to_pxpypz", &hwint_to_pxpypz, "GT inputs (in integer hardware units) to (px, py, pz)");
  m.def("hwint_to_physical", &hwint_to_physical, "GT inputs (in integer hardware units) to physical units");
  m.def("anomaly_score", &anomaly_score, "GT inputs (in integer hardware units) to anomaly score");
  m.def("nn", &nn, "(px, py, pz) NN inputs (in doubles) to NN outputs (in doubles)");
  m.def("nn_loss", &nn_loss, "NN outputs (in doubles) to NN loss score from computeLoss (in doubles)");
}