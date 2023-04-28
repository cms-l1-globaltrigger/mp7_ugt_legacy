import argparse
import logging
import os
import re

import toolbox as tb

# Only "insert l1a ttc port" in this patch file.

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

    mp7xe_690_path = "boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd"

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
