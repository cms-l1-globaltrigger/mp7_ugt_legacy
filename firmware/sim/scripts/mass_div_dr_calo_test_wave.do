onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mass_div_dr_calo_test_tb/lhc_clk
add wave -noupdate /mass_div_dr_calo_test_tb/calo_deta_bin(0)(1)
add wave -noupdate /mass_div_dr_calo_test_tb/calo_dphi_bin(0)(1)
add wave -noupdate /mass_div_dr_calo_test_tb/eg_eg_bx_0_bx_0_deta_integer(0)(1)
add wave -noupdate /mass_div_dr_calo_test_tb/eg_eg_bx_0_bx_0_dphi_integer(0)(1)
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/dout
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/lut_all_i/lut1_i/douta
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/lut_all_i/lut2_i/douta
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/lut_all_i/lut3_i/douta
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/lut_all_i/lut4_i/douta
add wave -noupdate -radix unsigned /mass_div_dr_calo_test_tb/lut_all_i/lut5_i/douta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54933 ps} 0} {{Cursor 2} {421555535 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 424
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
WaveRestoreZoom {0 ps} {267865 ps}
