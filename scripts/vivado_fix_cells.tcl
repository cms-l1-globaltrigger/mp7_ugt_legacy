## vivado -mode batch -source <local path>/mp7_ugt_legacy/scripts/vivado_fix_cells.tcl -tclargs <project path> <module nr>
set proj_path [lindex $argv 0]
set module_nr [lindex $argv 1]
open_project $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.xpr
open_run synth_1 -name synth_1
source $proj_path/src/mp7_ugt_legacy/scripts/constraints_fixed_cells.tcl
file mkdir $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.srcs/constrs_1/new
close [ open $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.srcs/constrs_1/new/fixed_cells.xdc w ]
add_files -fileset constrs_1 $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.srcs/constrs_1/new/fixed_cells.xdc
set_property target_constrs_file $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.srcs/constrs_1/new/fixed_cells.xdc [current_fileset -constrset]
save_constraints -force
close_project
