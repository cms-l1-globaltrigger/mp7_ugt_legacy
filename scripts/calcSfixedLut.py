#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import shutil
import logging
import sys, os, re
import math

EXIT_SUCCESS = 0
EXIT_FAILURE = 1


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help="file name of LUT")
    parser.add_argument('prec', type=int, help="precision of input values")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()
    
    fin = "sfixed_luts/integer_sources/{}.txt".format(args.filename)
    num_lines = sum(1 for line in open(fin))
    print "num_lines:",num_lines
    
    num_val_line = 16
    inval_list = [0] * (num_lines-3) * num_val_line
        
    line_index = 0
    inval_list_index = 0
    with open(fin) as fp:
      for line in fp:
        if line_index == 0:
	      first_line = line
        elif line_index == 1:
	      sec_line = line
        elif line_index == num_lines-1:
	      last_line = line
        else:
          line_split = " ".join(line.split())
          line_elem = line_split.split(",")
          for j in range(0, num_val_line):
            inval_list[inval_list_index] = line_elem[j]
            inval_list_index = inval_list_index + 1
        line_index = line_index + 1
    first_line_elem = first_line.split("sfixed(")
    fract_bits_len_string = first_line_elem[1].split(")")
    fract_bits_len_elem = fract_bits_len_string[0].split(" downto ")
    fract_bits_len = abs(int(fract_bits_len_elem[1]))
    int_bits_len = int(fract_bits_len_elem[0])+1
    print "int_bits_len:",int_bits_len
    fract_bits = [0] * fract_bits_len
    res_l_z_list = [0] * len(inval_list)
    
    inval_list_index = 0
    sign = 0
    res_len = int_bits_len+fract_bits_len
    prec = args.prec
    
    for inval in inval_list:
      fract_bits = [str(0)] * fract_bits_len
      sign = 0 
      if int(inval) < 0:
	    sign = 1      
      
      inval_float = float(inval)
      inval_float_div = float(inval)/10**prec
      inval_int = int(math.modf(inval_float_div)[1])
      inval_fract = abs(inval_float_div)-abs(inval_int)     
      temp = inval_fract
      for i in range(1, fract_bits_len):
	fract_equation = 1./2**i
	if fract_equation < temp:
	  temp = temp - fract_equation
	  fract_bits[i-1] = 1
      inval_int_bin_str = "{0:b}".format(abs(inval_int))
      inval_int_bin_str_l_z = str(inval_int_bin_str).zfill(int_bits_len-1)
      fract_bits_str = ''.join(map(str, fract_bits))    
      res = str(sign) + inval_int_bin_str_l_z + fract_bits_str
      res_l_z = str(res).zfill(res_len)
      res_l_z_list[inval_list_index] = res_l_z
      inval_list_index = inval_list_index + 1
    print "writing to sfixed_luts/sfixed/{}_sfixed.txt".format(args.filename)
    # Writing file
    fout = open('sfixed_luts/sfixed/{}_sfixed.txt'.format(args.filename),'w+')
    fout.write("%s" % first_line)
    fout.write("%s" % sec_line)
    print "len(inval_list):",len(inval_list)
    
    for i in range(0, len(inval_list), 4):
      if i < (len(inval_list)-4):
        for j in range(0, 4):
          fout.write('"%s", ' % res_l_z_list[i+j])
        fout.write("\n")
      else:
        for j in range(0, 3):
          fout.write('"%s", ' % res_l_z_list[i+j])
        fout.write('"%s"' % res_l_z_list[i+3])
        fout.write("\n")
    fout.write(");\n")
    fout.close()

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
