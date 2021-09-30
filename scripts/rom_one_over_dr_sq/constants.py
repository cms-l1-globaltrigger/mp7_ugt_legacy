"""Constants for scripts of 1/DR^2 calculations, LUTs and checks.
"""

# BRAM
bram_size = 18432 # BRAM size of Virtex chip

# calos
calo_objects = 12 # see interface definition (scales_inputs_2_ugt.pdf)

## full bin width for eta
calo_eta_max_value = 5.0 # value from scales
calo_eta_min_value = -5.0 # value from scales
calo_eta_step = 0.0435 # value from scales
calo_eta_bins = int((abs(calo_eta_min_value)+calo_eta_max_value)/calo_eta_step)+1
## full bin width for phi
calo_phi_bins = 144 # see interface definition (scales_inputs_2_ugt.pdf)

calo_precision = 5 # value from scales in menu XML (<object>PRECISION</object> <type>EG-EG-InverseDeltaRMath</type> <n_bits>5</n_bits>) [same value for all calo object types]

## definitions for calo ROMs (containing LUTs for 1/DR^2)
calo_rom_size = 4096
calo_nr_roms = 5
calo_deta_block_size_rom1_4 = 64
calo_dphi_block_size_rom1_4 = 64
calo_deta_block_size_rom5 = 256
calo_dphi_block_size_rom5 = 16

# muon
muon_objects = 8 # see interface definition (scales_inputs_2_ugt.pdf)

## double bin width for eta (depends on resources of BRAMs in Virtex chip)
muon_eta_max_value = 2.45 # value from scales
muon_eta_min_value = -2.45 # value from scales
muon_eta_step_def = 0.010875 # value from scales
muon_eta_factor = 2 # double bin width
muon_eta_step = muon_eta_step_def * muon_eta_factor
muon_eta_bins = int(((abs(muon_eta_min_value)+muon_eta_max_value)/muon_eta_step_def)/muon_eta_factor)+1
## double bin width for phi (depends on resources of BRAMs in Virtex chip)
muon_phi_bins = 576 # see interface definition (scales_inputs_2_ugt.pdf)
muon_phi_factor = 2 # double bin width
muon_phi_bins_reduced = int(muon_phi_bins/muon_phi_factor) # double bin width

muon_precision = 5 # value from scales in menu XML (<object>PRECISION</object> <type>MU-MU-InverseDeltaRMath</type> <n_bits>5</n_bits>)

## definitions for muon ROMs (containing LUTs for 1/DR^2)
muon_rom_size = 8192
muon_nr_roms = 6
muon_deta_block_size = 128
muon_dphi_block_size = 64

