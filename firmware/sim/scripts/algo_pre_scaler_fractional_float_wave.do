onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /algo_pre_scaler_fractional_tb/lhc_clk
add wave -noupdate /algo_pre_scaler_fractional_tb/start
add wave -noupdate /algo_pre_scaler_fractional_tb/request_update_factor_pulse
add wave -noupdate /algo_pre_scaler_fractional_tb/update_factor_pulse
add wave -noupdate /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/update_pulse_del
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/prescale_factor_algo_1
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/prescale_factor_algo_2
add wave -noupdate /algo_pre_scaler_fractional_tb/algo
add wave -noupdate /algo_pre_scaler_fractional_tb/prescaled_algo_1_o
add wave -noupdate /algo_pre_scaler_fractional_tb/prescaled_algo_2_o
add wave -noupdate /algo_pre_scaler_fractional_tb/check_shadow_i/shadow
add wave -noupdate -divider {sim signals}
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/algo_1_cnt_sim
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/prescaled_algo_1_cnt_sim
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/algo_2_cnt_sim
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/prescaled_algo_2_cnt_sim
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/data_i
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/data_o
add wave -noupdate /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/request_ff
add wave -noupdate -radix decimal /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/data_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20338655 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 511
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
WaveRestoreZoom {18250311 ps} {22426999 ps}
