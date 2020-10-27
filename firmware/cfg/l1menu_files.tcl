#!/usr/bin/tclsh

set mod_id $env(module_id)
# puts $mod_id

set gtl_pkg "../../../src/module_${mod_id}/gtl_pkg.vhd"
# puts $gtl_pkg
set algo_mapping_rop "../../../src/module_${mod_id}/algo_mapping_rop.vhd"
# puts $algo_mapping_rop
set gtl_module "../../../src/module_${mod_id}/gtl_module.vhd"
# puts $gtl_module

add_files -norecurse -fileset sources_1 $gtl_pkg $algo_mapping_rop $gtl_module
