onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /algo_pre_scaler_fractional_tb/lhc_clk
add wave -noupdate -label start_run /algo_pre_scaler_fractional_tb/start
add wave -noupdate -label prescale_factor_request /algo_pre_scaler_fractional_tb/request_update_factor_pulse
add wave -noupdate -label begin_lumi /algo_pre_scaler_fractional_tb/update_factor_pulse
add wave -noupdate -label begin_lumi_delayed /algo_pre_scaler_fractional_tb/dut_1/prescale_factor_update_i/update_pulse_del
add wave -noupdate -label prescale_factor_1 -radix decimal /algo_pre_scaler_fractional_tb/prescale_factor_algo_1
add wave -noupdate -label prescale_factor_2 -radix decimal /algo_pre_scaler_fractional_tb/prescale_factor_algo_2
add wave -noupdate -label algo /algo_pre_scaler_fractional_tb/algo
add wave -noupdate -label prescaled_algo_1 /algo_pre_scaler_fractional_tb/prescaled_algo_1_o
add wave -noupdate -label prescaled_algo_2 /algo_pre_scaler_fractional_tb/prescaled_algo_2_o
add wave -noupdate -label rate_counter_1 -radix decimal /algo_pre_scaler_fractional_tb/rate_cnt_1_i/counter_o
add wave -noupdate -label rate_counter_2 -radix decimal /algo_pre_scaler_fractional_tb/rate_cnt_2_i/counter_o
add wave -noupdate -label {"shadow"} /algo_pre_scaler_fractional_tb/check_shadow_i/shadow
add wave -noupdate -divider {sim signals}
add wave -noupdate -label algo_counter -radix decimal /algo_pre_scaler_fractional_tb/algo_1_cnt_sim
add wave -noupdate -label prescaled_algo_1_counter -radix decimal /algo_pre_scaler_fractional_tb/prescaled_algo_1_cnt_sim
add wave -noupdate -label prescaled_algo_2_counter -radix decimal /algo_pre_scaler_fractional_tb/prescaled_algo_2_cnt_sim
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {255084814 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 237
configure wave -valuecolwidth 63
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
WaveRestoreZoom {0 ps} {666051328 ps}
