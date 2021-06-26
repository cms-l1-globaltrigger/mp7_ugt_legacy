#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import configparser
import logging
import os
import subprocess
import sys
import urllib.request
import urllib.parse
import urllib.error

import toolbox as tb

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

DefaultSynthDir = 'work_synth/production'
DefaultUgtTag = 'v1.15.2'

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menuname', type=tb.xmlname_t, help="L1Menu name (eg. 'L1Menu_Collisions2020_v0_1_6')")
    parser.add_argument('--user', required=True, help='user name')
    parser.add_argument('--xml_path', metavar='<path>', required=True, help="absolute path to XML file")
    parser.add_argument('--menu_repo', required=True, help='github repo relative path for menu')
    parser.add_argument('--dist', required=True, help="distribution number for VHDL Ptroducer")
    parser.add_argument('--tv_path', metavar='<path>', required=True, help="absolute path to test vector file")
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help='menu build version (eg. 0x1001) [required]')
    parser.add_argument('--synth_dir', metavar='<path>', default=DefaultSynthDir, help="relative path to local dir for synthesis results (default is '{}')".format(DefaultSynthDir))
    parser.add_argument('--ugt', metavar='<path>', default=DefaultUgtTag, help="ugt firmware repo: tag or branch name (default is '{}')".format(DefaultUgtTag))
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    DefaultMenuLocalDir = 'cms-l1-menu'
    DefaultUgtLocalDir = 'mp7_ugt_legacy'

    xml_name = args.menuname
    dist = args.dist
    menuname_dist = "{}-d{}".format(xml_name, dist)
    home_dir = "/home/{}".format(args.user)
    menu_url = "https://raw.githubusercontent.com/{}/{}".format(args.menu_repo, menuname_dist)
    #local_menu_dir = "{}/temp_work/{}".format(home_dir, DefaultMenuLocalDir)

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)

    menu_path = "{}/temp_work/{}/2021/{}".format(home_dir, DefaultMenuLocalDir, menuname_dist)
    print(menu_path)
    if os.path.exists(menu_path):
        raise RuntimeError('%s exists' % menu_path)

    logging.info("===========================================================================")
    logging.info("create temp_work dir")
    command = 'bash -c "cd; mkdir temp_work"'
    run_command(command)

    logging.info("===========================================================================")
    logging.info("clone repo '%s' to temp_work", menuname_dist)
    command = 'bash -c "cd; cd temp_work; git clone https://github.com/herbberg/cms-l1-menu.git cms-l1-menu; cd cms-l1-menu; git checkout L1Menu_Collisions2020_v0_1_5-d3; git checkout -b {menuname_dist}"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("clone repo 'mp7_ugt_legacy' to temp_work")
    command = 'bash -c "cd; cd temp_work; git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git mp7_ugt_legacy; cd mp7_ugt_legacy; git checkout {args.ugt}; pip install -r scripts/requirements.txt"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("clone repo 'mp7' to temp_work (for simulation)")
    command = 'bash -c "cd; cd temp_work; git clone https://gitlab.cern.ch/hbergaue/mp7.git mp7; cd mp7; git checkout mp7fw_v2_4_1_mp7_ugt"'
    run_command(command)

    logging.info("===========================================================================")
    logging.info("install tm-vhdlproducer in temp_work")
    command = 'bash -c "cd; cd temp_work; pip install -U pip; pip install git+https://github.com/herbberg/tm-vhdlproducer.git@master"'
    run_command(command)

    logging.info("===========================================================================")
    logging.info("run VHDL Producer")
    command = 'bash -c "cd; cd temp_work; tm-vhdlproducer {args.xml_path}/{xml_name}.xml --modules 6 --dist {dist} --sorting desc --output {DefaultMenuLocalDir}/2021"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("copy test vector file to created menu %s", menuname_dist)
    command = 'bash -c "scp {args.tv_path} temp_work/{DefaultMenuLocalDir}/2021/{menuname_dist}/testvectors/TestVector_{xml_name}.txt"'.format(**locals())
    run_command(command)

    commit_message = "'added new menu {}'".format(menuname_dist)
    logging.info("===========================================================================")
    logging.info("commit generated VHDL code of menu %s", menuname_dist)
    command = 'bash -c "cd; cd temp_work/{DefaultMenuLocalDir}; git add 2021/{menuname_dist}; git commit -m {commit_message}; git push --set-upstream origin {menuname_dist}"'.format(**locals())
    run_command(command)

    logging.info("===========================================================================")
    logging.info("run simulation")
    subprocess.check_call(['python3', os.path.join(home_dir, 'temp_work', DefaultUgtLocalDir, 'scripts', 'run_simulation_questa.py'), menuname_dist, '--url', os.path.join('https://raw.githubusercontent.com', args.menu_repo, menuname_dist, '2021'), '--mp7_tag', os.path.join(home_dir, "temp_work/mp7")])

    logging.info("===========================================================================")
    logging.info("run synthesis (takes about 4 hours)")
    subprocess.check_call(['python3', os.path.join(home_dir, 'temp_work', DefaultUgtLocalDir, 'scripts', 'runIpbbSynth.py'), menuname_dist, '--menuurl', os.path.join(menu_url, '2021'), '--ugturl https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy --ugt', args.ugt, '--build', args.build, '-p', args.synth_dir])

    write_bitstream_path = "{}/{}/scripts/vivado_write_bitstream.tcl".format(home_dir, args.menu_local_dir)
    build_path = "{}/{}/{}/{}/mp7_ugt_legacy/{}/mp7fw_v3_0_0/vivado_2019.2".format(home_dir, args.ugt_local_dir, home_dir, args.synth_dir, args.build, menuname_dist, args.ugt)
    build_cfg = "{}/{}/{}/{}/mp7_ugt_legacy/{}/mp7fw_v3_0_0/vivado_2019.2/build_{}.cfg".format(home_dir, args.synth_dir, args.build, menuname_dist, args.ugt, args.build)

    print("\n***************************************")
    print("after all syntheses have finished, check results with:")
    print("$ python3", args.synth_dir,"/scripts/checkIpbbSynth.py", build_cfg)
    print("")
    print("if timing errors (and bit files is not generated) occur, execute the following command for every module with errors:")
    print("$ vivado -mode batch -source", write_bitstream_path," -tclargs", build_path," <module number (e.g.: 0)>")
    print("")
    print("after successfully created bit files, execute the following command to create tar file for HW:")
    print("$ python3", args.synth_dir,"/scripts/fwpackerIpbb.py", build_cfg)
    print("***************************************\n")

    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
