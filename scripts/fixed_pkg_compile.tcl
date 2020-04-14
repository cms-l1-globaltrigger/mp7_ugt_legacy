open_project top/top.xpr
add_files -norecurse ../../src/mp7_ugt_legacy/firmware/hdl/fixed_pkg_2008.vhd
set_property library ieee [get_files ../../src/mp7_ugt_legacy/firmware/hdl/fixed_pkg_2008.vhd]
read_vhdl -vhdl2008 ./../../src/mp7/boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7xe_690.vhd
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1 -name synth_1
