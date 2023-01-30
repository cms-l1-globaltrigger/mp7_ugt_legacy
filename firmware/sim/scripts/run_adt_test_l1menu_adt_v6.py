import argparse
import os
import logging

TEST_DIR_DEF = "adt_test"
L1MENU_DEF = "l1menu_adt_v6"

PKG_NAME = "adt_test_sim_pkg"
PKG_TPL = "{}_tpl.vhd".format(PKG_NAME)
PKG_TMP = "{}_tmp.vhd".format(PKG_NAME)
PKG_FILE = "{}.vhd".format(PKG_NAME)
DO_NAME = "adt_test_l1menu_adt_v6"
DO_TPL = "{}_tpl.do".format(DO_NAME)
DO_FILE = "{}.do".format(DO_NAME)

# order in algo_bit_name: module 0 to 3 (key = algo bit, value = algo name)
algo_bit_name = {0: "L1_ADT_20000", 2: "L1_ADT_400", 1: "L1_ADT_4000", 3: "L1_ADT_80"}

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def render_template(src, dst, args):
    """Replaces content of file *src* with values of dictionary *args* and writes to file *dst*.
    >>> render_template("template.txt", "sample.txt", { 'foo' : "bar", })
    """
    logging.debug("rendering template %s as %s", src, dst)
    with open(src) as f:
        content = f.read()
    for needle, subst in list(args.items()):
        logging.debug("  replacing `%s' by `%s'", needle, subst)
        content = content.replace(needle, subst)
    with open(dst, 'w') as dst:
        dst.write(content)

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--menu', default=L1MENU_DEF, help="menu name of L1Menu for adt test (default is '{}')".format(L1MENU_DEF))
    parser.add_argument('--test_dir', default=TEST_DIR_DEF, help="dir name for adt test data (default is '{}')".format(TEST_DIR_DEF))
    return parser.parse_args()

def main():
    args = parse_args()

    err_files = {}
    
    work_dir = os.path.abspath(os.getcwd())
    
    TEST_DIR = args.test_dir
    L1MENU = args.menu
        
    for i in range(len(algo_bit_name)):
        module_nr = 'module_{}'.format(i)
        error_file_path = os.path.join(work_dir, TEST_DIR, L1MENU, module_nr, 'error_file_{}.txt').format(algo_bit_name.get(list(algo_bit_name.keys())[i]))
        err_files[i] = error_file_path
        
        vhdl_file_tpl_path = os.path.join(work_dir, 'testbench', 'templates', PKG_TPL)
        vhdl_file_path = os.path.join(work_dir, 'testbench', PKG_TMP)
        render_template(vhdl_file_tpl_path, vhdl_file_path, {'{{ALGO_BIT}}': str(list(algo_bit_name.keys())[i])})
        
        vhdl_file_tpl_path = os.path.join(work_dir, 'testbench', PKG_TMP)
        vhdl_file_path = os.path.join(work_dir, 'testbench', PKG_FILE)
        render_template(vhdl_file_tpl_path, vhdl_file_path, {'{{ERR_FILE_LOC}}': error_file_path})
        
        do_file_tpl_path = os.path.join(work_dir, 'scripts', 'templates', DO_TPL)
        do_file_path = os.path.join(work_dir, 'scripts', DO_FILE)
        render_template(do_file_tpl_path, do_file_path, {'{{MOD_NR}}': module_nr})
        
        do_cmds_path = os.path.join(work_dir, TEST_DIR, L1MENU, module_nr, 'temp.txt')
        exec_do_cmds = ". " + do_cmds_path
        line = '/opt/mentor/questasim/bin/vsim -c -do "do scripts/{}; quit -f"'.format(DO_FILE)
        with open(do_cmds_path, 'w') as f:
            f.write(line)
            f.write('\n')
    
        command = f'bash -c "chmod 744 {do_cmds_path}; {exec_do_cmds}"'
        run_command(command)

    for i in range(len(algo_bit_name)):
        if os.path.getsize(err_files[i]) != 0:
            print('Errors in file: {}'.format(err_files[i]))

        command = f'bash -c "rm {work_dir}/{TEST_DIR}/{L1MENU}/module_{i}/temp.txt"'
        run_command(command)
        
    command = f'bash -c "rm {vhdl_file_path}; rm {do_file_path}"'
    run_command(command)

if __name__ == '__main__':
    main()

