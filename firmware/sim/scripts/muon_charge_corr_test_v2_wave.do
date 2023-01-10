onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_charge_corr_test_v2_tb/lhc_clk
add wave -noupdate /muon_charge_corr_test_v2_tb/muon
add wave -noupdate /muon_charge_corr_test_v2_tb/calc_muon_charge_correlations_bx_0_bx_0_i/ls_charcorr_triple
add wave -noupdate /muon_charge_corr_test_v2_tb/calc_muon_charge_correlations_bx_0_bx_0_i/os_charcorr_triple
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/condition_and_or
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/requested_charge_correlation
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/not_esums_sel/mass_3_obj_i/matrix_corr_cond_i/condition_and_or
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/not_esums_sel/mass_3_obj_i/matrix_corr_cond_i/charge_comp_triple
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/not_esums_sel/mass_3_obj_i/matrix_corr_cond_i/type_obj1
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/not_esums_sel/mass_3_obj_i/matrix_corr_cond_i/type_obj2
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/type_obj1
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/type_obj2
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/type_obj3
add wave -noupdate -subitemconfig {/muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(0)(3) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(0)(4) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(2) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(2)(0) -expand} /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/obj1_vs_templ_pipe
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/obj2_vs_templ_pipe
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/obj3_vs_templ_pipe
add wave -noupdate -subitemconfig {/muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(1) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(2) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(3) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(4) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(5) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(6) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(7) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(1)(0) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(1)(1) -expand /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(1)(2) -expand} /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(1)(2)
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(0)(1)(3)
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/mass_3_obj_comp_pipe(1)(2)(3)
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(0)(1)(2)
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(0)(1)(3)
add wave -noupdate /muon_charge_corr_test_v2_tb/cond_invariant_mass3_i3_i/charge_comp_triple_pipe(1)(2)(3)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14722 ps} 0} {{Cursor 2} {421895479 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 776
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
WaveRestoreZoom {0 ps} {235155 ps}
