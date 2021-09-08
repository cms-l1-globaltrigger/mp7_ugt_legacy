onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/lhc_clk
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/muon_deta_bin
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/muon_dphi_bin
add wave -noupdate -radix unsigned -childformat {{/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(7) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(6) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(5) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(4) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(3) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(2) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(1) -radix unsigned} {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(0) -radix unsigned}} -subitemconfig {/rom_lut_muon_inv_dr_sq_all_tb/dut/deta(7) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(6) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(5) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(4) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(3) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(2) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(1) {-height 16 -radix unsigned} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(0) {-height 16 -radix unsigned}} /rom_lut_muon_inv_dr_sq_all_tb/dut/deta
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout
add wave -noupdate -divider Details
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout1
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout2
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout3
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout4
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout5
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout6
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout7
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout8
add wave -noupdate -radix unsigned /rom_lut_muon_inv_dr_sq_all_tb/dut/dout9
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/addr_lsb
add wave -noupdate -radix hexadecimal /rom_lut_muon_inv_dr_sq_all_tb/dut/addr_lsb_9
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta_msb
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi_msb
add wave -noupdate -divider {New Divider}
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(7)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(6)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(5)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(4)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(3)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(2)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(1)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/deta(0)
add wave -noupdate -divider {New Divider}
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi(4)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi(3)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi(2)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi(1)
add wave -noupdate /rom_lut_muon_inv_dr_sq_all_tb/dut/dphi(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65538 ps} 0} {{Cursor 2} {624382 ps} 0}
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
WaveRestoreZoom {225378 ps} {514454 ps}
