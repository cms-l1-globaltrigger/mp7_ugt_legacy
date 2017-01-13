## HB 2016-08-31: no "limit setting"
## HB 2016-08-17: increase limit for better placement performance

# set_param place.sliceLegEffortLimit 4000

# Place constraints for the uGT algo block in this file:

## HB 2016-08-09: used pblock payload for payload.vhd
#add_cells_to_pblock [get_pblock payload] payload

## HB 2016-08-31: ../ucf/algo_constraints.xdc not used anymore (see uGT_algo.dep)

# HB 2016-11-17: set output FFs in IOB for finor_2_mezz_lemo, veto_2_mezz_lemo and finor_preview_2_mezz_lemo
set_property IOB TRUE [get_ports {mezz_p[0]}]
set_property IOB TRUE [get_ports {mezz_p[1]}]
set_property IOB TRUE [get_ports {mezz_p[2]}]