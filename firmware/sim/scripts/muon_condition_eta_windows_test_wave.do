onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_condition_eta_windows_test_tb/lhc_clk
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w1_upper_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w1_lower_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w2_upper_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w2_lower_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w3_upper_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w3_lower_limits_obj1
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w1_upper_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w1_lower_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w2_upper_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w2_lower_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w3_upper_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/eta_w3_lower_limit_obj2
add wave -noupdate /muon_condition_eta_windows_test_tb/muon_data
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/obj1_slice_1_vs_templ_pipe
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/obj1_slice_2_vs_templ_pipe
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/condition_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_1_l(0)/comp_i/eta_windows_comp_i/eta
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_1_l(0)/comp_i/eta_windows_comp_i/eta_comp_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_1_l(1)/comp_i/eta_windows_comp_i/eta_comp_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_2_l(0)/comp_i/eta_windows_comp_i/eta_comp_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_2_l(1)/comp_i/eta_windows_comp_i/eta_comp_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_1_l(2)/comp_i/eta_windows_comp_i/eta_comp_o
add wave -noupdate /muon_condition_eta_windows_test_tb/dut/muon_i/obj_cuts_i/obj_slice_2_l(2)/comp_i/eta_windows_comp_i/eta_comp_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90158 ps} 0} {{Cursor 2} {1632855000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 737
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
WaveRestoreZoom {0 ps} {510222 ps}
