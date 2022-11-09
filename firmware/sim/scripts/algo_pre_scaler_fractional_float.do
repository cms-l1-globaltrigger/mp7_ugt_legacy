
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
set GT_SRC ./../hdl

set TESTBENCH ./../sim/testbench

## Create and map work directory
vlib work
vmap work work

#Top Entity the design
vcom -93 -work work $TESTBENCH/fdl_pkg_prescale_float_sim.vhd
vcom -93 -work work $GT_SRC/payload/fdl/update_process.vhd
vcom -93 -work work $GT_SRC/payload/fdl/algo_pre_scaler_fractional_float.vhd

#Testbench
vcom -93 -work work $TESTBENCH/algo_pre_scaler_fractional_float_tb.vhd

#Load Design
vsim -t 1ps work.algo_pre_scaler_fractional_TB

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/algo_pre_scaler_fractional_float_wave.do

##Run simulation
#run 3800 ns
run 23300 ms

# eof



