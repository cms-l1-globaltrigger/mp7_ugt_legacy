# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [v1.22.4] - 2023-04-27
### Comment

- mp7_ugt firmware release v1.22.4
- development for topological trigger (topo_trigger)

### Added
- source files:
  - ../payload/gtl/topo_trigger/topo_wrapper.vhd

### Changed
- source files:
  - ../packages/gt_core_pkg.vhd
  - ../payload/gtl_module_tpl.vhd

## [v1.22.3] - 2023-04-15
### Comment

- mp7_ugt firmware release v1.22.3
- bug fixed for muon index

### Added
- source files:
  - ../payload/gtl/common/muon_index_comp.vhd
  - ../payload/gtl/common/muon_index_windows_comp.vhd

### Changed
- source files:
  - ../payload/gtl/common/muon_comparators.vhd
  - ../packages/gt_mp7_core_pkg.vhd
- simulation file:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa.do
- dep file:
  - ../cfg/uGT_algo.dep

## [v1.22.2] - 2023-04-09
### Comment

- mp7_ugt firmware release v1.22.2
- bug fixed in scripts/mp7_patch.py

### Changed
- script files:
  - scripts/mp7_patch.py

## [v1.22.1] - 2023-04-07
### Comment

- mp7_ugt firmware release v1.22.1
- based on v1.22.0, but without links 32..71

## [v1.22.0] - 2023-03-24
### Comment

- mp7_ugt firmware release v1.22.0
- development for "MUS2" (email: "New 2Loose HMT configuration", 3.12.2022)
- implemented cut for muon index bits
- implemented "anomaly detection trigger (ADT)"
- changes for 10G ZDC on link 11
- all 72 links
- scouting outputs on links 28-31

### Changed
- source files:
  - ../payload/frame/output_mux.vhd
  - ../packages/gt_mp7_core_pkg.vhd
  - ../packages/top_decl.vhd
  - ../packages/gtl_pkg.vhd
  - ../packages/gt_core_pkg.vhd
  - ../payload/gtl/bx_pipeline.vhd
  - ../payload/gtl_module_tpl.vhd
  - ../payload/gtl/muon_comparators.vhd
  - ../payload/gtl/muon_obj_cuts.vhd
  - ../payload/gtl/comb_conditions.vhd
  - ../payload/gtl/correlation_conditions.vhd
  - ../payload/gtl/zdc_condition.vhd
- script files:
  - scripts/mp7_patch.py

## [v1.21.7] - 2022-11-29
### Comment

- mp7_ugt firmware release v1.21.7
- bug fix in algo_pre_scaler_fractional_float.vhd (reset counter with factor=0)

### Changed
- source files:
  - ../payload/fdl/algo_pre_scaler_fractional_float.vhd
- simulation file:
  - ../sim/scripts/algo_pre_scaler_fractional_float.do
  - ../sim/scripts/algo_pre_scaler_fractional_float_wave.do
  - ../sim/testbench/algo_pre_scaler_fractional_float_tb.vhd

## [v1.21.6] - 2022-11-23
### Comment

- mp7_ugt firmware release v1.21.6
- updated doc/scales_inputs_2_ugt (added definition of muon shower bits)

### Changed
- tex file:
  - doc/scales_inputs_2_ugt/src/latex/scales_inputs_2_ugt.tex

## [v1.21.5] - 2022-11-16
### Comment

- mp7_ugt firmware release v1.21.5
- bug fix in correlation_conditions.vhd

### Changed
- source files:
  - ../payload/gtl/correlation_conditions.vhd
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.21.4] - 2022-10-04
### Comment

- mp7_ugt firmware release v1.21.4
- updated top_decl.vhd: used "demux" in formatter for algo outputs to enable "orbit header" for scouting (therefore MP7 FW v3.2.2 or newer needed)

### Changed
- source files:
  - ../packages/top_decl.vhd
  - ../packages/gt_mp7_core_pkg.vhd
- script files:
  - scripts/run_synth_ipbb.py
  - scripts/run_simulation_questa.py

## [v1.21.3] - 2022-09-29
### Comment

