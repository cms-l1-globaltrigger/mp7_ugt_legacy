
##***************************** Beginning of Script ***************************

## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

#set XILINX   $env(XILINX)
if [info exists env(MTI_LIBS)] {
    set MTI_LIBS $env(MTI_LIBS)
    vlib UNISIM
    vlib SECUREIP
    vmap UNISIM $MTI_LIBS/unisim
    vmap SECUREIP $MTI_LIBS/secureip
}

## set your src files directory for your design
set HDL_DIR ./../hdl
set NGC_DIR ./../ngc

set TESTBENCH ./../sim/testbench

## Create and map work directory
vlib work
vmap work work

vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $HDL_DIR/lhc_data_pkg.vhd
vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $HDL_DIR/math_pkg.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/gtl_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/eta_comp_signed.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/phi_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/eta_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/calo_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/muon_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/dr_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/twobody_pt_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/mass_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/mass_div_dr_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/orm_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sum_mass_calc.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sum_mass.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/cuts_instances.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/correlation_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/esums_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/esums_4_corr_cond.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/obj_parameter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/differences.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/cosh_deta_cos_dphi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/correlation_conditions_calo.vhd

#Testbench
vcom -93 -work work $TESTBENCH/mass_3_eg_tb.vhd

#Load Design
vsim -t 1ps work.mass_3_eg_tb

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/mass_3_test_wave.do

##Run simulation
run 500 ns

# eof
