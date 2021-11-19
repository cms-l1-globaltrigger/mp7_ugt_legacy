#!/usr/bin/env python

import os

script_path = os.path.dirname(os.path.realpath(__file__))
ugt_path_temp = script_path.split('scripts')
ugt_path = ugt_path_temp[0]
doc_files_path = os.path.join(ugt_path, "doc/rom_one_over_dr_sq")

for obj in ("calo","muon"):
    if obj == "calo":
        file_emu_lut = os.path.join(doc_files_path, "emulator/emulator_lut_calo_inv_dr_sq_calc_CODE.txt")
        file_fw_lut = os.path.join(doc_files_path, "calo_one_over_dr_sq_lut.txt")
    else:
        file_emu_lut = os.path.join(doc_files_path, "emulator/emulator_lut_muon_inv_dr_sq_calc_CODE_corr.txt")
        file_fw_lut = os.path.join(doc_files_path, "muon_one_over_dr_sq_lut.txt")

    emu_lut_line = 0
    emu_lut_val = {}
    with open(file_emu_lut) as emu_lut:
        for line in emu_lut:
            if not line.isspace(): # only not empty lines
                emu_lut_val[emu_lut_line] = line.split('    ')[6]
                emu_lut_line += 1

    fw_lut_line = 0
    fw_lut_val = {}
    with open(file_fw_lut) as fw_lut:
        for line in fw_lut:
            if not line.isspace():
                fw_lut_val[fw_lut_line] = line.split(' ')[0]
                fw_lut_line += 1

    if emu_lut_line != fw_lut_line:
        raise RuntimeError("ERROR: different line numbers!", emu_lut_line, fw_lut_line)

    for i in range(0, emu_lut_line):
        if emu_lut_val[i] != fw_lut_val[i]:
            raise RuntimeError("Mismatch in LUT value @ line:", i+1)

    print("SUCCESS for:", obj)
    print("===================================================")

