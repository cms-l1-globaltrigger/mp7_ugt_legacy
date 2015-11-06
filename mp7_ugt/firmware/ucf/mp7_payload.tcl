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
create_pblock payload5
resize_pblock [get_pblocks payload5] -add {SLICE_X106Y150:SLICE_X180Y199}
create_pblock payload6
resize_pblock [get_pblocks payload6] -add {SLICE_X106Y100:SLICE_X180Y149}
create_pblock payload7
resize_pblock [get_pblocks payload7] -add {SLICE_X106Y50:SLICE_X180Y99}
create_pblock payload8
resize_pblock [get_pblocks payload8] -add {SLICE_X106Y0:SLICE_X180Y49}
create_pblock payload9
resize_pblock [get_pblocks payload9] -add {SLICE_X30Y0:SLICE_X105Y49}
create_pblock payload10
resize_pblock [get_pblocks payload10] -add {SLICE_X30Y50:SLICE_X105Y99}
create_pblock payload11
resize_pblock [get_pblocks payload11] -add {SLICE_X30Y100:SLICE_X105Y149}
create_pblock payload12
resize_pblock [get_pblocks payload12] -add {SLICE_X30Y150:SLICE_X105Y199}
create_pblock payload13
resize_pblock [get_pblocks payload13] -add {SLICE_X30Y200:SLICE_X105Y249}
create_pblock payload14
resize_pblock [get_pblocks payload14] -add {SLICE_X30Y250:SLICE_X105Y299}
create_pblock payload15
resize_pblock [get_pblocks payload15] -add {SLICE_X30Y300:SLICE_X105Y349}
create_pblock payload16
resize_pblock [get_pblocks payload16] -add {SLICE_X30Y350:SLICE_X105Y399}
create_pblock payload17
resize_pblock [get_pblocks payload17] -add {SLICE_X30Y400:SLICE_X105Y449}


# Algo area constraints

# sync stage for the slower bgo signals, use same region as used in the vhdl code!
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/bgo_sync_i]]

# add dm for the bc_res to same region as used bc0 signal!
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/dm_i/dm_bcres]]
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/dm_i/dm_bcres_fdl]]

# add tcm to same region as used bc0 signal!
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/tcm_inst]]

