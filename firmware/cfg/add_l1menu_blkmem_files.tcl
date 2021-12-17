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

# set ROM_INV_DR_SQ_VERSION $env(UGT_ROM_INV_DR_SQ_VERSION)
# set DP_MEM_VERSION $env(UGT_DP_MEM_VERSION)
set BLK_MEM_GEN_VERSION $env(UGT_BLK_MEM_GEN_VERSION)

add_files -norecurse -fileset sources_1 "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_calo_inv_dr_sq_1/rom_lut_calo_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_calo_inv_dr_sq_2/rom_lut_calo_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_calo_inv_dr_sq_3/rom_lut_calo_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_calo_inv_dr_sq_4/rom_lut_calo_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_calo_inv_dr_sq_5/rom_lut_calo_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_1/rom_lut_muon_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_2/rom_lut_muon_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_3/rom_lut_muon_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_4/rom_lut_muon_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_5/rom_lut_muon_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/rom_lut_muon_inv_dr_sq_6/rom_lut_muon_inv_dr_sq_6.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${BLK_MEM_GEN_VERSION}/dp_mem_4096x32/dp_mem_4096x32.xci"

# add_files -norecurse -fileset sources_1 "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_calo_inv_dr_sq_1/rom_lut_calo_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_calo_inv_dr_sq_2/rom_lut_calo_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_calo_inv_dr_sq_3/rom_lut_calo_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_calo_inv_dr_sq_4/rom_lut_calo_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_calo_inv_dr_sq_5/rom_lut_calo_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_1/rom_lut_muon_inv_dr_sq_1.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_2/rom_lut_muon_inv_dr_sq_2.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_3/rom_lut_muon_inv_dr_sq_3.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_4/rom_lut_muon_inv_dr_sq_4.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_5/rom_lut_muon_inv_dr_sq_5.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${ROM_INV_DR_SQ_VERSION}/rom_lut_muon_inv_dr_sq_6/rom_lut_muon_inv_dr_sq_6.xci" "../../src/mp7_ugt_legacy/firmware/ngc/${DP_MEM_VERSION}/dp_mem_4096x32/dp_mem_4096x32.xci"
