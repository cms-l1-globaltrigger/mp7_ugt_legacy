onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /one_over_dr_sq_calo_tb/lhc_clk
add wave -noupdate -radix decimal /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/calo_deta_bin(0)(1)
add wave -noupdate -radix decimal /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/calo_dphi_bin(0)(1)
add wave -noupdate -radix decimal /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/inverted_dr_sq(0)(1)
add wave -noupdate -divider Details
add wave -noupdate /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/addr_lsb
add wave -noupdate /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/addr_msb
add wave -noupdate -radix unsigned /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/dout1
add wave -noupdate -radix unsigned /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/dout2
add wave -noupdate -radix unsigned /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/dout3
add wave -noupdate -radix unsigned /one_over_dr_sq_calo_tb/calc_cut_mass_over_dr_eg_eg_bx_0_bx_0_i/cuts_l_1(0)/cuts_l_2(1)/mass_over_dr_sel/rom_lut_calo_sel/rom_lut_i/dout4
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {149704 ps} 0} {{Cursor 2} {421895479 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 880
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
WaveRestoreZoom {80496 ps} {214668 ps}