# demux_lane_data (240 -> 40MHz)
add_cells_to_pblock [get_pblocks payload0] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[0]*]]
add_cells_to_pblock [get_pblocks payload0] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[1]*]]
add_cells_to_pblock [get_pblocks payload0] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[2]*]]
add_cells_to_pblock [get_pblocks payload0] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[3]*]]
add_cells_to_pblock [get_pblocks payload1] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[4]*]]
add_cells_to_pblock [get_pblocks payload1] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[5]*]]
add_cells_to_pblock [get_pblocks payload1] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[6]*]]
add_cells_to_pblock [get_pblocks payload1] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[7]*]]
add_cells_to_pblock [get_pblocks payload2] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[8]*]]
add_cells_to_pblock [get_pblocks payload2] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[9]*]]
add_cells_to_pblock [get_pblocks payload2] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[10]*]]
#add_cells_to_pblock [get_pblocks payload2] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[11]*]] #empty channels have to be commented out
add_cells_to_pblock [get_pblocks payload3] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[12]*]]
add_cells_to_pblock [get_pblocks payload3] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[13]*]]
add_cells_to_pblock [get_pblocks payload3] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[14]*]]
add_cells_to_pblock [get_pblocks payload3] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[15]*]]
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[16]*]]
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[17]*]]
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[18]*]]
# add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[19]*]]
# add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[20]*]]
# add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[21]*]]
# add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[22]*]]
# add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[23]*]]
# add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[24]*]]
# add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[25]*]]
# add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[26]*]]
# add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[27]*]]
# add_cells_to_pblock [get_pblocks payload7] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[28]*]]
# add_cells_to_pblock [get_pblocks payload7] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[29]*]]
# add_cells_to_pblock [get_pblocks payload7] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[30]*]]
# add_cells_to_pblock [get_pblocks payload7] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[31]*]]
# add_cells_to_pblock [get_pblocks payload8] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[32]*]]
# add_cells_to_pblock [get_pblocks payload8] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[33]*]]
# add_cells_to_pblock [get_pblocks payload8] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[34]*]]
# add_cells_to_pblock [get_pblocks payload8] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[35]*]]
# add_cells_to_pblock [get_pblocks payload9] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[36]*]]
# add_cells_to_pblock [get_pblocks payload9] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[37]*]]
# add_cells_to_pblock [get_pblocks payload9] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[38]*]]
# add_cells_to_pblock [get_pblocks payload9] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[39]*]]
# add_cells_to_pblock [get_pblocks payload10] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[40]*]]
# add_cells_to_pblock [get_pblocks payload10] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[41]*]]
# add_cells_to_pblock [get_pblocks payload10] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[42]*]]
# add_cells_to_pblock [get_pblocks payload10] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[43]*]]
# add_cells_to_pblock [get_pblocks payload11] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[44]*]]
# add_cells_to_pblock [get_pblocks payload11] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[45]*]]
# add_cells_to_pblock [get_pblocks payload11] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[46]*]]
# add_cells_to_pblock [get_pblocks payload11] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[47]*]]
# add_cells_to_pblock [get_pblocks payload12] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[48]*]]
# add_cells_to_pblock [get_pblocks payload12] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[49]*]]
# add_cells_to_pblock [get_pblocks payload12] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[50]*]]
# add_cells_to_pblock [get_pblocks payload12] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[51]*]]
# add_cells_to_pblock [get_pblocks payload13] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[52]*]]
# add_cells_to_pblock [get_pblocks payload13] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[53]*]]
# add_cells_to_pblock [get_pblocks payload13] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[54]*]]
# add_cells_to_pblock [get_pblocks payload13] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[55]*]]
# add_cells_to_pblock [get_pblocks payload14] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[56]*]]
# add_cells_to_pblock [get_pblocks payload14] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[57]*]]
# add_cells_to_pblock [get_pblocks payload14] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[58]*]]
# add_cells_to_pblock [get_pblocks payload14] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[59]*]]
# add_cells_to_pblock [get_pblocks payload15] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[60]*]]
# add_cells_to_pblock [get_pblocks payload15] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[61]*]]
# add_cells_to_pblock [get_pblocks payload15] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[62]*]]
# add_cells_to_pblock [get_pblocks payload15] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[63]*]]
# add_cells_to_pblock [get_pblocks payload16] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[64]*]]
# add_cells_to_pblock [get_pblocks payload16] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[65]*]]
# add_cells_to_pblock [get_pblocks payload16] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[66]*]]
# add_cells_to_pblock [get_pblocks payload16] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[67]*]]
# add_cells_to_pblock [get_pblocks payload17] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[68]*]]
# add_cells_to_pblock [get_pblocks payload17] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[69]*]]
# add_cells_to_pblock [get_pblocks payload17] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[70]*]]
# add_cells_to_pblock [get_pblocks payload17] [get_cells -quiet [list payload/frame_i/demux_lane_data_l[71]*]]


# output mux (40 -> 240MHz)
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux0_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux1_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux2_i*]]
add_cells_to_pblock [get_pblocks payload4] [get_cells -quiet [list payload/frame_i/output_mux_i/mux3_i*]]
add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/output_mux_i/mux4_i*]]
add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/output_mux_i/mux5_i*]]
add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/output_mux_i/mux6_i*]]
add_cells_to_pblock [get_pblocks payload5] [get_cells -quiet [list payload/frame_i/output_mux_i/mux7_i*]]
add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/output_mux_i/mux8_i*]]
add_cells_to_pblock [get_pblocks payload6] [get_cells -quiet [list payload/frame_i/output_mux_i/mux9_i*]]

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