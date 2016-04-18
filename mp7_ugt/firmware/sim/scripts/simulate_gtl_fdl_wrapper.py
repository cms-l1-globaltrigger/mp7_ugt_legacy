#!/usr/bin/env python2
#
# This script runs Modelsim on given trigger menu for gtl_fdl_wrapper.vhd
#

import argparse
import subprocess
import logging
import glob
import sys, os

# Default paths and versions.
DEFAULT_XILINX_PATH = '/opt/xilinx/14.6'
DEFAULT_MODELSIM_VERSION = '10.3b'
DEFAULT_MODELSIM_INI_TPL = 'modelsim_tpl.ini'

# Directories.
SCRIPTS_DIR = 'scripts'
TB_DIR = 'testbench'
SRC_DIR = '../hdl'

# Do file and template.
INI_FILE_TPL = 'modelsim_tpl.ini'
INI_FILE = 'modelsim.ini'

# Do file and template.
DO_FILE_TPL = os.path.join(SCRIPTS_DIR, 'gtl_fdl_wrapper_tpl.do')
DO_FILE = os.path.join(SCRIPTS_DIR, 'gtl_fdl_wrapper.do')

# Testbench file and template.
TB_FILE_TPL = os.path.join(TB_DIR, 'gtl_fdl_wrapper_tb_tpl.vhd')
TB_FILE = os.path.join(TB_DIR, 'gtl_fdl_wrapper_tb.vhd')

TEMP_FILE = os.path.join(TB_DIR, 'temp_file.vhd')

# gt_mp7_top_pkg_tpl.vhd template.
GT_MP7_TOP_PKG_TPL = os.path.join(SRC_DIR, 'gt_mp7_top_pkg_tpl.vhd')
GT_MP7_TOP_PKG_SIM_TEMP = os.path.join(SRC_DIR, 'gt_mp7_top_pkg_sim_temp.vhd')

def remove_file(filename):
    """Savely remove a file or a symbolic link."""
    if os.path.isfile(filename) or os.path.islink(filename):
        os.remove(filename)

def count_modules(menu):
    """Returns count of modules of menu. *menu* is the path to the menu directory."""
    pattern = os.path.join(menu, 'vhdl', 'module_*')
    return len(glob.glob(pattern))

def render_template(src, dst, args):
    """Replaces content of file *src* with values of dictionary *args* and writes to file *dst*.
    >>> render_template("template.txt", "sample.txt", { 'foo' : "bar", })
    """
    logging.info("rendering template %s as %s", src, dst)
    with open(src) as src:
        content = src.read()
    for needle, subst in args.items():
        logging.info("  replacing `%s' by `%s'", needle, subst)
        content = content.replace(needle, subst)
    with open(dst, 'w') as dst:
        dst.write(content)

def call_process(*args):
    logging.info("executing: %s", ' '.join(['"{0}"'.format(arg) if ' ' in str(arg) else str(arg) for arg in args]))
    subprocess.check_call(args)

