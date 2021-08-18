#!/usr/bin/python

import sys
import math
import os

coe_file_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc")
#print(coe_file_path)

# double bin width
eta_factor=2
eta_bin_width=0.087/8*eta_factor
eta_min_bin=-225
eta_max_bin=225
deta_bins=int((abs(eta_min_bin)+eta_max_bin)/eta_factor)+1
# same bin width as for calos
phi_factor=4
phi_bins=576
phi_bins_reduced=phi_bins/phi_factor
dphi_bins=int(phi_bins_reduced/2)
print(phi_bins_reduced, dphi_bins)
# same precision as for muon invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+4]
precision=6

idx=0
undef="undefined"

print(f"{'idx':>6}", f"{'dphi_idx':>9}", f"{'deta_idx':>9}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}")

for deta_idx in range(0,deta_bins+1):
    for dphi_idx in range(0,dphi_bins+1):
        deta_val = deta_idx*eta_bin_width
        dphi_val = dphi_idx*2*math.pi/phi_bins_reduced
        if deta_idx == 0 and dphi_idx == 0:
            print(f"{idx:>6}", f"{dphi_idx:>9}", f"{deta_idx:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}")
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
            inv_dr_sq_rounded = round(inv_dr_sq,precision)
            inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
            print(f"{idx:>6}", f"{dphi_idx:>9}", f"{deta_idx:>9}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}")
        idx+=1

print("====================================================================================")

idx=0
inv_dr_sq_fw_lut_arr={}
part=0

for dphi_msb in range(0,2):
    for deta_msb in range(0,4):
        part+=1
        filename=os.path.join(coe_file_path, "rom_lut_muon_inv_dr_sq_part" + str(part) + "_new.coe")
        print("create coe file: ", filename)
        f = open(filename, "w")
        print("memory_initialization_radix=10;", file=f)
        print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,64):
            for dphi_idx in range(0,64):
                deta_val = (deta_idx+deta_msb*64)*eta_bin_width
                dphi_val = (dphi_idx+dphi_msb*64)*2*math.pi/phi_bins_reduced
                if deta_val == 0 and dphi_val == 0:
                    inv_dr_sq_fw_lut_arr[0] = 0
                else:
                    inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
                    inv_dr_sq_rounded = round(inv_dr_sq,precision)
                    inv_dr_sq_fw_lut_arr[idx] = int(round(inv_dr_sq_rounded*(10**precision),0))

                loc_idx=idx-(part-1)*64*64
                for i in range(0,4):
                    j=(i*16)+(deta_idx*64)
                    if loc_idx >= j and loc_idx < j+15:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ', ', file=f)
                    if loc_idx == j+15:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                idx+=1
        print(";", file=f)
        f.close()

print("====================================================================================")

idx=0
inv_dr_sq_fw_lut_arr={}
part=9

filename=os.path.join(coe_file_path, "rom_lut_muon_inv_dr_sq_part" + str(part) + "_new.coe")
print("create coe file: ", filename)
f = open(filename, "w")
print("memory_initialization_radix=10;", file=f)
print("memory_initialization_vector=", file=f)
for deta_idx in range(0,256):
    for dphi_idx in range(0,16):
        deta_val = deta_idx*eta_bin_width
        dphi_val = (dphi_idx+127)*2*math.pi/phi_bins_reduced
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq_fw_lut_arr[0] = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
            inv_dr_sq_rounded = round(inv_dr_sq,precision)
            inv_dr_sq_fw_lut_arr[idx] = int(round(inv_dr_sq_rounded*(10**precision),0))

        for i in range(0,4):
            j=(i*16)+(deta_idx*16)
            if idx >= j and idx < j+15:
                print(inv_dr_sq_fw_lut_arr[idx], end = ', ', file=f)
                #print("zeile 1-3, inv_dr_sq_fw_lut_arr[idx]:", inv_dr_sq_fw_lut_arr[idx])
            if idx == j+15:
                print(inv_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                #print("zeile 4, inv_dr_sq_fw_lut_arr[idx]:", inv_dr_sq_fw_lut_arr[idx])
        idx+=1
print(";", file=f)
f.close()
