onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_charge_corr_test_tb/lhc_clk
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/data1
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_double
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_double
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_triple
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_triple
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_quad
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_quad
add wave -noupdate /muon_charge_corr_test_tb/charge_comp_double_o
add wave -noupdate /muon_charge_corr_test_tb/charge_comp_triple_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {149704 ps} 0} {{Cursor 2} {421895479 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 496
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
WaveRestoreZoom {0 ps} {314489 ps}
