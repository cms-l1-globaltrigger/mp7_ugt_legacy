onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /correlation_conditions_muon_tb/lhc_clk
add wave -noupdate /correlation_conditions_muon_tb/muon_bx_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94646 ps} 0} {{Cursor 2} {468325 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 600
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
WaveRestoreZoom {0 ps} {220390 ps}