- mp7_ugt firmware release v1.21.3
- updated scripts for MP7 patch in run_synth_ipbb.py and run_simulation_questa.py

### Changed
- script files:
  - scripts/mp7patch.py
  - scripts/run_synth_ipbb.py
  - scripts/run_simulation_questa.py
- simulation file:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa.do
- source files:
  - ../packages/gt_mp7_core_pkg.vhd



## [v1.21.2] - 2022-09-28
### Comment

- mp7_ugt firmware release v1.21.2
- cleaned up VHDL code

### Changed
- multiple VHDL files

## [v1.21.1] - 2022-09-26
### Comment

- mp7_ugt firmware release v1.21.1
- added script run_latex_w_versions.py (extract versions from gt_mp7_core_pkg.vhd, creates versions.tex and run latex ['make'])

### Added
- script files:
  - scripts/run_latex_w_versions.py

### Changed
- source files:
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.21.0] - 2022-09-14
### Comment

- mp7_ugt firmware release v1.21.0
- changed reset for prescale counter from "begin of lumi" to "start"

### Changed
- source files:
  - ../mp7_payload.vhd
  - ../payload/fdl_module.vhd
  - ../payload/fdl/algo_slice.vhd
  - ../payload/fdl/algo_pre_scaler_fractional_float.vhd
  - ../payload/fdl/algo_post_dead_time_counter.vhd
  - ../payload/fdl/algo_rate_counter.vhd
  - ../packages/gt_mp7_core_pkg.vhd
- simulation files:
  - ../sim/testbench/algo_pre_scaler_fractional_float_tb.vhd
  - ../sim/scripts/algo_pre_scaler_fractional_float.do
  - ../sim/scripts/algo_pre_scaler_fractional_float_wave.do
- README.md

## [v1.20.2] - 2022-09-14
### Comment

- mp7_ugt firmware release v1.20.2
- updated script run_simulation_questa.py (removed UGT_GITLAB_PWD) and documentation

### Changed
- source files:
  - scripts/run_simulation_questa.py
- latex files:
  - doc/mp7_ugt_firmware_specification/src/latex/content/gtl.tex
  - doc/mp7_ugt_firmware_specification/src/latex/content/fdl.tex
  - doc/mp7_ugt_firmware_specification/src/latex/content/revision_history_fw.tex
  - doc/mp7_ugt_firmware_specification/src/latex/content/glossary.tex
  - doc/mp7_ugt_firmware_specification/src/latex/content/versions.tex

## [v1.20.1] - 2022-04-28
### Comment

- mp7_ugt firmware release v1.20.1
- updated scripts run_simulation_questa.py and run_synth_ipbb.py
- removed script run_synth_workflow.py
- added function (year_str_t) in toolbox.py
- added setup_env_sim_synth_tpl.sh

### Added
- shell script file:
  - setup_env_sim_synth_tpl.sh

### Changed
- script files:
  - scripts/run_simulation_questa.py
  - scripts/run_synth_ipbb.py
  - scripts/toolbox.py

## [v1.20.0] - 2022-03-25
### Comment

- mp7_ugt firmware release v1.20.0
- updated and cleaned up framework
- inserted constants for frame version in gt_mp7_core_pkg.vhd

### Changed
- source files:
  - ../mp7_payload.vhd
  - ../payload/frame.vhd
  - ../payload/frame/tcm.vhd
  - ../payload/frame/output_mux.vhd
  - ../payload/frame/spytrig.vhd
  - ../packages/gt_mp7_core_pkg.vhd
  - ../packages/gt_mp7_core_pkg_sim.vhd
  - ../packages/fdl_pkg_tpl.vhd
  - ../packages/frame_addr_decode.vhd
  - ../payload/frame/frame_module_info.vhd
  - ../payload/fdl_module.vhd

## [v1.19.3] - 2022-02-16
### Comment

- mp7_ugt firmware release v1.19.3
- bug fixed in comb_conditions.vhd

### Changed
- source files:
  - ../payload/gtl/comb_conditions.vhd
  - ../packages/gt_mp7_core_pkg.vhd
