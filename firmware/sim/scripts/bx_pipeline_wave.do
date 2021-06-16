onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bx_pipeline_tb/lhc_clk
add wave -noupdate -expand /bx_pipeline_tb/dut/gtl_data.mu
add wave -noupdate -expand /bx_pipeline_tb/dut/bx_data.mus0
add wave -noupdate -expand /bx_pipeline_tb/dut/bx_data.mus1
add wave -noupdate -expand /bx_pipeline_tb/dut/bx_data.musoot0
add wave -noupdate -expand /bx_pipeline_tb/dut/bx_data.musoot1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94646 ps} 0} {{Cursor 2} {624382 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 346
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
WaveRestoreZoom {0 ps} {1156304 ps}