def parse():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('mp7tag', help = "path to MP7 tag")
    parser.add_argument('menu', help = "path to trigger menu directory")
    parser.add_argument('testvector', help = "path to testvector to be used")
    parser.add_argument('-m', '--module', metavar = '<n>', type = int, default = 0, help = "module to be simulated, default is `0'")
    parser.add_argument('-o', metavar = '<filename>', default = None, help = "write transcript, warnings and errors to file, default is `sim_results_gtl_fdl_wrapper_<testvector>'")
    parser.add_argument('--wlf', action = 'store_true', help = "no console transcript info, warning and error messages (transcript output to vsim.wlf)")
    parser.add_argument('--xilinx-path', metavar = '<path>', default = DEFAULT_XILINX_PATH, help = "path to xilinx installation, default is `{DEFAULT_XILINX_PATH}'".format(**globals()))
    parser.add_argument('--modelsim', metavar = '<version>', default = DEFAULT_MODELSIM_VERSION, help = "select modelsim version, default is `{DEFAULT_MODELSIM_VERSION}'".format(**globals()))
    parser.add_argument('--config', metavar = '<filename>', default = DEFAULT_MODELSIM_INI_TPL, help = "set modelsim INI template file, default is `{DEFAULT_MODELSIM_INI_TPL}'".format(**globals()))
    parser.add_argument('--p', action = 'store_true', help = "enables debug prints to console")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse()

    debug = 'prints' if args.p else ''

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)

    # MP7 tag path.
    mp7_tag = args.mp7tag

    # Menu path.
    menu_path = args.menu

    # Fetch menu name from path.
    menu_name = os.path.basename(args.menu)

    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Menu contains no modules")

    # Fetch number of menu modules.
    modules = count_modules(args.menu)

    if not modules:
        raise RuntimeError("Menu contains no modules")
    if args.module >= modules:
        raise RuntimeError("Selected module out of range")

    # Set message mode:
    # wlf => no output to console for transcript info, warning and error messages (transcript output to vsim.wlf).
    # tran => output to console.
    msgmode = 'wlf' if args.wlf else 'tran'

    # Testvector name (basename without extension).
    testvector_name = os.path.splitext(os.path.basename(args.testvector))[0]
    if debug == 'prints':
	print "testvector_name: {testvector_name}".format(**locals())
 
    # As things are getting serious let's start logging to file.
    handler = logging.FileHandler('sum_{testvector_name}.log'.format(**locals()), mode = 'w')
    handler.setFormatter(logging.Formatter(fmt = '%(asctime)s %(levelname)s : %(message)s', datefmt='%Y-%m-%d %H:%M:%S'))
    handler.setLevel(logging.DEBUG)
    logging.getLogger().addHandler(handler)

    # ---------------------------------------------------------------------
    #  Setup report
    # ---------------------------------------------------------------------

    logging.info("Running GTL/FDL simulation...")
    logging.info("mp7_tag: %s", args.mp7tag)
    logging.info("menu: %s", args.menu)
    logging.info("module: %s", args.module)
    logging.info("test vector: %s", args.testvector)
    logging.info("vsim msgmode: %s", msgmode)
    logging.info("Xilinx path: %s", args.xilinx_path)
    logging.info("ModelSIM version: %s", args.modelsim)

    # ---------------------------------------------------------------------
    #  Substitute variables in do file template and testbench template.
    # ---------------------------------------------------------------------

    render_template(INI_FILE_TPL, INI_FILE, {
        '{{XILINX_PATH}}' : args.xilinx_path,
        '{{MODELSIM_VERSION}}' : args.modelsim,
    })
    render_template(DO_FILE_TPL, DO_FILE, {
        '_MP7_TAG_' : mp7_tag,
        '_MENU_PATH_' : menu_path,
    })
    render_template(TB_FILE_TPL, TEMP_FILE, {
        '_MENU_NAME_' : menu_name,
    })
    render_template(TEMP_FILE, TB_FILE, {
        '{{TESTVECTOR_FILENAME}}' : args.testvector,
        '{{TESTVECTOR_NAME}}' : testvector_name,
    })
    render_template(GT_MP7_TOP_PKG_TPL, GT_MP7_TOP_PKG_SIM_TEMP, {
        '{{IPBUS_TIMESTAMP}}' : 'X"00000000"',
        '{{IPBUS_USERNAME}}' : 'X"0000000000000000000000000000000000000000000000000000000000000000"',
        '{{IPBUS_HOSTNAME}}' : 'X"0000000000000000000000000000000000000000000000000000000000000000"',
        '{{IPBUS_BUILD_VERSION}}' : 'X"00000000"',
    })

    # Run Modelsim with makefile, on fail (1) raise error.
    call_process('vsim', '-c', '-msgmode', msgmode, '-do', 'do {filename}; quit -f'.format(filename = DO_FILE))

    print
    print " ==> see `sim_results_gtl_fdl_wrapper_{testvector_name}.txt' for detailed information !!!".format(**locals())
    print
#    remove_file(GT_MP7_TOP_PKG_SIM_TEMP)
    print

    return 0 # exit success

# Run main function with passed arguments.
if __name__ == '__main__':
    sys.exit(main())

#eof
