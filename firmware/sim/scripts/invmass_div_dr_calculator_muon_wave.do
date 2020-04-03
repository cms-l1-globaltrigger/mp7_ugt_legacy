onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_upper_limit
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_lower_limit
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/pt1_int
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/pt2_int
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt1_pt2
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/diff_eta_int
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/diff_phi_int
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_eta
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_phi
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/dr
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/cosh_deta_int
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/cos_dphi_int
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/cosh_cos_int
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/cosh_cos
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr
add wave -noupdate /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_comp
add wave -noupdate -divider Constants
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/dphi_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/pt_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/cosh_deta_int_digits
add wave -noupdate -radix decimal -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/fract_digits
add wave -noupdate -divider Test
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/div_diff
add wave -noupdate -radix ufixed -radixshowbase 0 /invmass_div_dr_calculator_muon_tb/dut/diff_eta_t
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_phi_t
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_eta_div
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/diff_phi_div
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/dr_calc
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/cosh_cos_t
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/cosh_cos_div
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_uf
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/mass_div_dr_uf
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt1_t
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt2_t
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt1_div
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt2_div
add wave -noupdate -radix ufixed /invmass_div_dr_calculator_muon_tb/dut/pt1_pt2_t
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
WaveRestoreZoom {0 ps} {391154 ps}
