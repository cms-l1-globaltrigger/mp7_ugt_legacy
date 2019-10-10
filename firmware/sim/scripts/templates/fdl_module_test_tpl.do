
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

set MP7_BRDS _MP7_TAG_/boards/mp7/base_fw
set MP7_COMPONENTS _MP7_TAG_/components

set L1TM _MENU_PATH_

set GT_SRC ./../hdl
set GT_CORES ./../ngc
set TESTBENCH ./../sim/testbench

## Create and map work directory
vlib work
vmap work work

#Top Entity the design
vcom -93 -work work $MP7_BRDS/mp7xe_690/firmware/hdl/mp7_brd_decl.vhd
vcom -93 -work work $MP7_BRDS/common/firmware/hdl/mp7_top_decl.vhd
vcom -93 -work work $MP7_COMPONENTS/mp7_datapath/firmware/hdl/mp7_data_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_package.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_trans_decl.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/ipbus_reg_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/syncreg_w.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/syncreg_r.vhd    
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/ipbus_syncreg_v.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/trans_buffer.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/trans_buffer_test.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/uc_spi_interface.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/uc_pipe_interface.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_buffer_selector.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_build_arp.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_build_payload.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_build_ping.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_build_resend.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_build_status.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_byte_sum.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_clock_crossing_if.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_do_rx_reset.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_dualportram.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_dualportram_rx.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_dualportram_tx.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_ipaddr_block.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_packet_parser.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_rarp_block.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_rxram_mux.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_rxram_shim.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_rxtransactor_if_simple.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_status_buffer.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_tx_mux.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_txtransactor_if_simple.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/udp_if_flat.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/trans_arb.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/transactor_if.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/transactor_sm.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/transactor_cfg.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/transactor.vhd
vcom -93 -work work $MP7_COMPONENTS/mp7_ctrl/firmware/hdl/ipbus_addr_decode.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_fabric.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/ipbus_reg_types.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_slaves/firmware/hdl/ipbus_ctrlreg_v.vhd
vcom -93 -work work $MP7_COMPONENTS/ipbus_core/firmware/hdl/ipbus_ctrl.vhd

vcom -93 -work work $GT_SRC/top_decl.vhd
vcom -93 -work work $GT_SRC/lhc_data_pkg.vhd
vcom -93 -work work $GT_SRC/math_pkg.vhd
vcom -93 -work work $GT_SRC/gt_mp7_top_pkg_sim.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gt_mp7_core_pkg.vhd
vcom -93 -work work $L1TM/vhdl/module_0/src/gtl_pkg.vhd
vcom -93 -work work $L1TM/vhdl/module_0/src/algo_mapping_rop.vhd
#vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_pkg.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/update_process.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/pulse_converter.vhd
#vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/serializer_2_to_1.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_addr_decode.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_fabric.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_rate_counter.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_slice.vhd
vcom -93 -work work $GT_CORES/dp_mem_4096x32/dp_mem_4096x32.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_dpmem_4096_32.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_read_regs.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_write_regs.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_pulse_regs.vhd
vcom -93 -work work $GT_SRC/ipbus/slaves/ipb_pulse_regs.vhd
vcom -93 -work work $GT_SRC/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd

#Testbench
vcom -93 -work work $TESTBENCH/fdl_module_test_tb.vhd

#Load Design
vsim -t 1ps work.fdl_module_TB 

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/fdl_module_test__MENU_NAME__wave.do

##Run simulation
run 2000 ns

# eof
