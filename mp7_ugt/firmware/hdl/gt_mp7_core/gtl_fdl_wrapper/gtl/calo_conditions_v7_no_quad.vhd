
-- Desription:
-- Condition module for calorimeter object types (eg, jet and tau).
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.

-- Version history:
-- HB 2017-10-04: based on calo_conditions_v6_no_quad - used limit vector for pt_sq_threshold.
-- HB 2017-09-05: inserted slice ranges in generic for correct use of object slices.
-- HB 2017-06-13: module for single, double and triple conditions.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-20: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_v7_no_quad is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
        obj_type : natural := EG_TYPE;
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array;

        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1

    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        condition_o: out std_logic;
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS) := (others => (others => '0'));
        cos_phi_integer : in calo_sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0);
        sin_phi_integer : in calo_sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0)
   );
end calo_conditions_v7_no_quad;

architecture rtl of calo_conditions_v7_no_quad is

-- dummy
    constant calo_object_slice_4_low : natural := 1;
    constant calo_object_slice_4_high : natural := 1;

    constant nr_objects_slice_1_int: natural := calo_object_slice_1_high-calo_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo_object_slice_2_high-calo_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo_object_slice_3_high-calo_object_slice_3_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(calo_object_slice_1_low to calo_object_slice_1_high, 1 to 1);
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(calo_object_slice_2_low to calo_object_slice_2_high, 1 to 1);
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(calo_object_slice_3_low to calo_object_slice_3_high, 1 to 1);
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(calo_object_slice_4_low to calo_object_slice_4_high, 1 to 1) := (others => (others => '1'));
    
    signal condition_and_or : std_logic;
    
    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high) := (others => (others => '1'));

begin

-- HB 2017-05-16: TBPT only for Double condition
    check_tbpt_i: if twobody_pt_cut generate
        assert (nr_templates = 2) report 
            "two-body pt cut only for Double condition - nr_templates = " & integer'image(nr_templates) 
        severity failure;        
    end generate check_tbpt_i;
    
-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
        twobody_pt_i: entity work.twobody_pt
            generic map(
                calo_object_slice_1_low, calo_object_slice_1_high,
                calo_object_slice_2_low, calo_object_slice_2_high,
                nr_templates,
                
                twobody_pt_cut,
                pt_width, 
                pt_sq_threshold_vector,
                sin_cos_width,
                pt_sq_sin_cos_precision
            )
            port map(
                pt, cos_phi_integer, sin_phi_integer, twobody_pt_comp
            );
    end generate twobody_pt_cut_i;

    cuts: entity work.calo_obj_cuts
        generic map(
            calo_object_slice_1_low, calo_object_slice_1_high,
            calo_object_slice_2_low, calo_object_slice_2_high,
            calo_object_slice_3_low, calo_object_slice_3_high,
            calo_object_slice_4_low, calo_object_slice_4_high,
            nr_templates, et_ge_mode, obj_type,
            et_thresholds,
            eta_full_range, eta_w1_upper_limits, eta_w1_lower_limits,
            eta_w2_ignore, eta_w2_upper_limits, eta_w2_lower_limits,
            phi_full_range, phi_w1_upper_limits, phi_w1_lower_limits,
            phi_w2_ignore, phi_w2_upper_limits, phi_w2_lower_limits,
            iso_luts
        )
        port map(
           data_i, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ
        );

-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            else
                if (clk'event and clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    twobody_pt_comp_pipe <= twobody_pt_comp;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

    cond_matrix: entity work.calo_cond_matrix
        generic map(
            calo_object_slice_1_low, calo_object_slice_1_high,
            calo_object_slice_2_low, calo_object_slice_2_high,
            calo_object_slice_3_low, calo_object_slice_3_high,
            1,
            1,
            nr_templates
        )
        port map(clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            twobody_pt_comp_pipe,
            condition_o
        );

end architecture rtl;
