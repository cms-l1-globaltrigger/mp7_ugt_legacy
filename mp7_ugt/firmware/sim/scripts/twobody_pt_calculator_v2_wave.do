onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /twobody_pt_calculator_v2_tb/eg_data
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt1
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt2
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/cos_phi_1_integer
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/cos_phi_2_integer
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/sin_phi_1_integer
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/sin_phi_2_integer
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/cos_plus_sin_integer
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt1_square
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt2_square
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/cos_plus_sin_vec_temp
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/cos_plus_sin_vec
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt1_x_pt2_x_cos_plus_sin_temp
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt1_x_pt2_x_cos_plus_sin
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt_sq_threshold_vector
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt_square
add wave -noupdate -radix decimal /twobody_pt_calculator_v2_tb/dut/pt_square_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162116 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 473
configure wave -valuecolwidth 184
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
WaveRestoreZoom {0 ps} {492009 ps}
