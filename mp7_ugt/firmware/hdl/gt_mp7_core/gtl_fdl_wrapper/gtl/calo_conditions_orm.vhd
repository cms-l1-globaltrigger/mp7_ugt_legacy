
-- Description:
-- Condition module for calorimeter object types (eg, jet and tau) conditions with "overlap removal (orm)".

-- Version history:
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-03: used instances "calo_cuts" and "calo_cond_matrix_orm" to reduce resources. Inserted instance for twobody_pt.
-- HB 2017-10-04: added limit vectors for correlation cuts.
-- HB 2017-09-07: splitted vector in "matrix_quad_p" 3x 4096.
-- HB 2017-09-06: based on calo_conditions_orm_v2, but only for quad condition.
-- HB 2017-09-05: based on calo_conditions_orm, but updated for correct use of object slices.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-10: improved orm-and-structure of "obj_vs_templ_vec".
-- HB 2017-05-10: inserted "twobody_pt" cut for double condition.
-- HB 2017-04-24: inserted "calo2_obj_vs_templ" in and-structure.
-- HB 2017-04-21: wrong typo fixed.
-- HB 2017-04-20: removed "orm mask" (roll back to version from 2017-04-05).
-- HB 2017-04-10: inserted "orm mask" for use in "and structure" of "obj_vs_templ_vec".
-- HB 2017-04-06: max. 6 objects for nr_templates = 3 and nr_templates = 4 are allowed, because of length of "obj_vs_templ_vec".
-- HB 2017-04-05: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_orm is
     generic(
        deta_orm_cut: boolean := false;
        dphi_orm_cut: boolean := false;
        dr_orm_cut: boolean := true;

        calo1_object_slice_1_low: natural;
        calo1_object_slice_1_high: natural;
        calo1_object_slice_2_low: natural;
        calo1_object_slice_2_high: natural;
        calo1_object_slice_3_low: natural;
        calo1_object_slice_3_high: natural;
        calo1_object_slice_4_low: natural;
        calo1_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode_calo1: boolean;
        obj_type_calo1 : natural := EG_TYPE; -- eg=0, jet=1, tau=2
        et_thresholds_calo1: calo_templates_array;
        nr_eta_windows_calo1 : calo_templates_natural_array;
        eta_w1_upper_limits_calo1: calo_templates_array;
        eta_w1_lower_limits_calo1: calo_templates_array;
        eta_w2_upper_limits_calo1: calo_templates_array;
        eta_w2_lower_limits_calo1: calo_templates_array;
        eta_w3_upper_limits_calo1: calo_templates_array;
        eta_w3_lower_limits_calo1: calo_templates_array;
        eta_w4_upper_limits_calo1: calo_templates_array;
        eta_w4_lower_limits_calo1: calo_templates_array;
        eta_w5_upper_limits_calo1: calo_templates_array;
        eta_w5_lower_limits_calo1: calo_templates_array;
        phi_full_range_calo1 : calo_templates_boolean_array;
        phi_w1_upper_limits_calo1: calo_templates_array;
        phi_w1_lower_limits_calo1: calo_templates_array;
        phi_w2_ignore_calo1 : calo_templates_boolean_array;
        phi_w2_upper_limits_calo1: calo_templates_array;
        phi_w2_lower_limits_calo1: calo_templates_array;
        iso_luts_calo1: calo_templates_iso_array;

        calo2_object_low: natural;
        calo2_object_high: natural;
        et_ge_mode_calo2: boolean;
        obj_type_calo2: natural := TAU_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo2 : natural;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2: boolean;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2: boolean;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        diff_eta_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_eta_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        diff_phi_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_phi_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dr_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        dr_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);

        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1
    );
    port(
        clk: in std_logic;
        calo1: in calo_objects_array;
        calo2: in calo_objects_array;
        diff_eta_orm: in deta_dphi_vector_array;
        diff_phi_orm: in deta_dphi_vector_array;
        condition_o: out std_logic;
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0)
    );
