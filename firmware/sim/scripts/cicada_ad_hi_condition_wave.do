onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cicada_ad_hi_condition_tb/lhc_clk
add wave -noupdate /cicada_ad_hi_condition_tb/dut/ad_int_thr
add wave -noupdate /cicada_ad_hi_condition_tb/dut/ad_dec_thr
add wave -noupdate /cicada_ad_hi_condition_tb/dut/ad_requ
add wave -noupdate /cicada_ad_hi_condition_tb/cicada_ad_int
add wave -noupdate /cicada_ad_hi_condition_tb/cicada_ad_dec
add wave -noupdate /cicada_ad_hi_condition_tb/dut/ad_comp
add wave -noupdate /cicada_ad_hi_condition_tb/dut/comp_v
add wave -noupdate /cicada_ad_hi_condition_tb/dut/comp_v_o
add wave -noupdate /cicada_ad_hi_condition_tb/dut/ad_comp_o
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
