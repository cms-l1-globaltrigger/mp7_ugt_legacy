onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /algo_post_dead_time_counter_tb/dut/sys_clk
add wave -noupdate /algo_post_dead_time_counter_tb/lhc_clk
add wave -noupdate -radix binary /algo_post_dead_time_counter_tb/dut/algo
add wave -noupdate /algo_post_dead_time_counter_tb/algo_s
add wave -noupdate -radix binary /algo_post_dead_time_counter_tb/dut/algo_delayed
add wave -noupdate /algo_post_dead_time_counter_tb/l1a
add wave -noupdate /algo_post_dead_time_counter_tb/l1a_s
add wave -noupdate /algo_post_dead_time_counter_tb/begin_lumi_section
add wave -noupdate /algo_post_dead_time_counter_tb/begin_lumi_section_s
add wave -noupdate -radix hexadecimal /algo_post_dead_time_counter_tb/dut/counter_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9200 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 410
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
WaveRestoreZoom {0 ps} {1102900 ps}
