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

set GT_SRC ./../hdl
set HDL_DIR ./../hdl
set NGC_DIR ./../ngc
set TB_DIR ./testbench
set TEST_DIR ./common_test
#set TEST_DIR_MOD ./adt_test/l1menu_adt_v6/module_0

## Create and map work directory
vlib work
vmap work work

## MP7 files
vcom -93 -work work $TEST_DIR/mp7_data_types.vhd
vcom -93 -work work $TEST_DIR/mp7_brd_decl.vhd
vcom -93 -work work $TEST_DIR/mp7_top_decl.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_top_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/packages/top_decl.vhd
vcom -93 -work work $HDL_DIR/packages/lhc_data_pkg.vhd
vcom -93 -work work $TB_DIR/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $TB_DIR/txt_util_pkg.vhd
#vcom -93 -work work $TEST_DIR_MOD/adt_test_sim_pkg.vhd

## GT packages
vcom -93 -work work $HDL_DIR/packages/math_pkg.vhd
## HB 2022-09-21: used gt_mp7_top_pkg_sim.vhd for simulation
vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_pkg.vhd
#vcom -93 -work work $TEST_DIR_MOD/fdl_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_luts_pkg.vhd
#
## GTL modules
### common modules
vcom -93 -work work $HDL_DIR/payload/gtl/common/delay_pipeline.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/pt_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/upt_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/lut_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/charge_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/phi_windows_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/eta_comp_signed.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/eta_windows_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/calo_comparators.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/esums_comparators.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/muon_comparators.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/matrix_calo_cond.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/matrix_calo_cond_orm.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/matrix_muon_cond.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/matrix_muon_charge_corr.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/matrix_corr_cond.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/deta_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/dphi_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/deta_cosh_deta_luts.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/dphi_cos_dphi_luts.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/dr_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/mass_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/sum_mass_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/sum_mass.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/mass_over_dr_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/tbpt_calc.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/calo_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/muon_obj_cuts.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/charge_correlation_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/correlation_cut_comp.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/correlation_cuts_wrapper.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/orm_cuts.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/esums_4_corr_cond.vhd
#
### modules of instances in gtl_module.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/bx_pipeline.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/muon_charge_correlations.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/conv_eta_phi.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/obj_parameter.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/deta_dphi_calculations.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/correlation_cuts_calculation.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/comb_conditions.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/esums_conditions.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/min_bias_hf_conditions.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/towercount_condition.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/correlation_conditions.vhd
#
### modules of BRAMs used for mass over DeltaR
#
## FRAME modules
vcom -93 -work work $HDL_DIR/payload/frame/delay_element.vhd
#
## FDL modules
#vcom -93 -work work $TEST_DIR_MOD/algo_mapping_rop.vhd
#
## IPBus modules
#
## top modules
vcom -93 -work work $HDL_DIR/payload/gtl_data_mapping.vhd
#vcom -93 -work work $TEST_DIR_MOD/gtl_module.vhd
# vcom -93 -work work $HDL_DIR/payload/fdl_module.vhd

## Modules - check only
vcom -93 -work work $HDL_DIR/payload/gtl_data_mapping.vhd

##TB_DIR
vcom -93 -work work $TB_DIR/algo_494_test_tb.vhd

##Load Design
vsim -t 1ps work.algo_494_test_tb

##Load signals in wave window
view wave
do $TB_DIR/../scripts/algo_494_test_wave.do

##Run simulation
run 500 ns

# eof
