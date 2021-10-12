## Description of python scripts for 1/DR^2 calculations, LUTs and checks

Files are located in ../scripts/rom_one_over_dr_sq

### constants.py

File containing constants used in one_over_dr_sq_calc.py and extract_mif_files.py

### one_over_dr_sq_calc.py

Creates a files with calculation of 1/DR^2 LUT values:
- ../doc/rom_lut_inv_dr_sq/emulator_lut_calo_one_over_dr_sq_calc.txt
- ../doc/rom_lut_inv_dr_sq/emulator_lut_muon_one_over_dr_sq_calc.txt

Creates a files with calculations of ROMs data width and number of needed BRAMs:
- ../doc/rom_lut_inv_dr_sq/data_width_rom_lut_calo_one_over_dr_sq.txt
- ../doc/rom_lut_inv_dr_sq/data_width_rom_lut_muon_one_over_dr_sq.txt

ATTENTION: if one wants to create new coe file, execute "python3 one_over_dr_sq_calc.py --coe"

Creates coe files (as input for IPs of BRAMs, used as ROMs) for LUT of 1/DR^2:
- ../firmware/ngc/lut_calo_inv_dr_sq_rom1.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom2.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom3.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom4.coe
- ../firmware/ngc/lut_calo_inv_dr_sq_rom5.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom1.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom2.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom3.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom4.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom5.coe
- ../firmware/ngc/lut_muon_inv_dr_sq_rom6.coe

Creates a files with 1/DR^2 LUT values for simulation:
- ../firmware/sim/calo_lut_one_over_dr_sq_4_sim.txt
- ../firmware/sim/muon_lut_one_over_dr_sq_4_sim.txt

### extract_mif_files.py

Reads contents of mif files (content of ROMs [after BRAMs generation in Vivado]) and creates a file containing
the LUT values of 1/DR^2:
- ../doc/rom_lut_inv_dr_sq/calo_one_over_dr_sq_lut.txt
- ../doc/rom_lut_inv_dr_sq/muon_one_over_dr_sq_lut.txt

REMARK: order of LUT values is done with increasing delta phi values in "inner loop" and increasing delta eta values in "outer loop"

Additionally a comparison of calculated 1/DR^2 values with LUT values is done, see file below for details:
- ../doc/rom_lut_inv_dr_sq/compare_calo_lut_rom.txt
- ../doc/rom_lut_inv_dr_sq/compare_muon_lut_rom.txt


