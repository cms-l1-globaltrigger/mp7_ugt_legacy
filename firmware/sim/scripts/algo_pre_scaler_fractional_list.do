onerror {resume}
radix -dec
add list /algo_pre_scaler_fractional_tb/algo_cnt_sim
add list /algo_pre_scaler_fractional_tb/prescaled_algo_cnt_sim
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
