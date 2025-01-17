onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ett_imb_comparator_tb/lhc_clk
add wave -noupdate -radix decimal /ett_imb_comparator_tb/ett_pos
add wave -noupdate -radix decimal /ett_imb_comparator_tb/ett_neg
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/et_threshold
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/ett_minus
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/ett_minus_d
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/ett_total
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/ett_total_d
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/inv_ett_tot_lut_value
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/thresold_i
add wave -noupdate -radix decimal /ett_imb_comparator_tb/dut/imb
add wave -noupdate -radix binary /ett_imb_comparator_tb/dut/comp_o
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
WaveRestoreZoom {0 ps} {357860 ps}
