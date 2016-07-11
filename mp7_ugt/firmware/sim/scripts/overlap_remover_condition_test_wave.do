onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /overlap_remover_condition_test_tb/lhc_clk
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/tau_dr
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/tau_dr_pipe
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_dr
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_dr_pipe
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_dr_2
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_inv_mass
add wave -noupdate /overlap_remover_condition_test_tb/dut/condition_o
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_eta_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_phi_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_eta_integer_inv_mass
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_phi_integer_inv_mass
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/tau_eta_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/tau_phi_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_tau_eta_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_tau_phi_integer
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_jet_eta_integer_inv_mass
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_jet_phi_integer_inv_mass
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_tau_eta_vector
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/diff_jet_tau_phi_vector
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_pt_vector
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_jet_cosh_deta_vector
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/jet_jet_cos_dphi_vector
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/removed_overlaps_pt
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/removed_objects_mask
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/removed_objects_mask_pipe
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/calo1_delta_r_obj_vs_templ_pipe
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/calo2_delta_r_obj_vs_templ_pipe
add wave -noupdate -radix hexadecimal /overlap_remover_condition_test_tb/dut/dr_comp_pipe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {142835 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 499
configure wave -valuecolwidth 100
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
WaveRestoreZoom {33392 ps} {524559 ps}
