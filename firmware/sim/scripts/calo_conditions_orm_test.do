
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
set MTI ./../hdl

set TESTBENCH ./../sim/testbench

## Create and map work directory
vlib work
vmap work work

vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $MTI/lhc_data_pkg.vhd
vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $MTI/math_pkg.vhd
vcom -93 -work work $MTI/gt_mp7_core/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/gtl_pkg_sim.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_comp_signed.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/phi_windows_comp.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_windows_comp.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_comparators_v2.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/dr_calculator_v2.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_orm.vhd

#Testbench
vcom -93 -work work $TESTBENCH/calo_conditions_orm_tb.vhd

#Load Design
vsim -t 1ps calo_conditions_orm_tb 

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/calo_conditions_orm_test_wave.do

##Run simulation
run 800 ns

# eof
