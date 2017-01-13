onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mass_cuts_tb/eg_data
add wave -noupdate -radix hexadecimal /mass_cuts_tb/pt1
add wave -noupdate -radix hexadecimal /mass_cuts_tb/pt2
add wave -noupdate -radix hexadecimal /mass_cuts_tb/eg_eta_integer
add wave -noupdate -radix hexadecimal /mass_cuts_tb/eg_phi_integer
add wave -noupdate -radix hexadecimal /mass_cuts_tb/diff_eg_eg_eta_integer
add wave -noupdate -radix hexadecimal /mass_cuts_tb/diff_eg_eg_phi_integer
add wave -noupdate -radix hexadecimal /mass_cuts_tb/cosh_deta_vector
add wave -noupdate -radix hexadecimal /mass_cuts_tb/cos_dphi_vector
add wave -noupdate -radix hexadecimal /mass_cuts_tb/cos_phi_1
add wave -noupdate -radix hexadecimal /mass_cuts_tb/cos_phi_2
add wave -noupdate -radix hexadecimal /mass_cuts_tb/sin_phi_1
add wave -noupdate -radix hexadecimal /mass_cuts_tb/sin_phi_2
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sim_pt_sq_lower_limit_vector
add wave -noupdate -radix decimal /mass_cuts_tb/dut/sim_pt_square
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
WaveRestoreCursors {{Cursor 1} {150000 ps} 0}
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
