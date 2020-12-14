
-- Desription:
-- Condition module for muon objects.
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.
-- Charge correlation selection implemented with "LS" and "OS" (charge correlation calculated in muon_charge_correlations.vhd)

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now and new order in generic.
-- HB 2020-12-01: changed order in generic.
-- HB 2020-11-27: added default parameters. Changed order in port.
-- HB 2020-08-10: inserted "twobody unconstraint pt".
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" [upt] and "impact parameter" [ip].
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from muon_conditions_v7 to muon_conditions.
-- HB 2017-10-04: based on muon_conditions_v6 - used limit vector for pt_sq_threshold.
-- HB 2017-09-05: based on muon_conditions_v5, but inserted slice ranges in generic for correct use of object slices.
-- HB 2017-06-20: changed order in port for charge correlation signals.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-25: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "muon_object_low" and "muon_object_high" in generic (and replaced NR_MUON_OBJECTS by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions is
    generic (
    
        slice_1_low_obj1: natural := 0;
        slice_1_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_2_low_obj1: natural := 0;
        slice_2_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_3_low_obj1: natural := 0;
        slice_3_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_4_low_obj1: natural := 0;
        slice_4_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_thresholds_obj1: muon_templates_array := (others => (others => '0'));
        nr_eta_windows_obj1: muon_templates_natural_array := (others => 0);
        eta_w1_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w1_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w2_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w2_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w3_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w3_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w4_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w4_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w5_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        eta_w5_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        nr_phi_windows_obj1: muon_templates_natural_array := (others => 0);
        phi_w1_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        phi_w1_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        phi_w2_upper_limits_obj1: muon_templates_array := (others => (others => '0'));
        phi_w2_lower_limits_obj1: muon_templates_array := (others => (others => '0'));
        iso_luts_obj1: muon_templates_iso_array := (others => (others => '1'));
        requested_charges: muon_templates_string_array := (others => "ign");
        qual_luts: muon_templates_quality_array := (others => (others => '1'));
        upt_cuts: muon_templates_boolean_array := (others => false);
        upt_upper_limits: muon_templates_array := (others => (others => '0'));
        upt_lower_limits: muon_templates_array := (others => (others => '0'));
        ip_luts: muon_templates_ip_array := (others => (others => '1'));
        requested_charge_correlation: string(1 to 2) := "ig";

        twobody_pt_cut: boolean := false;
        pt_width: positive := MU_PT_VECTOR_WIDTH; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        twobody_upt_cut: boolean := false;
        upt_width: positive := MU_UPT_VECTOR_WIDTH; 
        upt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;
        
        nr_templates: positive := 4
        
    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        pt : in diff_inputs_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0);
        condition_o : out std_logic
    );
end muon_conditions;

architecture rtl of muon_conditions is

    constant nr_objects_slice_1_int: natural := slice_1_high_obj1-slice_1_low_obj1+1;
    constant nr_objects_slice_2_int: natural := slice_2_high_obj1-slice_2_low_obj1+1;
    constant nr_objects_slice_3_int: natural := slice_3_high_obj1-slice_3_low_obj1+1;
    constant nr_objects_slice_4_int: natural := slice_4_high_obj1-slice_4_low_obj1+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(slice_1_low_obj1 to slice_1_high_obj1, 1 to 1);
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(slice_2_low_obj1 to slice_2_high_obj1, 1 to 1);
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(slice_3_low_obj1 to slice_3_high_obj1, 1 to 1);
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(slice_4_low_obj1 to slice_4_high_obj1, 1 to 1);
    
--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
    signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
    signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal condition_and_or : std_logic;

    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(slice_1_low_obj1 to slice_1_high_obj1, slice_2_low_obj1 to slice_2_high_obj1) := (others => (others => '1'));

    signal twobody_upt_comp, twobody_upt_comp_temp, twobody_upt_comp_pipe : 
        std_logic_2dim_array(slice_1_low_obj1 to slice_1_high_obj1, slice_2_low_obj1 to slice_2_high_obj1) := (others => (others => '1'));

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
                slice_1_low_obj1, slice_1_high_obj1,
                slice_2_low_obj1, slice_2_high_obj1,
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

-- Instantiation of two-body unconstraint pt cut.
    twobody_upt_cut_i: if twobody_upt_cut = true and nr_templates = 2 generate
        twobody_upt_i: entity work.twobody_pt
            generic map(
                slice_1_low_obj1, slice_1_high_obj1,
                slice_2_low_obj1, slice_2_high_obj1,
                nr_templates,                
                twobody_upt_cut,
                upt_width, 
                upt_sq_threshold_vector,
                sin_cos_width,
                pt_sq_sin_cos_precision
            )
            port map(
                pt, cos_phi_integer, sin_phi_integer, twobody_upt_comp
            );
    end generate twobody_upt_cut_i;

-- Instantiation of object cuts.
    obj_cuts_i: entity work.muon_obj_cuts
        generic map(
            slice_1_low_obj1, slice_1_high_obj1,
            slice_2_low_obj1, slice_2_high_obj1,
            slice_3_low_obj1, slice_3_high_obj1,
            slice_4_low_obj1, slice_4_high_obj1,
            nr_templates, pt_ge_mode_obj1,
            pt_thresholds_obj1,
            nr_eta_windows_obj1,
            eta_w1_upper_limits_obj1, eta_w1_lower_limits_obj1,
            eta_w2_upper_limits_obj1, eta_w2_lower_limits_obj1,
            eta_w3_upper_limits_obj1, eta_w3_lower_limits_obj1,
            eta_w4_upper_limits_obj1, eta_w4_lower_limits_obj1,
            eta_w5_upper_limits_obj1, eta_w5_lower_limits_obj1,
            nr_phi_windows_obj1, 
            phi_w1_upper_limits_obj1, phi_w1_lower_limits_obj1,
            phi_w2_upper_limits_obj1, phi_w2_lower_limits_obj1,
            requested_charges_obj1, qual_luts_obj1, iso_luts_obj1,
            upt_cuts_obj1, upt_upper_limits_obj1, upt_lower_limits_obj1,
            ip_luts            
        )
        port map(
            data_i, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ
        );

-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
                twobody_upt_comp_pipe <= twobody_upt_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                    twobody_pt_comp_pipe <= twobody_pt_comp;
                    twobody_upt_comp_pipe <= twobody_upt_comp;
                end if;
            end if;
    end process;

-- Instantiation of charge correlation matrix.
    charge_corr_matrix_i: entity work.muon_charge_corr_matrix
        generic map(
            obj_vs_templ_pipeline_stage,
            slice_1_low_obj1, slice_1_high_obj1,
            slice_2_low_obj1, slice_2_high_obj1,
            slice_3_low_obj1, slice_3_high_obj1,
            slice_4_low_obj1, slice_4_high_obj1,
            nr_templates,
            requested_charge_correlation
        )
        port map(lhc_clk,
            ls_charcorr_double, os_charcorr_double,
            ls_charcorr_triple, os_charcorr_triple,
            ls_charcorr_quad, os_charcorr_quad,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe
        );

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.muon_cond_matrix
        generic map(
            slice_1_low_obj1, slice_1_high_obj1,
            slice_2_low_obj1, slice_2_high_obj1,
            slice_3_low_obj1, slice_3_high_obj1,
            slice_4_low_obj1, slice_4_high_obj1,
            nr_templates
        )
        port map(lhc_clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe, twobody_upt_comp_pipe,
            condition_o
        );

end architecture rtl;
