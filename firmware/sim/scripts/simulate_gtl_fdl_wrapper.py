#
# This script runs Modelsim on given trigger menu for gtl_fdl_wrapper.vhd
#
import argparse
import subprocess
import logging
import glob
import sys, os
import shutil
# Default paths and versions.
DEFAULT_XILINX_PATH = '/opt/xilinx/14.6'
DEFAULT_MODELSIM_VERSION = '10.3b'
DEFAULT_MODELSIM_INI_TPL = 'modelsim_tpl.ini'
# Do file and template.
INI_FILE_TPL = 'modelsim_tpl.ini'
INI_FILE = 'modelsim.ini'
# Do file and template.
DO_FILE_TPL = 'scripts/gtl_fdl_wrapper_tpl.do'
DO_FILE = 'scripts/gtl_fdl_wrapper.do'
# Testbench file and template.
TB_FILE_TPL = 'testbench/gtl_fdl_wrapper_tb_tpl.vhd'
TB_FILE = 'testbench/gtl_fdl_wrapper_tb.vhd'
TEMP_FILE = 'testbench/temp_file.vhd'
## HB 2016-12-05: not used anymore (using ../hdl/gt_mp7_core/gt_mp7_core_pkg_sim.vhd for simulation)
## gt_mp7_top_pkg_tpl.vhd template.
#GT_MP7_TOP_PKG_TPL = os.path.join(SRC_DIR, 'gt_mp7_top_pkg_tpl.vhd')
#GT_MP7_TOP_PKG_SIM_TEMP = os.path.join(SRC_DIR, 'gt_mp7_top_pkg_sim_temp.vhd')
## *****************************************************************************************************
def remove_file(filename):
    """Savely remove a file or a symbolic link."""
    if os.path.isfile(filename) or os.path.islink(filename):
        os.remove(filename)
## *****************************************************************************************************
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
## *****************************************************************************************************
def call_process(*args):
    logging.info("executing: %s", ' '.join(['"{0}"'.format(arg) if ' ' in str(arg) else str(arg) for arg in args]))
    return subprocess.check_call(args)
## *****************************************************************************************************
def template_replace(template, replace_map, result):
    """Load template by replacing keys from dictionary and writing to result
    file. The function ignores VHDL escaped lines.

    Example:
    >>> template_replace('sample.tpl.vhd', {'name': "title"}, 'sample.vhd')"""
    # Read content of source file.
    with open(template) as fp:
        lines = fp.readlines()
    # Replace placeholders.
    for key, value in replace_map.items():
        for i, line in enumerate(lines):
            if not line.strip().startswith('--'):
                lines[i] = line.replace(key, value)
    # Write content to destination file.
    with open(result, 'w') as fp:
        fp.write(''.join(lines))
## *****************************************************************************************************
def read_file(filename):
    """Returns contents of a file."""
    with open(filename) as fp:
        return fp.write()
## *****************************************************************************************************
def parse():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('mp7tag', type=os.path.abspath, help = "path to MP7 tag")
    parser.add_argument('menu', type=os.path.abspath, help = "path to trigger menu directory")
    parser.add_argument('--testvector', type=os.path.abspath, help = "path to testvector to be used")
    parser.add_argument('-o', metavar = '<filename>', help = "write transcript, warnings and errors to file, default is `sim_results_gtl_fdl_wrapper_<testvector>'")
    parser.add_argument('--wlf', action = 'store_true', help = "no console transcript info, warning and error messages (transcript output to vsim.wlf)")
    parser.add_argument('--xilinx-path', metavar = '<path>', default = DEFAULT_XILINX_PATH, help = "path to xilinx installation, default is `{DEFAULT_XILINX_PATH}'".format(**globals()))
    parser.add_argument('--modelsim', metavar = '<version>', default = DEFAULT_MODELSIM_VERSION, help = "select modelsim version, default is `{DEFAULT_MODELSIM_VERSION}'".format(**globals()))
    parser.add_argument('--config', metavar = '<filename>', default = DEFAULT_MODELSIM_INI_TPL, help = "set modelsim INI template file, default is `{DEFAULT_MODELSIM_INI_TPL}'".format(**globals()))
    parser.add_argument('-v', '--verbose', action = 'store_true', help = "enables debug prints to console")
    return parser.parse_args()
