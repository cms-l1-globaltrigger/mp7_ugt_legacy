#!/usr/bin/python

import sys
import math
import os

coe_file_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc")

eta_bin_width=0.087/2
eta_min_bin=-115
eta_max_bin=114
deta_bins=abs(eta_min_bin)+eta_max_bin+1
phi_bins=144
dphi_bins=int(phi_bins/2)
# same precision as for calo invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+3]
precision=5

undef="undefined"
inv_dr_sq_fw_lut_arr={}

idx=0
part=0

print(f"{'idx':>6}", f"{'dphi_idx':>9}", f"{'deta_idx':>9}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}")

for dphi_msb in range(0,2):
    for deta_msb in range(0,4):
        part+=1
        filename=os.path.join(coe_file_path, "rom_lut_calo_inv_dr_sq_part" + str(part) + "_new.coe")
        f = open(filename, "w")
        print("memory_initialization_radix=10;", file=f)
        print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,64):
            for dphi_idx in range(0,64):
                deta_idx_gl = deta_idx+deta_msb*64
                deta_val = deta_idx_gl*eta_bin_width
                dphi_idx_gl = dphi_idx+dphi_msb*64
                dphi_val = dphi_idx_gl*2*math.pi/phi_bins
                if deta_val == 0 and dphi_val == 0:
                    inv_dr_sq_fw_lut_arr[0] = 0

                    print(f"{idx:>6}", f"{dphi_idx:>9}", f"{deta_idx:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}")
                else:
                    inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
                    inv_dr_sq_rounded = round(inv_dr_sq,precision)
                    inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
                    inv_dr_sq_fw_lut_arr[idx] = inv_dr_sq_fw_lut

                    if deta_idx_gl <= 230 and dphi_idx_gl <= 72:
                        print(f"{idx:>6}", f"{dphi_idx_gl:>9}", f"{deta_idx_gl:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}")

                loc_idx=idx-(part-1)*64*64
                for i in range(0,4):
                    j=(i*16)+(deta_idx*64)
                    if loc_idx >= j and loc_idx < j+15:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ',', file=f)
                    if loc_idx == j+15:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)

                idx+=1
        print(";", file=f)
        f.close()
