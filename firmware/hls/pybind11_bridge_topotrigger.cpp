#include "topotrigger/topo_trigger.h"
#include "topotrigger/NN/TOPO_HLS.h"
#include "ap_fixed.h"
#include <vector>
#include <cassert>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

// 'bridge' function for Python binding (not for firmware)

void hwint_to_GTobjects(std::vector<int> in, ETMiss& etMiss, EGamma egammas[TPT_NEGAMMAS], Muon muons[TPT_NMUONS], Jet jets[TPT_NJETS]){
    
    assert((void("Wrong number of inputs"), in.size() == 2 + 3 * (TPT_NEGAMMAS + TPT_NMUONS + TPT_NJETS)  ));
    
    // convert ETMiss
    etMiss.clear();
    etMiss.et.V = in[0];
    etMiss.phi.V = in[1];
    
    int particle = 0;
    // convert Jet
    for(int i = 0; i < TPT_NJETS; i++){
        jets[i] = Jet::initFromHWInt(in[ 2 + (particle * 3) ], in[ 3 + (particle * 3) ], in[ 4 + (particle * 3) ]);
        particle++;
    }
    // convert Muon
    for(int i = 0; i < TPT_NMUONS; i++){
        muons[i] = Muon::initFromHWInt(in[ 2 + (particle * 3) ], in[ 3 + (particle * 3) ], in[ 4 + (particle * 3) ]);
        particle++;
    }
    // convert EGamma
    for(int i = 0; i < TPT_NEGAMMAS; i++){
        egammas[i] = EGamma::initFromHWInt(in[ 2 + (particle * 3) ], in[ 3 + (particle * 3) ], in[ 4 + (particle * 3) ]);
        particle++;
    }



}

void packed_to_GTObjects(std::vector<uint64_t> in, ETMiss& etMiss, EGamma egammas[TPT_NEGAMMAS], Muon muons[TPT_NMUONS], Jet jets[TPT_NJETS]){
    
    assert((void("Wrong number of inputs"), in.size() == (TPT_NEGAMMAS+TPT_NMUONS+TPT_NJETS+1)));

    // convert ETMiss
    // note ETMiss eta expected at in[1], but not used
    etMiss.initFromBits(in[0]);

    // convert Jet
    for(int i = 0; i < TPT_NJETS; i++){
        jets[i].initFromBits(in[1+i]);
    }
    // convert Muon
    for(int i = 0; i < TPT_NMUONS; i++){
        muons[i].initFromBits(in[1+TPT_NJETS+i]);
    }
    // convert EGamma
    for(int i = 0; i < TPT_NEGAMMAS; i++){
        egammas[i].initFromBits(in[1+TPT_NJETS+TPT_NMUONS+i]);
    }

    
}

// 'bridge' function for Python binding (not for firmware)
std::vector<double> hwint_to_physical(std::vector<int> in){
    
    assert((void("Wrong number of inputs"), in.size() == 2 + 3 * (TPT_NEGAMMAS + TPT_NMUONS + TPT_NJETS)  ));
    
    // read MET pt, MET phi, then (pT, eta, phi) for each of (in order): jets, muons, egs
    std::vector<double> phys;

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[TPT_NEGAMMAS];
    Muon muons[TPT_NMUONS];
    Jet jets[TPT_NJETS];
    
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    phys.push_back(etMiss.et);
    phys.push_back(etMiss.phi * Scales::CALO_PHI_LSB);
    
    
    // convert Jet
    for(int i = 0; i < TPT_NJETS; i++){
        phys.push_back(jets[i].et);
        phys.push_back(jets[i].eta * Scales::CALO_ETA_LSB);
        phys.push_back(jets[i].phi * Scales::CALO_PHI_LSB);
    }
    // convert Muon
    for(int i = 0; i < TPT_NMUONS; i++){
        phys.push_back(muons[i].pt);
        phys.push_back(muons[i].eta_extrapolated * Scales::MUON_ETA_LSB);
        phys.push_back(muons[i].phi_extrapolated * Scales::MUON_PHI_LSB);
    }

    // convert EGamma
    for(int i = 0; i < TPT_NEGAMMAS; i++){
        phys.push_back(egammas[i].et);
        phys.push_back(egammas[i].eta * Scales::CALO_ETA_LSB);
        phys.push_back(egammas[i].phi * Scales::CALO_PHI_LSB);
    }
    
    return phys;

}

