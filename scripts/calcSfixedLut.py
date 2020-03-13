#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import toolbox as tb
import mp7patch

import argparse
import urllib
import shutil
import logging
from distutils.dir_util import copy_tree
import subprocess
import ConfigParser
import sys, os, re
import socket
from xmlmenu import XmlMenu
from run_simulation_questa import run_simulation_questa

EXIT_SUCCESS = 0
EXIT_FAILURE = 1


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('inval', help="input value for calculation")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()
    inval = args.inval
    print "inval:",inval
    inval_int = int(inval)/1000
    inval_float = float(inval)/1000.-inval_int
    print "inval_int:",inval_int
    print "inval_float:",inval_float
    bits = [0] * 20
    val = 0.
    val_check = 0.
    temp = inval_float
    sign = 0
    if int(inval) < 0:
      sign = 1
    
    for i in range(1,20):
      #if div[i] < temp:
	#temp = temp - div[i]
	#val = val + div[i]
	#bits[i] = 1
      div = 1./2**i
      if div < temp:
	temp = temp - div
	val = val + div
	bits[i-1] = 1
    print "val:",val+inval_int
    inval_int_bin = "{0:b}".format(inval_int)
    print "inval_int_bin:",inval_int_bin
    bits_str = ''.join(map(str, bits))    
    print "bits:",bits
    for i in range(0,20):
      print "bits[i]:",bits[i]
      if bits[i] == 1:
	val_check = val_check + (1./2**(i+1))
    print "val_check:",val_check
    print "bits_str:",bits_str
    val_bin_str = str(sign) + inval_int_bin + bits_str
    print "val_bin_str:",val_bin_str

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
