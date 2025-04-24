##***************************** Beginning of Script ***************************

## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

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
set TEST_DIR ./axo_v5_score_test

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

## GT packages
vcom -93 -work work $HDL_DIR/packages/math_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_top_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/packages/top_decl.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_pkg.vhd
vcom -93 -work work $TEST_DIR/fdl_pkg_test.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_luts_pkg.vhd
#
## GTL modules
### common modules
vcom -93 -work work $HDL_DIR/payload/gtl/common/delay_pipeline.vhd
#
### modules of instances in gtl_module.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/bx_pipeline.vhd
#
vcom -93 -work work $HDL_DIR/payload/gtl/axol1tl_trigger/model_v5/axol1tl_v5_da_mul_15s_15s_30_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/axol1tl_trigger/model_v5/axol1tl_v5_da_mul_16s_16s_32_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/axol1tl_trigger/model_v5/axol1tl_v5_da_mul_17s_17s_34_1_1.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/axol1tl_trigger/model_v5/axol1tl_v5_da.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/axol1tl_trigger/model_v5/axol1tl_v5_wrapper.vhd
#
## FRAME modules
vcom -93 -work work $HDL_DIR/payload/frame/delay_element.vhd
#
## top modules
vcom -93 -work work $HDL_DIR/payload/gtl_data_mapping.vhd
vcom -93 -work work $TEST_DIR/gtl_module_axo_v5_test.vhd

##TB_DIR
vcom -93 -work work $TB_DIR/gtl_wrapper_axo_v5_tb.vhd

##Load Design
vsim -t 1ps work.gtl_wrapper_axo_v5_tb

##Load signals in wave window
view wave
do $TB_DIR/../scripts/gtl_wrapper_axo_v5_wave.do

##Run simulation
run 2000 ns
#run 91000 ns

# eof

