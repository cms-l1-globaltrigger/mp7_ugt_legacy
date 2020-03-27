onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/pt1
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/pt2
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/diff_eta
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/diff_phi
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/cosh_deta
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/cos_dphi
add wave -noupdate -radix binary -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/cos_dphi
add wave -noupdate /invmass_div_dr_calculator_eg_tb/cos_dphi_sign
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_eg_tb/dut/mass_div_dr_upper_limit
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_eg_tb/dut/mass_div_dr_lower_limit
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/dr
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/mass
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/mass_div_dr
add wave -noupdate /invmass_div_dr_calculator_eg_tb/dut/mass_div_dr_comp
add wave -noupdate -divider Constants
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/dphi_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/pt_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/cosh_deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_eg_tb/dut/fract_digits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {33994 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 503
configure wave -valuecolwidth 612
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
WaveRestoreZoom {0 ps} {260304 ps}
