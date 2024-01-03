onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/lhc_clk
add wave -noupdate -expand /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/lhc_data
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/algo
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/algo_log
add wave -noupdate -radix hexadecimal -childformat {{/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(15) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(14) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(13) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(12) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(11) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(10) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(9) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(8) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(7) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(6) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(5) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(4) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(3) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(2) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(1) -radix hexadecimal} {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(0) -radix hexadecimal}} -expand -subitemconfig {/topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(15) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(14) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(13) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(12) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(11) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(10) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(9) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(8) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(7) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(6) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(5) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(4) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(3) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(2) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(1) {-radix hexadecimal} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score(0) {-radix hexadecimal}} /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score_tmp
add wave -noupdate /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/topo_score_int
add wave -noupdate -radix hexadecimal /topo_test_l1menu_cicada_topo_test_v2_mod_1_tb/gtl_module_i/cond_topological_trigger_i8_i/threshold
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1413059 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 635
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
WaveRestoreZoom {835322 ps} {1716602 ps}