end calo_conditions_orm;

architecture rtl of calo_conditions_orm is

    constant nr_objects_slice_1_int: natural := calo1_object_slice_1_high-calo1_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo1_object_slice_2_high-calo1_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo1_object_slice_3_high-calo1_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := calo1_object_slice_4_high-calo1_object_slice_4_low+1;

    constant nr_calo2_objects_int: natural := calo2_object_high-calo2_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal calo1_obj_slice_1_vs_templ, calo1_obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(calo1_object_slice_1_low to calo1_object_slice_1_high, 1 to 1);
    signal calo1_obj_slice_2_vs_templ, calo1_obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(calo1_object_slice_2_low to calo1_object_slice_2_high, 1 to 1);
    signal calo1_obj_slice_3_vs_templ, calo1_obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(calo1_object_slice_3_low to calo1_object_slice_3_high, 1 to 1);
    signal calo1_obj_slice_4_vs_templ, calo1_obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(calo1_object_slice_4_low to calo1_object_slice_4_high, 1 to 1);
    
    signal diff_eta_orm_comp, diff_eta_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal diff_phi_orm_comp, diff_phi_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal dr_orm_comp, dr_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1) := (others => (others => '0'));

    signal condition_and_or : std_logic;
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

    signal twobody_pt_comp, twobody_pt_comp_pipe : 
    std_logic_2dim_array(calo1_object_slice_1_low to calo1_object_slice_1_low, calo1_object_slice_2_low to calo1_object_slice_2_high) := (others => (others => '1'));

begin

    assert_i: if nr_templates = 4 generate 
    -- HB 2017-09-07: max. 7 calo1 objects are allowed for quad condition, because of length of obj_vs_templ_vec
        assert (nr_objects_slice_1_int < 8 and nr_objects_slice_2_int < 8 and nr_objects_slice_3_int < 8 and nr_objects_slice_4_int < 8) report 
            "number of objects to high for quad condition: max. 7 calo1 objects per slice allowed"
        severity failure;
    end generate;

-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
        twobody_pt_i: entity work.twobody_pt
            generic map(
                calo1_object_slice_1_low, calo1_object_slice_1_high,
                calo1_object_slice_2_low, calo1_object_slice_2_high,
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

-- Instantiation of object cuts for calo1.
    calo1_obj_cuts_i: entity work.calo_obj_cuts
        generic map(
            calo1_object_slice_1_low, calo1_object_slice_1_high,
            calo1_object_slice_2_low, calo1_object_slice_2_high,
            calo1_object_slice_3_low, calo1_object_slice_3_high,
            calo1_object_slice_4_low, calo1_object_slice_4_high,
            nr_templates, et_ge_mode_calo1, obj_type_calo1,
            et_thresholds_calo1,
            nr_eta_windows_calo1, 
            eta_w1_upper_limits_calo1, eta_w1_lower_limits_calo1,
            eta_w2_upper_limits_calo1, eta_w2_lower_limits_calo1,
            eta_w3_upper_limits_calo1, eta_w3_lower_limits_calo1,
            eta_w4_upper_limits_calo1, eta_w4_lower_limits_calo1,
            eta_w5_upper_limits_calo1, eta_w5_lower_limits_calo1,
            phi_full_range_calo1, phi_w1_upper_limits_calo1, phi_w1_lower_limits_calo1,
            phi_w2_ignore_calo1, phi_w2_upper_limits_calo1, phi_w2_lower_limits_calo1,
            iso_luts_calo1
        )
        port map(
            calo1, calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo1_obj_slice_4_vs_templ
        );

-- Instantiation of object cuts for calo2.
    calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
        calo2_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo2, obj_type_calo2,
                et_threshold_calo2,
                nr_eta_windows_calo2,
                eta_w1_upper_limit_calo2, eta_w1_lower_limit_calo2,
                eta_w2_upper_limit_calo2, eta_w2_lower_limit_calo2,
                eta_w3_upper_limit_calo2, eta_w3_lower_limit_calo2,
                eta_w4_upper_limit_calo2, eta_w4_lower_limit_calo2,
                eta_w5_upper_limit_calo2, eta_w5_lower_limit_calo2,
                phi_full_range_calo2,
                phi_w1_upper_limit_calo2,
                phi_w1_lower_limit_calo2,
                phi_w2_ignore_calo2,
                phi_w2_upper_limit_calo2,
                phi_w2_lower_limit_calo2,
                iso_lut_calo2
            )
            port map(
                calo2(i), calo2_obj_vs_templ(i,1)
            );
    end generate calo2_obj_l;

