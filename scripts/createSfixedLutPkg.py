#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import shutil
import logging
import sys, os, re
import math

EXIT_SUCCESS = 0
EXIT_FAILURE = 1


def main():
    """Main routine."""

    #file_names = [
        #"eg_pt_lut_sfixed", 
        #"jet_pt_lut_sfixed", 
        #"muon_pt_lut_sfixed", 
        #"calo_deta_lut_sfixed", 
        #"calo_dphi_lut_sfixed", 
        #"calo_cosh_deta_lut_sfixed", 
        #"calo_cos_dphi_lut_sfixed", 
        #"muon_deta_lut_sfixed", 
        #"muon_dphi_lut_sfixed", 
        #"muon_cosh_deta_lut_sfixed", 
        #"muon_cos_dphi_lut_sfixed" 
        #] 
    file_names = [
        "integer_sources/sfixed_luts_pkg_begin.vhd", 
        "sfixed/eg_pt_lut_sfixed.txt", 
        "sfixed/jet_pt_lut_sfixed.txt", 
        "sfixed/muon_pt_lut_sfixed.txt", 
        "sfixed/calo_deta_lut_sfixed.txt", 
        "sfixed/calo_dphi_lut_sfixed.txt", 
        "sfixed/calo_cosh_deta_lut_sfixed.txt", 
        "sfixed/calo_cos_dphi_lut_sfixed.txt", 
        "sfixed/muon_deta_lut_sfixed.txt", 
        "sfixed/muon_dphi_lut_sfixed.txt", 
        "sfixed/muon_cosh_deta_lut_sfixed.txt", 
        "sfixed/muon_cos_dphi_lut_sfixed.txt", 
        "integer_sources/sfixed_luts_pkg_end.vhd" 
        ] 
    
    print "writing sfixed_luts/sfixed/sfixed_luts_pkg.vhd"
    fout = open('sfixed_luts/sfixed/sfixed_luts_pkg.vhd','a')
    for file_name in file_names:
        fin = "sfixed_luts/{}".format(file_name)
        with open(fin) as fp:
            for line in fp:
                fout.write(line)
    fout.close()

if __name__ == '__main__':
    try:
        main()
    except RuntimeError, message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
