# Place constraints for the uGT algo block in this file:

## HB 2016-08-09: used pblock payload for payload.vhd
add_cells_to_pblock [get_pblock payload] payload
# add_cells_to_pblock [get_pblock payload] payload
# add_cells_to_pblock [get_pblock payload] [get_cells payload/frame_i]
# add_cells_to_pblock [get_pblock payload] [get_cells payload/gtl_fdl_wrapper_i]
