#!/usr/bin/env python

import sys
import os

# command: python3 run_make.py <emu or gt>

if sys.argv[1] == "emu":
    doc_name = "gtl_4_emulator"
elif sys.argv[1] == "gt":
    doc_name = "gt-mp7-firmware-specification"
else:
    raise RuntimeError("No or wrong argument for DOCUMENT_NAME")

make_path = os.path.dirname(os.path.realpath(__file__))
make_file_name = os.path.join(make_path, "Makefile")

idx = 0
lines = {}
with open(make_file_name) as make_file:
    for line in make_file:
        if not line.isspace(): # only not empty lines
            if line.split(' ')[0] == "DOCUMENT_NAME":
                line = "DOCUMENT_NAME = "+doc_name
            lines[idx] = line
            idx += 1
f_w = open(make_file_name, "w")
for idx in range(0,idx):
    print(lines[idx], file=f_w)
f_w.close()
os.system("make")
