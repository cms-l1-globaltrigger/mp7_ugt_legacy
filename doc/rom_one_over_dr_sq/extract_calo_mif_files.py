#!/usr/bin/env python

import os
import math
from constants import calo_eta_bin_width, calo_eta_min_bin, calo_eta_max_bin, calo_phi_bins, calo_rom_size, calo_nr_roms, calo_deta_block_size_rom1_4, calo_dphi_block_size_rom1_4, calo_dphi_block_size_rom5, calo_precision

script_path = os.path.dirname(os.path.realpath(__file__))
ngc_path_temp = script_path.split('doc')
ngc_path = os.path.join(ngc_path_temp[0], "firmware", "ngc")

eta_bin_width=calo_eta_bin_width
deta_bins=abs(calo_eta_min_bin)+calo_eta_max_bin+1

dphi_bins=int(calo_phi_bins/2)

rom_len_1 = calo_deta_block_size_rom1_4 * calo_dphi_block_size_rom1_4
rom_len_2 = calo_deta_block_size_rom1_4 * calo_dphi_block_size_rom1_4
rom_len_3 = calo_deta_block_size_rom1_4 * calo_dphi_block_size_rom1_4
rom_len_4 = (deta_bins+1-3*calo_deta_block_size_rom1_4) * calo_dphi_block_size_rom1_4
rom_len_5 = (deta_bins+1) * (dphi_bins-calo_dphi_block_size_rom1_4+1)
rom_len = rom_len_1 + rom_len_2 + rom_len_3 + rom_len_4 + rom_len_5
#print(rom_len, rom_len_1, rom_len_2, rom_len_3, rom_len_4, rom_len_5)

rom = [[0 for x in range(calo_rom_size)] for x in range(calo_nr_roms)]
lut = [0 for x in range(rom_len)]
lut_calc = [0 for x in range(rom_len)]
#rom_val = [0 for x in range(calo_rom_size*calo_nr_roms)]

rom_idx = 0
lut_idx = 0

file_path_lut = os.path.join(script_path, "calo_one_over_dr_sq_lut.txt")
print("Path calo lut file:", file_path_lut)
f_lut = open(file_path_lut, 'w')
#file_path_w = os.path.join(script_path, "calo_roms_1_5.txt")
#f_rom = open(file_path_w, 'w')
for i in range(0,calo_nr_roms):
    file_path_r = os.path.join(ngc_path, "rom_lut_calo_inv_dr_sq_"+str(i+1), "rom_lut_calo_inv_dr_sq_"+str(i+1)+".mif")
    f_in = open(file_path_r, 'r')
    for line_nr in range(0,calo_rom_size):
        rom[i][line_nr] = "0b" + f_in.readline().strip('\n')
        #rom_val[rom_idx] = int(rom[i][line_nr],0)
        #print(rom_idx, i, rom_val[rom_idx], file=f_rom)
        rom_idx+=1
    f_in.close()
#f_rom.close()

for i in range(0,deta_bins+1):
    for j in range(0,dphi_bins+1):
        
        deta_val = i*eta_bin_width
        dphi_val = j*2*math.pi/calo_phi_bins
        if deta_val == 0 and dphi_val == 0:
            one_over_dr_sq = 0
        else:
            one_over_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        one_over_dr_sq_rounded = round(one_over_dr_sq,calo_precision)
        lut_calc[lut_idx] = int(round(one_over_dr_sq*(10**calo_precision),0))

        if j < calo_dphi_block_size_rom1_4 and i < calo_deta_block_size_rom1_4:
            line_nr = i*calo_dphi_block_size_rom1_4+j
            lut[lut_idx] = int(rom[0][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j < calo_dphi_block_size_rom1_4 and i >= calo_deta_block_size_rom1_4 and i < calo_deta_block_size_rom1_4*2:
            line_nr = (i-calo_deta_block_size_rom1_4)*calo_dphi_block_size_rom1_4+j
            lut[lut_idx] = int(rom[1][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j < calo_dphi_block_size_rom1_4 and i >= calo_deta_block_size_rom1_4*2 and i < calo_deta_block_size_rom1_4*3:
            line_nr = (i-calo_deta_block_size_rom1_4*2)*calo_dphi_block_size_rom1_4+j
            lut[lut_idx] = int(rom[2][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j < calo_dphi_block_size_rom1_4 and i >= calo_deta_block_size_rom1_4*3 and i <= deta_bins:
            line_nr = (i-calo_deta_block_size_rom1_4*3)*calo_dphi_block_size_rom1_4+j
            lut[lut_idx] = int(rom[3][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j >= calo_dphi_block_size_rom1_4 and j <= dphi_bins and i <= deta_bins:
            line_nr = i*calo_dphi_block_size_rom5+(j-calo_dphi_block_size_rom1_4)
            lut[lut_idx] = int(rom[4][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        
#print(lut_idx)

f_lut.close()

comp_status = "ok"
error_total = False

file_path_lut_rom = os.path.join(script_path, "compare_calo_lut_rom.txt")
f_lut_rom = open(file_path_lut_rom, 'w')
for i in range(0,lut_idx):
    if lut_calc[i] == lut[i]:
        comp_status = "ok"
    else:
        comp_status = "mismatch"
        error_total = True

    print(comp_status, lut_calc[i], lut[i], file=f_lut_rom)
if error_total:
    print("mismatches in comparisons ! (search for 'mismatch')", file=f_lut_rom)
else:
    print("comparisons ok !", file=f_lut_rom)

f_lut_rom.close()

if error_total:
    print("mismatches in comparisons !")
else:
    print("comparisons ok !")



