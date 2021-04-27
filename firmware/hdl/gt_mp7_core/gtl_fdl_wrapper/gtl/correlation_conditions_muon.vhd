
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

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_div_dr_vector_width: positive := MU_MU_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_vector_width: positive := MU_PT_VECTOR_WIDTH+MU_PT_VECTOR_WIDTH+MU_MU_COSH_COS_VECTOR_WIDTH;
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        tbpt_cut: boolean := false;
        tbpt_vector_width : positive := 2+MU_PT_VECTOR_WIDTH+MU_PT_VECTOR_WIDTH+MUON_SIN_COS_VECTOR_WIDTH+MUON_SIN_COS_VECTOR_WIDTH;
        tbpt_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');

        nr_obj2: natural := NR_MU_OBJECTS;
        type_obj2: natural := MU_TYPE;

        mass_3_obj: boolean := false;
        same_bx: boolean := false

    );
    port(
        lhc_clk: in std_logic;
        obj1: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        obj2: in muon_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        obj3: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        ls_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        os_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        ls_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        os_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        deta: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dr : in dr_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_pt : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_upt : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_trans : in mass_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_div_dr : in mass_div_dr_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbpt: in tbpt_dim2_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end correlation_conditions_muon;

architecture rtl of correlation_conditions_muon is

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double, charge_comp_double_pipe : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '1'));
    signal charge_comp_triple, charge_comp_triple_pipe : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '1')));
--***************************************************************

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

--         corr_cuts_comp_i: entity work.correlation_cuts_comp
        corr_cuts_comp_i: entity work.correlation_cuts_wrapper
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
                tbpt_vector_width => tbpt_vector_width,
                tbpt_threshold_vector => tbpt_threshold_vector,
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
                tbpt => tbpt,
                deta_comp_o => deta_comp_pipe,
                dphi_comp_o => dphi_comp_pipe,
                dr_comp_o => dr_comp_pipe,
                mass_comp_o => mass_comp_pipe,
                tbpt_comp_o => tbpt_comp_pipe
            );

        matrix_2_obj_i: if not mass_3_obj generate
            corr_cuts_comp_i: entity work.correlation_cuts_wrapper
                generic map(
                    nr_obj1 => NR_MU_OBJECTS,
                    type_obj1 => MU_TYPE,
                    nr_obj2 => nr_obj2,
                    type_obj2 => type_obj2,
                    slice_low_obj1 => slice_low_obj1,
                    slice_high_obj1 => slice_high_obj1,
                    slice_low_obj2 => slice_low_obj2,
                    slice_high_obj2 => slice_high_obj2,
                    mass_cut => mass_cut,
                    mass_type => mass_type,
                    mass_vector_width => mass_vector_width,
                    mass_div_dr_vector_width => mass_div_dr_vector_width,
                    mass_div_dr_threshold => mass_div_dr_threshold,
                    same_bx => same_bx
                )
                port map(
                    lhc_clk,
                    mass_div_dr => mass_div_dr,
                    mass_div_dr_comp_o => mass_div_dr_comp_pipe
                );

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
                if not INTERMEDIATE_PIPELINE then
                    charge_comp_double_pipe <= charge_comp_double;
                else
                    if (lhc_clk'event and lhc_clk = '1') then
                        charge_comp_double_pipe <= charge_comp_double;
                    end if;
                end if;
            end process;

            matrix_corr_cond_i: entity work.matrix_corr_cond
                generic map(
                    no_orm => true,
                    slice_low_obj1 => slice_low_obj1,
                    slice_high_obj1 => slice_high_obj1,
                    slice_low_obj2 => slice_low_obj2,
                    slice_high_obj2 => slice_high_obj2,
                    type_obj1 => MU_TYPE,
                    type_obj2 => MU_TYPE,
                    same_bx => same_bx
                    )
                port map(
                    obj1_vs_templ => obj1_vs_templ_pipe,
                    obj2_vs_templ => obj2_vs_templ_pipe,
                    deta_comp => deta_comp_pipe,
                    dphi_comp => dphi_comp_pipe,
                    dr_comp => dr_comp_pipe,
                    mass_comp => mass_comp_pipe,
                    mass_div_dr_comp => mass_div_dr_comp_pipe,
                    tbpt_comp => tbpt_comp_pipe,
                    charge_comp_double => charge_comp_double_pipe,
                    condition_and_or => condition_and_or
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
                if not INTERMEDIATE_PIPELINE then
                    charge_comp_triple_pipe <= charge_comp_triple;
                else
                    if (lhc_clk'event and lhc_clk = '1') then
                        charge_comp_triple_pipe <= charge_comp_triple;
                    end if;
                end if;
            end process;

            matrix_corr_cond_i: entity work.matrix_corr_cond
                generic map(
                    mass_3_obj => true,
                    slice_low_obj1 => slice_low_obj1,
                    slice_high_obj1 => slice_high_obj1,
                    slice_low_obj2 => slice_low_obj2,
                    slice_high_obj2 => slice_high_obj2,
                    slice_low_obj3 => slice_low_obj3,
                    slice_high_obj3 => slice_high_obj3
                    )
                port map(
                    obj1_vs_templ => obj1_vs_templ_pipe,
                    obj2_vs_templ => obj2_vs_templ_pipe,
                    obj3_vs_templ => obj3_vs_templ_pipe,
                    mass_3_obj_comp => mass_3_obj_comp_pipe,
                    charge_comp_triple => charge_comp_triple_pipe,
                    condition_and_or => condition_and_or
                );

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
                mass_vector_width,
                tbpt_cut,
                tbpt_vector_width,
                dphi_upper_limit_vector,
                dphi_lower_limit_vector,
                mass_upper_limit_vector,
                mass_lower_limit_vector,
                tbpt_threshold_vector,
                MU_TYPE,
                NR_MU_OBJECTS
            )
            port map(
                lhc_clk,
                esums,
                obj1_vs_templ_pipe,
                dphi,
                mass_trans,
                tbpt,
                condition_and_or
            );

    end generate esums_sel;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
        begin
            if not CONDITIONS_PIPELINE then
                condition_o <= condition_and_or;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;

end architecture rtl;
