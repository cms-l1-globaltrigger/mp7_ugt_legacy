#!/usr/bin/python

import sys
import math
import os

sim_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/sim")

# double bin width
eta_factor=2
eta_bin_width=0.087/8*eta_factor
eta_min_bin=-225
eta_max_bin=225
deta_bins=int((abs(eta_min_bin)+eta_max_bin)/eta_factor)+1
# same bin width as for calos
phi_factor=2
phi_bins=576
phi_bins_reduced=int(phi_bins/phi_factor)
dphi_bins=int(phi_bins_reduced/2)
print("created muon LUTs with reduced bins [max deta:",deta_bins,", max dphi:",dphi_bins,"]")
# same precision as for muon invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+4]
precision=6

filename=os.path.join(sim_files_path, "muon_lut_one_over_dr_sq_4_sim.txt")
f_sim = open(filename, "w")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*eta_bin_width
        dphi_val = dphi_idx*2*math.pi/phi_bins_reduced
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        inv_dr_sq_rounded = round(inv_dr_sq,precision)
        inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
        print(inv_dr_sq_fw_lut, file=f_sim)
f_sim.close()
