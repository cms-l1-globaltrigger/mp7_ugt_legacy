onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /correlation_conditions_muon_tb/lhc_clk
add wave -noupdate /correlation_conditions_muon_tb/mu_bx_0
add wave -noupdate /correlation_conditions_muon_tb/mu_bx_0_int
add wave -noupdate /correlation_conditions_muon_tb/condition_o
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_cut
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_type
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_upper_limit_vector
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_lower_limit_vector
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/obj1
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/obj2
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/pt1
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/pt2
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/upt1
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/upt2
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/cosh_deta
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/cos_dphi
add wave -noupdate -expand /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/obj1_vs_templ_pipe
add wave -noupdate -expand /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/obj2_vs_templ_pipe
add wave -noupdate -expand -subitemconfig {/correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_comp_pipe(0) -expand} /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/mass_comp_pipe
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/invariant_mass
add wave -noupdate /correlation_conditions_muon_tb/invariant_mass_upt_i0_i/condition_and_or
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94646 ps} 0} {{Cursor 2} {319226 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 504
configure wave -valuecolwidth 126
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {81259 ps} {573959 ps}
