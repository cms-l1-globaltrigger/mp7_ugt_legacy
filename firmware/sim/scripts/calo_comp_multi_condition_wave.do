onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /calo_comp_multi_condition_tb/lhc_clk
add wave -noupdate /calo_comp_multi_condition_tb/dut/obj_nr
add wave -noupdate /calo_comp_multi_condition_tb/dut/pt_threshold
add wave -noupdate /calo_comp_multi_condition_tb/dut/data_i
add wave -noupdate /calo_comp_multi_condition_tb/dut/pt
add wave -noupdate /calo_comp_multi_condition_tb/dut/comp
add wave -noupdate /calo_comp_multi_condition_tb/dut/condition_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100000 ps} 0} {{Cursor 2} {1632855000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 329
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
WaveRestoreZoom {0 ps} {715721 ps}
