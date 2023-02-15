#!/usr/bin/python

def num_to_bin(num, wordsize):
    if num < 0:
        num = 2**wordsize+num
    base = bin(num)[2:]
    padding_size = wordsize - len(base)
    return '0' * padding_size + base

eta_bin_width = 0.087/2

for i in range(114, -116, -1):
    i_hex = hex(int(num_to_bin(i, 8),2))
    eta_range_l = round(eta_bin_width*i, 4)
    eta_range_h = round(eta_bin_width*(i+1), 4)
    print("{0:4d} {1:4s} {2:7f} {3:7f}".format(i, i_hex, eta_range_l, eta_range_h))

