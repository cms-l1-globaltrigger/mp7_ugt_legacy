import argparse
import logging
import os
import re

import toolbox as tb

def replace_area_constraints(filename):
    content = tb.read_file(filename)

    #expr_forloop = re.compile(r"(for\s+{\s*set\s*i\s*0\s*}\s+{\s*\$i\s*<\s*)(\d+)(\s*}\s+{\s*incr\s+i\s*})")
    #expr_cells = re.compile(r"(add_cells_to_pblock\s+\[\s*get_pblocks\s+payload_)(\d+)(\s*]\s*\[get_cells\s+(?:-\w+\s+)?datapath/rgen\[)(\d+)(]\.region/pgen\.\*])")

    #content, count = expr_forloop.subn(r"\g<1>8\g<3>", content)
    #if count != 1:
        #raise RuntimeError("Could not replace the for-loop value.")

    #content, count = expr_cells.subn(r"\g<1>7\g<3>7\g<5>", content)
    #if count != 1:
        #raise RuntimeError("Could not replace add_cells_to_pblock line.")
    
    text = "resize_pblock [get_pblocks payload] -add {SLICE_X30Y0:SLICE_X191Y449}"
    subs = "resize_pblock [get_pblocks payload] -add {SLICE_X0Y0:SLICE_X191Y449}"
    flags = 0
    
    with open( filename, "r+" ) as file:
        fileContents = file.read()
        textPattern = re.compile( re.escape( text ), flags )
        fileContents = textPattern.sub( subs, fileContents )
        file.seek( 0 )
        file.truncate()
        file.write( fileContents )
        
#def replace_brd_decl(filename):
    #content = tb.read_file(filename)

    #expr_nregion = re.compile(r"(constant\s+N_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")
    #expr_crossregion = re.compile(r"(constant\s+CROSS_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")

    #content, count = expr_nregion.subn(r"\g<1>8\g<3>", content)
    #if count != 1:
        #raise RuntimeError("Could not replace the N_REGION value.")

    #content, count = expr_crossregion.subn(r"\g<1>7\g<3>", content)
    #if count != 1:
        #raise RuntimeError("Could not replace the CROSS_REGION value.")

    #with open(filename, "w") as fp:
        #fp.write(content)
        #logging.info("Successfully patched brd_decl file '{}'".format(filename))

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

## HB 2022-09-16: with IPBB 0.5.2 'scripts/firmware/dep_tree/VivadoScriptWriter.py' does not exist anymore in environment "ipbb-0.5.2".
## Statements "set_property ..." are now located in '../mp7_ugt_legacy/firmware/ucf/ugt_strategy.tcl'. No need for patch anymore.

#def append_vivado_rules(filename):
    #rules = [
        #"      ## HB 2017-04-06: inserted -assert = 1, which means \"Enable VHDL assert statements to be evaluated\"",
        #"      ## (see UG901 (v2016.3) October 21, 2016, page 12)",
        #"      write( \'set_property \"steps.synth_design.args.assert\" 1 [get_runs synth_1]\' )",

        #"      ## HB 2017-04-06: for timimg optimisation",
        #"      write( \'set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]\' )",

        #"      ## EOF",
    #]

    #with open(filename, "a") as fp:
        #for rule in rules:
            #fp.write(rule)
            #fp.write("\n")
        #logging.info("Successfully patched VivadoScriptWriter file '{}'".format(filename))

def patch_all(projectpath):
    """Batch patch all firmware files."""
    root_path = os.path.abspath(projectpath)

    #brd_decl_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd'
    area_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl'
    mp7xe_690_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd'
    #script_writer_path = 'scripts/firmware/dep_tree/VivadoScriptWriter.py'

    #append_vivado_rules(os.path.join(root_path, script_writer_path))
    replace_area_constraints(os.path.join(root_path, area_constraints_path))
    #replace_brd_decl(os.path.join(root_path, brd_decl_path))
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
