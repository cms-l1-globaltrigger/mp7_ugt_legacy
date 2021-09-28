#!/usr/bin/python

import argparse
import configparser
import urllib.parse
import math
import os
from constants import calo_eta_bin_width, calo_eta_bins, calo_phi_bins, calo_rom_size, calo_nr_roms, calo_precision, bram_size, calo_objects
from constants import muon_eta_bin_width, muon_eta_bins, muon_phi_bins_reduced, muon_rom_size, muon_nr_roms, muon_precision, bram_size, muon_objects

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--coe', action='store_true', help='creating coe files')
    return parser.parse_args()

"""Main routine."""

# Parse command line arguments.
args = parse_args()

if args.coe:
    print("creating coe files")

script_path = os.path.dirname(os.path.realpath(__file__))
ugt_path_temp = script_path.split('scripts')
ugt_path = ugt_path_temp[0]
coe_files_path = os.path.join(ugt_path, "firmware/ngc")
doc_files_path = os.path.join(ugt_path, "doc/rom_one_over_dr_sq")
sim_files_path = os.path.join(ugt_path, "firmware/sim")

undef="undefined"
one_over_dr_sq_fw_lut_arr={}

## CALOS

eta_bin_width=calo_eta_bin_width
deta_bins=calo_eta_bins

dphi_bins=int(calo_phi_bins/2)

#print("created calo LUTs with reduced bins [max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",calo_precision,"]")

idx=0
rom_nr=0
end_emu_file=False

one_over_dr_sq_fw_lut_list=[[0 for x in range(calo_rom_size)] for x in range(calo_nr_roms)]

filename_emu=("emulator_lut_calo_one_over_dr_sq_calc.txt")
filepath_emu=os.path.join(doc_files_path, filename_emu)
f_emu = open(filepath_emu, "w")
print("creates emulator_lut_calo_one_over_dr_sq_calc.txt")
print(f"{'dphi':>5}", f"{'deta':>5}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'one_over_dr_sq':>25}", f"{'one_over_dr_sq_rounded':>18}", f"{'one_over_dr_sq_fw_lut':>17}", f"{'rom_nr':>8}", file=f_emu)

