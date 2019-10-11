onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /algo_pre_scaler_fractional_tb/lhc_clk
add wave -noupdate /algo_pre_scaler_fractional_tb/sres_counter
add wave -noupdate /algo_pre_scaler_fractional_tb/request_update_factor_pulse
add wave -noupdate /algo_pre_scaler_fractional_tb/update_factor_pulse
add wave -noupdate -radix hexadecimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/prescale_factor
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/prescale_factor_int
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/numerator
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/denominator
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/counter
add wave -noupdate /algo_pre_scaler_fractional_tb/dut/limit
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/index_sim
add wave -noupdate /algo_pre_scaler_fractional_tb/algo
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/dut/prescaled_algo_o
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/algo_cnt_sim
add wave -noupdate -radix decimal -radixshowbase 0 /algo_pre_scaler_fractional_tb/dut/prescaled_algo_cnt_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90987500 ps} 0}
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
WaveRestoreZoom {87135229 ps} {91203409 ps}
