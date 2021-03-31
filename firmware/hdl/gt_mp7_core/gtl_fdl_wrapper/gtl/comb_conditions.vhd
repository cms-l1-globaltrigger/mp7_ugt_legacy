
-- Description:
-- Condition module for all combination conditions.

-- Version history:
-- HB 2021-03-03: bug fixed.
-- HB 2021-02-19: updated condition output.
-- HB 2020-02-11: replaced code with "orm_cuts" instances.
-- HB 2021-02-03: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity comb_conditions is
     generic(

        slice_1_low_obj1: natural := 0;
        slice_1_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_2_low_obj1: natural := 0;
        slice_2_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_3_low_obj1: natural := 0;
        slice_3_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_4_low_obj1: natural := 0;
        slice_4_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_thresholds_obj1: common_templates_array := (others => (others => '0'));
        nr_eta_windows_obj1: common_templates_natural_array := (others => 0);
        eta_w1_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w1_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w2_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w2_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w3_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w3_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w4_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w4_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w5_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w5_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        nr_phi_windows_obj1: common_templates_natural_array := (others => 0);
        phi_w1_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w1_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w2_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w2_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        iso_luts_obj1: common_templates_iso_array := (others => (others => '1'));
        requested_charges_obj1: common_templates_string_array := (others => "ign");
        qual_luts_obj1: common_templates_quality_array := (others => (others => '1'));
        upt_cuts_obj1: common_templates_boolean_array := (others => false);
        upt_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        upt_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        ip_luts_obj1: common_templates_ip_array := (others => (others => '1'));

        requested_charge_correlation: string(1 to 2) := "ig";

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_TAU_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2: natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj2: natural := 0;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj2: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');

        twobody_pt_cut: boolean := false;
        pt_width: positive := EG_PT_VECTOR_WIDTH;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        twobody_upt_cut: boolean := false;
        upt_width: positive := MU_UPT_VECTOR_WIDTH;
        upt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1 : natural := EG_TYPE;
        nr_obj2: natural := NR_TAU_OBJECTS;
        type_obj2 : natural := TAU_TYPE;
        nr_templates: positive := COMMON_NR_TEMPLATES

    );
    port(
        lhc_clk: in std_logic;
        obj1_calo: in calo_objects_array(0 to nr_obj1-1) := (others => (others => '0'));
        obj1_muon: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        obj2: in calo_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        deta_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt : in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        condition_o: out std_logic
    );
end comb_conditions;

architecture rtl of comb_conditions is

    constant nr_objects_slice_1_int: natural := slice_1_high_obj1-slice_1_low_obj1+1;
    constant nr_objects_slice_2_int: natural := slice_2_high_obj1-slice_2_low_obj1+1;
    constant nr_objects_slice_3_int: natural := slice_3_high_obj1-slice_3_low_obj1+1;
    constant nr_objects_slice_4_int: natural := slice_4_high_obj1-slice_4_low_obj1+1;

    signal obj1_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(slice_1_low_obj1 to slice_1_high_obj1, 1 to 1);
    signal obj1_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(slice_2_low_obj1 to slice_2_high_obj1, 1 to 1);
    signal obj1_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(slice_3_low_obj1 to slice_3_high_obj1, 1 to 1);
    signal obj1_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(slice_4_low_obj1 to slice_4_high_obj1, 1 to 1);

--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
    signal charge_comp_double_pipe : muon_charcorr_double_array;
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal deta_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal dphi_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal dr_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal obj2_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));

    signal condition_and_or : std_logic;

    signal twobody_pt_comp, twobody_pt_comp_pipe :
    std_logic_2dim_array(slice_1_low_obj1 to slice_1_high_obj1, slice_2_low_obj1 to slice_2_high_obj1) := (others => (others => '1'));

    signal twobody_upt_comp, twobody_upt_comp_temp, twobody_upt_comp_pipe :
        std_logic_2dim_array(slice_1_low_obj1 to slice_1_high_obj1, slice_2_low_obj1 to slice_2_high_obj1) := (others => (others => '1'));

