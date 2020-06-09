# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
  
## [v1.11.0] - 2020-06-09
### Comment

- mp7_ugt firmware release v1.11.0 (implemented new muon structure with "unconstraint pt" and "impact parameter").

### Changed

- source files:
  - ../gtl/muon_comparators.vhd
  - ../gtl/muon_obj_cuts.vhd
  - ../gtl/muon_conditions.vhd
  - ../gtl/muon_conditions_orm.vhd
  - ../gtl/muon_muon_correlation_condition.vhd
  - ../gtl/calo_muon_correlation_condition.vhd
  - ../gtl/muon_esums_correlation_condition.vhd
  - ../gtl/gtl_pkg.vhd
  - ../gtl/gt_mp7_core_pkg.vhd

## [v1.10.7] - 2020-02-03
### Comment

- mp7_ugt firmware release v1.10.7 (bugs fixed - condition output pipeline).

### Added

- source files:
  - ../gtl/esums_comparators.vhd
  - ../gtl/min_bias_hf_conditions.vhd

## [v1.10.6] - 2020-01-28
### Comment

- mp7_ugt firmware release v1.10.6 (bugs fixed).

### Changed

- source files:
  - ../gtl/calo_cond_matrix_orm.vhd
  
## [v1.10.5] - 2020-01-20
### Comment

- mp7_ugt firmware release v1.10.5 (bugs fixed).

### Changed

- source files:
  - ../gtl/calo_calo_calo_correlation_orm_condition.vhd
- script files:
  - ../scripts/run_simulation_questa.py
  - ../scripts/runIpbbSynth.py
  
## [v1.10.4] - 2019-11-14
### Comment

- mp7_ugt firmware release v1.10.4 (bug fixed in script).

### Changed

- script files:
  - ../scripts/runIpbbSynth.py
  - ../scripts/buildReport.py
  - ../scripts/checkIpbbSynth.py
  - ../scripts/fwpackerIpbb.py

## [v1.10.3] - 2019-11-12
### Comment

- mp7_ugt firmware release v1.10.3 is based on v1.10.2, but bug fixed in script.

### Added

- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do

### Changed

- script file:
  - ../scripts/run_compile_simlib.py

## [v1.10.2] - 2019-10-23
### Comment

- mp7_ugt firmware release v1.10.2 is based on v1.10.1, but bug fixed in script.

### Changed

- script file:
  - ../scripts/runIpbbSynth.py

## [v1.10.1] - 2019-10-21
### Comment

- mp7_ugt firmware release v1.10.1 is based on frame v1.2.3, gtl v1.9.1 and fdl v1.3.6.

### Changed

- source files:
  - ../gtl/calo_conditions.vhd

## [v1.10.0] - 2019-10-17
### Comment

- mp7_ugt firmware release v1.10.0 is based on frame v1.2.3, gtl v1.9.0 and fdl v1.3.6.

### Added

- source files:
  - ../gtl/muon_cond_matrix_orm.vhd
  - ../gtl/muon_conditions_orm.vhd

### Changed

- source files:
  - ../gtl/calo_conditions_orm.vhd
  - ../gtl/calo_cond_matrix_orm.vhd

- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2018.2.do
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2018.3.do

- dep file:
  - ../cfg/uGT_algo.dep

## [v1.9.3] - 2019-10-11
### Comment

- mp7_ugt firmware release v1.9.3 is based on frame v1.2.3, gtl v1.8.0 and fdl v1.3.6.
- typo in tag name.

## [mp7_ugt_v1_9_2] - 2019-10-11
### Comment

- mp7_ugt firmware release v1.9.2 is based on frame v1.2.3, gtl v1.8.0 and fdl v1.3.6.
- changed logic for fractional prescaler - using 32 bits including 2 fractional digits for prescale factor.

### Added

- source files:
  - ../fdl/algo_pre_scaler_fractional_float.vhd
  - ../fdl/algo_pre_scaler_fractional_num_denom.vhd
  - ../fdl/fdl_pkg_prescale_float.vhd
  - ../fdl/fdl_pkg_prescale_num_denom.vhd