// 'bridge' function for Python binding (not for firmware)
std::vector<uint64_t> hwint_to_packed(std::vector<int> in){


    assert((void("Wrong number of inputs"), in.size() == 2 + 3 * (TPT_NEGAMMAS + TPT_NMUONS + TPT_NJETS)  ));

    // read MET pt, MET phi, then (pT, eta, phi) for each of (in order): jets, muons, egs
    // return their packed bits

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[TPT_NEGAMMAS];
    Muon muons[TPT_NMUONS];
    Jet jets[TPT_NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    std::vector<uint64_t> out;
    
    out.push_back(etMiss.pack());
 
    
    // convert Jet
    for(int i = 0; i < TPT_NJETS; i++){
        out.push_back(jets[i].pack());
    }
    
    // convert Muon
    for(int i = 0; i < TPT_NMUONS; i++){
        out.push_back(muons[i].pack());
    }

    // write EGamma
    for(int i = 0; i < TPT_NEGAMMAS; i++){
        out.push_back(egammas[i].pack());
    }
    
    return out;
}


// 'bridge' function for Python binding (not for firmware)
std::vector<int> packed_to_hwint(std::vector<uint64_t> in){

    assert((void("Wrong number of inputs"), in.size() == (TPT_NEGAMMAS+TPT_NMUONS+TPT_NJETS+1)));
    // read packed integers for each of (in order): MET, electrons, muons, jets
    // return their packed bits

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[TPT_NEGAMMAS];
    Muon muons[TPT_NMUONS];
    Jet jets[TPT_NJETS];
    packed_to_GTObjects(in, etMiss, egammas, muons, jets);

    std::vector<int> out;

    out.push_back(etMiss.et.V);
    out.push_back(etMiss.phi.V);
    
    
    // convert Jet
    for(int i = 0; i < TPT_NJETS; i++){
        out.push_back(jets[i].et.V);
        out.push_back(jets[i].eta.V);
        out.push_back(jets[i].phi.V);
    }
    
    // convert Muon
    for(int i = 0; i < TPT_NMUONS; i++){
        out.push_back(muons[i].pt.V);
        out.push_back(muons[i].eta_extrapolated.V);
        out.push_back(muons[i].phi_extrapolated.V);
    }
    // write EGamma
    for(int i = 0; i < TPT_NEGAMMAS; i++){
        out.push_back(egammas[i].et.V);
        out.push_back(egammas[i].eta.V);
        out.push_back(egammas[i].phi.V);
    }

    return out;

}


std::vector<double> hwint_scaling(std::vector<int> in) {
    
    assert((void("Wrong number of inputs"), in.size() == 2 + 3 * (TPT_NEGAMMAS + TPT_NMUONS + TPT_NJETS)  ));
    
    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[NEGAMMAS];
    Muon muons[NMUONS];
    Jet jets[NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);
    
    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    
    unscaled_t nn_inputs_unscaled[TPT_NNNINPUTS];
    unroll_particles(muons, jets, egammas, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, nn_inputs_unscaled);
    
    TPT_NN_IN_T nn_inputs[TPT_NNNINPUTS];
    scaleNNInputs(nn_inputs_unscaled, nn_inputs);
    
    // we need to convert back to a vector to return
    std::vector<double> out;
    for (int i = 0; i < TPT_NNNINPUTS; i++) {
        out.push_back(nn_inputs[i]);
    }
    
    return out;
    
}


// 'bridge' function for Python binding (not for firmware)
double hwint_to_topo_score(std::vector<int> in){

    assert((void("Wrong number of inputs"), in.size() == 2 + 3 * (TPT_NEGAMMAS + TPT_NMUONS + TPT_NJETS)  ));
    // read (pT, eta, phi) for each of (in order): MET, electrons, muons, jets

    // Convert ints to GT objects
    ETMiss etMiss;
    EGamma egammas[NEGAMMAS];
    Muon muons[NMUONS];
    Jet jets[NJETS];
    hwint_to_GTobjects(in, etMiss, egammas, muons, jets);

    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    
    TPT_NN_OUT_T score;
    topo_trigger(muons, jets, egammas, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, score);
    return (double) score;
    
}


// 'bridge' function for Python binding (not for firmware)
double objects_to_topo_score(ETMiss etMiss, std::vector<EGamma> egammas, std::vector<Muon> muons, std::vector<Jet> jets){

    assert((void("Wrong number of inputs"), egammas.size() == TPT_NEGAMMAS));
    assert((void("Wrong number of inputs"), muons.size() == TPT_NMUONS));
    assert((void("Wrong number of inputs"), jets.size() == TPT_NJETS));
    
    // Convert ints to GT objects
    EGamma egammas_int[NEGAMMAS];
    Muon muons_int[NMUONS];
    Jet jets_int[NJETS];
    for(int i = 0; i < NJETS; i++){
        if(i < TPT_NJETS){ jets_int[i] = jets[i]; }
        else{ jets_int[i].clear(); }
    }
    for(int i = 0; i < NMUONS; i++){
        if(i < TPT_NMUONS){ muons_int[i] = muons[i]; }
        else{ muons_int[i].clear(); }
    }
    for(int i = 0; i < NEGAMMAS; i++){
        if(i < TPT_NEGAMMAS){ egammas_int[i] = egammas[i]; }
        else{ egammas_int[i].clear(); }
    }

    // the unused inputs
    Tau taus[NTAUS]; ET et; HT ht; HTMiss htmiss; ETHFMiss ethfmiss; HTHFMiss hthfmiss; 
    
    TPT_NN_OUT_T score;
    topo_trigger(muons_int, jets_int, egammas_int, taus, et, ht, etMiss, htmiss, ethfmiss, hthfmiss, score);
    return (double) score;
    
}


std::vector<TPT_NN_OUT_T> nn(std::vector<TPT_NN_IN_T> in){
    assert((void("Wrong number of inputs"), in.size() == TPT_NNNINPUTS));
    TPT_NN_IN_T nn_inputs[TPT_NNNINPUTS];
    for(int i = 0; i < TPT_NNNINPUTS; i++){
        nn_inputs[i] = in[i];
    }
    TPT_NN_OUT_T nn_outputs[TPT_NNNOUTPUT];
    TOPO_HLS(nn_inputs, nn_outputs, TPT_SIZE_IN, TPT_SIZE_OUT);
    std::vector<TPT_NN_OUT_T> out(std::begin(nn_outputs), std::end(nn_outputs));
    return out;
}


namespace py = pybind11;
PYBIND11_MODULE(topotrigger_emulation, m){
  m.doc() = "Python bindings for topo trigger Detection at L1T HLS for emulation. Most methods assume an object ordering: ETMiss, 4*EGamma, 4*Muon, 10*Jet";
  m.def("hwint_to_physical", &hwint_to_physical, "GT inputs (in integer hardware units) to physical units");
  m.def("hwint_to_packed", &hwint_to_packed, "GT inputs to packed integers");
  m.def("packed_to_hwint", &packed_to_hwint, "Packed into GT inputs to (pt, eta, phi)");
  m.def("hwint_to_topo_score", &hwint_to_topo_score, "GT inputs (in integer hardware units) to topo score");
  m.def("objects_to_topo_score", &objects_to_topo_score, "GT inputs (in integer hardware units) to topo score");
  //m.def("scale_nn_inputs", &scale_nn_inputs, "inputs to scaled NN inputs (in doubles");
  m.def("nn", &nn, "Scaled NN inputs (in doubles) to NN outputs (in doubles)");
  m.def("hwint_scaling", &hwint_scaling, "hwints normalization");

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

  m.attr("TPT_NMUONS") = &TPT_NMUONS;
  m.attr("TPT_NJETS") = &TPT_NJETS;
  m.attr("TPT_NEGAMMAS") = &TPT_NEGAMMAS;
  m.attr("TPT_NNNPARTICLES") = &TPT_NNNPARTICLES;
  m.attr("TPT_NNNINPUTS") = &TPT_NNNINPUTS;
  m.attr("TPT_NNNOUTPUT") = &TPT_NNNOUTPUT;
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
typedef ap_fixed<16, 6> ap_f_16_6;
typedef ap_fixed<16, 6, AP_RND, AP_SAT> ap_f_16_6_RND_SAT;
BIND_AP_TYPE_THRU_DOUBLE(ap_f_8_6_RND_CONV_SAT, "ap_fixed<8,6,AP_RND_CONV,AP_SAT>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_10_7, "ap_fixed<10,7>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_10_7_RND_CONV_SAT, "ap_fixed<10,7,AP_RND_CONV,AP_SAT>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_13_8, "ap_fixed<13,8>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_13, "ap_fixed<16,13>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_15_TRN_SAT, "ap_fixed<16,15,AP_TRN,AP_SAT>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_6, "ap_fixed<16, 6>")
BIND_AP_TYPE_THRU_DOUBLE(ap_f_16_6_RND_SAT, "ap_fixed<16, 6, AP_RND, AP_SAT>")

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