## *****************************************************************************************************
def main():
    """Main routine."""
    # Parse command line arguments.
    args = parse()
    sim_dir = os.getenv('SIM_ROOT')#looks for sim dir if not found display error
    if not sim_dir:
        raise RuntimeError("var SIM_ROOT is not defined (start setup.sh first!)")
    debug = 'prints' if args.p else ''
    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)
    # Menu path.
    menu_path = args.menu + '/vhdl/module_' + str(args.module)
    # Fetch menu name from path.
    menu_name = os.path.basename(args.menu)
    if not menu_name.startswith('L1Menu_'):
        raise RuntimeError("Menu contains no modules")
    # Set message mode:
    # wlf => no output to console for transcript info, warning and error messages (transcript output to vsim.wlf).
    # tran => output to console.
    msgmode = 'wlf' if args.wlf else 'tran'
    # Testvector name (basename without extension).
    if not args.testvector:
        pass # TODO!
    else:
        testvector_name = os.path.splitext(os.path.basename(args.testvector))[0]
    if debug == 'prints':
        print("testvector_name: {testvector_name}".format(**locals()))
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
    logging.info("menu_path: %s", menu_path)
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
        '_MP7_TAG_' : args.mp7_tag,
        '_MENU_PATH_' : menu_path,
    })
    render_template(TB_FILE_TPL, TEMP_FILE, {
        '_MENU_NAME_' : menu_name,
    })
    render_template(TEMP_FILE, TB_FILE, {
        '{{TESTVECTOR_FILENAME}}' : args.testvector,
        '{{TESTVECTOR_NAME}}' : testvector_name,
    })
## HB 2016-12-05: not used anymore (using ../hdl/gt_mp7_core/gt_mp7_core_pkg_sim.vhd for simulation)
    #render_template(GT_MP7_TOP_PKG_TPL, GT_MP7_TOP_PKG_SIM_TEMP, {
        #'{{IPBUS_TIMESTAMP}}' : 'X"00000000"',
        #'{{IPBUS_USERNAME}}' : 'X"0000000000000000000000000000000000000000000000000000000000000000"',
        #'{{IPBUS_HOSTNAME}}' : 'X"0000000000000000000000000000000000000000000000000000000000000000"',
        #'{{IPBUS_BUILD_VERSION}}' : 'X"00000000"',
    #})
## HB 2016-11-15: generate temporary VHDL files with templates of VHDL files and 'snippets' from VHDL Producer
## HB 2016-11-16: create temporary directory 'vhdl_temp'
    sim_dir_vhdl_temp = os.path.join(sim_dir, 'vhdl_temp')
    #print sim_dir_vhdl_temp
    if not os.path.exists(sim_dir_vhdl_temp):
        os.makedirs(sim_dir_vhdl_temp)

    uGTalgosPath = os.path.abspath(os.path.join(sim_dir, '..'))
    src_dir = os.path.join(menu_path, 'src')
    replace_map = {
        '{{algo_index}}': read_file(os.path.join(src_dir, 'algo_index.vhd')),
        '{{ugt_constants}}': read_file(os.path.join(src_dir, 'ugt_constants.vhd')),
        '{{gtl_module_signals}}': read_file(os.path.join(src_dir, 'gtl_module_signals.vhd')),
        '{{gtl_module_instances}}': read_file(os.path.join(src_dir, 'gtl_module_instances.vhd')),
    }
    gtl_fdl_wrapper_dir = os.path.join(uGTalgosPath, 'hdl', 'gt_mp7_core', 'gtl_fdl_wrapper')
    gtl_dir = os.path.join(gtl_fdl_wrapper_dir, 'gtl')
    fdl_dir = os.path.join(gtl_fdl_wrapper_dir, 'fdl')
    # Patch VHDL files
    template_replace(os.path.join(fdl_dir, 'algo_mapping_rop_tpl.vhd'), replace_map, os.path.join(sim_dir_vhdl_temp, 'algo_mapping_rop.vhd'))
    template_replace(os.path.join(gtl_dir, 'gtl_pkg_tpl.vhd'), replace_map, os.path.join(sim_dir_vhdl_temp, 'gtl_pkg.vhd'))
    template_replace(os.path.join(gtl_dir, 'gtl_module_tpl.vhd'), replace_map, os.path.join(sim_dir_vhdl_temp, 'gtl_module.vhd'))
    # Run Modelsim with makefile, on fail (1) raise error.
    if 0 != call_process('vsim', '-c', '-msgmode', msgmode, '-do', 'do {filename}; quit -f'.format(filename = DO_FILE)):
        print("something went wrong")
    print()
    print(" ==> see 'sim_results_gtl_fdl_wrapper_{testvector_name}.txt' for detailed information !!!".format(**locals()))
    print()
## HB 2016-11-16: remove temporary directory 'vhdl_temp'
    #print " ==> removed temporary directory 'vhdl_temp'"
#    shutil.rmtree('vhdl_temp')
    return 0 # exit success
# Run main function with passed arguments.
if __name__ == '__main__':
    sys.exit(main())
#eof
