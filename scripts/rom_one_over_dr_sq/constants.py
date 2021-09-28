"""Constants for scripts of 1/DR^2.
"""

# BRAM
bram_size = 18432

# calos
calo_objects = 12

calo_eta_bin_width = 0.087/2
calo_eta_min_bin = -115
calo_eta_max_bin = 114
calo_phi_bins = 144

calo_precision = 5
calo_rom_size = 4096
calo_nr_roms = 5

calo_deta_block_size_rom1_4 = 64
calo_dphi_block_size_rom1_4 = 64
calo_deta_block_size_rom5 = 256
calo_dphi_block_size_rom5 = 16

# muon
""" double bin width
"""
muon_objects = 8

muon_eta_factor = 2
muon_eta_bin_width = 0.087/8*muon_eta_factor
muon_eta_min_bin = -225
muon_eta_max_bin = 225
""" double bin width
"""
muon_phi_factor = 2
muon_phi_bins = 576
muon_phi_bins_reduced = int(muon_phi_bins/muon_phi_factor)

muon_precision = 5
muon_rom_size = 8192
muon_nr_roms = 6

muon_deta_block_size = 128
muon_dphi_block_size = 64

