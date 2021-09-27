#!/usr/bin/python

import math
import os
from constants import calo_eta_bin_width, calo_eta_min_bin, calo_eta_max_bin, calo_phi_bins, calo_precision

script_path = os.path.dirname(os.path.realpath(__file__))
sim_path_temp = script_path.split('doc')
sim_files_path = os.path.join(sim_path_temp[0], "firmware", "sim")

eta_bin_width=calo_eta_bin_width
deta_bins=abs(calo_eta_min_bin)+calo_eta_max_bin+1

dphi_bins=int(calo_phi_bins/2)

filename=os.path.join(sim_files_path, "calo_lut_one_over_dr_sq_4_sim.txt")
print("created calo LUTs [with full bins => max deta:",deta_bins,", max dphi:",dphi_bins,"] at", filename)

f_sim = open(filename, "w")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*calo_eta_bin_width
        dphi_val = dphi_idx*2*math.pi/calo_phi_bins
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        inv_dr_sq_rounded = round(inv_dr_sq,calo_precision)
        inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**calo_precision),0))
        print(inv_dr_sq_fw_lut, file=f_sim)
f_sim.close()
