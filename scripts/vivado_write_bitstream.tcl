## vivado -mode batch -source <local path>/mp7_ugt_legacy/scripts/vivado_write_bitstream.tcl -tclargs <project path> <module nr>
set proj_path [lindex $argv 0]
set module_nr [lindex $argv 1]
open_project $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.xpr
open_run impl_1
write_bitstream -force $proj_path/proj/module_$module_nr/module_$module_nr/module_$module_nr.runs/impl_1/top.bit
