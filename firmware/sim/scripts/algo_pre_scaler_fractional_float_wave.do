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
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/PRESCALE_FACTOR_WIDTH_TEST
add wave -noupdate /algo_pre_scaler_fractional_tb/PRESCALE_FACTOR_VALUE
add wave -noupdate -radix unsigned /algo_pre_scaler_fractional_tb/PRESCALE_FACTOR_VALUE_INTEGER
add wave -noupdate -radix unsigned /algo_pre_scaler_fractional_tb/PRESCALE_FACTOR_VALUE_VEC
add wave -noupdate -radix unsigned /algo_pre_scaler_fractional_tb/dut/prescale_factor_update_i/data_i
add wave -noupdate -radix unsigned /algo_pre_scaler_fractional_tb/dut/prescale_factor_update_i/data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4059163 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 459
configure wave -valuecolwidth 184
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
WaveRestoreZoom {0 ps} {260366336 ps}