- script files:
  - scripts/run_simulation_questa.py

## [v1.19.2] - 2022-02-10
### Comment

- mp7_ugt firmware release v1.19.2
- added script file for creating documents with current version numbers in text

### Added
- script files:
  - doc/mp7_ugt_firmware_specification/src/latex/replace_versions_and_make.py
  - doc/gtl_4_emulator/src/latex/replace_versions_and_make.py
- tex files:
  - doc/../src/latex/content/fdl_tmpl.tex
  - doc/../src/latex/content/gtl_tmpl.tex
  - doc/../src/latex/content/firmware_tmpl.tex
  - doc/../src/latex/content/framework_tmpl.tex

### Changed
- source files:
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.19.1] - 2022-01-28
### Comment

- mp7_ugt firmware release v1.19.1
- cleaned up and updated scripts

### Changed
- script files:
  - scripts/run_simulation_questa.py
  - scripts/run_synth_ipbb.py
  - scripts/run_synth_workflow.py
- source files:
  - ../packages/gt_mp7_core_pkg.vhd
- readme.md

## [v1.19.0] - 2022-01-10
### Comment

- mp7_ugt firmware release v1.19.0
- renamed scripts (no camel case) and updated for different version of Questsim and Vivado

### Changed
- script files:
  - scripts/run_simulation_questa.py
  - scripts/build_report.py
  - scripts/check_synth_ipbb.py
  - scripts/fwpacker_ipbb.py
  - scripts/run_synth_ipbb.py
  - scripts/run_synth_workflow.py
- source files:
  - ../packages/gt_mp7_core_pkg.vhd
- readme.md

## [v1.18.0] - 2021-12-18
### Comment

- mp7_ugt firmware release v1.18.0
- updated scripts for different version of Questsim and Vivado

### Changed
- script files:
  - scripts/run_simulation_questa.py
  - scripts/run_simulation_questa_local.py
  - scripts/runIpbbSynth.py
- source files:
  - ../packages/gt_mp7_core_pkg.vhd
- readme.md

## [v1.17.3] - 2021-12-17
### Comment

- mp7_ugt firmware release v1.17.3
- reorganized ../firmware/ngc

### Changed
- tcl file:
  - ../cfg/add_l1menu_blkmem_files.tcl
- simulation file:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa.do

## [v1.17.2] - 2021-12-16
### Comment

- mp7_ugt firmware release v1.17.2
- cleaned up ../firmware/ngc

## [v1.17.1] - 2021-12-09
### Comment

- mp7_ugt firmware release v1.17.1
- updated logic for jet DISP cut

### Changed
- source files:
  - ../payload/gtl/common/calo_comparators.vhd
  - ../payload/gtl/common/calo_obj_cuts.vhd
  - ../payload/gtl/common/comb_conditions.vhd
  - ../payload/gtl/common/correlation_conditions.vhd
  - ../payload/gtl_module_tpl.vhd
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.17.0] - 2021-11-30
### Comment

- mp7_ugt firmware release v1.17.0
- implemented logic for jet DISP (displaced) cut [DISP = bit 27 of jet data]
- bug fixed in correlation_cuts_wrapper.vhd.
- updated code for MU-MU mass over dr - "half resolution" for eta and phi.
- added sim files for "mass_over_dr_muon_tv".
- added script compare_lut_values_emu_fw.py for comparison of emulator and firmware LUT values of 1/deltaR^2.
- added python script for selection of Latex documents (both documents gt-mp7-firmware-specification and gtl_4_emulator created in directory mp7_ugt_firmware_specification - directory gtl_4_emulator will be obsolete).

### Changed
- source files:
  - ../payload/gtl/common/correlation_cuts_wrapper.vhd
  - ../payload/gtl/common/calo_comparators.vhd
  - ../payload/gtl/common/calo_obj_cuts.vhd
  - ../payload/gtl/common/comb_conditions.vhd
  - ../payload/gtl/common/correlation_conditions.vhd
  - ../payload/gtl_module_tpl.vhd
  - ../packages/gt_mp7_core_pkg.vhd
  - ../packages/gtl_pkg.vhd
  - ../packages/correlation_cuts_calculation.vhd
  - ../packages/deta_dphi_calculations.vhd
  - ../packages/obj_parameter.vhd

