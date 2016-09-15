## HB 2016-08-31: no "limit setting"
## HB 2016-08-17: increase limit for better placement performance

# set_param place.sliceLegEffortLimit 4000

# Place constraints for the uGT algo block in this file:

## HB 2016-08-09: used pblock payload for payload.vhd
#add_cells_to_pblock [get_pblock payload] payload

## HB 2016-08-31: ../ucf/algo_constraints.xdc not used anymore (see uGT_algo.dep)