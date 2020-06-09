
-- Description:
-- Condition module for muon objects conditions with "overlap removal (orm)".

-- Version history:
-- HB 2019-10-16: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions_orm is
     generic(
        deta_orm_cut: boolean := false;
        dphi_orm_cut: boolean := false;
        dr_orm_cut: boolean := true;

        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode_muon: boolean;
        et_thresholds_muon: muon_templates_array;
        nr_eta_windows_muon : muon_templates_natural_array;
        eta_w1_upper_limits_muon: muon_templates_array;
        eta_w1_lower_limits_muon: muon_templates_array;
        eta_w2_upper_limits_muon: muon_templates_array;
        eta_w2_lower_limits_muon: muon_templates_array;
        eta_w3_upper_limits_muon: muon_templates_array;
        eta_w3_lower_limits_muon: muon_templates_array;
        eta_w4_upper_limits_muon: muon_templates_array;
        eta_w4_lower_limits_muon: muon_templates_array;
        eta_w5_upper_limits_muon: muon_templates_array;
        eta_w5_lower_limits_muon: muon_templates_array;
        phi_full_range_muon : muon_templates_boolean_array;
        phi_w1_upper_limits_muon: muon_templates_array;
        phi_w1_lower_limits_muon: muon_templates_array;
        phi_w2_ignore_muon : muon_templates_boolean_array;
        phi_w2_upper_limits_muon: muon_templates_array;
        phi_w2_lower_limits_muon: muon_templates_array;
        requested_charges_muon: muon_templates_string_array;
        qual_luts_muon: muon_templates_quality_array;
        iso_luts_muon: muon_templates_iso_array;
        ptu_cuts_muon: muon_templates_boolean_array;
        ptu_upper_limits_muon: muon_templates_array;
        ptu_lower_limits_muon: muon_templates_array;
        ip_luts_muon: muon_templates_ip_array;
        requested_charge_correlation: string(1 to 2);

        calo_object_low: natural;
        calo_object_high: natural;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := TAU_TYPE;
        et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo : natural;
        eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo: boolean;
        phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo: boolean;
        phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

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
        muon: in muon_objects_array;
        calo: in calo_objects_array;
        diff_eta_orm: in deta_dphi_vector_array;
        diff_phi_orm: in deta_dphi_vector_array;
        condition_o: out std_logic;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0)
    );
end muon_conditions_orm;

architecture rtl of muon_conditions_orm is

    constant nr_objects_slice_1_int: natural := muon_object_slice_1_high-muon_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := muon_object_slice_2_high-muon_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := muon_object_slice_3_high-muon_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := muon_object_slice_4_high-muon_object_slice_4_low+1;

    constant nr_calo_objects_int: natural := calo_object_high-calo_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal muon_obj_slice_1_vs_templ, muon_obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array(muon_object_slice_1_low to muon_object_slice_1_high, 1 to 1);
    signal muon_obj_slice_2_vs_templ, muon_obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array(muon_object_slice_2_low to muon_object_slice_2_high, 1 to 1);
    signal muon_obj_slice_3_vs_templ, muon_obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array(muon_object_slice_3_low to muon_object_slice_3_high, 1 to 1);
    signal muon_obj_slice_4_vs_templ, muon_obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array(muon_object_slice_4_low to muon_object_slice_4_high, 1 to 1);
    
    signal diff_eta_orm_comp, diff_eta_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal diff_phi_orm_comp, diff_phi_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal dr_orm_comp, dr_orm_comp_pipe : std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo_object_low to calo_object_high) := (others => (others => '0'));
    signal calo_obj_vs_templ, calo_obj_vs_templ_pipe : std_logic_2dim_array(calo_object_low to calo_object_high, 1 to 1) := (others => (others => '0'));

--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
--     signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--     signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
--     signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

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
    std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_low, muon_object_slice_2_low to muon_object_slice_2_high) := (others => (others => '1'));

begin

--     assert_i: if nr_templates = 4 generate 
--     -- HB 2017-09-07: max. 7 calo1 objects are allowed for quad condition, because of length of obj_vs_templ_vec
--         assert (nr_objects_slice_1_int < 8 and nr_objects_slice_2_int < 8 and nr_objects_slice_3_int < 8 and nr_objects_slice_4_int < 8) report 
--             "number of objects to high for quad condition: max. 7 calo1 objects per slice allowed"
--         severity failure;
--     end generate;

