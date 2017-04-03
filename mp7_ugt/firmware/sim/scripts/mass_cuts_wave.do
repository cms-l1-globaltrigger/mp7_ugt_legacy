onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mass_cuts_tb/eg_data
add wave -noupdate -radix decimal /mass_cuts_tb/pt1
add wave -noupdate -radix decimal /mass_cuts_tb/pt2
add wave -noupdate -radix decimal -childformat {{/mass_cuts_tb/eg_eta_integer(0) -radix decimal} {/mass_cuts_tb/eg_eta_integer(1) -radix decimal}} -subitemconfig {/mass_cuts_tb/eg_eta_integer(0) {-height 17 -radix decimal} /mass_cuts_tb/eg_eta_integer(1) {-height 17 -radix decimal}} /mass_cuts_tb/eg_eta_integer
add wave -noupdate -radix decimal /mass_cuts_tb/eg_phi_integer
add wave -noupdate -radix decimal /mass_cuts_tb/diff_eg_eg_eta_integer
add wave -noupdate -radix decimal /mass_cuts_tb/diff_eg_eg_phi_integer
add wave -noupdate -radix decimal /mass_cuts_tb/cosh_deta_vector
add wave -noupdate -radix decimal /mass_cuts_tb/cos_dphi_vector
add wave -noupdate -radix decimal /mass_cuts_tb/dut/cos_phi_1_integer
add wave -noupdate -radix decimal /mass_cuts_tb/dut/cos_phi_2_integer
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sin_phi_1_integer
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sin_phi_2_integer
add wave -noupdate -radix decimal /mass_cuts_tb/dut/twobody_pt_calculator_i/cos_plus_sin_vec
add wave -noupdate -radix decimal /mass_cuts_tb/dut/twobody_pt_calculator_i/pt1_x_pt2_x_cos_plus_sin
add wave -noupdate -radix decimal /mass_cuts_tb/dut/twobody_pt_calculator_i/pt_sq_threshold_vector
add wave -noupdate -radix decimal /mass_cuts_tb/dut/twobody_pt_calculator_i/pt_square
add wave -noupdate /mass_cuts_tb/dut/pt_square_comp
add wave -noupdate -radix decimal /mass_cuts_tb/dut/mass_upper_limit
add wave -noupdate -radix decimal /mass_cuts_tb/dut/mass_lower_limit
add wave -noupdate -radix decimal /mass_cuts_tb/dut/mass_upper_limit_vector
add wave -noupdate -radix decimal /mass_cuts_tb/dut/mass_lower_limit_vector
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sim_invariant_mass_sq_div2
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sim_transverse_mass_sq_div2
add wave -noupdate -radix decimal /mass_cuts_tb/dut/mass_type
add wave -noupdate /mass_cuts_tb/dut/inv_mass_comp
add wave -noupdate /mass_cuts_tb/dut/mass_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67110 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 459
configure wave -valuecolwidth 184
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
WaveRestoreZoom {0 ps} {497668 ps}
