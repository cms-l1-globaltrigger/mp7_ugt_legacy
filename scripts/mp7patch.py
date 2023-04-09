import argparse
import logging
import os
import re

import toolbox as tb

def replace_area_constraints(filename):

    fin = open(filename, "rt")
    #read file contents to string
    data = fin.read()
    #replace all occurrences of the required string
    data = data.replace('X191', 'X181')
    data = data.replace('X192', 'X162')
    #close the input file
    fin.close()
    #open the input file in write mode
    fin = open(filename, "wt")
    #overrite the input file with the resulting data
    fin.write(data)
    #close the file
    fin.close()

    content = tb.read_file(filename)
    
    t_pblock = "resize_pblock [get_pblocks payload] -add {SLICE_X30Y0:SLICE_X181Y449}"
    s_pblock = "resize_pblock [get_pblocks payload] -add {SLICE_X0Y0:SLICE_X181Y449}"
    t_loop = "for {set i 0} {$i < 18} {incr i} {"
    s_loop = "for {set i 0} {$i < 8} {incr i} {"
    t_cell = "add_cells_to_pblock [get_pblocks payload_8] [get_cells -quiet datapath/rgen[8].region/pgen.*]"
    s_cell = "add_cells_to_pblock [get_pblocks payload_7] [get_cells -quiet datapath/rgen[7].region/pgen.*]"
    text = [t_pblock, t_loop, t_cell]
    subs = [s_pblock, s_loop, s_cell]
    flags = 0
    
    for i in range(0,3):
        with open( filename, "r+" ) as file:
            fileContents = file.read()
            textPattern = re.compile( re.escape( text[i] ), flags )
            fileContents = textPattern.sub( subs[i], fileContents )
            file.seek( 0 )
            file.truncate()
            file.write( fileContents )
        
def replace_brd_decl(filename):
    content = tb.read_file(filename)

    expr_nregion = re.compile(r"(constant\s+N_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")
    expr_crossregion = re.compile(r"(constant\s+CROSS_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")

    content, count = expr_nregion.subn(r"\g<1>8\g<3>", content)
    if count != 1:
        raise RuntimeError("Could not replace the N_REGION value.")

    content, count = expr_crossregion.subn(r"\g<1>7\g<3>", content)
    if count != 1:
        raise RuntimeError("Could not replace the CROSS_REGION value.")

    with open(filename, "w") as fp:
        fp.write(content)
        logging.info("Successfully patched brd_decl file '{}'".format(filename))

def insert_l1a_ttc(filename):
    content = tb.read_file(filename)

    expr_payload = re.compile(r"(\s*ctrs\s*=>\s*ctrs\s*,)(\s*bc0\s*=>\s*payload_bc0\s*,)")
    l1a_str = "\n           l1a => ttc_l1a,"

    content, count = expr_payload.subn(r"\g<1>{l1a_str}\g<2>".format(**locals()), content)
    if count != 1:
        raise RuntimeError("Could not insert l1a ttc port.")

    with open(filename, "w") as fp:
        fp.write(content)
        logging.info("Successfully patched l1a_ttc file '{}'".format(filename))

def patch_all(projectpath):
    """Batch patch all firmware files."""
    root_path = os.path.abspath(projectpath)

    brd_decl_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd'
    area_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl'
    mp7xe_690_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd'
    #script_writer_path = 'scripts/firmware/dep_tree/VivadoScriptWriter.py'

    #append_vivado_rules(os.path.join(root_path, script_writer_path))
    replace_area_constraints(os.path.join(root_path, area_constraints_path))
    replace_brd_decl(os.path.join(root_path, brd_decl_path))
    insert_l1a_ttc(os.path.join(root_path, mp7xe_690_path))

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('path', type=os.path.abspath, help="path to the cactusupgrades dir of the fw tag which should be patched")
    return parser.parse_args()

def main():
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)

    # Patch all files
    try:
        patch_all(args.path)
    except Exception as message:
        logging.error(message)
        raise

    logging.info("done.")

if __name__ == '__main__':
    main()
