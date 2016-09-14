onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/data_i(0)
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/data_o(0)
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/pt
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/phi
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/charge
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/phi_o
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/phi_temp_o
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/phi_value
add wave -noupdate -radix hexadecimal /muon_phi_correction_objects_tb/dut/obj_l(0)/muon_phi_correction_i/phi_correction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18164 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 578
configure wave -valuecolwidth 151
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
WaveRestoreZoom {0 ps} {231029 ps}