### Added
- source file:
  - ../payload/gtl/common/pt_disp_comp.vhd
- script files:
  - scripts/rom_one_over_dr_sq/compare_lut_values_emu_fw.py
- simulation files:
  - ../sim/testbench/mass_over_dr_muon_tv_tb.vhd
  - ../sim/scripts/mass_over_dr_muon_tv.do
  - ../sim/scripts/mass_over_dr_muon_tv_wave.do
- script files:
  - ../doc/mp7_ugt_firmware_specification/src/latex/run_make.py

## [v1.16.3] - 2021-11-16
### Comment

- mp7_ugt firmware release v1.16.3
- added utils to doc directory (used for Latex)

### Added
- ../doc/utils

## [v1.16.2] - 2021-10-27
### Comment

- mp7_ugt firmware release v1.16.2
- bug fixed in matrix_corr_cond.vhd

### Changed
- source files:
  - ../payload/gtl/common/matrix_corr_cond.vhd
  - ../payload/gtl_module_tpl.vhd
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.16.1] - 2021-10-18
### Comment

- mp7_ugt firmware release v1.16.1
- bug fixed in calo_comparators.vhd

### Changed
- source files:
  - ../payload/gtl/common/calo_comparators.vhd
  - ../payload/gtl_module_tpl.vhd
  - ../packages/gt_mp7_core_pkg.vhd

## [v1.16.0] - 2021-09-30
### Comment

- mp7_ugt firmware release v1.16.0
- renewed logic and LUTs (ROMs) of 1/DR^2 (for mass over dr)

### Changed
- source files:
  - coe files
  - regenerated IPs for rom_lut_calo_inv_dr_sq_1, ...
  - regenerated IPs for rom_lut_muon_inv_dr_sq_1, ...
  - ../payload/gtl/correlation_cuts_calculation.vhd
  - ../payload/gtl/common/mass_over_dr_calc.vhd
  - ../payload/gtl/common/rom_lut_calo_inv_dr_sq_all.vhd
  - ../payload/gtl/common/rom_lut_muon_inv_dr_sq_all.vhd
  - ../packages/gt_mp7_core_pkg.vhd
  - ../packages/gtl_pkg.vhd

### Added
- script files:
  - ../doc/../one_over_dr_sq_calc.py
  - ../doc/../extract_mif_files.py
  - ../doc/../constants.py
- simulation file:
  - ../sim/scripts/mass_div_dr_calo.do
  - ../sim/scripts/mass_div_dr_calo_wave.do
  - ../sim/scripts/mass_div_dr_muon_result.do
  - ../sim/scripts/mass_div_dr_muon_result_wave.do
  - ../sim/scripts/mass_div_dr_muon.do
  - ../sim/scripts/mass_div_dr_muon_wave.do
  - ../sim/scripts/one_over_dr_sq_calo.do
  - ../sim/scripts/one_over_dr_sq_calo_wave.do
  - ../sim/scripts/one_over_dr_sq_muon.do
  - ../sim/scripts/one_over_dr_sq_muon_wave.do
  - ../sim/scripts/rom_lut_calo_inv_dr_sq_all.do
  - ../sim/scripts/rom_lut_calo_inv_dr_sq_all_wave.do
  - ../sim/scripts/rom_lut_muon_inv_dr_sq_all.do
  - ../sim/scripts/rom_lut_muon_inv_dr_sq_all_wave.do
  - ../sim/testbench/mass_div_dr_calo_tb.vhd
  - ../sim/testbench/one_over_dr_sq_calo_tb.vhd
  - ../sim/testbench/one_over_dr_sq_muon_tb.vhd
  - ../sim/testbench/mass_div_dr_muon_tb.vhd
  - ../sim/testbench/mass_div_dr_muon_result_tb.vhd
  - ../sim/testbench/rom_lut_calo_inv_dr_sq_all_tb.vhd
  - ../sim/testbench/rom_lut_muon_inv_dr_sq_all_tb.vhd