for dphi_msb in range(0,2):
    for deta_msb in range(0,4):
        rom_nr+=1
        if rom_nr == calo_nr_roms:
            dphi_idx_range = 16
            deta_idx_range = 256
        elif rom_nr < calo_nr_roms:
            dphi_idx_range = 64
            deta_idx_range = 64
        if args.coe:
            filename=os.path.join(coe_files_path, "lut_calo_inv_dr_sq_rom" + str(rom_nr) + ".coe")
            if rom_nr <= calo_nr_roms:
                f = open(filename, "w")
                print("memory_initialization_radix=10;", file=f)
                print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,deta_idx_range):
            for dphi_idx in range(0,dphi_idx_range):
                if rom_nr == calo_nr_roms:
                    deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                    dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range+64-dphi_idx_range
                elif rom_nr < calo_nr_roms:
                    deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                    dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range
                deta_val = deta_idx_gl*calo_eta_bin_width
                dphi_val = dphi_idx_gl*2*math.pi/calo_phi_bins
                if deta_val == 0 and dphi_val == 0:
                    one_over_dr_sq_fw_lut_arr[0] = 0

                    print(f"{dphi_idx:>5}", f"{deta_idx:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}", f"{rom_nr:>8}", file=f_emu)
                else:
                    one_over_dr_sq = 1/((deta_val**2)+(dphi_val**2))
                    one_over_dr_sq_rounded = round(one_over_dr_sq,calo_precision)
                    one_over_dr_sq_fw_lut = int(round(one_over_dr_sq_rounded*(10**calo_precision),0))
                    one_over_dr_sq_fw_lut_arr[idx] = one_over_dr_sq_fw_lut

                    if deta_idx_gl == deta_bins and dphi_idx_gl == dphi_bins+1:
                        end_emu_file=True
                        #print("EOF:", end_emu_file, file=f_emu)

                    if not end_emu_file:
                        if deta_idx_gl <= deta_bins and dphi_idx_gl <= dphi_bins:
                            print(f"{dphi_idx_gl:>5}", f"{deta_idx_gl:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{one_over_dr_sq:>25}", f"{one_over_dr_sq_rounded:>18}", f"{one_over_dr_sq_fw_lut:>17}", f"{rom_nr:>8}", file=f_emu)

                if rom_nr <= calo_nr_roms:
                    if args.coe:
                        idx_modulo=idx%16
                        if idx_modulo == 15:
                            print(one_over_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                        else:
                            print(one_over_dr_sq_fw_lut_arr[idx], end = ',', file=f)

                    one_over_dr_sq_fw_lut_list[rom_nr-1].append(one_over_dr_sq_fw_lut_arr[idx])

                idx+=1
        if rom_nr <= calo_nr_roms:
            if args.coe:
                print(";", file=f)
        if args.coe:
            f.close()
f_emu.close()

brams18_sum = 0

filename=("data_width_rom_lut_calo_one_over_dr_sq.txt")
print("creates data_width_rom_lut_calo_one_over_dr_sq.txt")
filepath=os.path.join(doc_files_path, filename)
f = open(filepath, "w")
print("Data width of roms and number of 18kb BRAMs for calo 1/DR^2 [max deta:",deta_bins,", max dphi:", dphi_bins,", precision:",calo_precision,"]", file=f)
print("'rom_nr' 'data width' 'BRAM 18kb'", file=f)
for rom_nr in range(0, calo_nr_roms):
    brams18 = int(max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length() * calo_rom_size / bram_size) + 1
    brams18_sum = brams18_sum + brams18
    print("  ",rom_nr+1, "        ", max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length(), "         ", brams18, file=f)
brams36_total = (brams18_sum/2) * (calo_objects*(calo_objects-1)/2)
print("Total number of BRAM 36kb for calos:", brams36_total, file=f)
f.close()

filename=os.path.join(sim_files_path, "calo_lut_one_over_dr_sq_4_sim.txt")
print("creates calo LUTs with full bins [ max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",calo_precision,"] at", filename)

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

## MUON

deta_bins=muon_eta_bins
dphi_bins=int(muon_phi_bins_reduced/2)

#print("created muon LUTs with reduced bins [max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",muon_precision,"]")

idx=0
rom_nr=0

end_emu_file=False

one_over_dr_sq_fw_lut_list=[[0 for x in range(muon_rom_size)] for x in range(muon_nr_roms)]

filename_emu=("emulator_lut_muon_one_over_dr_sq_calc.txt")
print("creates emulator_lut_muon_one_over_dr_sq_calc.txt")
filepath_emu=os.path.join(doc_files_path, filename_emu)
f_emu = open(filepath_emu, "w")
print(f"{'dphi':>5}", f"{'deta':>5}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'one_over_dr_sq':>25}", f"{'one_over_dr_sq_rounded':>18}", f"{'one_over_dr_sq_fw_lut':>17}", f"{'rom_nr':>8}", file=f_emu)

for dphi_msb in range(0,3):
    for deta_msb in range(0,2):
        rom_nr+=1
        dphi_idx_range = 64
        deta_idx_range = 128
        if args.coe:
            filepath=os.path.join(coe_files_path, "lut_muon_inv_dr_sq_rom" + str(rom_nr) + ".coe")
            if rom_nr <= muon_nr_roms:
                f = open(filepath, "w")
                print("memory_initialization_radix=10;", file=f)
                print("memory_initialization_vector=", file=f)
        for deta_idx in range(0,deta_idx_range):
            for dphi_idx in range(0,dphi_idx_range):
                deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                deta_val = deta_idx_gl*muon_eta_bin_width
                dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range
                dphi_val = dphi_idx_gl*2*math.pi/muon_phi_bins_reduced
                if deta_val == 0 and dphi_val == 0:
                    one_over_dr_sq_fw_lut_arr[0] = 0

                    print(f"{dphi_idx:>5}", f"{deta_idx:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{undef:>25s}", f"{undef:>18s}", f"{undef:>17s}", f"{rom_nr:>8}", file=f_emu)
                else:
                    one_over_dr_sq = 1/((deta_val**2)+(dphi_val**2))
                    one_over_dr_sq_rounded = round(one_over_dr_sq,muon_precision)
                    one_over_dr_sq_fw_lut = int(round(one_over_dr_sq_rounded*(10**muon_precision),0))
                    one_over_dr_sq_fw_lut_arr[idx] = one_over_dr_sq_fw_lut

                    if deta_idx_gl == deta_bins and dphi_idx_gl == dphi_bins+1:
                        end_emu_file=True
                        #print("EOF:", end_emu_file, file=f_emu)

                    if not end_emu_file:
                        if deta_idx_gl <= deta_bins and dphi_idx_gl <= dphi_bins:
                            print(f"{dphi_idx_gl:>5}", f"{deta_idx_gl:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{one_over_dr_sq:>25}", f"{one_over_dr_sq_rounded:>18}", f"{one_over_dr_sq_fw_lut:>17}", f"{rom_nr:>8}", file=f_emu)

                if rom_nr <= muon_nr_roms:
                    if args.coe:
                        idx_modulo=idx%16
                        if idx_modulo == 15:
                            print(one_over_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                        else:
                            print(one_over_dr_sq_fw_lut_arr[idx], end = ',', file=f)

                    one_over_dr_sq_fw_lut_list[rom_nr-1].append(one_over_dr_sq_fw_lut_arr[idx])

                idx+=1
        if rom_nr <= muon_nr_roms:
            if args.coe:
                print(";", file=f)
        if args.coe:
            f.close()
f_emu.close()

brams18_sum = 0

filename=("data_width_rom_lut_muon_one_over_dr_sq.txt")
print("creates data_width_rom_lut_muon_one_over_dr_sq.txt")
filepath=os.path.join(doc_files_path, filename)
f = open(filepath, "w")
print("Data width of roms and number of 18kb BRAMs for muon 1/DR^2 with reduced bins [max deta:",deta_bins,", max dphi:", dphi_bins,", precision:",muon_precision,"]", file=f)
print("'rom_nr' 'data width' 'BRAM 18kb'", file=f)
for rom_nr in range(0, muon_nr_roms):
    brams18 = int(max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length() * muon_rom_size / bram_size) + 1
    brams18_sum = brams18_sum + brams18
    print("  ",rom_nr+1, "        ", max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length(), "         ", brams18, file=f)
brams36_total = (brams18_sum/2) * (muon_objects*(muon_objects-1)/2)
print("Total number of BRAM 36kb for muon:", brams36_total, file=f)
f.close()

filename=os.path.join(sim_files_path, "muon_lut_one_over_dr_sq_4_sim.txt")
print("created muon LUT for simulation with reduced bins [ max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",calo_precision,"] at", filename)
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
