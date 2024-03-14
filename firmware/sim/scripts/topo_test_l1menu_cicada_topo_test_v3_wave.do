onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/lhc_clk
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/lhc_data
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/algo
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/algo_log
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/gtl_module_topo_i/cond_topological_trigger_i8_i/threshold
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/topo_score
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/topo_score_tmp
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/topo_score_int
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/gtl_module_adt_i/cond_anomaly_detection_trigger_i5_i/threshold
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/gtl_module_adt_i/cond_anomaly_detection_trigger_i5_i/anomaly_score
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v3_tb/gtl_module_adt_i/cond_anomaly_detection_trigger_i5_i/adt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1425000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 683
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
WaveRestoreZoom {1346082 ps} {2034417 ps}
