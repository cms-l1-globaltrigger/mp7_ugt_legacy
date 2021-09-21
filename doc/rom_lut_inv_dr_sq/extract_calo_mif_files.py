#!/usr/bin/env python

import os
import math

dir_path = os.path.dirname(os.path.realpath(__file__))
print(dir_path)
ngc_path_temp = dir_path.split('doc')
ngc_path = os.path.join(ngc_path_temp[0], "firmware", "ngc")
print(ngc_path)

eta_bin_width=0.087/2
eta_min_bin=-115
eta_max_bin=114
deta_bins=abs(eta_min_bin)+eta_max_bin+1

phi_bins=144
dphi_bins=int(phi_bins/2)

precision=5

deta_block_size = 128
dphi_block_size = 64

nr_rom_addr = 8192
nr_roms = 4

rom_len_1 = deta_block_size * dphi_block_size
rom_len_2 = (deta_bins-deta_block_size+1) * dphi_block_size
rom_len_3 = deta_block_size * (dphi_bins-dphi_block_size+1)
rom_len_4 = (deta_bins-deta_block_size+1) * (dphi_bins-dphi_block_size+1)
rom_len = rom_len_1 + rom_len_2 + rom_len_3 + rom_len_4
#print(rom_len, rom_len_1, rom_len_2, rom_len_3, rom_len_4)

rom = [[0 for x in range(nr_rom_addr)] for x in range(nr_roms)]
lut = [0 for x in range(rom_len)]
lut_calc = [0 for x in range(rom_len)]
#rom_val = [0 for x in range(nr_rom_addr*nr_roms)]

rom_idx = 0
lut_idx = 0

file_path_lut = os.path.join(dir_path, "calo_one_over_dr_sq_lut.txt")
f_lut = open(file_path_lut, 'w')
#file_path_w = os.path.join(dir_path, "calo_roms_1_4.txt")
#f_rom = open(file_path_w, 'w')
for i in range(0,nr_roms):
    file_path_r = os.path.join(ngc_path, "rom_lut_calo_inv_dr_sq_"+str(i+1), "rom_lut_calo_inv_dr_sq_"+str(i+1)+".mif")
    f_in = open(file_path_r, 'r')
    for line_nr in range(0,nr_rom_addr):
        rom[i][line_nr] = "0b" + f_in.readline().strip('\n')
        #rom_val[rom_idx] = int(rom[i][line_nr],0)
        #print(rom_idx, i, rom_val[rom_idx], file=f_rom)
        rom_idx+=1
    f_in.close()
#f_rom.close()

for i in range(0,deta_bins+1):
    for j in range(0,dphi_bins+1):

        deta_val = i*eta_bin_width
        dphi_val = j*2*math.pi/phi_bins
        if deta_val == 0 and dphi_val == 0:
            one_over_dr_sq = 0
        else:
            one_over_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        one_over_dr_sq_rounded = round(one_over_dr_sq,precision)
        lut_calc[lut_idx] = int(round(one_over_dr_sq*(10**precision),0))

        if j < dphi_block_size and i < deta_block_size:
            line_nr = i*dphi_block_size+j
            lut[lut_idx] = int(rom[0][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j >= dphi_block_size and j <= dphi_bins and i < deta_block_size:
            line_nr = i*dphi_block_size+(j-dphi_block_size)
            lut[lut_idx] = int(rom[2][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j < dphi_block_size and i >= deta_block_size and i <= deta_bins:
            line_nr = (i-dphi_block_size*2)*dphi_block_size+j
            lut[lut_idx] = int(rom[1][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1
        if j >= dphi_block_size and j <= dphi_bins and i >= deta_block_size and i <= deta_bins:
            line_nr = (i-dphi_block_size*2)*dphi_block_size+(j-dphi_block_size)
            lut[lut_idx] = int(rom[3][line_nr],0)
            print(lut[lut_idx], file=f_lut)
            lut_idx+=1

f_lut.close()

comp_status = "ok"
error_total = False

file_path_lut_rom = os.path.join(dir_path, "compare_calo_lut_rom.txt")
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



