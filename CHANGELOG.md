# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [v1.11.3] - 2021-04-29
### Comment

- mp7_ugt firmware release v1.11.3
- bug fixed in calo_mass_3_obj_condition.vhd and muon_mass_3_obj_condition.vhd

### Changed
- source files:
  - ../gtl/calo_mass_3_obj_condition.vhd
  - ../gtl/muon_mass_3_obj_condition.vhd
  - ../gtl/gtl_module_tpl.vhd
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd.vhd

## [v1.11.2] - 2020-12-01
### Comment

- mp7_ugt firmware release v1.11.2

### Added
- source files:
  - ../gtl/pipelines.vhd
  - ../gtl/ext_cond_pipeline.vhd
  - ../gtl/centrality_pipeline.vhd

### Changed
- source files:
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd.vhd
  - ../gtl/calo_calo_correlation_condition.vhd
  - ../gtl/calo_muon_correlation_condition.vhd
  - ../gtl/gtl_module_tpl.vhd
  - ../gtl/gtl_pkg_tpl.vhd
  - ../gtl/mass_div_dr_comp.vhd
  - ../gtl/muon_muon_correlation_condition.vhd
  - ../gtl/calo_conditions.vhd
  - ../gtl/calo_conditions_orm.vhd
  - ../gtl/esums_conditions.vhd
  - ../gtl/muon_conditions.vhd
  - ../gtl/calo_mass_3_obj_condition.vhd
  - ../gtl/muon_mass_3_obj_condition.vhd
  - ../gtl/p_m_2_bx_pipeline.vhd
- dep file:
  - ../cfg/uGT_algo.dep
- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do

### Removed
- source files:
  - ../gtl/bs_muon_muon_eg_condition.vhd
  - ../gtl/calo_calo_mass_div_dr_condition.vhd (included in calo_calo_correlation_condition.vhd)
  - ../gtl/calo_collection_builder.vhd
  - ../gtl/calo_muon_muon_b_tagging_condition.vhd
  - ../gtl/muon_muon_mass_div_dr_condition.vhd (included in muon_muon_correlation_condition.vhd)
  - ../frame/crc/*
  - ../frame/dsmux/*
  - ../frame/dyndl/*
  - ../frame/fifo/*
  - ../frame/l1asim/*
  - ../frame/ram/*
  - ../frame/rop/*
  - ../frame/sw_reset/*
  - ../frame/synchronizer/*

## [v1.11.1] - 2020-11-23
### Comment

- mp7_ugt firmware release v1.11.1 (converted scripts to python3 [for IPBB v0.5.2])

### Changed
- script files:
  - ../scripts/buildReport.py
  - ../scripts/calcDeltaRRomCoeAllPartsCalo.py
  - ../scripts/calcDeltaRRomCoeAllPartsMuon.py
  - ../scripts/calcDeltaRRomCoeCalo.py
  - ../scripts/calcDeltaRRomCoeMuon.py
  - ../scripts/checkIpbbSynth.py
  - ../scripts/fwpackerIpbb.py
  - ../scripts/mp7patch.py
  - ../scripts/pkgpatch.py
  - ../scripts/requirements.txt
  - ../scripts/run_compile_simlib.py
  - ../scripts/runIpbbSynth_laptop.py
  - ../scripts/runIpbbSynth.py
  - ../scripts/run_simulation_questa.py
  - ../scripts/toolbox.py
  - ../scripts/xmlmenu.py


## [v1.11.0] - 2020-06-19
### Comment

- mp7_ugt firmware release v1.11.0
- implemented new muon structure with "unconstraint pt" and "impact parameter"
- added files for invariant mass with 3 objects
- added files for invariant mass divided by deltaR

### Added
- source files:
  - ../gtl/sum_mass_calc.vhd
  - ../gtl/muon_mass_3_obj_condition.vhd
  - ../gtl/calo_mass_3_obj_condition.vhd
  - ../gtl/calo_calo_mass_div_dr_condition.vhd
  - ../gtl/muon_muon_mass_div_dr_condition.vhd
  - ../gtl/mass_div_dr_calculator.vhd
  - ../gtl/rom_lut_calo_inv_dr_sq_all.vhd
  - ../gtl/rom_lut_muon_inv_dr_sq_all.vhd
  - ../ngc/rom_lut_calo_inv_dr_sq_1/*.*
  ...
  - ../ngc/rom_lut_calo_inv_dr_sq_9/*.*
  - ../ngc/rom_lut_muon_inv_dr_sq_1/*.*
  ...
  - ../ngc/rom_lut_muon_inv_dr_sq_9/*.*

### Changed
- source files:
  - ../gtl/muon_comparators.vhd
  - ../gtl/muon_obj_cuts.vhd
  - ../gtl/muon_conditions.vhd
  - ../gtl/muon_conditions_orm.vhd
  - ../gtl/muon_muon_correlation_condition.vhd
  - ../gtl/calo_muon_correlation_condition.vhd
  - ../gtl/muon_esums_correlation_condition.vhd
  - ../gtl/gtl_module_tpl.vhd
  - ../gtl/gtl_pkg_sim.vhd
  - ../gtl/gtl_pkg.vhd
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd.vhd
- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2018.2.do
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2018.3.do
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do
- dep file:
  - ../cfg/uGT_algo.dep
- script files:
  - ../scripts/checkIpbbSynth.py

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
