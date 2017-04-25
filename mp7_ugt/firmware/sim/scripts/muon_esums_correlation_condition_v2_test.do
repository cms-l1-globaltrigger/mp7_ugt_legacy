##--------------------------------------------------------------------------------
##-- Simulator   : ModelSim 10.1
##-- Platform    : Linux Ubuntu 10.04
##-- Targets     : Simulation
##--------------------------------------------------------------------------------
##-- This work is held in copyright as an unpublished work by HEPHY (Institute
##-- of High Energy Physics) All rights reserved.  This work may not be used
##-- except by authorized licensees of HEPHY. This work is the
##-- confidential information of HEPHY.
##--------------------------------------------------------------------------------
##---Description: 
##-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/scripts/calo_muon_correlation_condition_test_dr.do $
##-- $Date: 2015-08-25 11:26:14 +0200 (Die, 25 Aug 2015) $
##-- $Author: bergauer $
##-- $Revision: 4175 $
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
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_comparators_v2.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_comparators.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/twobody_pt_calculator.vhd
#vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_cuts.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/mass_calculator.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/cuts_instances.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_integer_obj_vs_obj.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_phi_integer_obj_vs_obj.vhd
vcom -93 -work work $MTI/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_esums_correlation_condition_v2.vhd

#Testbench
vcom -93 -work work $TESTBENCH/muon_esums_correlation_condition_v2_tb.vhd

#Load Design
vsim -t 1ps work.muon_esums_correlation_condition_v2_tb

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/muon_esums_correlation_condition_v2_test_wave.do

##Run simulation
run 500 ns

# eof
