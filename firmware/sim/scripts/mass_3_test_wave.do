onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mass_3_eg_tb/lhc_clk
add wave -noupdate /mass_3_eg_tb/eg_bx_0
add wave -noupdate /mass_3_eg_tb/dut/obj1_vs_templ_pipe
add wave -noupdate /mass_3_eg_tb/dut/obj2_vs_templ_pipe
add wave -noupdate /mass_3_eg_tb/dut/obj3_vs_templ_pipe
add wave -noupdate /mass_3_eg_tb/dut/pt1
add wave -noupdate /mass_3_eg_tb/dut/pt2
add wave -noupdate /mass_3_eg_tb/dut/cosh_deta
add wave -noupdate /mass_3_eg_tb/dut/cos_dphi
add wave -noupdate /mass_3_eg_tb/dut/not_esums_sel/mass_3_obj_i/sum_mass_i/invariant_mass
add wave -noupdate /mass_3_eg_tb/dut/not_esums_sel/mass_3_obj_i/sum_mass_i/sum_mass_temp
add wave -noupdate /mass_3_eg_tb/dut/not_esums_sel/mass_3_obj_i/sum_mass_i/sum_mass
add wave -noupdate /mass_3_eg_tb/dut/mass_3_obj_comp_pipe
add wave -noupdate /mass_3_eg_tb/dut/condition_o
add wave -noupdate /mass_3_eg_tb/dut/not_esums_sel/correlation_cuts_i/mass_cut
add wave -noupdate /mass_3_eg_tb/dut/not_esums_sel/correlation_cuts_i/mass_type
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94646 ps} 0} {{Cursor 2} {468325 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 600
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
WaveRestoreZoom {0 ps} {220390 ps}
