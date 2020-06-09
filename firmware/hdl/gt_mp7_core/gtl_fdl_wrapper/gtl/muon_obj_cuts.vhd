-- Description:
-- Muon object cuts

-- Version history:
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" and "impact parameter".
-- HB 2019-04-30: first version (proposed by Dinyar/Hannes for calos).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity muon_obj_cuts is
     generic(
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        pt_ge_mode : boolean;
        pt_thresholds: muon_templates_array;
        nr_eta_windows : muon_templates_natural_array;
        eta_w1_upper_limits: muon_templates_array;
        eta_w1_lower_limits: muon_templates_array;
        eta_w2_upper_limits: muon_templates_array;
        eta_w2_lower_limits: muon_templates_array;
        eta_w3_upper_limits: muon_templates_array;
        eta_w3_lower_limits: muon_templates_array;
        eta_w4_upper_limits: muon_templates_array;
        eta_w4_lower_limits: muon_templates_array;
        eta_w5_upper_limits: muon_templates_array;
        eta_w5_lower_limits: muon_templates_array;
        phi_full_range : muon_templates_boolean_array;
        phi_w1_upper_limits: muon_templates_array;
        phi_w1_lower_limits: muon_templates_array;
        phi_w2_ignore : muon_templates_boolean_array;
        phi_w2_upper_limits: muon_templates_array;
        phi_w2_lower_limits: muon_templates_array;
        requested_charges: muon_templates_string_array;
        qual_luts: muon_templates_quality_array;
        iso_luts: muon_templates_iso_array;
        ptu_upper_limits : muon_templates_array;
        ptu_lower_limits : muon_templates_array;
        ip_luts : muon_templates_ip_array        

    );
    port(
        data_i : in muon_objects_array;
        obj_slice_1_vs_templ: out object_slice_1_vs_template_array;
        obj_slice_2_vs_templ: out object_slice_2_vs_template_array;
        obj_slice_3_vs_templ: out object_slice_3_vs_template_array;
        obj_slice_4_vs_templ: out object_slice_4_vs_template_array
    );

end muon_obj_cuts;

architecture behavioral of muon_obj_cuts is

    type muon_object_slices_array is array (1 to 4) of natural;
    signal muon_object_slices_low : muon_object_slices_array;
    signal muon_object_slices_high : muon_object_slices_array;    
    
    type obj_slices_vs_templ_array (1 to 4, natural range <>, natural range <>) of std_logic;
    signal obj_slices_vs_templ : obj_slices_vs_templ_array;

begin

    comp_l: for i in 1 to 4 generate
        -- Instance of comparators for muon objects. All permutations between objects and thresholds.
        obj_slice_l: for j in muon_object_slices_low(i) to muon_object_slices_high(i) generate
            comp_i: entity work.muon_comparators
                generic map(pt_ge_mode,
                    pt_thresholds(i)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
                    nr_eta_windows(i),
                    eta_w1_upper_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w1_lower_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w2_upper_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w2_lower_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w3_upper_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w3_lower_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w4_upper_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w4_lower_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w5_upper_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    eta_w5_lower_limits(i)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                    phi_full_range(i),
                    phi_w1_upper_limits(i)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                    phi_w1_lower_limits(i)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                    phi_w2_ignore(i),
                    phi_w2_upper_limits(i)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                    phi_w2_lower_limits(i)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                    requested_charges(i),
                    qual_luts(i),
                    iso_luts(i),
                    ptu_upper_limits(i)(D_S_I_MUON.ptu_high-D_S_I_MUON.ptu_low downto 0),
                    ptu_lower_limits(i)(D_S_I_MUON.ptu_high-D_S_I_MUON.ptu_low downto 0),
                    ip_luts(i)
                )
                port map(data_i(j), obj_slices_vs_templ(i,j,1));
        
            obj_slice_1_vs_templ(j,1) <= obj_slices_vs_templ(1,j,1);
            obj_slice_2_vs_templ(j,1) <= obj_slices_vs_templ(2,j,1);
            obj_slice_3_vs_templ(j,1) <= obj_slices_vs_templ(3,j,1);
            obj_slice_4_vs_templ(j,1) <= obj_slices_vs_templ(4,j,1);
        
        end generate obj_slice_1_l;
    end generate comp_l;
    
end behavioral;
