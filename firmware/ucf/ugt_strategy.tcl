
## HB 2019-03-15: ugt specific properties (for strategy and VHDL assert)

## HB 2017-04-06: inserted -assert = 1, which means "Enable VHDL assert statements to be evaluated"
## (see UG901 (v2016.3) October 21, 2016, page 12)
set_property "steps.synth_design.args.assert" 1 [get_runs synth_1]
## HB 2017-04-06: for timimg optimisation
set_property strategy Performance_ExplorePostRoutePhysOpt [get_runs impl_1]
