-- Description:
-- Calo objects cuts

-- Version history:
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-04-30: first version proposed by Dinyar/Hannes.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity calo_obj_cuts is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        calo_object_slice_4_low: natural;
        calo_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
    	obj_type : natural := EG_TYPE;
        et_thresholds: calo_templates_array;
        nr_eta_windows : calo_templates_natural_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        eta_w3_upper_limits: calo_templates_array;
        eta_w3_lower_limits: calo_templates_array;
        eta_w4_upper_limits: calo_templates_array;
        eta_w4_lower_limits: calo_templates_array;
        eta_w5_upper_limits: calo_templates_array;
        eta_w5_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array

    );
    port(
        data_i: in calo_objects_array;
        obj_slice_1_vs_templ: out object_slice_1_vs_template_array;
        obj_slice_2_vs_templ: out object_slice_2_vs_template_array;
        obj_slice_3_vs_templ: out object_slice_3_vs_template_array;
        obj_slice_4_vs_templ: out object_slice_4_vs_template_array
    );

end calo_obj_cuts;

architecture Behavioral of calo_obj_cuts is

begin

-- Instance of comparators for calorimeter objects. All permutations between objects and thresholds/luts.
    obj_slice_1_l: for i in calo_object_slice_1_low to calo_object_slice_1_high generate
        comp_i: entity work.calo_comparators
            generic map(et_ge_mode, obj_type,
                et_thresholds(1),
                nr_eta_windows(1),
                eta_w1_upper_limits(1),
                eta_w1_lower_limits(1),
                eta_w2_upper_limits(1),
                eta_w2_lower_limits(1),
                eta_w3_upper_limits(1),
                eta_w3_lower_limits(1),
                eta_w4_upper_limits(1),
                eta_w4_lower_limits(1),
                eta_w5_upper_limits(1),
                eta_w5_lower_limits(1),
                phi_full_range(1),
                phi_w1_upper_limits(1),
                phi_w1_lower_limits(1),
                phi_w2_ignore(1),
                phi_w2_upper_limits(1),
                phi_w2_lower_limits(1),
                iso_luts(1)
                )
            port map(data_i(i), obj_slice_1_vs_templ(i,1));
    end generate obj_slice_1_l;

    obj_slice_2_l: for i in calo_object_slice_2_low to calo_object_slice_2_high generate
        comp_i: entity work.calo_comparators
            generic map(et_ge_mode, obj_type,
                et_thresholds(2),
                nr_eta_windows(2),
                eta_w1_upper_limits(2),
                eta_w1_lower_limits(2),
                eta_w2_upper_limits(2),
                eta_w2_lower_limits(2),
                eta_w3_upper_limits(2),
                eta_w3_lower_limits(2),
                eta_w4_upper_limits(2),
                eta_w4_lower_limits(2),
                eta_w5_upper_limits(2),
                eta_w5_lower_limits(2),
                phi_full_range(2),
                phi_w1_upper_limits(2),
                phi_w1_lower_limits(2),
                phi_w2_ignore(2),
                phi_w2_upper_limits(2),
                phi_w2_lower_limits(2),
                iso_luts(2)
                )
            port map(data_i(i), obj_slice_2_vs_templ(i,1));
    end generate obj_slice_2_l;

    obj_slice_3_l: for i in calo_object_slice_3_low to calo_object_slice_3_high generate
        comp_i: entity work.calo_comparators
            generic map(et_ge_mode, obj_type,
                et_thresholds(3),
                nr_eta_windows(3),
                eta_w1_upper_limits(3),
                eta_w1_lower_limits(3),
                eta_w2_upper_limits(3),
                eta_w2_lower_limits(3),
                eta_w3_upper_limits(3),
                eta_w3_lower_limits(3),
                eta_w4_upper_limits(3),
                eta_w4_lower_limits(3),
                eta_w5_upper_limits(3),
                eta_w5_lower_limits(3),
                phi_full_range(3),
                phi_w1_upper_limits(3),
                phi_w1_lower_limits(3),
                phi_w2_ignore(3),
                phi_w2_upper_limits(3),
                phi_w2_lower_limits(3),
                iso_luts(3)
                )
            port map(data_i(i), obj_slice_3_vs_templ(i,1));
    end generate obj_slice_3_l;

    obj_slice_4_l: for i in calo_object_slice_4_low to calo_object_slice_4_high generate
        comp_i: entity work.calo_comparators
            generic map(et_ge_mode, obj_type,
                et_thresholds(4),
                nr_eta_windows(4),
                eta_w1_upper_limits(4),
                eta_w1_lower_limits(4),
                eta_w2_upper_limits(4),
                eta_w2_lower_limits(4),
                eta_w3_upper_limits(4),
                eta_w3_lower_limits(4),
                eta_w4_upper_limits(4),
                eta_w4_lower_limits(4),
                eta_w5_upper_limits(4),
                eta_w5_lower_limits(4),
                phi_full_range(4),
                phi_w1_upper_limits(4),
                phi_w1_lower_limits(4),
                phi_w2_ignore(4),
                phi_w2_upper_limits(4),
                phi_w2_lower_limits(4),
                iso_luts(4)
                )
            port map(data_i(i), obj_slice_4_vs_templ(i,1));
    end generate obj_slice_4_l;

end Behavioral;
