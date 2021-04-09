
-- Description:
-- Correlation Condition module for:
-- 1. two muon objects.
-- 2. mass for 3 objects.
-- 3. muon esums.

-- Version history:
-- HB 2021-02-19: updated instances of muon_comparators and condition output pipeline.
-- HB 2020-02-11: replaced code with "sum_mass" and "correlation_cuts" instances.
-- HB 2020-02-02: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity correlation_conditions_muon is
     generic(

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1 : natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj1: natural := 0;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj1: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');
        requested_charge_obj1: string(1 to 3) := "ign";
        qual_lut_obj1: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj1: boolean := false;
        upt_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj1: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2 : natural := 0;
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
        requested_charge_obj2: string(1 to 3) := "ign";
        qual_lut_obj2: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj2: boolean := false;
        upt_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj2: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj3: boolean := true;
        pt_threshold_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj3 : natural := 0;
        eta_w1_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj3: natural := 0;
        phi_w1_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj3: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');
        requested_charge_obj3: string(1 to 3) := "ign";
        qual_lut_obj3: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj3: boolean := false;
        upt_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj3: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        sel_esums: boolean := false;
        obj_type_esums: natural := ETM_TYPE;
        et_ge_mode_esums: boolean := true;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_esums: natural := 0;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');

        requested_charge_correlation: string(1 to 2) := "ig";

        deta_cut: boolean := false;
        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean := false;
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        pt1_width: positive := MU_PT_VECTOR_WIDTH;
        pt2_width: positive := MU_PT_VECTOR_WIDTH;
        upt1_width: positive := MU_UPT_VECTOR_WIDTH;
        upt2_width: positive := MU_UPT_VECTOR_WIDTH;

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_div_dr_vector_width: positive := MU_MU_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := MU_MU_COSH_COS_PRECISION;
        cosh_cos_width: positive := MU_MU_COSH_COS_VECTOR_WIDTH;

        tbpt_cut: boolean := false;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;

        nr_obj2: natural := NR_MU_OBJECTS;

        mass_3_obj: boolean := false;
        same_bx: boolean := false

    );
    port(
        lhc_clk: in std_logic;
        obj1: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        obj2: in muon_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        obj3: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        deta: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        upt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        upt2 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        cosh_deta : in common_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi : in common_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        dr : in dr_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_pt : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_upt : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_trans : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_div_dr : in mass_div_dr_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end correlation_conditions_muon;

architecture rtl of correlation_conditions_muon is

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double, charge_comp_double_pipe : muon_charcorr_double_array := (others => (others => '1'));
    signal charge_comp_triple, charge_comp_triple_pipe : muon_charcorr_triple_array := (others => (others => (others => '1')));
--***************************************************************

    constant mass_vector_width: positive := pt1_width+pt1_width+cosh_cos_width;
    signal type_obj2: natural := MU_TYPE;

    signal obj1_vs_templ_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
    signal obj2_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
    signal obj3_vs_templ_pipe : std_logic_2dim_array(slice_low_obj3 to slice_high_obj3, 1 to 1) := (others => (others => '0'));
-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp_pipe, dphi_comp_pipe, dr_comp_temp, dr_comp, dr_comp_pipe, mass_comp_temp, mass_comp, mass_comp_pipe, tbpt_comp_pipe :
    std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) :=
    (others => (others => '1'));
    signal invariant_mass, invariant_mass_temp : mass_dim2_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => (others => '0')));
    signal mass_3_obj_comp_pipe : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal condition_and_or : std_logic;

