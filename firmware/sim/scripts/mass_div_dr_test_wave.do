onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mass_div_dr_jet_tb/lhc_clk
add wave -noupdate /mass_div_dr_jet_tb/jet_bx_0
add wave -noupdate /mass_div_dr_jet_tb/dut/condition_o
add wave -noupdate /mass_div_dr_jet_tb/dut/mass_div_dr
add wave -noupdate /mass_div_dr_jet_tb/dut/mass_cut
add wave -noupdate /mass_div_dr_jet_tb/dut/mass_type
add wave -noupdate /mass_div_dr_jet_tb/dut/mass_div_dr_vector_width
add wave -noupdate /mass_div_dr_jet_tb/dut/mass_div_dr_threshold
add wave -noupdate /mass_div_dr_jet_tb/dut/obj1_vs_templ_pipe
add wave -noupdate /mass_div_dr_jet_tb/dut/obj2_vs_templ_pipe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94646 ps} 0} {{Cursor 2} {468325 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 346
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
WaveRestoreZoom {0 ps} {289076 ps}
