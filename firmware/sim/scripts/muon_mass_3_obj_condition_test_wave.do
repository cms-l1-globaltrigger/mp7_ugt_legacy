onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /muon_mass_3_obj_condition_tb/lhc_clk
add wave -noupdate -radix hexadecimal /muon_mass_3_obj_condition_tb/muon
add wave -noupdate -childformat {{/muon_mass_3_obj_condition_tb/dut/pt(0) -radix decimal} {/muon_mass_3_obj_condition_tb/dut/pt(1) -radix decimal} {/muon_mass_3_obj_condition_tb/dut/pt(2) -radix decimal}} -subitemconfig {/muon_mass_3_obj_condition_tb/dut/pt(0) {-height 16 -radix decimal} /muon_mass_3_obj_condition_tb/dut/pt(1) {-height 16 -radix decimal} /muon_mass_3_obj_condition_tb/dut/pt(2) {-height 16 -radix decimal}} /muon_mass_3_obj_condition_tb/dut/pt
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/inv_mass_value
add wave -noupdate -subitemconfig {/muon_mass_3_obj_condition_tb/dut/sum_mass(0) -expand /muon_mass_3_obj_condition_tb/dut/sum_mass(0)(1) -expand} /muon_mass_3_obj_condition_tb/dut/sum_mass
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/mass_upper_limit_vector
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/mass_lower_limit_vector
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/muon1_obj_vs_templ
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/muon2_obj_vs_templ
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/muon3_obj_vs_templ
add wave -noupdate /muon_mass_3_obj_condition_tb/dut/mass_comp
add wave -noupdate /muon_mass_3_obj_condition_tb/condition_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {159792 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 438
configure wave -valuecolwidth 159
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
WaveRestoreZoom {80453 ps} {290874 ps}
