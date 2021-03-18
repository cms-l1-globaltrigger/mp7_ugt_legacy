
##***************************** Beginning of Script ***************************

## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

## HB 2019-04-12: setting of XILINX not clear! Not needed, removed!
#set XILINX   $env(XILINX)

if [info exists env(MTI_LIBS)] {
    set MTI_LIBS $env(MTI_LIBS)
    vlib UNISIM
    vlib SECUREIP
    vmap UNISIM $MTI_LIBS/unisim
    vmap SECUREIP $MTI_LIBS/secureip
}

## set your src files directory for your design

set MP7_COMPONENTS {{MP7_TAG}}/components
set VIEW_WAVE {{VIEW_WAVE}}

set HDL_DIR {{SIM_DIR}}/../hdl
set NGC_DIR {{SIM_DIR}}/../ngc
set TB_DIR {{SIM_DIR}}/testbench
set MENU_DIR {{MENU_DIR}}
set MOD_TB_DIR {{MOD_TB_DIR}}
set FILE_NAME {{MENU_DIR}}/../running.lock

## Create and map work directory
vlib work
vmap work work

##Design files
vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $MTI/lhc_data_pkg.vhd
vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $MTI/math_pkg.vhd
vcom -93 -work work $MTI/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/gtl_pkg_sim.vhd
#
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/pt_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/upt_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/lut_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/charge_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/phi_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/eta_comp_signed.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/eta_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/twobody_pt_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/twobody_pt.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/calo_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/calo_cond_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/calo_cond_matrix_orm.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/calo_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/esums_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/muon_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/muon_cond_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/muon_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/muon_charge_corr_matrix.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/dr_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/mass_calculator.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/cuts_instances.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/mass_div_dr_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sum_mass_calc.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/sum_mass.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/orm_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/correlation_cuts.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/esums_4_corr_cond.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/matrix_corr_cond.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/common/mass_div_dr_calc.vhd
#
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/conv_eta_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/obj_parameter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_correlations.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/differences.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/cosh_deta_cos_dphi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_div_dr.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/comb_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/min_bias_hf_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/towercount_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/correlation_conditions_calo.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/correlation_conditions_muon.vhd

#Testbench
vcom -93 -work work $TESTBENCH/correlation_conditions_muon_tb.vhd

#Load Design
vsim -t 1ps work.correlation_conditions_muon

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/correlation_conditions_muon_test_wave.do

##Run simulation
run 500 ns

# eof
