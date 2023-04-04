#include "anomaly_detection/anomaly_detection.h"
#include "anomaly_detection/NN/VAE_HLS.h"
#include "ap_fixed.h"
#include <vector>
#include <cassert>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

// 'bridge' function for Python binding (not for firmware)

void hwint_to_GTobjects(std::vector<int> in, ETMiss& etMiss, EGamma egammas[AD_NEGAMMAS], Muon muons[AD_NMUONS], Jet jets[AD_NJETS]){
    assert((void("Wrong number of inputs"), in.size() == 3*(AD_NEGAMMAS+AD_NMUONS+AD_NJETS+1)));
    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    etMiss.clear();
    etMiss.et.V = in[0];
    etMiss.phi.V = in[2];

    // convert EGamma
    for(int i = 0; i < AD_NEGAMMAS; i++){
        egammas[i] = EGamma::initFromHWInt(in[3*(1 + i) + 0], in[3*(1 + i) + 1], in[3*(1 + i) + 2]);
    }

    // convert Muon
    for(int i = 0; i < AD_NMUONS; i++){
        muons[i] = Muon::initFromHWInt(in[3*(1+AD_NEGAMMAS+i) + 0], in[3*(1+AD_NEGAMMAS+i) + 1], in[3*(1+AD_NEGAMMAS+i) + 2]);
    }

    // convert Jet
    for(int i = 0; i < AD_NJETS; i++){
        jets[i] = Jet::initFromHWInt(in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 0], in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 1], in[3*(1+AD_NEGAMMAS+AD_NMUONS+i) + 2]);
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
double hwint_to_anomaly_score(std::vector<int> in){

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

// 'bridge' function for Python binding (not for firmware)
double objects_to_anomaly_score(ETMiss etMiss, std::vector<EGamma> egammas, std::vector<Muon> muons, std::vector<Jet> jets){

    assert((void("Wrong number of inputs"), egammas.size() == AD_NEGAMMAS));
    assert((void("Wrong number of inputs"), muons.size() == AD_NMUONS));
    assert((void("Wrong number of inputs"), jets.size() == AD_NJETS));
    // Convert ints to GT objects
    EGamma egammas_int[NEGAMMAS];
    Muon muons_int[NMUONS];
    Jet jets_int[NJETS];
    for(int i = 0; i < NEGAMMAS; i++){
        if(i < AD_NEGAMMAS){ egammas_int[i] = egammas[i]; }
        else{ egammas_int[i].clear(); }
    }
    for(int i = 0; i < NMUONS; i++){
        if(i < AD_NMUONS){ muons_int[i] = muons[i]; }
        else{ muons_int[i].clear(); }
    }
    for(int i = 0; i < NJETS; i++){
        if(i < AD_NJETS){ jets_int[i] = jets[i]; }
        else{ jets_int[i].clear(); }
    }

    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    AD_NN_OUT_SQ_T score;
    anomaly_detection(muons_int, jets_int, egammas_int, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, score);
    return (double) score;
}

/*std::vector<AD_NN_IN_T> scale_nn_inputs(std::vector<unscaled_t> unscaled){
    assert((void("Wrong number of inputs"), unscaled.size() == AD_NNNPARTICLES));
    AD_NN_IN_T scaled[AD_NNNINPUTS];
    unscaled_t* unscaled_arr = unscaled.data();
    scaleNNInputs(unscaled_arr, scaled);
    std::vector<AD_NN_IN_T> out(std::begin(scaled), std::end(scaled));
    return out;
}*/

std::vector<AD_NN_OUT_T> nn(std::vector<AD_NN_IN_T> in){
    assert((void("Wrong number of inputs"), in.size() == AD_NNNINPUTS));
    AD_NN_IN_T nn_inputs[AD_NNNINPUTS];
    for(int i = 0; i < AD_NNNINPUTS; i++){
        nn_inputs[i] = in[i];
    }
    AD_NN_OUT_T nn_outputs[AD_NNNOUTPUTS];
    VAE_HLS(nn_inputs, nn_outputs);
    std::vector<AD_NN_OUT_T> out(std::begin(nn_outputs), std::end(nn_outputs));
    return out;
}

AD_NN_OUT_SQ_T nn_loss(std::vector<AD_NN_OUT_T> in){
    assert((void("Wrong number of inputs"), in.size() == AD_NNNOUTPUTS));
    AD_NN_OUT_T nn_outputs[AD_NNNOUTPUTS];
    for(int i = 0; i < AD_NNNOUTPUTS; i++){
        nn_outputs[i] = in[i];
    }
    AD_NN_OUT_SQ_T loss = computeLoss(nn_outputs);
    return loss;
}

namespace py = pybind11;
PYBIND11_MODULE(anomaly_detection_emulation, m){
  m.doc() = "Python bindings for Anomaly Detection at L1T HLS for emulation. Most methods assume an object ordering: ETMiss, 4*EGamma, 4*Muon, 10*Jet";
  m.def("hwint_to_physical", &hwint_to_physical, "GT inputs (in integer hardware units) to physical units");
  m.def("hwint_to_packed", &hwint_to_packed, "GT inputs to packed integers");
  m.def("packed_to_hwint", &packed_to_hwint, "Packed into GT inputs to (pt, eta, phi)");
  m.def("hwint_to_anomaly_score", &hwint_to_anomaly_score, "GT inputs (in integer hardware units) to anomaly score");
  m.def("objects_to_anomaly_score", &objects_to_anomaly_score, "GT inputs (in integer hardware units) to anomaly score");
  //m.def("scale_nn_inputs", &scale_nn_inputs, "inputs to scaled NN inputs (in doubles");
  m.def("nn", &nn, "Scaled NN inputs (in doubles) to NN outputs (in doubles)");
  m.def("nn_loss", &nn_loss, "NN outputs (in doubles) to NN loss score from computeLoss (in doubles)");
  
  py::class_<PxPyPz>(m, "PxPyPz")
    .def_readwrite("px", &PxPyPz::px)
    .def_readwrite("py", &PxPyPz::py)
    .def_readwrite("pz", &PxPyPz::pz);

  py::class_<Muon>(m, "Muon")
    .def_readwrite("pt", &Muon::pt)
    .def_readwrite("eta_extrapolated", &Muon::eta_extrapolated)
    .def_readwrite("phi_extrapolated", &Muon::phi_extrapolated)
    .def("initFromHWInt", &Muon::initFromHWInt)
    .def("pack", &Muon::pack)
    .def("unpack", &Muon::unpack);

  py::class_<EGamma>(m, "EGamma")
    .def_readwrite("et", &EGamma::et)
    .def_readwrite("eta", &EGamma::eta)
    .def_readwrite("phi", &EGamma::phi)
    .def("initFromHWInt", &EGamma::initFromHWInt)
    .def("pack", &EGamma::pack)
    .def("unpack", &EGamma::unpack);

  py::class_<Jet>(m, "Jet")
    .def_readwrite("et", &Jet::et)
    .def_readwrite("eta", &Jet::eta)
    .def_readwrite("phi", &Jet::phi)
    .def("initFromHWInt", &Jet::initFromHWInt)
    .def("pack", &Jet::pack)
    .def("unpack", &Jet::unpack);

  py::class_<ETMiss>(m, "ETMiss")
    .def_readwrite("et", &ETMiss::et)
    .def_readwrite("phi", &ETMiss::phi)
    .def("initFromHWInt", &ETMiss::initFromHWInt)
    .def("pack", &ETMiss::pack)
    .def("unpack", &ETMiss::unpack);

  m.attr("AD_NMUONS") = &AD_NMUONS;
  m.attr("AD_NJETS") = &AD_NJETS;
  m.attr("AD_NEGAMMAS") = &AD_NEGAMMAS;
  m.attr("AD_NTAUS") = &AD_NTAUS;
  m.attr("AD_NNNPARTICLES") = &AD_NNNPARTICLES;
  m.attr("AD_NNNINPUTS") = &AD_NNNINPUTS;
  m.attr("AD_NNNOUTPUTS") = &AD_NNNOUTPUTS;
}

/* 
 * Functions must return Python native types (int, float, double, etc) to be bound
 * This is a shortcut to expose ap_fixed types through double 
 */
#define BIND_AP_TYPE_THRU_DOUBLE(type, name)                                                        \
namespace pybind11 { namespace detail {                                                             \
    template <> struct type_caster<type> {                                                          \
    public:                                                                                         \
        PYBIND11_TYPE_CASTER(type, _(name));                                                        \
        bool load(handle src, bool) {                                                               \
            PyObject *source = src.ptr();                                                           \
            PyObject *tmp = PyNumber_Float(source);                                                 \
            if (!tmp)                                                                               \
                return false;                                                                       \
            value = PyFloat_AsDouble(tmp);                                                          \
            Py_DECREF(tmp);                                                                         \
            return !PyErr_Occurred();                                                               \
        }                                                                                           \
        static handle cast(type src, return_value_policy /* policy */, handle /* parent */) {       \
            return PyFloat_FromDouble(src.to_double());                                             \
        }                                                                                           \
    };                                                                                              \
}} // namespace PYBIND11_NAMESPACE::detail

/* 
 * Functions must return Python native types (int, float, double, etc) to be bound
 * This is a shortcut to expose ap_fixed types through long 
 */
#define BIND_AP_TYPE_THRU_LONG(type, name)                                                          \
namespace pybind11 { namespace detail {                                                             \
    template <> struct type_caster<type> {                                                          \
    public:                                                                                         \
        PYBIND11_TYPE_CASTER(type, _(name));                                                        \
        bool load(handle src, bool) {                                                               \
            PyObject *source = src.ptr();                                                           \
            PyObject *tmp = PyNumber_Long(source);                                                  \
            if (!tmp)                                                                               \
                return false;                                                                       \
            value = PyLong_AsLong(tmp);                                                             \
            Py_DECREF(tmp);                                                                         \
            return !PyErr_Occurred();                                                               \
        }                                                                                           \
        static handle cast(type src, return_value_policy /* policy */, handle /* parent */) {       \
            return PyLong_FromLong(src);                                                            \
        }                                                                                           \
    };                                                                                              \
}} // namespace PYBIND11_NAMESPACE::detail 

// these types are used in data_types
// not sure why BIND_AP_TYPE_THRU_DOUBLE doesn't like ap_ufixed argument, but it doesn't
typedef ap_ufixed<9,8> ap_uf_9_8;
typedef ap_ufixed<11,10> ap_uf_11_10;
typedef ap_ufixed<12,11> ap_uf_12_11;
typedef ap_ufixed<16,14> ap_uf_16_14;
BIND_AP_TYPE_THRU_DOUBLE(ap_uf_9_8, "ap_ufixed<9,8>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uf_11_10, "ap_ufixed<11,10>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uf_12_11, "ap_ufixed<12,11>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uf_16_14, "ap_ufixed<16,14>");

typedef ap_fixed<8,6,AP_RND_CONV,AP_SAT> ap_f_8_6_RND_CONV_SAT;
typedef ap_fixed<10,7> ap_f_10_7;
typedef ap_fixed<10,7,AP_RND_CONV,AP_SAT> ap_f_10_7_RND_CONV_SAT;
typedef ap_fixed<13,8> ap_f_13_8;
typedef ap_fixed<16,13> ap_f_16_13;
typedef ap_fixed<16,15,AP_TRN,AP_SAT> ap_f_16_15_TRN_SAT;
BIND_AP_TYPE_THRU_DOUBLE(ap_f_8_6_RND_CONV_SAT, "ap_fixed<8,6,AP_RND_CONV,AP_SAT>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_10_7, "ap_fixed<10,7>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_10_7_RND_CONV_SAT, "ap_fixed<10,7,AP_RND_CONV,AP_SAT>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_13_8, "ap_fixed<13,8>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_13, "ap_fixed<16,13>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_15_TRN_SAT, "ap_fixed<16,15,AP_TRN,AP_SAT>")

BIND_AP_TYPE_THRU_DOUBLE(ap_uint<4>, "ap_uint<4>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uint<8>, "ap_uint<8>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uint<9>, "ap_uint<9>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uint<10>, "ap_uint<10>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uint<11>, "ap_uint<11>");
BIND_AP_TYPE_THRU_DOUBLE(ap_uint<12>, "ap_uint<12>");
BIND_AP_TYPE_THRU_LONG(ap_uint<32>, "ap_uint<32>");
BIND_AP_TYPE_THRU_LONG(ap_uint<64>, "ap_uint<64>");

BIND_AP_TYPE_THRU_DOUBLE(ap_int<8>, "ap_int<8>");
BIND_AP_TYPE_THRU_DOUBLE(ap_int<9>, "ap_int<9>");
BIND_AP_TYPE_THRU_DOUBLE(ap_int<10>, "ap_int<10>");
BIND_AP_TYPE_THRU_DOUBLE(ap_int<11>, "ap_int<11>");
BIND_AP_TYPE_THRU_DOUBLE(ap_int<12>, "ap_int<12>");
