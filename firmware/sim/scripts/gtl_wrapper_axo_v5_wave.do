onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate /gtl_wrapper_axo_v5_tb/lhc_clk
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_data
add wave -noupdate -divider Results
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/algo
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i0
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i1
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i2
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i3
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i4
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i5
add wave -noupdate /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_trigger_i6
add wave -noupdate -radix decimal /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_score
add wave -noupdate -radix hexadecimal /gtl_wrapper_axo_v5_tb/gtl_module_i/axol1tl_score
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {89108 ps} 0} {{Cursor 2} {1632855000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 390
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
WaveRestoreZoom {0 ps} {684669 ps}
