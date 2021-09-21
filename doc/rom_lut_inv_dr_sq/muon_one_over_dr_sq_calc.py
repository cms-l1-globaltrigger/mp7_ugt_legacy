#!/usr/bin/python

import sys
import math
import os

coe_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/firmware/ngc")
doc_files_path=os.path.join(os.path.expanduser("~"), "github/cms-l1-globaltrigger/mp7_ugt_legacy/doc/rom_lut_inv_dr_sq")

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

precision=5
print("created muon LUTs with reduced bins [max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",precision,"]")

undef="undefined"
inv_dr_sq_fw_lut_arr={}

idx=0
rom_nr=0
max_rom_nr=6
rom_size=8192
bram_size=18432
muon_objects=8
end_emu_file=False

inv_dr_sq_fw_lut_list=[[0 for x in range(rom_size)] for x in range(max_rom_nr)]

filename_emu=("emulator_lut_muon_one_over_dr_sq_calc.txt")
filepath_emu=os.path.join(doc_files_path, filename_emu)
f_emu = open(filepath_emu, "w")
print(f"{'dphi':>5}", f"{'deta':>5}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}", f"{'rom_nr':>8}", file=f_emu)

for dphi_msb in range(0,3):
    for deta_msb in range(0,2):
        rom_nr+=1
        dphi_idx_range = 64
        deta_idx_range = 128
        filepath=os.path.join(coe_files_path, "lut_muon_inv_dr_sq_rom" + str(rom_nr) + ".coe")
        if rom_nr <= max_rom_nr:
            f = open(filepath, "w")
            print("memory_initialization_radix=10;", file=f)
            print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,deta_idx_range):
            for dphi_idx in range(0,dphi_idx_range):
                deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                deta_val = deta_idx_gl*eta_bin_width
                dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range
                dphi_val = dphi_idx_gl*2*math.pi/phi_bins_reduced
                if deta_val == 0 and dphi_val == 0:
                    inv_dr_sq_fw_lut_arr[0] = 0

                    print(f"{dphi_idx:>5}", f"{deta_idx:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}", f"{rom_nr:>8}", file=f_emu)
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
                            print(f"{dphi_idx_gl:>5}", f"{deta_idx_gl:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}", f"{rom_nr:>8}", file=f_emu)

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

brams18_sum = 0

filename=("data_width_rom_lut_muon_one_over_dr_sq.txt")
filepath=os.path.join(doc_files_path, filename)
f = open(filepath, "w")
print("Data width of roms and number of 18kb BRAMs for muon 1/DR^2 with reduced bins [max deta:",deta_bins,", max dphi:", dphi_bins,", precision:",precision,"]", file=f)
print("'rom_nr' 'data width' 'BRAM 18kb'", file=f)
for rom_nr in range(0, max_rom_nr):
    brams18 = int(max(inv_dr_sq_fw_lut_list[rom_nr]).bit_length() * rom_size / bram_size) + 1
    brams18_sum = brams18_sum + brams18
    print("  ",rom_nr+1, "        ", max(inv_dr_sq_fw_lut_list[rom_nr]).bit_length(), "         ", brams18, file=f)
brams36_total = (brams18_sum/2) * (muon_objects*(muon_objects-1)/2)
print("Total number of BRAM 36kb for muon:", brams36_total, file=f)
f.close()
