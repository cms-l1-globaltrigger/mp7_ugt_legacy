#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import logging
import os
import subprocess
import sys
import toolbox as tb

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('menuname', type=tb.menuname_t, help="L1Menu name (eg. 'L1Menu_Collisions2018_v2_1_0-d1')")
    parser.add_argument('--menuurl', metavar='<path>', required=True, help="L1Menu URL to retrieve files from repo [required]")
    parser.add_argument('--ugturl', metavar='<path>', required=True, help="URL of ugt firmware repo [required]")
    parser.add_argument('--ugt', metavar='<path>',required=True, help='ugt firmware repo: tag or branch name [required]')
    parser.add_argument('--build', type=tb.build_str_t, required=True, metavar='<version>', help='menu build version (eg. 0x1001) [required]')
    parser.add_argument('--scripts', metavar='<path>', required=True, help="path to local scripts dir [required]")
    
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()
    
    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)


    cmd_venv = "python3 -m venv env_build_ugt_fw"
    cmd_activate_env = ". env_build_ugt_fw/bin/activate"
    cmd_pip = "pip install -U pip"
    cmd_lxml = "pip install lxml"
    cmd_ipbb = "pip install https://github.com/ipbus/ipbb/archive/v0.5.2.tar.gz"
    env_dir = os.path.join(os.getenv("HOME"),"env_build_ugt_fw")

    if os.path.isdir(env_dir):
        logging.info("===========================================================================")
        logging.info("removing environment 'env_build_ugt_fw' ...")
        command = 'bash -c "cd; rm -rf env_build_ugt_fw"'.format(**locals())
        run_command(command)
        logging.info("===========================================================================")
        logging.info("creating environment 'env_build_ugt_fw' ...")
        command = 'bash -c "cd; {cmd_venv} && {cmd_activate_env} && {cmd_pip} && {cmd_lxml} && {cmd_ipbb}"'.format(**locals())
        run_command(command)
    else:
        logging.info("===========================================================================")
        logging.info("creating environment 'env_build_ugt_fw' ...")
        command = 'bash -c "cd; {cmd_venv} && {cmd_activate_env} && {cmd_pip} && {cmd_lxml} && {cmd_ipbb}"'.format(**locals())
        run_command(command)
        
    cmd_run_synth = "python3 runIpbbSynth.py {args.menuname} --menuurl {args.menuurl} --ugturl {args.ugturl} --ugt {args.ugt} --build {args.build}".format(**locals())
    command = 'bash -c "cd; {cmd_activate_env}; cd {args.scripts}; {cmd_run_synth}"'.format(**locals())
    run_command(command)

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
