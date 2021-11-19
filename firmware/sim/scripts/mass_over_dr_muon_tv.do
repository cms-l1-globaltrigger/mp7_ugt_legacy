
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

vcom -93 -work work $TESTBENCH/txt_util_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/lhc_data_pkg.vhd
vcom -93 -work work $TESTBENCH/lhc_data_debug_util_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/math_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gt_mp7_core_pkg_sim.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_pkg.vhd
vcom -93 -work work $HDL_DIR/packages/gtl_luts_pkg.vhd

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
vcom -93 -work work $HDL_DIR/payload/gtl/common/charge_correlation_comp.vhd

vcom -93 -work work $HDL_DIR/payload/gtl/obj_parameter.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/deta_dphi_calculations.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/correlation_cuts_calculation.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/correlation_conditions.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/muon_charge_correlations.vhd

vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_1/synth/rom_lut_muon_inv_dr_sq_1.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_2/synth/rom_lut_muon_inv_dr_sq_2.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_3/synth/rom_lut_muon_inv_dr_sq_3.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_4/synth/rom_lut_muon_inv_dr_sq_4.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_5/synth/rom_lut_muon_inv_dr_sq_5.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_6/synth/rom_lut_muon_inv_dr_sq_6.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_7/synth/rom_lut_muon_inv_dr_sq_7.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_8/synth/rom_lut_muon_inv_dr_sq_8.vhd
vcom -93 -work work $NGC_DIR/rom_lut_muon_inv_dr_sq_9/synth/rom_lut_muon_inv_dr_sq_9.vhd
vcom -93 -work work $HDL_DIR/payload/gtl/common/rom_lut_muon_inv_dr_sq_all.vhd

#Testbench
vcom -93 -work work $TESTBENCH/mass_over_dr_muon_tv_tb.vhd

#Load Design
vsim -t 1ps work.mass_div_dr_muon_tb

##Load signals in wave window
view wave
do $TESTBENCH/../scripts/mass_over_dr_muon_tv_wave.do

##Run simulation
run 3000 us

# eof
