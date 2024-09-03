open_project {path}/proj/module_{module}/module_{module}/module_{module}.xpr
open_run synth_1 -name synth_1
source {path}/src/mp7_ugt_legacy/scripts/constraints_fixed_cells.tcl
file mkdir {path}/proj/module_{module}/module_{module}/module_{module}.srcs/constrs_1/new
close [ open {path}/proj/module_{module}/module_{module}/module_{module}.srcs/constrs_1/new/fixed_cells.xdc w ]
add_files -fileset constrs_1 {path}/proj/module_{module}/module_{module}/module_{module}.srcs/constrs_1/new/fixed_cells.xdc
set_property target_constrs_file {path}/proj/module_{module}/module_{module}/module_{module}.srcs/constrs_1/new/fixed_cells.xdc [current_fileset -constrset]
save_constraints -force
close_project
