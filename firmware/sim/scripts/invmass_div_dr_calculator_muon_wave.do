onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_upper_limit
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_lower_limit
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_eta
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_phi
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/dr_sq
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/invariant_mass_sq_div2
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/invmass_sq_div2_div_dr_sq
add wave -noupdate /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_comp
add wave -noupdate -divider Constants
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/dphi_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/pt_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/cosh_deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/fract_digits
add wave -noupdate -divider Test
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88629 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 503
configure wave -valuecolwidth 237
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
WaveRestoreZoom {128404 ps} {519558 ps}
