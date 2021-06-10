
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

#vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/lhc_data_pkg.vhd
#vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
#vcom -93 -work work $HDL_DIR/packages/math_pkg.vhd
#vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_pkg.vhd

vcom -93 -work work $HDL_DIR/payload/gtl/common/delay_pipeline.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/bx_pipeline.vhd

#Testbench
vcom -93 -work work $TESTBENCH/bx_pipeline_tb.vhd

#Load Design
vsim -t 1ps work.bx_pipeline_tb

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/bx_pipeline_wave.do

##Run simulation
run 1000 ns

# eof
