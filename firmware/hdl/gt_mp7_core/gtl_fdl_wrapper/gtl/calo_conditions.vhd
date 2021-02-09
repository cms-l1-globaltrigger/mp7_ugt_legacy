
-- Description:
-- Condition module for calorimeter object types (eg, jet and tau) conditions.

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now.
-- HB 2020-11-27: added default parameters. Changed order in port.
-- HB 2019-10-21: bug fix input ports.
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-05-03: used instances "calo_cuts" and "calo_cond_matrix" (proposal Dinyar/Hannes) to reduce resources. Inserted instance for twobody_pt.
-- HB 2017-09-05: inserted slice ranges in generic for correct use of object slices.
-- HB 2017-08-28: increased length of vector signals (to 4096).
-- HB 2017-06-13: module for quad condition only.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-20: based on calo_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on calo_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions is
     generic(
        
        slice_1_low_obj1: natural := 0;
        slice_1_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_2_low_obj1: natural := 0;
        slice_2_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_3_low_obj1: natural := 0;
        slice_3_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_4_low_obj1: natural := 0;
        slice_4_high_obj1: natural := NR_EG_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_thresholds_obj1: calo_templates_array := (others => (others => '0'));
        nr_eta_windows_obj1: calo_templates_natural_array := (others => 0);
        eta_w1_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w1_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w2_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w2_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w3_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w3_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w4_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w4_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w5_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        eta_w5_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        nr_phi_windows_obj1: calo_templates_natural_array := (others => 0);
        phi_w1_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        phi_w1_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        phi_w2_upper_limits_obj1: calo_templates_array := (others => (others => '0'));
        phi_w2_lower_limits_obj1: calo_templates_array := (others => (others => '0'));
        iso_luts_obj1: calo_templates_iso_array := (others => (others => '1'));

        twobody_pt_cut: boolean := false;
        pt_width: positive := EG_PT_VECTOR_WIDTH; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := EG_EG_SIN_COS_PRECISION;
        
        type_obj1 : natural := EG_TYPE;
        nr_templates: positive := 4
        
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        pt: in diff_inputs_array(0 to MAX_CALO_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer: in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0);
        sin_phi_integer: in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0);
        condition_o: out std_logic
    );
end calo_conditions;

architecture rtl of calo_conditions is

    constant nr_objects_slice_1_int: natural := slice_1_high_obj1-slice_1_low_obj1+1;
    constant nr_objects_slice_2_int: natural := slice_2_high_obj1-slice_2_low_obj1+1;
    constant nr_objects_slice_3_int: natural := slice_3_high_obj1-slice_3_low_obj1+1;
    constant nr_objects_slice_4_int: natural := slice_4_high_obj1-slice_4_low_obj1+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(slice_1_low_obj1 to slice_1_high_obj1, 1 to 1);
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(slice_2_low_obj1 to slice_2_high_obj1, 1 to 1);
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(slice_3_low_obj1 to slice_3_high_obj1, 1 to 1);
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(slice_4_low_obj1 to slice_4_high_obj1, 1 to 1);
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    signal condition_and_or : std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(slice_1_low_obj1 to slice_1_high_obj1, slice_2_low_obj1 to slice_2_high_obj1) := (others => (others => '1'));

begin

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

-- Instantiation of object cuts.
    obj_cuts_i: entity work.calo_obj_cuts
        generic map(
            slice_1_low_obj1, slice_1_high_obj1,
            slice_2_low_obj1, slice_2_high_obj1,
            slice_3_low_obj1, slice_3_high_obj1,
            slice_4_low_obj1, slice_4_high_obj1,
            nr_templates, pt_ge_mode_obj1, type_obj1,
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
            iso_luts_obj1
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
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            elsif (clk'event and clk = '1') then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.calo_cond_matrix
        generic map(
            slice_1_low_obj1, slice_1_high_obj1,
            slice_2_low_obj1, slice_2_high_obj1,
            slice_3_low_obj1, slice_3_high_obj1,
            slice_4_low_obj1, slice_4_high_obj1,
            nr_templates
        )
        port map(clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            twobody_pt_comp_pipe,
            condition_o
        );

end architecture rtl;