begin

    calo_i: if not (deta_orm_cut or dphi_orm_cut or dr_orm_cut) and (type_obj1 /= MU_TYPE) generate
        -- Instantiation of object cuts for obj1.
        obj1_cuts_i: entity work.calo_obj_cuts
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
                lhc_clk,
                obj1_calo, obj1_slice_1_vs_templ_pipe, obj1_slice_2_vs_templ_pipe, obj1_slice_3_vs_templ_pipe, obj1_slice_4_vs_templ_pipe
            );

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
            port map(
                lhc_clk,
                obj1_slice_1_vs_templ_pipe, obj1_slice_2_vs_templ_pipe, obj1_slice_3_vs_templ_pipe, obj1_slice_4_vs_templ_pipe,
                twobody_pt_comp_pipe,
                condition_o
            );
    end generate calo_i;

    -- condition with overlap removal
    calo_orm_i: if (deta_orm_cut or dphi_orm_cut or dr_orm_cut)  and (type_obj1 /= MU_TYPE) generate
        -- Instantiation of object cuts for obj2 - overlap removal object.
        obj2_l: for i in slice_low_obj2 to slice_high_obj2 generate
            obj2_comp_i: entity work.calo_comparators
                generic map(
                    pt_ge_mode_obj2, type_obj2,
                    pt_threshold_obj2,
                    nr_eta_windows_obj2,
                    eta_w1_upper_limit_obj2, eta_w1_lower_limit_obj2,
                    eta_w2_upper_limit_obj2, eta_w2_lower_limit_obj2,
                    eta_w3_upper_limit_obj2, eta_w3_lower_limit_obj2,
                    eta_w4_upper_limit_obj2, eta_w4_lower_limit_obj2,
                    eta_w5_upper_limit_obj2, eta_w5_lower_limit_obj2,
                    nr_phi_windows_obj2,
                    phi_w1_upper_limit_obj2,
                    phi_w1_lower_limit_obj2,
                    phi_w2_upper_limit_obj2,
                    phi_w2_lower_limit_obj2,
                    iso_lut_obj2
                )
                port map(
                    lhc_clk, obj2(i), obj2_vs_templ_pipe(i,1)
                );
        end generate obj2_l;

        orm_cuts_12_i: entity work.orm_cuts
            generic map(
                0,
                MAX_CALO_OBJECTS-1,
                slice_low_obj2,
                slice_high_obj2,
                deta_orm_cut,
                deta_orm_upper_limit_vector,
                deta_orm_lower_limit_vector,
                dphi_orm_cut,
                dphi_orm_upper_limit_vector,
                dphi_orm_lower_limit_vector,
                dr_orm_cut,
                dr_orm_upper_limit_vector,
                dr_orm_lower_limit_vector
            )
            port map(
                lhc_clk,
                deta_orm,
                dphi_orm,
                deta_orm_comp_pipe,
                dphi_orm_comp_pipe,
                dr_orm_comp_pipe
            );

        -- "Matrix" of permutations in an and-or-structure.
        -- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
        cond_matrix_i: entity work.calo_cond_matrix_orm
            generic map(
                slice_1_low_obj1, slice_1_high_obj1,
                slice_2_low_obj1, slice_2_high_obj1,
                slice_3_low_obj1, slice_3_high_obj1,
                slice_4_low_obj1, slice_4_high_obj1,
                nr_templates,
                slice_low_obj2, slice_high_obj2
            )
            port map(
                lhc_clk,
                obj1_slice_1_vs_templ_pipe, obj1_slice_2_vs_templ_pipe, obj1_slice_3_vs_templ_pipe, obj1_slice_4_vs_templ_pipe,
                obj2_vs_templ_pipe,
                twobody_pt_comp_pipe,
                deta_orm_comp_pipe, dphi_orm_comp_pipe, dr_orm_comp_pipe,
                condition_o
            );
    end generate calo_orm_i;

    muon_i: if type_obj1 = MU_TYPE generate
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
                ip_luts_obj1
            )
            port map(
                lhc_clk,
                obj1_muon, obj1_slice_1_vs_templ_pipe, obj1_slice_2_vs_templ_pipe, obj1_slice_3_vs_templ_pipe, obj1_slice_4_vs_templ_pipe
            );

        -- Instantiation of charge correlation matrix.
        charge_corr_matrix_i: entity work.muon_charge_corr_matrix
            generic map(
                slice_1_low_obj1, slice_1_high_obj1,
                slice_2_low_obj1, slice_2_high_obj1,
                slice_3_low_obj1, slice_3_high_obj1,
                slice_4_low_obj1, slice_4_high_obj1,
                nr_templates,
                requested_charge_correlation
            )
            port map(
                lhc_clk,
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
            port map(
                lhc_clk,
                obj1_slice_1_vs_templ_pipe, obj1_slice_2_vs_templ_pipe, obj1_slice_3_vs_templ_pipe, obj1_slice_4_vs_templ_pipe,
                charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe, twobody_upt_comp_pipe,
                condition_o
            );
    end generate muon_i;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, twobody_pt_comp, twobody_upt_comp)
    begin
        if INTERMEDIATE_PIPELINE = false then
            twobody_pt_comp_pipe <= twobody_pt_comp;
            twobody_upt_comp_pipe <= twobody_upt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                twobody_pt_comp_pipe <= twobody_pt_comp;
                twobody_upt_comp_pipe <= twobody_upt_comp;
            end if;
        end if;
    end process;

-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut and nr_templates = 2 generate
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
    twobody_upt_cut_i: if twobody_upt_cut and nr_templates = 2 generate
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

end architecture rtl;