### Removed
- source files:
  - obsolete coe files
  - IPs for rom_lut_calo_inv_dr_sq_6 to rom_lut_calo_inv_dr_sq_9
- simulation file:
  - obsolete simulation files

## [v1.15.4] - 2021-07-06
### Comment

- mp7_ugt firmware release v1.15.4
- selection for scouting
- selection for logic without spymem (to get enough BRAM resources for 12 objects)

### Changed
- source files:
  - ../payload/frame.vhd
  - ../packages/gtl_pkg.vhd
  - ../packages/gt_mp7_core_pkg.vhd
  - ../payload/frame/output_mux.vhd

## [v1.15.3] - 2021-06-29
### Comment

- mp7_ugt firmware release v1.15.3
- added script of syntheses workflow

### Changed
- script files:
  - scripts/run_simulation_questa.py

### Added
- script files:
  - scripts/runSynthWorkFlow.py

## [v1.15.2] - 2021-06-18
### Comment

- mp7_ugt firmware release v1.15.2
- added tcl script for "manualy" bit file generation (after timing errors)

### Changed
- source files:
  - ../packages/gt_mp7_core_pkg.vhd

### Added
- script files:
  - scripts/vivado_write_bitstream.tcl

## [v1.15.1] - 2021-06-14
### Comment

- mp7_ugt firmware release v1.15.1
- added logic for hadronic shower triggers (muon)

### Changed
- source files:
  - ../payload/gtl/bx_pipeline.vhd
  - ../packages/gtl_pkg.vhd
  - ../packages/gt_mp7_core_pkg.vhd
- script files:
  - scripts/buildReport.py

## [v1.15.0] - 2021-06-09
### Comment

- mp7_ugt firmware release v1.15.0
- created fdl_pkg_tpl.vhd for "ugt_constants" replacement
- changed file name gtl_pkg_tpl.vhd to gtl_pkg.vhd (package without replacement)
- changed python scripts for fdl_pkg_tpl.vhd
- extracted luts from gtl_pkg.vhd to gtl_luts_pkg.vhd
- removed D_S_I types
- added files for bx arrays
- changed structure and renamed directories
- moved all package files to new directory "packages"
- removed obsolete files
- moved code from gtl_fdl_wrapper.vhd to mp7_payload.vhd (deleted gtl_fdl_wrapper.vhd)

### Added
- source files:
  - ../fdl/fdl_pkg_tpl.vhd
  - ../gtl/gtl_pkg.vhd
  - ../gtl/gtl_luts_pkg.vhd
  - ../gtl/bx_pipeline.vhd
  - ../gtl/common/delay_pipeline.vhd

### Changed
- mp7_payload.vhd
- source files for inserting "fdl_pkg use clause" and removing D_S_I types
- script files:
  - scripts/run_simulation_questa.py
  - scripts/runIpbbSynth.py
- dep file:
  - ../cfg/uGT_algo.dep
- simulation file:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do

## [v1.14.1] - 2021-05-05
### Comment

- mp7_ugt firmware release v1.14.1
- bug fix in mass 3 body comparison

### Changed
- source files:
  - ../gtl/common/sum_mass.vhd

## [v1.14.0] - 2021-04-27
### Comment

- mp7_ugt firmware release v1.14.0
- removed obsolete modules
- added modules for correlation cuts calculations outside of conditions
- renamed files (differences.vhd => deta_dphi_calculations.vhd, ...)
- added new modules for and-or matrix
- cleaned up

### Added
- source files:
  - ../gtl/correlation_cuts_calculation.vhd
  - ../gtl/common/matrix_calo_cond.vhd
  - ../gtl/common/matrix_calo_cond_orm.vhd
  - ../gtl/common/matrix_muon_cond.vhd
  - ../gtl/common/matrix_muon_charge_corr.vhd

## [v1.13.0] - 2021-04-06
### Comment

