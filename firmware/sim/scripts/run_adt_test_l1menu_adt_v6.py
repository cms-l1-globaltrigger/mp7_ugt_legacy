#import xmlmenu
import os, sys
#import json
import subprocess
import logging
#import argparse
#import time, datetime
#from threading import Thread

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def main():

    algo_names = ["L1_ADT_20000", "L1_ADT_4000", "L1_ADT_400", "L1_ADT_80"]
    mod_nr = [0, 2, 1, 3]
    
    work_dir = os.path.abspath(os.getcwd())
        
    for i in range(len(algo_names)):
        module_nr = 'module_{}'.format(mod_nr[i])
        adt_test_pkg_path = os.path.join(work_dir, 'adt_test', 'l1menu_adt_v6', module_nr, 'adt_test_sim_pkg.vhd')
        a = 'constant ADT_ALGO_BIT: integer := {};'.format(i)
        b = 'constant ERROR_FILE_LOC: string := "./adt_test/l1menu_adt_v6/module_{}/error_file_{}.txt";'.format(mod_nr[i], algo_names[i])
        lines = ['library ieee;', 'use ieee.std_logic_1164.all;', 'package adt_test_sim_pkg is', a, b, 'end package;']
        with open(adt_test_pkg_path, 'w') as f:
            for line in lines:
                f.write(line)
                f.write('\n')
    
        do_cmds_path = os.path.join(work_dir, 'adt_test', 'l1menu_adt_v6', module_nr, 'temp.txt')
        exec_do_cmds = ". " + do_cmds_path
        line = '/opt/mentor/questasim/bin/vsim -c -do "do scripts/adt_test_l1menu_adt_v6_mod_{}.do; quit -f"'.format(mod_nr[i])
        with open(do_cmds_path, 'w') as f:
            f.write(line)
            f.write('\n')
    
        command = f'bash -c "chmod 744 {do_cmds_path}; {exec_do_cmds}"'
        run_command(command)

    for i in range(len(algo_names)):
        file_path = "{}/adt_test/l1menu_adt_v6/module_{}/error_file_{}.txt".format(work_dir, mod_nr[i], algo_names[i])
        if os.path.getsize(file_path) != 0:
            print('Errors in file: {}'.format(file_path))

        command = f'bash -c "rm {work_dir}/adt_test/l1menu_adt_v6/module_{i}/temp.txt"'
        run_command(command)
        command = f'bash -c "rm {work_dir}/adt_test/l1menu_adt_v6/module_{i}/adt_test_sim_pkg.vhd"'
        run_command(command)

if __name__ == '__main__':
    main()

