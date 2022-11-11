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

set MP7 {{MP7_TAG}}
set VIEW_WAVE {{VIEW_WAVE}}

set HDL_DIR {{SIM_DIR}}/../hdl
set NGC_DIR {{SIM_DIR}}/../ngc
set TB_DIR {{SIM_DIR}}/testbench
set MENU_DIR {{MENU_DIR}}
set MOD_TB_DIR {{MOD_TB_DIR}}
set IPB_DIR {{IPB_DIR}}
set FILE_NAME {{MENU_DIR}}/../running.lock

set BLK_MEM_GEN_VERSION $env(UGT_BLK_MEM_GEN_VERSION_SIM)

## Create and map work directory
vlib work
vmap work work

## MP7 files
vcom -93 -work work $MP7/components/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -93 -work work $MP7/boards/mp7/base_fw/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd
vcom -93 -work work $MP7/boards/mp7/base_fw/common/firmware/hdl/mp7_top_decl.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_top_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/packages/top_decl.vhd
vcom -93 -work work $MP7/components/mp7_ttc/firmware/hdl/mp7_ttc_decl.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_slaves/firmware/hdl/ipbus_reg_types.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_slaves/firmware/hdl/syncreg_w.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_slaves/firmware/hdl/syncreg_r.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_slaves/firmware/hdl/ipbus_syncreg_v.vhd
vcom -93 -work work $HDL_DIR/packages/lhc_data_pkg.vhd
vcom -93 -work work $TB_DIR/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $TB_DIR/txt_util_pkg.vhd

## GT packages
vcom -93 -work work $HDL_DIR/packages/math_pkg.vhd
## HB 2022-09-21: used gt_mp7_top_pkg_sim.vhd for simulation
vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_pkg.vhd
vcom -93 -work work $MENU_DIR/fdl_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/fdl_addr_decode.vhd
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
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_8ns_16_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_3ns_11_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_8s_16_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_11ns_8s_19_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_9ns_17_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_5ns_13_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_5s_13_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_6ns_14_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_15s_15s_30_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_12ns_8s_20_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_9ns_8s_17_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_3s_11_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_sinh_table_ROM_AUTO_1R.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_4ns_12_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_3s_10_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_6ns_12_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_4s_12_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_6s_13_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_2s_10_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_7s_15_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_5ns_11_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_sinh_table_3_ROM_AUTO_1R.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_sin_table_2_ROM_AUTO_1R.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_sin_table_ROM_AUTO_1R.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_4ns_10_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_11ns_9s_20_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_7ns_15_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_exp_table_ROM_AUTO_1R.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_2s_9_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_7s_14_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_7ns_13_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_9s_9ns_18_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_8s_6s_14_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_5s_12_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_4s_11_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_8s_15_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection_mul_7ns_3ns_9_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/anomaly_detection.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/anomaly_detection/adt_wrapper.vhd
#
### modules of BRAMs used for mass over DeltaR
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_calo_inv_dr_sq_1/synth/rom_lut_calo_inv_dr_sq_1.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_calo_inv_dr_sq_2/synth/rom_lut_calo_inv_dr_sq_2.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_calo_inv_dr_sq_3/synth/rom_lut_calo_inv_dr_sq_3.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_calo_inv_dr_sq_4/synth/rom_lut_calo_inv_dr_sq_4.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_calo_inv_dr_sq_5/synth/rom_lut_calo_inv_dr_sq_5.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_1/synth/rom_lut_muon_inv_dr_sq_1.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_2/synth/rom_lut_muon_inv_dr_sq_2.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_3/synth/rom_lut_muon_inv_dr_sq_3.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_4/synth/rom_lut_muon_inv_dr_sq_4.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_5/synth/rom_lut_muon_inv_dr_sq_5.vhd
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/rom_lut_muon_inv_dr_sq_6/synth/rom_lut_muon_inv_dr_sq_6.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/rom_lut_calo_inv_dr_sq_all.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/rom_lut_muon_inv_dr_sq_all.vhd
#
## FRAME modules
vcom -93 -work work $HDL_DIR/payload/frame/delay_element.vhd
#
## FDL modules
vcom -93 -work work $MENU_DIR/algo_mapping_rop.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/update_process.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/fdl_fabric.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/algo_pre_scaler_fractional_float.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/algo_rate_counter.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/algo_post_dead_time_counter.vhd
vcom -93 -work work $HDL_DIR/payload/fdl/algo_slice.vhd
#
## IPBus modules
vcom -93 -work work $NGC_DIR/$BLK_MEM_GEN_VERSION/dp_mem_4096x32/synth/dp_mem_4096x32.vhd
vcom -93 -work work $HDL_DIR/payload/ipbus/ipb_dpmem_4096_32.vhd
vcom -93 -work work $HDL_DIR/payload/ipbus/ipb_read_regs.vhd
vcom -93 -work work $HDL_DIR/payload/ipbus/ipb_write_regs.vhd
vcom -93 -work work $HDL_DIR/payload/ipbus/ipb_pulse_regs.vhd
#
## top modules
vcom -93 -work work $HDL_DIR/payload/gtl_data_mapping.vhd
vcom -93 -work work $MENU_DIR/gtl_module.vhd
vcom -93 -work work $HDL_DIR/payload/fdl_module.vhd

## Modules - check only
vcom -93 -work work $HDL_DIR/packages/frame_addr_decode.vhd
vcom -93 -work work $HDL_DIR/packages/frame_rb_pkg.vhd
vcom -93 -work work $HDL_DIR/payload/frame/demux_lane_data.vhd
vcom -93 -work work $HDL_DIR/payload/frame/demux_lane_validation.vhd
vcom -93 -work work $HDL_DIR/payload/frame/frame_module_info.vhd
vcom -93 -work work $HDL_DIR/payload/frame/frame_fabric.vhd
vcom -93 -work work $HDL_DIR/payload/frame/lmp.vhd
vcom -93 -work work $HDL_DIR/payload/frame/mux.vhd
vcom -93 -work work $HDL_DIR/payload/frame/output_mux.vhd
vcom -93 -work work $HDL_DIR/payload/frame/rb.vhd
vcom -93 -work work $HDL_DIR/payload/frame/spytrig.vhd
vcom -93 -work work $HDL_DIR/payload/frame/tcm.vhd
vcom -93 -work work $HDL_DIR/payload/frame.vhd
vcom -93 -work work $HDL_DIR/payload/bgo_sync.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_addr_decode.vhd
vcom -93 -work work $IPB_DIR/components/ipbus_core/firmware/hdl/ipbus_fabric_sel.vhd
vcom -93 -work work $HDL_DIR/payload/gtl_data_mapping.vhd
vcom -93 -work work $HDL_DIR/mp7_payload.vhd

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
