onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /invmass_div_dr_calculator_eg_tb/dut/mass_div_dr_comp
add wave -noupdate -radix hexadecimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/eg_data
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/eg_eta_integer
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/eg_phi_integer
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/diff_eg_eg_eta_integer
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/diff_eg_eg_phi_integer
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/mass_upper_limit
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/mass_lower_limit
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/dut/upper_limit
add wave -noupdate -radix decimal /invmass_div_dr_calculator_eg_tb/dut/lower_limit
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/inv_dr_sq
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/pt1
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/pt2
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/cosh_deta
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/cos_dphi
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/invariant_mass_sq_div2
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/invmass_sq_div2_div_dr_sq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {164347 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 498
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
WaveRestoreZoom {0 ps} {411392 ps}
