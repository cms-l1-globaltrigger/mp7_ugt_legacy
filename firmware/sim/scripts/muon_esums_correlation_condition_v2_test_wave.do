onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_esums_correlation_condition_v2_tb/lhc_clk
add wave -noupdate -radix hexadecimal /muon_esums_correlation_condition_v2_tb/etm
add wave -noupdate -radix hexadecimal /muon_esums_correlation_condition_v2_tb/etm_bx_0
add wave -noupdate -radix decimal /muon_esums_correlation_condition_v2_tb/dut/mass_type
add wave -noupdate /muon_esums_correlation_condition_v2_tb/dut/twobody_pt_cut
add wave -noupdate -radix decimal /muon_esums_correlation_condition_v2_tb/dut/delta_l(0)/mass_i/mass_calculator_i/mass_upper_limit_vector
add wave -noupdate -radix decimal /muon_esums_correlation_condition_v2_tb/dut/delta_l(0)/mass_i/mass_calculator_i/mass_lower_limit_vector
add wave -noupdate -radix decimal /muon_esums_correlation_condition_v2_tb/dut/delta_l(1)/mass_i/mass_calculator_i/sim_transverse_mass_sq_div2
add wave -noupdate /muon_esums_correlation_condition_v2_tb/dut/delta_l(1)/mass_i/mass_calculator_i/mass_comp
add wave -noupdate -radix decimal /muon_esums_correlation_condition_v2_tb/dut/delta_l(0)/mass_i/mass_calculator_i/sim_transverse_mass_sq_div2
add wave -noupdate /muon_esums_correlation_condition_v2_tb/dut/delta_l(0)/mass_i/mass_calculator_i/mass_comp
add wave -noupdate -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(0) -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(0)(0) -radix hexadecimal}}} {/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(1) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(2) -radix hexadecimal}} -expand -subitemconfig {/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(0) {-height 17 -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(0)(0) -radix hexadecimal}}} /muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(0)(0) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(1) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe(2) {-height 17 -radix hexadecimal}} /muon_esums_correlation_condition_v2_tb/dut/mass_comp_pipe
add wave -noupdate -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(0) -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(0)(0) -radix hexadecimal}}} {/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(1) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(2) -radix hexadecimal}} -expand -subitemconfig {/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(0) {-height 17 -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(0)(0) -radix hexadecimal}}} /muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(0)(0) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(1) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe(2) {-height 17 -radix hexadecimal}} /muon_esums_correlation_condition_v2_tb/dut/twobody_pt_comp_pipe
add wave -noupdate -radix hexadecimal /muon_esums_correlation_condition_v2_tb/dut/esums_comp_o_pipe
add wave -noupdate -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(0) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(1) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(2) -radix hexadecimal}} -expand -subitemconfig {/muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(0) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(1) {-height 17 -radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe(2) {-height 17 -radix hexadecimal}} /muon_esums_correlation_condition_v2_tb/dut/diff_phi_comp_pipe
add wave -noupdate -radix hexadecimal -childformat {{/muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(0) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(1) -radix hexadecimal} {/muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(2) -radix hexadecimal}} -expand -subitemconfig {/muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(0) {-radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(1) {-radix hexadecimal} /muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe(2) {-radix hexadecimal}} /muon_esums_correlation_condition_v2_tb/dut/obj_vs_templ_pipe
add wave -noupdate /muon_esums_correlation_condition_v2_tb/condition_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {286429 ps} 0} {{Cursor 2} {159724 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 988
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
WaveRestoreZoom {0 ps} {583608 ps}
