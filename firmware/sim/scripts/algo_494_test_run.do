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
