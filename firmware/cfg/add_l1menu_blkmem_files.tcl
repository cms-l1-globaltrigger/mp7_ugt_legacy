#!/usr/bin/tclsh

set mod_id $env(module_id)
# puts $mod_id

set fdl_pkg "../../src/module_${mod_id}/fdl_pkg.vhd"
# puts $gtl_pkg
set algo_mapping_rop "../../src/module_${mod_id}/algo_mapping_rop.vhd"
# puts $algo_mapping_rop
set gtl_module "../../src/module_${mod_id}/gtl_module.vhd"
# puts $gtl_module

add_files -norecurse -fileset sources_1 $fdl_pkg $algo_mapping_rop $gtl_module

## add blk_mem_gen files depending on environment variable

set BLK_MEM_GEN_NAME $env(UGT_BLK_MEM_GEN_NAME)

add_files -norecurse -fileset sources_1 "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_calo_inv_dr_sq_1/rom_lut_calo_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_calo_inv_dr_sq_2/rom_lut_calo_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_calo_inv_dr_sq_3/rom_lut_calo_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_calo_inv_dr_sq_4/rom_lut_calo_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_calo_inv_dr_sq_5/rom_lut_calo_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_1/rom_lut_muon_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_2/rom_lut_muon_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_3/rom_lut_muon_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_4/rom_lut_muon_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_5/rom_lut_muon_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_NAME}/rom_lut_muon_inv_dr_sq_6/rom_lut_muon_inv_dr_sq_6.xci"
