import argparse
import logging
import os
import re

import toolbox as tb

def replace_area_constraints(filename):
    # TODO consider using regular expressions
    patterns = [
        (
            "X191",
            "X181",
        ),
        (
            "X192",
            "X182",
        ),
        (
            "resize_pblock [get_pblocks payload] -add {SLICE_X30Y0:SLICE_X181Y449}",
            "resize_pblock [get_pblocks payload] -add {SLICE_X0Y0:SLICE_X181Y449}",
        ),
        (
            "for {set i 0} {$i < 18} {incr i} {",
            "for {set i 0} {$i < 8} {incr i} {",
        ),
        (
            "add_cells_to_pblock [get_pblocks payload_8] [get_cells -quiet datapath/rgen[8].region/pgen.*]",
            "add_cells_to_pblock [get_pblocks payload_7] [get_cells -quiet datapath/rgen[7].region/pgen.*]",
        ),
    ]

    content = tb.read_file(filename)

    for pattern, repl in patterns:
        content = re.sub(re.escape(pattern), repl, content)

    with open(filename, "wt") as f:
        f.write(content)


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

    with open(filename, "wt") as fp:
        fp.write(content)
        logging.info(f"Successfully patched brd_decl file {filename!r}")


def insert_l1a_ttc(filename):
    content = tb.read_file(filename)

    expr_payload = re.compile(r"(\s*ctrs\s*=>\s*ctrs\s*,)(\s*bc0\s*=>\s*payload_bc0\s*,)")
    l1a_str = "\n           l1a => ttc_l1a,"

    content, count = expr_payload.subn(r"\g<1>{l1a_str}\g<2>".format(**locals()), content)
    if count != 1:
        raise RuntimeError("Could not insert l1a ttc port.")

    with open(filename, "wt") as fp:
        fp.write(content)
        logging.info(f"Successfully patched l1a_ttc file {filename!r}")


def patch_all(projectpath):
    """Batch patch all firmware files."""
    root_path = os.path.abspath(projectpath)

    brd_decl_path = "boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd"
    area_constraints_path = "boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl"
    mp7xe_690_path = "boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd"
    #script_writer_path = "scripts/firmware/dep_tree/VivadoScriptWriter.py"

    #append_vivado_rules(os.path.join(root_path, script_writer_path))
    replace_area_constraints(os.path.join(root_path, area_constraints_path))
    replace_brd_decl(os.path.join(root_path, brd_decl_path))
    insert_l1a_ttc(os.path.join(root_path, mp7xe_690_path))


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument("path", type=os.path.abspath, help="path to the cactusupgrades dir of the fw tag which should be patched")
    return parser.parse_args()


def main():
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.DEBUG)

    # Patch all files
    try:
        patch_all(args.path)
    except Exception as exc:
        logging.exception(exc)
        raise

    logging.info("done.")


if __name__ == "__main__":
    main()