-- HB 2017-09-05: for optimisation - splitting to different loops with "calo1_object_slice_1_low to calo1_object_slice_1_high", etc.
    cuts_orm_l_1: for i in 0 to MAX_CALO_OBJECTS-1 generate 
        cuts_orm_l_2: for k in calo2_object_low to calo2_object_high generate
            deta_orm_cut_i: if deta_orm_cut = true generate
                diff_eta_orm_comp(i,k) <= '1' when diff_eta_orm(i,k) >= diff_eta_orm_lower_limit_vector and diff_eta_orm(i,k) <= diff_eta_orm_upper_limit_vector else '0';
            end generate deta_orm_cut_i;
            dphi_orm_cut_i: if dphi_orm_cut = true generate
                diff_phi_orm_comp(i,k) <= '1' when diff_phi_orm(i,k) >= diff_phi_orm_lower_limit_vector and diff_phi_orm(i,k) <= diff_phi_orm_upper_limit_vector else '0';
            end generate dphi_orm_cut_i;
            dr_orm_cut_i: if dr_orm_cut = true generate
                dr_calculator_i: entity work.dr_calculator
                    generic map(
                        upper_limit_vector => dr_orm_upper_limit_vector,
                        lower_limit_vector => dr_orm_lower_limit_vector
                    )
                    port map(
                        diff_eta => diff_eta_orm(i,k),
                        diff_phi => diff_phi_orm(i,k),
                        dr_comp => dr_orm_comp(i,k)
                    );
            end generate dr_orm_cut_i;
        end generate cuts_orm_l_2;
    end generate cuts_orm_l_1;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo1_obj_slice_4_vs_templ, calo2_obj_vs_templ,           diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
            calo1_obj_slice_1_vs_templ_pipe <= calo1_obj_slice_1_vs_templ;
            calo1_obj_slice_2_vs_templ_pipe <= calo1_obj_slice_2_vs_templ;
            calo1_obj_slice_3_vs_templ_pipe <= calo1_obj_slice_3_vs_templ;
            calo1_obj_slice_4_vs_templ_pipe <= calo1_obj_slice_4_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
            diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
        elsif (clk'event and clk = '1') then
            calo1_obj_slice_1_vs_templ_pipe <= calo1_obj_slice_1_vs_templ;
            calo1_obj_slice_2_vs_templ_pipe <= calo1_obj_slice_2_vs_templ;
            calo1_obj_slice_3_vs_templ_pipe <= calo1_obj_slice_3_vs_templ;
            calo1_obj_slice_4_vs_templ_pipe <= calo1_obj_slice_4_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
            diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
        end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.calo_cond_matrix_orm
        generic map(
            calo1_object_slice_1_low, calo1_object_slice_1_high,
            calo1_object_slice_2_low, calo1_object_slice_2_high,
            calo1_object_slice_3_low, calo1_object_slice_3_high,
            calo1_object_slice_4_low, calo1_object_slice_4_high,
            nr_templates,
            calo2_object_low, calo2_object_high
        )
        port map(clk,
            calo1_obj_slice_1_vs_templ_pipe, calo1_obj_slice_2_vs_templ_pipe, calo1_obj_slice_3_vs_templ_pipe, calo1_obj_slice_4_vs_templ_pipe, calo2_obj_vs_templ,
            twobody_pt_comp_pipe, diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe,
            condition_o
        );

end architecture rtl;
