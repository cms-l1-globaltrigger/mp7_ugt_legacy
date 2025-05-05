import argparse
import datetime
import json
import logging
import os
import re
import shutil
import subprocess
import sys
import tempfile

logger = utils.get_colored_logger(__name__)

QuestaSimPath = os.getenv("UGT_QUESTASIM_SIM_PATH")
if not QuestaSimPath:
    raise RuntimeError("UGT_QUESTASIM_SIM_PATH is not defined.")

DefaultQuestaSimLibsPath = os.getenv("UGT_QUESTASIM_LIBS_PATH")
if not DefaultQuestaSimLibsPath:
    raise RuntimeError("UGT_QUESTASIM_LIBS_PATH is not defined.")

TB_FILE_TPL = "gtl_wrapper_axo_v5_tb_tpl.vhd"
TB_FILE = "gtl_wrapper_axo_v5_tb.vhd"

INI_FILE = "modelsim.ini"

def render_template(src, dst, args):
    """Replaces content of file *src* with values of dictionary *args* and writes to file *dst*.
    >>> render_template("template.txt", "sample.txt", { 'foo' : "bar", })
    """
    logger.debug("rendering template %s as %s", src, dst)
    with open(src) as f:
        content = f.read()
    for needle, subst in list(args.items()):
        logger.debug("  replacing %r by %r", needle, subst)
        content = content.replace(needle, subst)
    with open(dst, "wt") as dst:
        dst.write(content)


def run_vsim(vsim, msgmode, ini_file):
    vsim_bin = os.path.join(vsim, "bin", "vsim")
    cmd = [vsim_bin, "-lic_noqueue", "-c", "-msgmode", msgmode, "-modelsimini", ini_file, "-do", "do {filename}; quit -f".format(filename=os.path.join(module.path, DO_FILE))]
    logger.info("starting simulation ...")
    logger.info("executing: %s", " ".join(['"{0}"'.format(arg) if " " in str(arg) else str(arg) for arg in cmd]))
    subprocess.run(cmd, stdout=logfile).check_returncode()
    logger.info(f"simulation done.")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("menu_xml", help="path to menu xml file (in repository or local")
    parser.add_argument("--project")
    parser.add_argument("--tv", required=True, help="Test vector path")
    parser.add_argument("--questasimlibs", default=DefaultQuestaSimLibsPath, help="Questasim Vivado libraries directory name (default is {!r})".format(DefaultQuestaSimLibsPath))
    return parser.parse_args()

def main():
    args = parse_args()
    
    render_template(
        TB_FILE_TPL,
        TB_FILE, {
            "{{TESTVECTOR_FILENAME}}": "",
        }
    )

    msgmode = "wlf"
    ini_file = os.path.join(args.questasimlibs, "modelsim.ini")
    vsim = "/opt/mentor/questa/2021.1_2/questasim"

    try:
        run_vsim(vsim, msgmode, ini_file)

if __name__ == "__main__":
    main()

