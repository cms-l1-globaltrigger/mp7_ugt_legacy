#philipp wanggo
#20.07.2017
#simultion program
#all credit to Johannes Wittmann and Bernhard Arnold
import xmlmenu
import os, sys
import shutil
import json
import subprocess
import logging
import argparse
import time, datetime
from threading import Thread

DefaultQuestaSimPath = '/opt/mentor/questasim'
DefaultQuestaSimLibsPath = 'questasimlibs'
pwd = os.path.dirname(__file__)

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def run_compile_simlib(vivado, questasim, questasimlib_path):

    # Check for VIVADO_BASE_DIR
    vivado_base_dir = os.getenv('VIVADO_BASE_DIR')
    if not vivado_base_dir:
        raise RuntimeError("Environment variable 'VIVADO_BASE_DIR' not set. Set with: 'export VIVADO_BASE_DIR=...'")

    settings64 = os.path.join(vivado_base_dir, vivado, 'settings64.sh')
    
    # Installation path of questasim (tcl syntax)
    questasim_path = "{" + questasim + "/bin}"
    # Variable for compile_simlib syntax
    questasimlib_path_tcl = "{" + "{questasimlib_path}".format(**locals()) + "}"
    # Path and compile_simlib command of tcl file used in Vivado
    tcl_file = "scripts/compile_simlib.tcl"
    tcl_compile_cmd = "compile_simlib -simulator questa -simulator_exec_path {questasim_path} -family virtex7 -language vhdl -library all -dir {questasimlib_path_tcl}".format(**locals())
        
    # Writing commands to tcl file
    with open(tcl_file, "w") as file:
        file.write("#!/usr/bin/tcls\n")
        file.write("{tcl_compile_cmd}\n".format(**locals()))
        file.write("exit\n")
        
    # Checking if questasimlib_path exists
    if not os.path.isdir(questasimlib_path):
        logging.info("===========================================================================")
        command = 'bash -c "source {}; vivado -mode batch -source {}/compile_simlib.tcl"'.format(settings64, pwd)
        logging.info("creating libs in %s (running '%s/compile_simlib.tcl')", questasimlib_path, pwd)
        run_command(command)
        logging.info("Done!")
        logging.info("===========================================================================")
    else:
        logging.info("===========================================================================")
        logging.info("libs in %s already exists", questasimlib_path)
        logging.info("Nothing to do!")
        logging.info("===========================================================================")
    
    # Copy modelsim.ini from questasimlib dir to sim dir (to get questasim libs corresponding to Vivado version)
    command = 'bash -c "cp {questasimlib_path}/modelsim.ini ."'.format(**locals())
    run_command(command)

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('--vivado', help = "Vivado version", required = True)
    parser.add_argument('--questasim', default=DefaultQuestaSimPath, help = "Questasim installation path")
    parser.add_argument('--output', default=DefaultQuestaSimLibsPath, help = "Questasim Vivado libraries path")
    return parser.parse_args()

def main():
    
    args = parse()
    
    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
    
    run_compile_simlib(args.vivado, args.questasim, args.output)
    
if __name__ == '__main__':
    main()
