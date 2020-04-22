#!/usr/bin/env python2
# -*- coding: utf-8 -*-

#import argparse
#import shutil
#import logging
import sys, os, re
import math

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def main():
    """Main routine."""

    deta_len = 230 # number of calo delta eta bins
    deta_bin = 0.0435 # bin width calo delta eta
    dphi_len = 144 # number of calo delta phi bins
    dphi_bin = 2*math.pi/dphi_len # bin width calo delta phi
    dr_list_len = deta_len * dphi_len # number of delta R values (= length of LUT)
    dr_list = [0] * dr_list_len
    prec = 5 # precision of delta R values (digits after comma, rounded)
    line_len = 16 # values per line in LUT (= dphi_len/9)
    
    calo_inv_dr_sq_lut_max_val = 52847140
    
    print "writing to delta_r_lut/delta_r_lut.txt"
    fout = open('delta_r_lut/delta_r_lut.txt',"w+")
    index_dphi_len = 1 

    fout.write("type calo_inv_dr_sq_lut_array is array (0 to %s-1, 0 to %s-1) of natural range 0 to CALO_INV_DR_SQ_LUT_MAX_VAL;\n" % (deta_len, dphi_len))
    fout.write("constant CALO_INV_DR_SQ_LUT : calo_inv_dr_sq_lut_array := (\n(")
    for i in range(0, deta_len):
      for j in range(0, dphi_len):
        if i == 0 and j == 0:
            dr_list[i+j] = 0
        else:
            dr_list[i+j] = int(10**prec * round(1/(((i*deta_bin)**2)+((j*dphi_bin)**2)), prec))
        fout.write('%s' % dr_list[i+j])
        if (index_dphi_len % dphi_len == 0) and not (index_dphi_len == deta_len*dphi_len) and not (index_dphi_len % line_len == 0):
            fout.write("), (")
        elif (index_dphi_len % dphi_len == 0) and not (index_dphi_len == deta_len*dphi_len) and (index_dphi_len % line_len == 0):
            fout.write("),\n(")
        elif (index_dphi_len == deta_len*dphi_len):
            fout.write(")")
        elif (index_dphi_len % line_len == 0):
            fout.write(",\n")
        else:
            fout.write(", ")
        index_dphi_len = index_dphi_len + 1
    fout.write("\n);")
    fout.close()

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
