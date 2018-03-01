#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import re
import os, sys
import logging

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

## HB 2018-02-22: removed replace_clock_constraints (values for clk_40_ext_period and refclks_period are correct in mp7 tags 2.4.0 and higher)

def replace_area_constraints(filename):
  try:
    with open(filename) as fp:
      content = fp.read()
  except (OSError, IOError) as message:
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  expr_forloop = re.compile(r"(for\s+{\s*set\s*i\s*0\s*}\s+{\s*\$i\s*<\s*)(\d+)(\s*}\s+{\s*incr\s+i\s*})")
  expr_cells = re.compile(r"(add_cells_to_pblock\s+\[\s*get_pblocks\s+payload_)(\d+)(\s*]\s*\[get_cells\s+(?:-\w+\s+)?datapath/rgen\[)(\d+)(]\.region/pgen\.\*])")

  content, count = expr_forloop.subn(r"\g<1>7\g<3>", content)
  if count != 1: raise RuntimeError("Could not replace the for-loop value.")

  content, count = expr_cells.subn(r"\g<1>6\g<3>6\g<5>", content)
  if count != 1: raise RuntimeError("Could not replace add_cells_to_pblock line.")

  with open(filename, "wb") as fp:
    fp.write(content)
    print "Successfully patched the area constraints file!"


def replace_brd_decl(filename):
  try:
    with open(filename) as fp:
        content = fp.read()
  except (OSError, IOError) as message:
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  expr_nregion = re.compile(r"(constant\s+N_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")
  expr_crossregion = re.compile(r"(constant\s+CROSS_REGION\s*:\s*integer\s*:=\s*)(\d+)(\s*;)")

  content, count = expr_nregion.subn(r"\g<1>7\g<3>", content)
  if count != 1: raise RuntimeError("Could not replace the N_REGION value.")

  content, count = expr_crossregion.subn(r"\g<1>6\g<3>", content)
  if count != 1: raise RuntimeError("Could not replace the CROSS_REGION value.")

  with open(filename, "wb") as fp:
    fp.write(content)
    print "Successfully patched the brd_decl file!"


def insert_l1a_ttc(filename):
  try:
    with open(filename) as fp:
      content = fp.read()
  except (OSError, IOError) as message:
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  expr_payload = re.compile(r"(\s*ctrs\s*=>\s*ctrs\s*,)(\s*bc0\s*=>\s*payload_bc0\s*,)")
  l1a_str = "\n                l1a => ttc_l1a,"

  content, count = expr_payload.subn(r"\g<1>{l1a_str}\g<2>".format(**locals()), content)
  if count != 1: raise RuntimeError("Could not insert l1a ttc port.")

  with open(filename, "wb") as fp:
    fp.write(content)
    print "Successfully patched the payload instance!"


def insert_vivado_rules(filename):
  rule1 =  "      ## HB 2017-04-06: inserted -assert = 1, which means \"Enable VHDL assert statements to be evaluated\" (see UG901 (v2016.3) October 21, 2016, page 12)\n" \
           "      write( \'set_property \"steps.synth_design.args.assert\" 1 [get_runs synth_1]\' )\n"
  rule2 =  "      ## HB 2017-04-06: for timimg optimisation\n" \
           "      write( \'set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]\' )\n"

  try:
    with open(filename, "a") as fp:
      fp.write(rule1)
      fp.write(rule2)
      print "Successfully patched the VivadoScriptWriter.py file!"
  except (OSError, IOError) as message:
    logging.error(message)
    sys.exit(EXIT_FAILURE)


def patch_all(projectpath): # to execute the patches from another python script
  clock_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/clock_constraints.tcl'
  brd_decl_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd'
  area_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl'
  mp7xe_690_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd'
  script_writer_path = 'scripts/firmware/dep_tree/VivadoScriptWriter.py'

  root_path = os.path.abspath(projectpath)

  try:
    replace_brd_decl(os.path.join(root_path, brd_decl_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    replace_area_constraints(os.path.join(root_path, area_constraints_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    insert_l1a_ttc(os.path.join(root_path, mp7xe_690_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    insert_vivado_rules(os.path.join(root_path, script_writer_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)



def parse_args():
  """Parse command line arguments."""
  parser = argparse.ArgumentParser()
  parser.add_argument('path', type = os.path.abspath, help = "path to the cactusupgrades dir of the fw tag which should be patched")
  #parser.add_argument('-b', '--brd_decl', metavar = '<mp7_brd_decl.vhd>', required = True, type = os.path.abspath, help = "path to mp7_brd_decl.vhd file")
  #parser.add_argument('-c', '--area_constr', metavar = '<area_constraints.tcl>', required = True, type = os.path.abspath, help = "path to area constraints file")
  #parser.add_argument('-t', '--top_vhdl', metavar = '<mp7xe_690.vhd>', required = True, type = os.path.abspath, help = "path to the MP7 top VHDL file")
  #parser.add_argument('-s', '--script_writer', metavar = '<VivadoScriptWriter.py>', required = True, type = os.path.abspath, help = "path to the VivadoScriptWriter.py file")
  return parser.parse_args()


def main():
  # Parse command line arguments.
  args = parse_args()

  clock_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/clock_constraints.tcl'
  brd_decl_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd'
  area_constraints_path = 'boards/mp7/base_fw/common/firmware/ucf/area_constraints.tcl'
  mp7xe_690_path = 'boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd'
  script_writer_path = 'scripts/firmware/dep_tree/VivadoScriptWriter.py'

  root_path = os.path.abspath(args.path)

  try:
    replace_brd_decl(os.path.join(root_path, brd_decl_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    replace_area_constraints(os.path.join(root_path, area_constraints_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    insert_l1a_ttc(os.path.join(root_path, mp7xe_690_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)

  try:
    insert_vivado_rules(os.path.join(root_path, script_writer_path))
  except (OSError, IOError) as message:
    print "\nFAILURE\n"
    logging.error(message)
    sys.exit(EXIT_FAILURE)


if __name__ == '__main__':
  main()