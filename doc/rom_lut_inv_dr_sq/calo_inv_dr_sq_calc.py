#!/usr/bin/python

import sys
import math
import os

coe_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc")
doc_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/doc/rom_lut_inv_dr_sq")

eta_bin_width=0.087/2
eta_min_bin=-115
eta_max_bin=114
deta_bins=abs(eta_min_bin)+eta_max_bin+1
phi_bins=144
dphi_bins=int(phi_bins/2)
print("created calo LUTs [with full bins => max deta:",deta_bins,", max dphi:",dphi_bins,"]")
# same precision as for calo invariant mass (2*pt_precision+cosh_cos_precision) [=1+1+3]
precision=5

undef="undefined"
inv_dr_sq_fw_lut_arr={}

inv_dr_sq_fw_lut_list=[[0 for x in range(4096)] for x in range(8)]

idx=0
rom_nr=0
max_rom_nr=5
end_emu_file=False

filename=os.path.join(doc_files_path, "emulator_lut_calo_inv_dr_sq_calc.txt")
f_emu = open(filename, "w")
print(f"{'dphi':>5}", f"{'deta':>5}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}",  file=f_emu)

for dphi_msb in range(0,2):
    for deta_msb in range(0,4):
        rom_nr+=1
        if rom_nr == max_rom_nr:
            dphi_idx_range = 16
            deta_idx_range = 256
        elif rom_nr < max_rom_nr:
            dphi_idx_range = 64
            deta_idx_range = 64
        filename=os.path.join(coe_files_path, "lut_calo_inv_dr_sq_rom" + str(rom_nr) + ".coe")
        if rom_nr <= max_rom_nr:
            f = open(filename, "w")
            print("memory_initialization_radix=10;", file=f)
            print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,deta_idx_range):
            for dphi_idx in range(0,dphi_idx_range):
                deta_idx_gl = deta_idx+deta_msb*64
                deta_val = deta_idx_gl*eta_bin_width
                dphi_idx_gl = dphi_idx+dphi_msb*64
                dphi_val = dphi_idx_gl*2*math.pi/phi_bins
                if deta_val == 0 and dphi_val == 0:
                    inv_dr_sq_fw_lut_arr[0] = 0

                    print(f"{dphi_idx:>5}", f"{deta_idx:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}",  file=f_emu)
                else:
                    inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
                    inv_dr_sq_rounded = round(inv_dr_sq,precision)
                    inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
                    inv_dr_sq_fw_lut_arr[idx] = inv_dr_sq_fw_lut


                    if deta_idx_gl == deta_bins and dphi_idx_gl == dphi_bins+1:
                        end_emu_file=True
                        #print("EOF:", end_emu_file, file=f_emu)

                    if not end_emu_file:
                        if deta_idx_gl <= deta_bins and dphi_idx_gl <= dphi_bins:
                            print(f"{dphi_idx_gl:>5}", f"{deta_idx_gl:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}",  file=f_emu)

                if rom_nr <= max_rom_nr:
                    idx_modulo=idx%16
                    if idx_modulo == 15:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                    else:
                        print(inv_dr_sq_fw_lut_arr[idx], end = ',', file=f)

                    inv_dr_sq_fw_lut_list[rom_nr-1].append(inv_dr_sq_fw_lut_arr[idx])

                idx+=1
        if rom_nr <= max_rom_nr:
            print(";", file=f)
        f.close()
f_emu.close()

filename=os.path.join(doc_files_path, "data_width_rom_lut_calo_inv_dr_sq.txt")
f = open(filename, "w")
print("data width of roms for calo 1/DR^2 [with full bins => max deta:",deta_bins,", max dphi:",dphi_bins,"]", file=f)
for rom_nr in range(0, max_rom_nr):
    print("rom_nr", rom_nr+1, ":", max(inv_dr_sq_fw_lut_list[rom_nr]).bit_length(), file=f)
f.close()