-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
        twobody_pt_i: entity work.twobody_pt
            generic map(
                muon_object_slice_1_low, muon_object_slice_1_high,
                muon_object_slice_2_low, muon_object_slice_2_high,
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

-- Instantiation of object cuts for muon.
    muon_obj_cuts_i: entity work.muon_obj_cuts
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates, et_ge_mode_muon,
            et_thresholds_muon,
            nr_eta_windows_muon, 
            eta_w1_upper_limits_muon, eta_w1_lower_limits_muon,
            eta_w2_upper_limits_muon, eta_w2_lower_limits_muon,
            eta_w3_upper_limits_muon, eta_w3_lower_limits_muon,
            eta_w4_upper_limits_muon, eta_w4_lower_limits_muon,
            eta_w5_upper_limits_muon, eta_w5_lower_limits_muon,
            phi_full_range_muon, phi_w1_upper_limits_muon, phi_w1_lower_limits_muon,
            phi_w2_ignore_muon, phi_w2_upper_limits_muon, phi_w2_lower_limits_muon,
            requested_charges_muon, qual_luts_muon, iso_luts_muon,
            ptu_cuts_muon, ptu_upper_limits_muon, ptu_lower_limits_muon,
            ip_luts_muon            
        )
        port map(
            muon, muon_obj_slice_1_vs_templ, muon_obj_slice_2_vs_templ, muon_obj_slice_3_vs_templ, muon_obj_slice_4_vs_templ
        );

-- Instantiation of object cuts for calo.
    calo_obj_l: for i in calo_object_low to calo_object_high generate
        calo_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo, obj_type_calo,
                et_threshold_calo,
                nr_eta_windows_calo,
                eta_w1_upper_limit_calo, eta_w1_lower_limit_calo,
                eta_w2_upper_limit_calo, eta_w2_lower_limit_calo,
                eta_w3_upper_limit_calo, eta_w3_lower_limit_calo,
                eta_w4_upper_limit_calo, eta_w4_lower_limit_calo,
                eta_w5_upper_limit_calo, eta_w5_lower_limit_calo,
                phi_full_range_calo,
                phi_w1_upper_limit_calo,
                phi_w1_lower_limit_calo,
                phi_w2_ignore_calo,
                phi_w2_upper_limit_calo,
                phi_w2_lower_limit_calo,
                iso_lut_calo
            )
            port map(
                calo(i), calo_obj_vs_templ(i,1)
            );
    end generate calo_obj_l;

-- HB 2017-09-05: for optimisation - splitting to different loops with "muon_object_slice_1_low to muon_object_slice_1_high", etc.
    cuts_orm_l_1: for i in 0 to MAX_CALO_OBJECTS-1 generate 
        cuts_orm_l_2: for k in calo_object_low to calo_object_high generate
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
    obj_vs_templ_pipeline_p: process(clk, muon_obj_slice_1_vs_templ, muon_obj_slice_2_vs_templ, muon_obj_slice_3_vs_templ, muon_obj_slice_4_vs_templ, calo_obj_vs_templ,           diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
            muon_obj_slice_1_vs_templ_pipe <= muon_obj_slice_1_vs_templ;
            muon_obj_slice_2_vs_templ_pipe <= muon_obj_slice_2_vs_templ;
            muon_obj_slice_3_vs_templ_pipe <= muon_obj_slice_3_vs_templ;
            muon_obj_slice_4_vs_templ_pipe <= muon_obj_slice_4_vs_templ;
            calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
            diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
            diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
        elsif (clk'event and clk = '1') then
            muon_obj_slice_1_vs_templ_pipe <= muon_obj_slice_1_vs_templ;
            muon_obj_slice_2_vs_templ_pipe <= muon_obj_slice_2_vs_templ;
            muon_obj_slice_3_vs_templ_pipe <= muon_obj_slice_3_vs_templ;
            muon_obj_slice_4_vs_templ_pipe <= muon_obj_slice_4_vs_templ;
            calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
            diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
            diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
        end if;
    end process;

-- Instantiation of charge correlation matrix.
    charge_corr_matrix_i: entity work.muon_charge_corr_matrix
        generic map(
            obj_vs_templ_pipeline_stage,
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates,
            requested_charge_correlation
        )
        port map(clk,
            ls_charcorr_double, os_charcorr_double,
            ls_charcorr_triple, os_charcorr_triple,
            ls_charcorr_quad, os_charcorr_quad,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe
        );

-- "Matrix" of permutations in an and-or-structure.
-- Selection of muon condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.muon_cond_matrix_orm
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates,
            calo_object_low, calo_object_high
        )
        port map(clk,
            muon_obj_slice_1_vs_templ_pipe, muon_obj_slice_2_vs_templ_pipe, muon_obj_slice_3_vs_templ_pipe, muon_obj_slice_4_vs_templ_pipe, 
            calo_obj_vs_templ_pipe,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe, 
            diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe,
            condition_o
        );

end architecture rtl;
