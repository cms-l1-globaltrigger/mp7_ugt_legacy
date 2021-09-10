#!/usr/bin/python

import sys
import math
import os

sim_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/sim")

eta_bin_width=0.087/2
eta_min_bin=-115
eta_max_bin=114
deta_bins=abs(eta_min_bin)+eta_max_bin+1
phi_bins=144
dphi_bins=int(phi_bins/2)
print("created calo LUTs [with full bins => max deta:",deta_bins,", max dphi:",dphi_bins,"]")
# same precision as for calo invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+3]
precision=5

filename=os.path.join(sim_files_path, "calo_lut_one_over_dr_sq_4_sim.txt")
f_sim = open(filename, "w")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*eta_bin_width
        dphi_val = dphi_idx*2*math.pi/phi_bins
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        inv_dr_sq_rounded = round(inv_dr_sq,precision)
        inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
        print(inv_dr_sq_fw_lut, file=f_sim)
f_sim.close()
