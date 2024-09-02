## arg1: project directory
## arg2: module number

open_project $arg1/proj/module_$arg2/module_$arg2/module_$arg2.xpr
open_run synth_1 -name synth_1
source $arg1/src/mp7_fixed_cells_short.tcl
file mkdir $arg1/proj/module_$arg2/module_$arg2/module_$arg2.srcs/constrs_1/new
close [ open $arg1/proj/module_$arg2/module_$arg2/module_$arg2.srcs/constrs_1/new/fixed_cells.xdc w ]
add_files -fileset constrs_1 $arg1/proj/module_$arg2/module_$arg2/module_$arg2.srcs/constrs_1/new/fixed_cells.xdc
set_property target_constrs_file $arg1/proj/module_$arg2/module_$arg2/module_$arg2.srcs/constrs_1/new/fixed_cells.xdc [current_fileset -constrset]
save_constraints -force
close_project


