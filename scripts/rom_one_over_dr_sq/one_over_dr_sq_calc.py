#!/usr/bin/python

import argparse
import configparser
import urllib.parse
import math
import os
from constants import calo_eta_step, calo_eta_bins, calo_phi_bins, calo_rom_size, calo_nr_roms, calo_precision, bram_size, calo_objects
from constants import muon_eta_step, muon_eta_bins, muon_phi_bins_reduced, muon_rom_size, muon_nr_roms, muon_precision, bram_size, muon_objects

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

for obj_type in ["calo", "muon"]:
    idx=0
    rom_nr=1
    end_emu_file=False
    if obj_type == "calo":
        eta_bin_width=calo_eta_step
        deta_bins=calo_eta_bins
        dphi_bins=int(calo_phi_bins/2)
        dphi_range = 2
        deta_range = 4
        nr_roms = calo_nr_roms
        rom_size = calo_rom_size

    elif obj_type == "muon":
        eta_bin_width=muon_eta_step
        deta_bins=muon_eta_bins
        dphi_bins=int(muon_phi_bins_reduced/2)
        dphi_range = 3
        deta_range = 2
        nr_roms = muon_nr_roms
        rom_size = muon_rom_size

    one_over_dr_sq_fw_lut_list=[[0 for x in range(rom_size)] for x in range(nr_roms)]

    filename_emu="emulator_lut_"+obj_type+"_one_over_dr_sq_calc.txt"
    filepath_emu=os.path.join(doc_files_path, filename_emu)
    f_emu = open(filepath_emu, "w")
    print("creates", filename_emu)
    print(f"{'dphi':>5}", f"{'deta':>5}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'one_over_dr_sq':>25}", f"{'one_over_dr_sq_rounded':>18}", f"{'one_over_dr_sq_fw_lut':>17}", f"{'rom_nr':>8}", file=f_emu)

# creating text file for emulator with 1/DR^2 calculation and coe file for ROMs (with --coe option)
    if args.coe:
        print(obj_type+" number ROMs:", nr_roms)
    for dphi_msb in range(0,dphi_range):
        for deta_msb in range(0,deta_range):
            if rom_nr <= nr_roms:
                if obj_type == "calo":
                    if rom_nr == nr_roms:
                        dphi_idx_range = 16
                        deta_idx_range = 256
                    elif rom_nr < nr_roms:
                        dphi_idx_range = 64
                        deta_idx_range = 64
                elif obj_type == "muon":
                    dphi_idx_range = 64
                    deta_idx_range = 128
                if args.coe:
                    filepath=os.path.join(coe_files_path, "lut_" + obj_type + "_inv_dr_sq_rom" + str(rom_nr) + ".coe")
                    if rom_nr <= muon_nr_roms:
                        f = open(filepath, "w")
                        print("memory_initialization_radix=10;", file=f)
                        print("memory_initialization_vector=", file=f)
                for deta_idx in range(0,deta_idx_range):
                    for dphi_idx in range(0,dphi_idx_range):
                        if obj_type == "calo":
                            if rom_nr == nr_roms:
                                deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                                dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range+64-dphi_idx_range
                            elif rom_nr < nr_roms:
                                deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                                dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range
                            deta_val = deta_idx_gl*calo_eta_step
                            dphi_val = dphi_idx_gl*2*math.pi/calo_phi_bins
                        elif obj_type == "muon":
                            deta_idx_gl = deta_idx+deta_msb*deta_idx_range
                            deta_val = deta_idx_gl*muon_eta_step
                            dphi_idx_gl = dphi_idx+dphi_msb*dphi_idx_range
                            dphi_val = dphi_idx_gl*2*math.pi/muon_phi_bins_reduced
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

                            if not end_emu_file:
                                if deta_idx_gl <= deta_bins and dphi_idx_gl <= dphi_bins:
                                    print(f"{dphi_idx_gl:>5}", f"{deta_idx_gl:>5}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{one_over_dr_sq:>25}", f"{one_over_dr_sq_rounded:>18}", f"{one_over_dr_sq_fw_lut:>17}", f"{rom_nr:>8}", file=f_emu)

                        if rom_nr <= nr_roms:
                            if args.coe:
                                idx_modulo=idx%16
                                if idx_modulo == 15:
                                    print(one_over_dr_sq_fw_lut_arr[idx], end = ',\n', file=f)
                                else:
                                    print(one_over_dr_sq_fw_lut_arr[idx], end = ',', file=f)

                            one_over_dr_sq_fw_lut_list[rom_nr-1].append(one_over_dr_sq_fw_lut_arr[idx])

                        idx+=1
                rom_nr+=1
                if args.coe:
                    print(";", file=f)
                    f.close()
    f_emu.close()

# creating text file with data width of ROMs
    brams18_sum = 0
    filename="data_width_rom_lut_"+obj_type+"_one_over_dr_sq.txt"
    print("creates", filename)
    filepath=os.path.join(doc_files_path, filename)
    f = open(filepath, "w")
    if obj_type == "calo":
        print("Data width of roms and number of 18kb BRAMs for calo 1/DR^2 [max deta:",deta_bins,", max dphi:", dphi_bins,", precision:",calo_precision,"]", file=f)
        print("'rom_nr' 'data width' 'BRAM 18kb'", file=f)
        objects = calo_objects
    elif obj_type == "muon":
        print("Data width of roms and number of 18kb BRAMs for muon 1/DR^2 with reduced bins [max deta:",deta_bins,", max dphi:", dphi_bins,", precision:",muon_precision,"]", file=f)
        print("'rom_nr' 'data width' 'BRAM 18kb'", file=f)
        objects = muon_objects
    for rom_nr in range(0, nr_roms):
        brams18 = int(max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length() * rom_size / bram_size) + 1
        brams18_sum = brams18_sum + brams18
        print("  ",rom_nr+1, "        ", max(one_over_dr_sq_fw_lut_list[rom_nr]).bit_length(), "         ", brams18, file=f)
    brams36_total = (brams18_sum/2) * (objects*(objects-1)/2)
    print("Total number of BRAM 36kb for "+obj_type+":", brams36_total, file=f)
    f.close()

# creating text file with LUTs values for simulation comparison
    if obj_type == "calo":
        print("creates calo LUTs with full bins [ max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",calo_precision,"] at", filename)
        precision = calo_precision
    elif obj_type == "muon":
        print("created muon LUT for simulation with reduced bins [ max deta:",deta_bins,", max dphi:",dphi_bins,", precision:",muon_precision,"] at", filename)
        precision = muon_precision
    filename=os.path.join(sim_files_path, obj_type+"_lut_one_over_dr_sq_4_sim.txt")
    f_sim = open(filename, "w")
    for deta_idx in range(0,deta_bins+1):
        for dphi_idx in range(0,dphi_bins+1):
            if obj_type == "calo":
                deta_val = deta_idx*calo_eta_step
                dphi_val = dphi_idx*2*math.pi/calo_phi_bins
            elif obj_type == "muon":
                deta_val = deta_idx*muon_eta_step
                dphi_val = dphi_idx*2*math.pi/muon_phi_bins_reduced
            if deta_val == 0 and dphi_val == 0:
                inv_dr_sq = 0
            else:
                inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
            inv_dr_sq_rounded = round(inv_dr_sq,precision)
            inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*(10**precision),0))
            print(inv_dr_sq_fw_lut, file=f_sim)
    f_sim.close()

