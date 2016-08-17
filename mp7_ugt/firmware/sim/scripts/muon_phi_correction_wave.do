onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /muon_phi_correction_tb/pt
add wave -noupdate -radix hexadecimal /muon_phi_correction_tb/phi
add wave -noupdate -radix decimal /muon_phi_correction_tb/dut/phi_value
add wave -noupdate -radix hexadecimal /muon_phi_correction_tb/dut/charge
add wave -noupdate -radix decimal /muon_phi_correction_tb/dut/phi_correction
add wave -noupdate -radix decimal /muon_phi_correction_tb/dut/phi_temp_o
add wave -noupdate -radix hexadecimal /muon_phi_correction_tb/dut/phi_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {72656 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 329
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
WaveRestoreZoom {0 ps} {292256 ps}
