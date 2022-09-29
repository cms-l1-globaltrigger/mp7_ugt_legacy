#include "anomaly_detection.h"
#include <math.h> 

#define NTEST 1

struct momvector3 {
    float px, py, pz;
    float pt, eta, phi;
    
    inline void clear(){
      px = 0;
      py = 0;
      pz = 0;
      pt = 0;
      eta = 0;
      phi = 0;
      
    }
};
  
typedef struct momvector3 PxPyPz_float;
  
PxPyPz_float ObjToCartesian(float pt_in,float eta_in,float phi_in)
{
    PxPyPz_float vec;
    vec.pt  = pt_in;
    vec.eta = eta_in;
    vec.phi = phi_in;
    vec.px = pt_in * cos(phi_in); //phi in radians
    vec.py = pt_in * sin(phi_in); //phi in radians
    vec.pz = pt_in * sinh(eta_in); //eta in radians

    return vec;
    
}

int main() {
   

    int test = 0;
    
    // Reference values
    
    // Open test file
    FILE *dump = fopen("test_input.txt","r"); 
    if (!dump) return 3;
    printf("Opened dump file\n");


    while (!feof(dump) && (++test <= NTEST)) {
      std::cout<< "Starting test = " << test << std::endl;
      
      Muon muons[AD_NMUONS];
      Jet jets[AD_NJETS];
      EGamma egammas[AD_NEGAMMAS];
      Tau taus[AD_NTAUS];
      ETMiss met;
       
      int ev,nobjs, njets, nmuons, negamma;
      float pt_in, eta_in, phi_in;
      if (fscanf(dump, "Event %d with %d objects, %d jets, %d muons, %d electrons and MET\n", &ev, &nobjs, &njets, &nmuons, &negamma) != 5) return 2;
      
      PxPyPz_float cartesians_truth[AD_NNNPARTICLES];
      PxPyPz cartesians[AD_NNNPARTICLES];
      std::string obj_name[AD_NNNPARTICLES];
      
      for(int i = 0; i < AD_NNNPARTICLES; i++){
        cartesians[i].clear();
        cartesians_truth[i].clear();
      }
      int iNNIn = 0;
      for(int i = 0; i < AD_NJETS; i++, iNNIn++){
        if (fscanf(dump, "   jet  pt %f eta %f phi %f", &pt_in, &eta_in, &phi_in) != 3) return 2;
        printf("   jet  pt %f eta %f phi %f \n", pt_in, eta_in, phi_in);
        jets[i].et.V  = pt_in;
        jets[i].eta.V = eta_in;
        jets[i].phi.V = phi_in;
        cartesians[iNNIn] = JetToCartesian(jets[i]);
        cartesians_truth[iNNIn] = ObjToCartesian(pt_in, eta_in*Scales::CALO_ETA_LSB, phi_in*Scales::CALO_PHI_LSB);
        obj_name[iNNIn] = "jet" + std::to_string(i);
      }
      for(int i = 0; i < AD_NEGAMMAS; i++, iNNIn++){
        if (fscanf(dump, "   egamma  pt %f eta %f phi %f", &pt_in, &eta_in, &phi_in) != 3) return 2;
        printf("   egamma  pt %f eta %f phi %f \n", pt_in, eta_in, phi_in);
        egammas[i].et.V  = pt_in;
        egammas[i].eta.V = eta_in;
        egammas[i].phi.V = phi_in;
        cartesians[iNNIn] = EGammaToCartesian(egammas[i]);
        cartesians_truth[iNNIn] = ObjToCartesian(pt_in, eta_in*Scales::CALO_ETA_LSB, phi_in*Scales::CALO_PHI_LSB);
        obj_name[iNNIn] = "egamma" + std::to_string(i);
      }
      for(int i = 0; i < AD_NMUONS; i++, iNNIn++){
          if (fscanf(dump, "   muon  pt %f eta %f phi %f", &pt_in, &eta_in, &phi_in) != 3) return 2;
          printf("   muon  pt %f eta %f phi %f \n", pt_in, eta_in, phi_in);
          muons[i].pt.V  = pt_in;
          muons[i].eta_extrapolated.V = eta_in;
          muons[i].phi_extrapolated.V = phi_in;
          cartesians[iNNIn] = MuonToCartesian(muons[i]);
          cartesians_truth[iNNIn] = ObjToCartesian(pt_in, eta_in*Scales::MUON_ETA_LSB, phi_in*Scales::MUON_PHI_LSB);
          obj_name[iNNIn] = "muon" + std::to_string(i);
        }
      if (fscanf(dump, "   MET  pt %f eta %f phi %f\n", &pt_in, &eta_in, &phi_in) != 3) return 2;
      printf("   MET  pt %f eta %f phi %f \n", pt_in, eta_in, phi_in);
      met.et.V = pt_in;
      met.phi.V = phi_in;
      cartesians[AD_NNNPARTICLES-1] = METToCartesian(met);
      cartesians_truth[AD_NNNPARTICLES-1] = ObjToCartesian(pt_in, 0., phi_in*Scales::CALO_PHI_LSB);
      obj_name[AD_NNNPARTICLES-1] = "MET";
      
      std::cout << "TEST : " << test << std::endl;
      for(int i = 0; i < AD_NNNPARTICLES; i++){
        std::cout <<"INPUT: " << obj_name[i] <<  std::endl;
        std::cout <<"pt = " << cartesians_truth[i].pt << "  eta = " << cartesians_truth[i].eta <<"  phi = " << cartesians_truth[i].phi <<  std::endl;
        std::cout <<obj_name[i] << ": px TRUTH = " << cartesians_truth[i].px << "      HLS = " << cartesians[i].px << std::endl;
        std::cout <<obj_name[i] << ": py TRUTH = " << cartesians_truth[i].py << "      HLS = " << cartesians[i].py << std::endl;
        std::cout <<obj_name[i] << ": pz TRUTH = " << cartesians_truth[i].pz << "      HLS = " << cartesians[i].pz << "\n" << std::endl;
      }
    }


    printf("Completed all %d tests\n", NTEST);
    return 0;
}