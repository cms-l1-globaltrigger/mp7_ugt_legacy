onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /calo_muon_correlation_condition_dr_tb/lhc_clk
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dut/dr_cut
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dr_upper_limit
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dr_lower_limit
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/dr_upper_limit_int
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/dr_lower_limit_int
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/dut/calo_data_i
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/dut/muon_data_i
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/tau_bx_0
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/tau_bx_0_ff
add wave -noupdate -radix decimal -childformat {{/calo_muon_correlation_condition_dr_tb/tau_eta_value_bx_0(0) -radix decimal} {/calo_muon_correlation_condition_dr_tb/tau_eta_value_bx_0(1) -radix decimal}} -expand -subitemconfig {/calo_muon_correlation_condition_dr_tb/tau_eta_value_bx_0(0) {-radix decimal} /calo_muon_correlation_condition_dr_tb/tau_eta_value_bx_0(1) {-radix decimal}} /calo_muon_correlation_condition_dr_tb/tau_eta_value_bx_0
add wave -noupdate -radix decimal -childformat {{/calo_muon_correlation_condition_dr_tb/tau_phi_value_bx_0(0) -radix decimal} {/calo_muon_correlation_condition_dr_tb/tau_phi_value_bx_0(1) -radix decimal}} -expand -subitemconfig {/calo_muon_correlation_condition_dr_tb/tau_phi_value_bx_0(0) {-radix decimal} /calo_muon_correlation_condition_dr_tb/tau_phi_value_bx_0(1) {-radix decimal}} /calo_muon_correlation_condition_dr_tb/tau_phi_value_bx_0
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/muon_bx_0
add wave -noupdate -radix hexadecimal /calo_muon_correlation_condition_dr_tb/muon_bx_0_ff
add wave -noupdate -radix decimal -childformat {{/calo_muon_correlation_condition_dr_tb/muon_eta_value_bx_0(0) -radix decimal} {/calo_muon_correlation_condition_dr_tb/muon_eta_value_bx_0(1) -radix decimal}} -expand -subitemconfig {/calo_muon_correlation_condition_dr_tb/muon_eta_value_bx_0(0) {-radix decimal} /calo_muon_correlation_condition_dr_tb/muon_eta_value_bx_0(1) {-radix decimal}} /calo_muon_correlation_condition_dr_tb/muon_eta_value_bx_0
add wave -noupdate -radix decimal -childformat {{/calo_muon_correlation_condition_dr_tb/muon_phi_value_bx_0(0) -radix decimal} {/calo_muon_correlation_condition_dr_tb/muon_phi_value_bx_0(1) -radix decimal}} -expand -subitemconfig {/calo_muon_correlation_condition_dr_tb/muon_phi_value_bx_0(0) {-radix decimal} /calo_muon_correlation_condition_dr_tb/muon_phi_value_bx_0(1) {-radix decimal}} /calo_muon_correlation_condition_dr_tb/muon_phi_value_bx_0
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_eta_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_eta_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_eta_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_eta_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_eta_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_eta_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_eta_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_eta_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_phi_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_phi_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_phi_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_phi_value_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_phi_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_phi_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_diff_phi_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_diff_phi_sq_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_dr_squ_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_dr_squ_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_dr_squ_out
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_dr_squ_out
add wave -noupdate -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(0) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(0)(1) -radix hexadecimal}}} {/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(1) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(1)(1) -radix hexadecimal}}}} -subitemconfig {/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(0) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(0)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(0)(1) {-height 13 -radix hexadecimal} /calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(1) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(1)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe(1)(1) {-height 13 -radix hexadecimal}} /calo_muon_correlation_condition_dr_tb/dut/calo_obj_vs_templ_pipe
add wave -noupdate -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(0) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(0)(1) -radix hexadecimal}}} {/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(1) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(1)(1) -radix hexadecimal}}}} -subitemconfig {/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(0) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(0)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(0)(1) {-height 13 -radix hexadecimal} /calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(1) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(1)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe(1)(1) {-height 13 -radix hexadecimal}} /calo_muon_correlation_condition_dr_tb/dut/muon_obj_vs_templ_pipe
add wave -noupdate -radix binary -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0) -radix binary -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(0) -radix binary} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(1) -radix binary}}} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(1) -radix binary -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(0) -radix binary} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(1) -radix binary}}}} -subitemconfig {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0) {-height 13 -radix binary -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(0) -radix binary} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(1) -radix binary}} -expand} /calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(0) {-height 13 -radix binary} /calo_muon_correlation_condition_dr_tb/dut/dr_comp(0)(1) {-height 13 -radix binary} /calo_muon_correlation_condition_dr_tb/dut/dr_comp(1) {-height 13 -radix binary -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(0) -radix binary} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(1) -radix binary}} -expand} /calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(0) {-height 13 -radix binary} /calo_muon_correlation_condition_dr_tb/dut/dr_comp(1)(1) {-height 13 -radix binary}} /calo_muon_correlation_condition_dr_tb/dut/dr_comp
add wave -noupdate -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(0) -radix hexadecimal} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(1) -radix hexadecimal}}} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1) -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(0) -radix hexadecimal} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(1) -radix hexadecimal}}}} -subitemconfig {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(0) -radix hexadecimal} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(0) {-height 13 -radix hexadecimal} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(0)(1) {-height 13 -radix hexadecimal} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1) {-height 13 -radix hexadecimal -childformat {{/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(0) -radix hexadecimal} {/calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(1) -radix hexadecimal}} -expand} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(0) {-height 13 -radix hexadecimal} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe(1)(1) {-height 13 -radix hexadecimal}} /calo_muon_correlation_condition_dr_tb/dut/dr_comp_pipe
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dut/condition_o
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(0)/dr_i/dr_calculator_i/sim_dr_comp
add wave -noupdate /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(0)/delta_l_2(1)/dr_i/dr_calculator_i/sim_dr_comp
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(0)/dr_i/dr_calculator_i/sim_dr_comp
add wave -noupdate -radix decimal /calo_muon_correlation_condition_dr_tb/dut/delta_l_1(1)/delta_l_2(1)/dr_i/dr_calculator_i/sim_dr_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55333 ps} 0}
configure wave -namecolwidth 851
configure wave -valuecolwidth 126
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {126569 ps} {519655 ps}
