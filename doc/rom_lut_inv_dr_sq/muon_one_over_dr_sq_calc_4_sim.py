#!/usr/bin/python

import math
import os
from constants import muon_eta_bin_width, muon_eta_min_bin, muon_eta_max_bin, muon_eta_factor, muon_phi_bins_reduced, muon_precision

script_path = os.path.dirname(os.path.realpath(__file__))
sim_path_temp = script_path.split('doc')
sim_files_path = os.path.join(sim_path_temp[0], "firmware", "sim")

deta_bins=int((abs(muon_eta_min_bin)+muon_eta_max_bin)/muon_eta_factor)+1
dphi_bins=int(muon_phi_bins_reduced/2)

filename=os.path.join(sim_files_path, "muon_lut_one_over_dr_sq_4_sim.txt")
print("created muon LUT for simulation with reduced bins [max deta:",deta_bins,", max dphi:",dphi_bins,"] at", filename)
f_sim = open(filename, "w")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*muon_eta_bin_width
        dphi_val = dphi_idx*2*math.pi/muon_phi_bins_reduced
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        inv_dr_sq_rounded = round(inv_dr_sq,muon_precision)
        inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**muon_precision),0))
        print(inv_dr_sq_fw_lut, file=f_sim)
f_sim.close()
