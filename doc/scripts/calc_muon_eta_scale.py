#!/usr/bin/python

def num_to_bin(num, wordsize):
    if num < 0:
        num = 2**wordsize+num
    base = bin(num)[2:]
    padding_size = wordsize - len(base)
    return '0' * padding_size + base

eta_bin_width = 0.087/8

for i in range(225, -226, -1):
    i_hex = hex(int(num_to_bin(i, 9),2))
    eta_range_l = round(eta_bin_width*(i-0.5), 7)
    eta_range_h = round(eta_bin_width*(i+0.5), 7)
    print("{0:4d} {1:5s} {2:2.7f} {3:2.7f}".format(i, i_hex, eta_range_l, eta_range_h))

