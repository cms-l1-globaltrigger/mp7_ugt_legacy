onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /algo_pre_scaler_fractional_tb/lhc_clk
add wave -noupdate /algo_pre_scaler_fractional_tb/start
add wave -noupdate /algo_pre_scaler_fractional_tb/request_update_factor_pulse
add wave -noupdate /algo_pre_scaler_fractional_tb/update_factor_pulse
add wave -noupdate -radix unsigned -radixshowbase 0 /algo_pre_scaler_fractional_tb/prescale_factor
add wave -noupdate -radix unsigned -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/prescale_factor_int
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/counter
add wave -noupdate /algo_pre_scaler_fractional_tb/dut/limit
add wave -noupdate /algo_pre_scaler_fractional_tb/algo
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/dut/prescaled_algo_o
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/algo_cnt_sim
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/prescaled_algo_cnt_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 379
configure wave -valuecolwidth 39
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
WaveRestoreZoom {0 ps} {38484805 ps}
