onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/lhc_clk
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/calo_deta_bin
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/calo_dphi_bin
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/deta
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/dphi
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/addr_lsb
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/addr_lsb_5
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout1
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout2
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout3
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout4
add wave -noupdate -radix unsigned /rom_lut_calo_inv_dr_sq_all_tb/dut/dout5
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/deta_msb
add wave -noupdate /rom_lut_calo_inv_dr_sq_all_tb/dut/dphi_msb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50000 ps} 0} {{Cursor 2} {624382 ps} 0}
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
