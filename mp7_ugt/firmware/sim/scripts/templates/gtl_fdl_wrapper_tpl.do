##--------------------------------------------------------------------------------
##-- Simulator   : ModelSim 10.3b
##-- Platform    : Linux Ubuntu 10.04
##-- Targets     : Simulation
##--------------------------------------------------------------------------------
##-- This work is held in copyright as an unpublished work by HEPHY (Institute
##-- of High Energy Physics) All rights reserved.  This work may not be used
##-- except by authorized licensees of HEPHY. This work is the
##-- confidential information of HEPHY.
##--------------------------------------------------------------------------------
##---Description:
##-- $HeadURL: https://svn.cern.ch/reps/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/sim/scripts/gtl_fdl_wrapper_test_tpl.do $
##-- $Date: 2015-09-08 11:26:11 +0200 (Tue, 08 Sep 2015) $
##-- $Author: hbergaue $
##-- $Revision: 39037 $
##--------------------------------------------------------------------------------

##***************************** Beginning of Script ***************************

## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

set XILINX   $env(XILINX)
if [info exists env(MTI_LIBS)] {
    set MTI_LIBS $env(MTI_LIBS)
    vlib UNISIM
    vlib SECUREIP
    vmap UNISIM $MTI_LIBS/unisim
    vmap SECUREIP $MTI_LIBS/secureip
}

## set your src files directory for your design

set MP7_COMPONENTS {{MP7_TAG}}/cactusupgrades/components
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
vcom -93 -work work $MP7_COMPONENTS/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd
vcom -93 -work work $HDL_DIR/lhc_data_pkg.vhd
vcom -93 -work work $HDL_DIR/math_pkg.vhd
## HB 2016-12-05: used gt_mp7_core_pkg_sim.vhd for simulation without other MP7 packages
vcom -93 -work work $HDL_DIR/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $MENU_DIR/gtl_pkg.vhd
vcom -93 -work work $TB_DIR/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $TB_DIR/txt_util_pkg.vhd

vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/p_m_2_bx_pipeline.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/phi_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_comp_signed.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_windows_comp.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/twobody_pt_calculator_v2.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_comparators_v2.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v7_no_quad.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_condition_v6_quad.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_comparators.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/min_bias_hf_conditions.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_comparators_v2.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_conditions_v7.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_correlations.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/dr_calculator_v3.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_calculator_v2.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/cuts_instances_v2.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/towercount_condition.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_muon_correlation_condition_v3.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition_v4.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_muon_correlation_condition_v4.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_esums_correlation_condition_v3.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition_v3.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_orm_v4_single_double.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_orm_v4_triple.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_orm_v4_quad.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_calo_correlation_orm_condition_v3.vhd
vcom -93 -work work $MENU_DIR/gtl_module.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/frame/dm/delay_element.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/update_process.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/pulse_converter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_addr_decode.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_fabric.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_rate_counter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_post_dead_time_counter.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_slice.vhd
vcom -93 -work work $NGC_DIR/dp_mem_4096x32/dp_mem_4096x32.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_dpmem_4096_32.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_read_regs.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_write_regs.vhd
vcom -93 -work work $HDL_DIR/ipbus/slaves/ipb_pulse_regs.vhd
vcom -93 -work work $MENU_DIR/algo_mapping_rop.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd
vcom -93 -work work $HDL_DIR/gt_mp7_core/gtl_fdl_wrapper/gtl_fdl_wrapper.vhd

##TB_DIR
vcom -93 -work work $MOD_TB_DIR/gtl_fdl_wrapper_tb.vhd

##Load Design
vsim -t 1ps work.gtl_fdl_wrapper_TB

if {$VIEW_WAVE} {
  #Load signals in wave window
  view wave
  do $TB_DIR/../scripts/gtl_fdl_wrapper_test_wave.do
}
set fileId [open $FILE_NAME "w"]
close $fileId
##Run simulation
run 91000 ns

# eof
