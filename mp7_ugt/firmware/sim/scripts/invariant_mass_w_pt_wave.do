onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/eg_data
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/pt1
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/pt2
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/eg_eta_integer
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/eg_phi_integer
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/diff_eg_eg_eta_integer
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/diff_eg_eg_phi_integer
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/cosh_deta_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/cos_dphi_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/cos_phi_1
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/cos_phi_2
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/sin_phi_1
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/sin_phi_2
add wave -noupdate /invariant_mass_w_pt_tb/dut/pt_sq_upper_limit
add wave -noupdate /invariant_mass_w_pt_tb/dut/pt_sq_lower_limit
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/sim_pt_sq_upper_limit_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/sim_pt_sq_lower_limit_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/sim_pt_square
add wave -noupdate /invariant_mass_w_pt_tb/dut/pt_square_comp
add wave -noupdate /invariant_mass_w_pt_tb/dut/pt_square_cut_internal
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/inv_mass_upper_limit
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/inv_mass_lower_limit
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/inv_mass_upper_limit_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/inv_mass_lower_limit_vector
add wave -noupdate -radix hexadecimal /invariant_mass_w_pt_tb/dut/inv_mass_sq_div2
add wave -noupdate -radix binary /invariant_mass_w_pt_tb/dut/inv_mass_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {211034 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 382
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
WaveRestoreZoom {0 ps} {528798 ps}
