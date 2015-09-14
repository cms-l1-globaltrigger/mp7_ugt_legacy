# Area constraints for MP7 null algo

# create_pblock payload
# resize_pblock [get_pblocks payload] -add {SLICE_X40Y0:SLICE_X181Y449}
# resize_pblock [get_pblocks payload] -add {RAMB18_X2Y0:RAMB18_X12Y179}
# resize_pblock [get_pblocks payload] -add {RAMB36_X2Y0:RAMB36_X12Y89}
#
# add_cells_to_pblock [get_pblock payload] payload
# add_cells_to_pblock [get_pblock payload] [get_cells payload/frame_i]
# add_cells_to_pblock [get_pblock payload] [get_cells payload/gtl_fdl_wrapper_i]

# area constraints for outputs
create_pblock payload0
resize_pblock [get_pblocks payload0] -add {SLICE_X106Y400:SLICE_X180Y449}
create_pblock payload1
resize_pblock [get_pblocks payload1] -add {SLICE_X106Y350:SLICE_X180Y399}
create_pblock payload2
resize_pblock [get_pblocks payload2] -add {SLICE_X106Y300:SLICE_X180Y349}
create_pblock payload3
resize_pblock [get_pblocks payload3] -add {SLICE_X106Y250:SLICE_X180Y299}
create_pblock payload4
resize_pblock [get_pblocks payload4] -add {SLICE_X106Y200:SLICE_X180Y249}

# Algo area constraints
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux0_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux1_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux2_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux3_i*]]

# add_cells_to_pblock [get_pblocks payload_1] [get_cells -quiet [list payload/frame_i/output_mux_i/mux4_i*]]
# add_cells_to_pblock [get_pblocks payload_1] [get_cells -quiet [list payload/frame_i/output_mux_i/mux5_i*]]
# add_cells_to_pblock [get_pblocks payload_1] [get_cells -quiet [list payload/frame_i/output_mux_i/mux8_i*]]
# add_cells_to_pblock [get_pblocks payload_1] [get_cells -quiet [list payload/frame_i/output_mux_i/mux9_i*]]
#
# add_cells_to_pblock [get_pblocks payload_2] [get_cells -quiet [list payload/frame_i/output_mux_i/mux6_i*]]
# add_cells_to_pblock [get_pblocks payload_2] [get_cells -quiet [list payload/frame_i/output_mux_i/mux7_i*]]
# add_cells_to_pblock [get_pblocks payload_2] [get_cells -quiet [list payload/frame_i/output_mux_i/mux10_i*]]
# add_cells_to_pblock [get_pblocks payload_2] [get_cells -quiet [list payload/frame_i/output_mux_i/mux11_i*]]
# # mux11_i is removed in the optimization process when valid bit is always 0!
#
# add_cells_to_pblock [get_pblocks payload_3] [get_cells -quiet [list payload/frame_i/output_mux_i/mux12_i*]]
# add_cells_to_pblock [get_pblocks payload_3] [get_cells -quiet [list payload/frame_i/output_mux_i/mux13_i*]]
# add_cells_to_pblock [get_pblocks payload_3] [get_cells -quiet [list payload/frame_i/output_mux_i/mux14_i*]]
# add_cells_to_pblock [get_pblocks payload_3] [get_cells -quiet [list payload/frame_i/output_mux_i/mux15_i*]]