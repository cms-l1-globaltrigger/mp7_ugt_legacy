#!/usr/bin/python

import sys
import math

# same bin width as for calos
eta_bin_width=0.0435
eta_min_bin=-56
eta_max_bin=56
deta_bins=abs(eta_min_bin)+eta_max_bin+1
phi_min_bin=0
phi_max_bin=143
phi_bins=phi_min_bin+phi_max_bin+1
dphi_bins=int(phi_bins/2)
# same precision as for muon invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+4]
precision=6

idx=0
undef="undefined"

print(f"{'idx':>6}", f"{'dphi_idx':>9}", f"{'deta_idx':>9}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*eta_bin_width
        dphi_val = dphi_idx*2*math.pi/phi_bins
        if deta_idx == 0 and dphi_idx == 0:
            print(f"{idx:>6}", f"{dphi_idx:>9}", f"{deta_idx:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}")
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
            inv_dr_sq_rounded = round(inv_dr_sq,precision)
            inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
            print(f"{idx:>6}", f"{dphi_idx:>9}", f"{deta_idx:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}")
        idx+=1
