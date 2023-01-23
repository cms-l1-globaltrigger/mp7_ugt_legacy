onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/lhc_clk
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/lhc_data
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_data
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_module_i/bx_data
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_data.mu
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_data.eg
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_data.jet
add wave -noupdate /adt_test_l1menu_adt_v6_mod_1_tb/gtl_data.etm
add wave -noupdate -radix decimal /adt_test_l1menu_adt_v6_mod_1_tb/anomaly_score
add wave -noupdate -radix binary /adt_test_l1menu_adt_v6_mod_1_tb/gtl_module_i/algo
add wave -noupdate -radix binary /adt_test_l1menu_adt_v6_mod_1_tb/gtl_module_i/algo_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1207000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 547
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
WaveRestoreZoom {89196429 ps} {91094925 ps}
