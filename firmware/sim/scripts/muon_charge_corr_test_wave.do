onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_charge_corr_test_tb/lhc_clk
add wave -noupdate -expand /muon_charge_corr_test_tb/muon_charge_correlations_i/data1
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_double
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_double
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_triple
add wave -noupdate -expand /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_triple
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/ls_charcorr_quad
add wave -noupdate /muon_charge_corr_test_tb/muon_charge_correlations_i/os_charcorr_quad
add wave -noupdate /muon_charge_corr_test_tb/charge_correlation_comp_i/requested_charge_correlation
add wave -noupdate /muon_charge_corr_test_tb/charge_correlation_comp_i/double_sel
add wave -noupdate /muon_charge_corr_test_tb/charge_correlation_comp_i/triple_sel
add wave -noupdate /muon_charge_corr_test_tb/matrix_corr_cond_i/charge_comp_double
add wave -noupdate /muon_charge_corr_test_tb/matrix_corr_cond_i/charge_comp_triple
add wave -noupdate /muon_charge_corr_test_tb/matrix_corr_cond_i/condition_and_or
add wave -noupdate /muon_charge_corr_test_tb/obj1_vs_templ
add wave -noupdate /muon_charge_corr_test_tb/obj2_vs_templ
add wave -noupdate /muon_charge_corr_test_tb/obj3_vs_templ
add wave -noupdate /muon_charge_corr_test_tb/mass_3_obj_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14722 ps} 0} {{Cursor 2} {421895479 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 560
configure wave -valuecolwidth 162
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
WaveRestoreZoom {0 ps} {289306 ps}
