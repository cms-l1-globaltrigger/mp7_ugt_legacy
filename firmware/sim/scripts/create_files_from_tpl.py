#
# This script runs Modelsim on given trigger menu for gtl_fdl_wrapper.vhd
#

import argparse
import subprocess
import logging
import glob
import sys, os

# Directories.
SCRIPTS_DIR = 'scripts'
TB_DIR = 'testbench'

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

def parse():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('dofile', help = "dofile name (without extension) [in './../scripts']")
    parser.add_argument('path_mp7_tag', help = "path to tag of MP7 boards and components sources")
    parser.add_argument('testvector', help = "path to testvector file to be used")
    parser.add_argument('--p', action = 'store_true', help = "enables prints to console")
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse()

    debug = args.p

    # Create name of do-file template.
    dofile_tpl = ''.join([args.dofile, '_tpl.do'])
    if debug:
        print(("dofile_tpl: {dofile_tpl}".format(**locals())))
        print(("path_mp7_tag: {args.path_mp7_tag}".format(**locals())))

    testvector = (args.testvector)
    if debug:
        print("testvector_path: {args.testvector}".format(**locals()))
    # Get string of testvector.
    testvector_name = os.path.basename(args.testvector)
    if debug:
        print("testvector_name: {testvector_name}".format(**locals()))

    menu_name_array = testvector.split("/")
    # revers order of array
#    menu_name_array_inv = menu_name_array.reverse()
    menu_name_array_inv = menu_name_array[::-1]
    #if debug:
        #print "menu_name_array: {menu_name_array}".format(**locals())
        #print "menu_name_array_inv: {menu_name_array_inv}".format(**locals())

    for i in range(1,3):
        menu_name_array_inv.pop(0)
        #if debug:
             #print "menu_name_array_inv {i}: {menu_name_array_inv}".format(**locals())

    menu_name = menu_name_array_inv[0]
    #if debug:
        #print "menu_name: {menu_name}".format(**locals())

    menu_path_array = menu_name_array_inv[::-1]
    if debug:
        print("menu_path_array: {menu_path_array}".format(**locals()))

    temp = []
    for i in range(len(menu_path_array)+1):
        temp.append(0)
    #if debug:
        #print "temp: {temp}".format(**locals())
    temp[0] = ''
    #if debug:
        #print "temp[0]: {temp[0]}".format(**locals())

    for i in range(len(menu_path_array)):
        if i == len(menu_path_array)-1:
            temp[i+1] = ''.join([temp[i], menu_path_array[i]]) # no '/' at end of path
        else:
            temp[i+1] = ''.join([temp[i], menu_path_array[i], '/'])

    #if debug:
        #print "temp after loop: {temp}".format(**locals())
    menu_path = temp[len(menu_path_array)]
    if debug:
        print("menu_path: {menu_path}".format(**locals()))

    dofile_out = ''.join([args.dofile, '_', menu_name, '.do'])
    if debug:
        print("***********************************************************")
        print("==> dofile for use in vsim (ModelSim): {dofile_out}".format(**locals()))
        print("***********************************************************")

    tbfile_tpl = ''.join([args.dofile, '_tb_tpl.vhd'])
    if debug:
        print("tbfile_tpl: {tbfile_tpl}".format(**locals()))
    tbfile_out = ''.join([args.dofile, '_tb.vhd'])
    if debug:
        print("tbfile: {tbfile_out}".format(**locals()))

    # ---------------------------------------------------------------------
    #  Substitute variables in do file template.
    # ---------------------------------------------------------------------

    render_template((os.path.join(SCRIPTS_DIR, dofile_tpl)), (os.path.join(SCRIPTS_DIR, dofile_out)), {
        '_MP7_TAG_' : args.path_mp7_tag,
        '_MENU_PATH_' : menu_path,
        '_MENU_NAME_' : menu_name,
    })

    # ---------------------------------------------------------------------
    #  Substitute variables in testbench file template.
    # ---------------------------------------------------------------------

    render_template((os.path.join(TB_DIR, tbfile_tpl)), (os.path.join(TB_DIR, tbfile_out)), {
        '{{TESTVECTOR_FILENAME}}' : testvector,
        '{{FILE_NAME}}' : args.dofile,
        '{{TESTVECTOR_NAME}}' : testvector_name,
    })

    # ---------------------------------------------------------------------
    #  Copy wave file.
    # ---------------------------------------------------------------------

    #wave_file_src = ''.join([args.dofile, '_wave.do'])
    #wave_file_dst = ''.join([args.dofile, '_', menu_name, '_wave.do'])
    #render_template((os.path.join(SCRIPTS_DIR, wave_file_src)), (os.path.join(SCRIPTS_DIR, wave_file_dst)), {
    ## used for copy, because "copyfile" did not work
    #})

    #copyfile(wave_file_src, wave_file_dst)

    return 0 # exit success

# Run main function with passed arguments.
if __name__ == '__main__':
    sys.exit(main())

#eof
