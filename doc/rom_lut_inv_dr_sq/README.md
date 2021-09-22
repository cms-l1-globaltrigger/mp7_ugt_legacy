## Description of python scripts

### calo_one_over_dr_sq_calc.py

ATTENTION: should be used if one wants to update coe files, only!

Creates a file with calculation of 1/DR^2 LUT values for calo correlations:
- ../doc/rom_lut_inv_dr_sq/emulator_lut_calo_one_over_dr_sq_calc.txt

Creates a file with calculations of ROMs data width and number of needed BRAMs:
- ../doc/rom_lut_inv_dr_sq/data_width_rom_lut_calo_one_over_dr_sq.txt

Creates coe files (as input for IPs of BRAMs, used as ROMs) for LUT of 1/DR^2 for calo correlations:
- ../firmware/ngc/lut_calo_inv_dr_sq_rom1.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom2.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom3.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom4.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom5.coe

### muon_one_over_dr_sq_calc.py

ATTENTION: should be used if one wants to update coe files, only!

Creates a file with calculation of 1/DR^2 LUT values for muon correlations:
- ../doc/rom_lut_inv_dr_sq/emulator_lut_muon_one_over_dr_sq_calc.txt

Creates a file with calculations of ROMs data width and number of needed BRAMs:
- ../doc/rom_lut_inv_dr_sq/data_width_rom_lut_muon_one_over_dr_sq.txt

Creates coe files (as input for IPs of BRAMs, used as ROMs) for LUT of 1/DR^2 for muon correlations:
- ../firmware/ngc/lut_muon_inv_dr_sq_rom1.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom2.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom3.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom4.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom5.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom6.coe

### extract_calo_mif_files.py

Reads contents of mif files (content of ROMs [after BRAMs generation in Vivado]) and creates a file containing
the LUT values of 1/DR^2 for calo correlations:
- ../doc/rom_lut_inv_dr_sq/calo_one_over_dr_sq_lut.txt

REMARK: order of LUT values is done with increasing delta phi values in "inner loop" and increasing delta eta values in "outer loop"

Additionally a comparison of calculated 1/DR^2 values with LUT values is done, see file below for details:
- ../doc/rom_lut_inv_dr_sq/compare_calo_lut_rom.txt

### extract_muon_mif_files.py

Reads contents of mif files (content of ROMs [after BRAMs generation in Vivado]) and creates a file containing
the LUT values of 1/DR^2 for muon correlations:
- ../doc/rom_lut_inv_dr_sq/muon_one_over_dr_sq_lut.txt

REMARK: order of LUT values is done with increasing delta phi values in "inner loop" and increasing delta eta values in "outer loop"

Additionally a comparison of calculated 1/DR^2 values with LUT values is done, see file below for details:
- ../doc/rom_lut_inv_dr_sq/compare_muon_lut_rom.txt

### calo_one_over_dr_sq_calc_4_sim.py

Creates a file with 1/DR^2 LUT values (calo correlations) for simulation:
- ../firmware/sim/calo_lut_one_over_dr_sq_4_sim.txt

### muon_one_over_dr_sq_calc_4_sim.py

Creates a file with 1/DR^2 LUT values (muon correlations) for simulation:
- ../firmware/sim/muon_lut_one_over_dr_sq_4_sim.txt