- mp7_ugt firmware release v1.13.0
- changed directory structure in gtl (created sub dir "common")
- added new modules for calculations
- added new modules for object cuts comparators (for better modularity of resources)
- added new modules for and-or matrix in correlation conditions

### Added
- source files:
  - ../gtl/conv_eta_phi.vhd
  - ../gtl/obj_parameter.vhd
  - ../gtl/cosh_deta_cos_dphi.vhd
  - ../gtl/differences.vhd
  - ../gtl/common/pt_comp.vhd
  - ../gtl/common/upt_comp.vhd
  - ../gtl/common/charge_comp.vhd
  - ../gtl/common/lut_comp.vhd
  - ../gtl/common/matrix_corr_cond.vhd
  - ../gtl/common/mass_div_dr_calc.vhd

### Changed
- source files:
  - ../gtl/common/calo_comparators.vhd
  - ../gtl/common/muon_comparators.vhd
- dep file:
  - ../cfg/uGT_algo.dep
- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do

### Removed
- source file:
  - ../gtl/mass_div_dr_calculator.vhd

## [v1.12.1] - 2021-03-31
### Comment

- mp7_ugt firmware release v1.12.1

### Changed
- source files:
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd
  - ../gtl/correlation_conditions_muon.vhd

## [v1.12.0] - 2021-02-05
### Comment

- mp7_ugt firmware release v1.12.0
- implemented new phi comp (similar to eta comp)
- unified generic and port structures
- implemented comb_conditions.vhd, correlation_conditions_calo.vhd and correlation_conditions_muon

### Added
- source files:
  - ../gtl/comb_conditions.vhd
  - ../gtl/correlation_conditions_calo.vhd
  - ../gtl/correlation_conditions_muon.vhd

### Changed
- source files:
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd
  - ../gtl/gtl_module_tpl.vhd
  - ../gtl/gtl_pkg_tpl.vhd
  - ../gtl/calo_conditions.vhd
  - ../gtl/calo_conditions_orm.vhd
  - ../gtl/muon_conditions.vhd
  - ../gtl/esums_conditions.vhd
  - ../gtl/calo_calo_correlation_condition_orm.vhd (new name)
  - ../gtl/calo_calo_correlation_condition.vhd
  - ../gtl/calo_esums_correlation_condition.vhd
  - ../gtl/calo_mass_3_obj_condition.vhd
  - ../gtl/muon_esums_correlation_condition.vhd
  - ../gtl/muon_mass_3_obj_condition.vhd
  - ../gtl/calo_muon_correlation_condition.vhd
  - ../gtl/muon_muon_correlation_condition.vhd
  - ../gtl/calo_obj_cuts.vhd
  - ../gtl/cuts_instances.vhd
  - ../gtl/mass_calculator.vhd
  - ../gtl/muon_charge_corr_matrix.vhd
  - ../gtl/muon_obj_cuts.vhd
  - ../gtl/muon_obj_cuts.vhd
- dep file:
  - ../cfg/uGT_algo.dep
- simulation files:
  - ../sim/scripts/templates/gtl_fdl_wrapper_tpl_questa_v2019.2.do

## [v1.11.4] - 2021-05-20
### Comment

    mp7_ugt firmware release v1.11.4
    added additional constants to gtl_pkg_tpl.vhd

### Changed

    source files:
        ../gtl/gtl_pkg_tpl.vhd
        ../gtl/gtl_module_tpl.vhd
        ../gt_mp7_core/gt_mp7_core_pkg.vhd.vhd


## [v1.11.3] - 2021-04-29
### Comment

    mp7_ugt firmware release v1.11.3
    bug fixed in calo_mass_3_obj_condition.vhd and muon_mass_3_obj_condition.vhd

### Changed

    source files:
        ../gtl/calo_mass_3_obj_condition.vhd
        ../gtl/muon_mass_3_obj_condition.vhd
        ../gtl/gtl_module_tpl.vhd
        ../gt_mp7_core/gt_mp7_core_pkg.vhd.vhd

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
  - ../gt_mp7_core/gt_mp7_core_pkg.vhd
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
