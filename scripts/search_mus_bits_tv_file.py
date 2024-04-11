#!/usr/bin/python

import argparse

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('tv', help="Test vector path")
    return parser.parse_args()

def extract_mus_bit(hex_char):
    """Returns mus bit from hex character."""
    hex_char_bin = bin(int(hex_char,16))
    mus_bit = hex_char_bin.split("b")[1].zfill(4)[2]
    return mus_bit

args = parse_args()
file_name = args.tv
file1 = open(file_name, 'r')
Lines = file1.readlines()

mus_bit_find = False

# MUS bits on bit 61 of muon objects (looking at bit 1 of MSB character of muon data)
for line in Lines:
    bx = line.split(" ")[0]
    mus0 = extract_mus_bit(line.split(" ")[1][0])
    mus1 = extract_mus_bit(line.split(" ")[3][0])
    mus2_loose = extract_mus_bit(line.split(" ")[4][0])
    if mus0 != "0":
        print("bx {} mus0 = {}".format(bx, mus0))
        mus_bit_find = True
    if mus1 != "0":
        print("bx {} mus1 = {}".format(bx, mus1))
        mus_bit_find = True
    if mus2_loose != "0":
        print("bx {} mus2_loose = {}".format(bx, mus2_loose))
        mus_bit_find = True
if not mus_bit_find:
    print("NO mus bits found in {} !!!".format(file_name))


