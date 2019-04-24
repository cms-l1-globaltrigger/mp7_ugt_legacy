#!/usr/bin/tclsh

mod_id = puts $env(module_id)

add_files -norecurse -fileset sources_1 ../../../../module_$mod_id/gtl_pkg.vhd ../../../../module_$mod_id/algo_mapping_rop.vhd ../../../../module_$mod_id/gtl_module.vhd
