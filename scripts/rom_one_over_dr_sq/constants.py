"""Constants for scripts of 1/DR^2.
"""

# BRAM
bram_size = 18432

# calos
calo_objects = 12

calo_eta_bin_width = 0.087/2 # see interface definition (scales_inputs_2_ugt.pdf)
calo_eta_min_bin = -115 # see interface definition (scales_inputs_2_ugt.pdf)
calo_eta_max_bin = 114 # see interface definition (scales_inputs_2_ugt.pdf)
calo_eta_bins = abs(calo_eta_min_bin)+(calo_eta_max_bin+1) # "+1" is for eta bin 0 (0..0.087/2)
calo_phi_bins = 144 # see interface definition (scales_inputs_2_ugt.pdf)

calo_precision = 5 # see scales in menu XML (e.g.: <object>PRECISION</object> <type>EG-EG-InverseDeltaRMath</type> <n_bits>5</n_bits>)
calo_rom_size = 4096
calo_nr_roms = 5

calo_deta_block_size_rom1_4 = 64
calo_dphi_block_size_rom1_4 = 64
calo_deta_block_size_rom5 = 256
calo_dphi_block_size_rom5 = 16

# muon
muon_objects = 8

## double bin width for eta
muon_eta_bin_width_def = 0.087/8 # see interface definition (scales_inputs_2_ugt.pdf)
muon_eta_factor = 2 # double bin width
muon_eta_bin_width = muon_eta_bin_width_def*muon_eta_factor
muon_eta_min_bin = -225 # see interface definition (scales_inputs_2_ugt.pdf)
muon_eta_max_bin = 225 # see interface definition (scales_inputs_2_ugt.pdf)
muon_eta_bins = int((abs(muon_eta_min_bin)+muon_eta_max_bin)/muon_eta_factor)+1
## double bin width for phi
muon_phi_bins = 576 # see interface definition (scales_inputs_2_ugt.pdf)
muon_phi_factor = 2 # double bin width
muon_phi_bins_reduced = int(muon_phi_bins/muon_phi_factor)

muon_precision = 5 # see scales in menu XML (<object>PRECISION</object> <type>MU-MU-InverseDeltaRMath</type> <n_bits>5</n_bits>)
muon_rom_size = 8192
muon_nr_roms = 6

muon_deta_block_size = 128
muon_dphi_block_size = 64