begin

    obj1_l: for i in slice_low_obj1 to slice_high_obj1 generate
        comp_i: entity work.muon_comparators
            generic map(
                pt_ge_mode_obj1,
                pt_threshold_obj1,
                nr_eta_windows_obj1,
                eta_w1_upper_limit_obj1,
                eta_w1_lower_limit_obj1,
                eta_w2_upper_limit_obj1,
                eta_w2_lower_limit_obj1,
                eta_w3_upper_limit_obj1,
                eta_w3_lower_limit_obj1,
                eta_w4_upper_limit_obj1,
                eta_w4_lower_limit_obj1,
                eta_w5_upper_limit_obj1,
                eta_w5_lower_limit_obj1,
                nr_phi_windows_obj1,
                phi_w1_upper_limit_obj1,
                phi_w1_lower_limit_obj1,
                phi_w2_upper_limit_obj1,
                phi_w2_lower_limit_obj1,
                requested_charge_obj1,
                qual_lut_obj1,
                iso_lut_obj1,
                upt_cut_obj1,
                upt_upper_limit_obj1,
                upt_lower_limit_obj1,
                ip_lut_obj1
                )
            port map(lhc_clk, obj1(i), obj1_vs_templ_pipe(i,1));
    end generate obj1_l;

    not_esums_sel: if not sel_esums generate
        obj2_l: for i in slice_low_obj2 to slice_high_obj2 generate
            comp_i: entity work.muon_comparators
                generic map(
                    pt_ge_mode_obj2,
                    pt_threshold_obj2,
                    nr_eta_windows_obj2,
                    eta_w1_upper_limit_obj2,
                    eta_w1_lower_limit_obj2,
                    eta_w2_upper_limit_obj2,
                    eta_w2_lower_limit_obj2,
                    eta_w3_upper_limit_obj2,
                    eta_w3_lower_limit_obj2,
                    eta_w4_upper_limit_obj2,
                    eta_w4_lower_limit_obj2,
                    eta_w5_upper_limit_obj2,
                    eta_w5_lower_limit_obj2,
                    nr_phi_windows_obj2,
                    phi_w1_upper_limit_obj2,
                    phi_w1_lower_limit_obj2,
                    phi_w2_upper_limit_obj2,
                    phi_w2_lower_limit_obj2,
                    requested_charge_obj2,
                    qual_lut_obj2,
                    iso_lut_obj2,
                    upt_cut_obj2,
                    upt_upper_limit_obj2,
                    upt_lower_limit_obj2,
                    ip_lut_obj2
                    )
                port map(lhc_clk, obj2(i), obj2_vs_templ_pipe(i,1));
        end generate obj2_l;

        sel_type_obj2: if mass_type = TRANSVERSE_MASS_TYPE generate
            type_obj2 <= obj_type_esums; -- default => MU_TYPE
        end generate sel_type_obj2;

        corr_cuts_comp_i: entity work.correlation_cuts_comp
            generic map(
                nr_obj1 => NR_MU_OBJECTS,
                type_obj1 => MU_TYPE,
                nr_obj2 => nr_obj2,
                type_obj2 => type_obj2,
                slice_low_obj1 => slice_low_obj1,
                slice_high_obj1 => slice_high_obj1,
                slice_low_obj2 => slice_low_obj2,
                slice_high_obj2 => slice_high_obj2,
                deta_cut => deta_cut,
                deta_upper_limit_vector => deta_upper_limit_vector,
                deta_lower_limit_vector => deta_lower_limit_vector,
                dphi_cut => dphi_cut,
                dphi_upper_limit_vector => dphi_upper_limit_vector,
                dphi_lower_limit_vector => dphi_lower_limit_vector,
                dr_cut => dr_cut,
                dr_upper_limit_vector => dr_upper_limit_vector,
                dr_lower_limit_vector => dr_lower_limit_vector,
                mass_cut => mass_cut,
                mass_type => mass_type,
                mass_vector_width => mass_vector_width,
                mass_upper_limit_vector => mass_upper_limit_vector,
                mass_lower_limit_vector => mass_lower_limit_vector,
                tbpt_cut => tbpt_cut,
                pt_sq_threshold_vector => pt_sq_threshold_vector,
                same_bx => same_bx
            )
            port map(
                lhc_clk,
                deta => deta,
                dphi => dphi,
                dr => dr,
                mass_inv_pt => mass_inv_pt,
                mass_inv_upt => mass_inv_upt,
                mass_trans => mass_trans,
                deta_comp_o => deta_comp_pipe,
                dphi_comp_o => dphi_comp_pipe,
                dr_comp_o => dr_comp_pipe,
                mass_comp_o => mass_comp_pipe,
                tbpt_comp_o => tbpt_comp_pipe
            );

        matrix_2_obj_i: if not mass_3_obj generate
        -- HB 2020-08-27: comparison for invariant mass divided by delta R (one pipeline delay inside of the calculation of "mass_div_dr").
            mass_div_dr_sel: if mass_cut = true and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
                mass_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
                    mass_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                        mass_comp_l1: if same_bx and j>i generate
                            comp_i: entity work.mass_div_dr_comp
                                generic map(
                                    mass_div_dr_vector_width,
                                    mass_div_dr_threshold
                                )
                                port map(
                                    mass_div_dr(i,j)(mass_div_dr_vector_width-1 downto 0),
                                    mass_div_dr_comp_t(i,j)
                                );
                            mass_div_dr_comp_pipe(i,j) <= mass_div_dr_comp_t(i,j);
                            mass_div_dr_comp_pipe(j,i) <= mass_div_dr_comp_t(i,j);
                        end generate mass_comp_l1;
                        mass_comp_l2: if not same_bx generate
                            comp_i: entity work.mass_div_dr_comp
                                generic map(
                                    mass_div_dr_vector_width,
                                    mass_div_dr_threshold
                                )
                                port map(
                                    mass_div_dr(i,j)(mass_div_dr_vector_width-1 downto 0),
                                    mass_div_dr_comp_pipe(i,j)
                                );
                        end generate mass_comp_l2;
                    end generate mass_l_2;
                end generate mass_l_1;
            end generate mass_div_dr_sel;

            charge_double_i: if requested_charge_correlation /= "ig" generate
            -- Charge correlation comparison
                charge_double_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
                    charge_double_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                        obj_same_bx_l: if same_bx = true generate
                            charge_double_if: if j/=i generate
                                charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                    '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                    '1' when requested_charge_correlation = "ig" else '0';
                            end generate charge_double_if;
                        end generate obj_same_bx_l;
                        obj_different_bx_l: if same_bx = false generate
                            charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                '1' when requested_charge_correlation = "ig" else '0';
                        end generate obj_different_bx_l;
                    end generate charge_double_l_2;
                end generate charge_double_l_1;
            end generate charge_double_i;

            cc_double_p: process(lhc_clk, charge_comp_double)
                begin
                if INTERMEDIATE_PIPELINE = false then
                    charge_comp_double_pipe <= charge_comp_double;
                else
                    if (lhc_clk'event and lhc_clk = '1') then
                        charge_comp_double_pipe <= charge_comp_double;
                    end if;
                end if;
            end process;

            matrix_corr_cond_i: entity work.matrix_corr_cond
                generic map(
                    slice_low_obj1,
                    slice_high_obj1,
                    slice_low_obj2,
                    slice_high_obj2,
                    MU_TYPE,
                    MU_TYPE,
                    same_bx
                    )
                port map(
                    obj1_vs_templ_pipe,
                    obj2_vs_templ_pipe,
                    deta_comp_pipe,
                    dphi_comp_pipe,
                    dr_comp_pipe,
                    mass_comp_pipe,
                    mass_div_dr_comp_pipe,
                    tbpt_comp_pipe,
                    charge_comp_double_pipe,
                    condition_and_or
                );

        end generate matrix_2_obj_i;

        mass_3_obj_i: if mass_3_obj generate
    -- comparator for obj3
            obj3_l: for i in slice_low_obj3 to slice_high_obj3 generate
                comp_i: entity work.muon_comparators
                    generic map(
                        pt_ge_mode_obj3,
                        pt_threshold_obj3,
                        nr_eta_windows_obj3,
                        eta_w1_upper_limit_obj3,
                        eta_w1_lower_limit_obj3,
                        eta_w2_upper_limit_obj3,
                        eta_w2_lower_limit_obj3,
                        eta_w3_upper_limit_obj3,
                        eta_w3_lower_limit_obj3,
                        eta_w4_upper_limit_obj3,
                        eta_w4_lower_limit_obj3,
                        eta_w5_upper_limit_obj3,
                        eta_w5_lower_limit_obj3,
                        nr_phi_windows_obj3,
                        phi_w1_upper_limit_obj3,
                        phi_w1_lower_limit_obj3,
                        phi_w2_upper_limit_obj3,
                        phi_w2_lower_limit_obj3,
                        requested_charge_obj3,
                        qual_lut_obj3,
                        iso_lut_obj3,
                        upt_cut_obj3,
                        upt_upper_limit_obj3,
                        upt_lower_limit_obj3,
                        ip_lut_obj3
                        )
                    port map(lhc_clk, obj3(i), obj3_vs_templ_pipe(i,1));
            end generate obj3_l;

            sum_mass_i: entity work.sum_mass
                generic map(
                    slice_low_obj1,
                    slice_high_obj1,
                    slice_low_obj2,
                    slice_high_obj2,
                    slice_low_obj3,
                    slice_high_obj3,
                    mass_upper_limit_vector,
                    mass_lower_limit_vector,
                    mass_vector_width,
                    NR_MU_OBJECTS
                )
                port map(
                    lhc_clk,
--                     invariant_mass,
                    mass_inv_pt,
                    mass_3_obj_comp_pipe
                );

            charge_triple_i: if requested_charge_correlation /= "ig" generate
            -- Charge correlation comparison
                charge_triple_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
                    charge_triple_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                        charge_triple_l_3: for k in slice_low_obj3 to slice_high_obj3 generate
                            obj_same_bx_l: if same_bx = true generate
                                charge_triple_if: if (j/=i and k/=i and k/=j) generate
                                    charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                        '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                        '1' when requested_charge_correlation = "ig" else '0';
                                end generate charge_triple_if;
                            end generate obj_same_bx_l;
                            obj_different_bx_l: if same_bx = false generate
                                charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                    '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                    '1' when requested_charge_correlation = "ig" else '0';
                            end generate obj_different_bx_l;
                        end generate charge_triple_l_3;
                    end generate charge_triple_l_2;
                end generate charge_triple_l_1;
            end generate charge_triple_i;

            cc_triple_p: process(lhc_clk, charge_comp_triple)
                begin
                if INTERMEDIATE_PIPELINE = false then
                    charge_comp_triple_pipe <= charge_comp_triple;
                else
                    if (lhc_clk'event and lhc_clk = '1') then
                        charge_comp_triple_pipe <= charge_comp_triple;
                    end if;
                end if;
            end process;

            -- "Matrix" of permutations in an and-or-structure.
            matrix_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, obj3_vs_templ_pipe, mass_3_obj_comp_pipe, charge_comp_triple_pipe)
                variable index : integer := 0;
                variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)*(slice_high_obj3-slice_low_obj3+1) downto 1) := (others => '0');
                variable condition_and_or_tmp : std_logic := '0';
            begin
                index := 0;
                obj_vs_templ_vec := (others => '0');
                condition_and_or_tmp := '0';
                for i in slice_low_obj1 to slice_high_obj1 loop
                    for j in slice_low_obj2 to slice_high_obj2 loop
                        for k in slice_low_obj3 to slice_high_obj3 loop
                            if j/=i and i/=k and j/=k then
                                index := index + 1;
                                obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and obj3_vs_templ_pipe(k,1) and
                                    mass_3_obj_comp_pipe(i,j,k) and charge_comp_triple_pipe(i,j,k);
                            end if;
                        end loop;
                    end loop;
                end loop;
                for i in 1 to index loop
                    -- ORs for matrix
                    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
                end loop;
                condition_and_or <= condition_and_or_tmp;
            end process matrix_p;

        end generate mass_3_obj_i;
    end generate not_esums_sel;

    esums_sel: if sel_esums generate

        esums_i: entity work.esums_4_corr_cond
            generic map(
                slice_low_obj1,
                slice_high_obj1,
                obj_type_esums,
                et_ge_mode_esums,
                et_threshold_esums,
                nr_phi_windows_esums,
                phi_w1_upper_limit_esums,
                phi_w1_lower_limit_esums,
                phi_w2_upper_limit_esums,
                phi_w2_lower_limit_esums,
                dphi_cut,
                mass_cut,
                mass_type,
                tbpt_cut,
                dphi_upper_limit_vector,
                dphi_lower_limit_vector,
                mass_upper_limit_vector,
                mass_lower_limit_vector,
                pt1_width,
                pt2_width,
                mass_cosh_cos_precision,
                cosh_cos_width,
                pt_sq_threshold_vector,
                sin_cos_width,
                pt_sq_sin_cos_precision,
                NR_MU_OBJECTS
            )
            port map(
                lhc_clk,
                esums,
                obj1_vs_templ_pipe,
                dphi,
                pt1,
                pt2,
                cos_dphi,
                cos_phi_1_integer,
                cos_phi_2_integer,
                sin_phi_1_integer,
                sin_phi_2_integer,
                condition_and_or
            );

    end generate esums_sel;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
        begin
            if CONDITIONS_PIPELINE = false then
                condition_o <= condition_and_or;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;

end architecture rtl;
