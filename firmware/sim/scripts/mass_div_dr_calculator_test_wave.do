onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mass_div_dr_calculator_eg_tb/lhc_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {86774 ps} 0} {{Cursor 2} {468325 ps} 0}
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
WaveRestoreZoom {0 ps} {440779 ps}
