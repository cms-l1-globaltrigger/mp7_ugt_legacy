
-- Description:

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New order in generic.
-- HB 2020-11-26: added default parameters.
-- HB 2020-01-21: inserted port calo2 (bug fix).
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_calo_calo_correlation_orm_condition_v3 to calo_calo_calo_correlation_orm_condition.
-- HB 2017-07-04: changed from calo_calo_calo_correlation_orm_condition to calo_calo_calo_correlation_orm_condition_v2 for correct use of different object slices. 
--                Object types and bx of calo1 and calo2 are the same. Only one collection of input data (port "calo1") for calo1 and calo2.
-- HB 2017-05-18: updated and-structure for correct use with orm.
-- HB 2017-05-03: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_calo_correlation_orm_condition is
     generic(
        nr_obj1: natural := NR_EG_OBJECTS;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        type_obj2: natural := EG_TYPE;
        type_obj3: natural := JET_TYPE;

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1 : natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj1: boolean := true;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_EG_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2 : natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj2: boolean := true;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_JET_OBJECTS-1;
        pt_ge_mode_obj3: boolean := true;
        pt_threshold_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj3 : natural := 0;
        eta_w1_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj3: boolean := true;
        phi_w1_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj3: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj3: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        deta_cut: boolean := false;
        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean := false;
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        pt1_width: positive := EG_PT_VECTOR_WIDTH; 
        pt2_width: positive := EG_PT_VECTOR_WIDTH; 

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := EG_EG_COSH_COS_PRECISION;
        cosh_cos_width: positive := EG_EG_COSH_COS_VECTOR_WIDTH;

        twobody_pt_cut: boolean := false;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := EG_EG_SIN_COS_PRECISION;

        obj_2plus1: boolean := true

    );
    port(
        lhc_clk: in std_logic;
        calo1: in calo_objects_array;
        calo2: in calo_objects_array;
        calo3: in calo_objects_array;
        deta_orm: in deta_dphi_vector_array;
        dphi_orm: in deta_dphi_vector_array;
        deta: in deta_dphi_vector_array;
        dphi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        cosh_deta : in calo_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi : in calo_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        condition_o: out std_logic;
        sim_orm_vec: out std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => (others => '0')));
        sim_orm_vec_or_tmp: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
        sim_obj_vs_templ_vec: out std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => (others => '0')));
        sim_obj_vs_templ_or_tmp: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
        sim_obj_vs_templ_orm_vec: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'))
    );
end calo_calo_calo_correlation_orm_condition; 

architecture rtl of calo_calo_calo_correlation_orm_condition is

-- fixed pipeline structure
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal deta_orm_comp_13, deta_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal deta_orm_comp_23, deta_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dphi_orm_comp_13, dphi_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dphi_orm_comp_23, dphi_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dr_orm_comp_13, dr_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dr_orm_comp_23, dr_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
    signal calo3_obj_vs_templ, calo3_obj_vs_templ_pipe : std_logic_2dim_array(slice_low_obj3 to slice_high_obj3, 1 to 1) := (others => (others => '0'));
-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp_12, deta_comp_12_temp, deta_comp_12_pipe, dphi_comp_12, dphi_comp_12_temp, dphi_comp_12_pipe, dr_comp_12, dr_comp_12_temp, dr_comp_12_pipe, mass_comp_12, mass_comp_12_temp, mass_comp_12_pipe, twobody_pt_comp_12, twobody_pt_comp_12_temp, twobody_pt_comp_12_pipe : 
        std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
    signal deta_comp_13, deta_comp_13_temp, deta_comp_13_pipe, dphi_comp_13, dphi_comp_13_temp, dphi_comp_13_pipe, dr_comp_13, dr_comp_13_temp, dr_comp_13_pipe, mass_comp_13, mass_comp_13_temp, mass_comp_13_pipe, twobody_pt_comp_13, twobody_pt_comp_13_temp, twobody_pt_comp_13_pipe : 
        std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
    signal condition_and_or : std_logic;
    
begin

    calo1_obj_l: for i in slice_low_obj1 to slice_high_obj1 generate
        calo1_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_obj1, type_obj1,
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
                iso_lut_obj1
            )
            port map(calo1(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    obj_2plus1_true_comb_i: if obj_2plus1 = true generate
        calo2_obj_l: for i in slice_low_obj2 to slice_high_obj2 generate
            calo2_comp_i: entity work.calo_comparators
                generic map(pt_ge_mode_obj2, type_obj2,
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
                    iso_lut_obj2
                )
                port map(calo2(i), calo2_obj_vs_templ(i,1));
        end generate calo2_obj_l;
    end generate obj_2plus1_true_comb_i;

    calo3_obj_l: for i in slice_low_obj3 to slice_high_obj3 generate
        calo3_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_obj3, type_obj3,
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
                iso_lut_obj3
            )
            port map(calo3(i), calo3_obj_vs_templ(i,1));
    end generate calo3_obj_l;

    cuts_orm_13_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
        cuts_orm_13_l_2: for k in slice_low_obj3 to slice_high_obj3 generate
            deta_orm_cut_i: if deta_orm_cut = true generate
                deta_orm_comp_13(i,k) <= '1' when deta_orm(i,k) >= deta_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                                     deta_orm(i,k) <= deta_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
            end generate deta_orm_cut_i;
            dphi_orm_cut_i: if dphi_orm_cut = true generate
                dphi_orm_comp_13(i,k) <= '1' when dphi_orm(i,k) >= dphi_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                                     dphi_orm(i,k) <= dphi_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
            end generate dphi_orm_cut_i;
            dr_orm_cut_i: if dr_orm_cut = true generate
                dr_calculator_i: entity work.dr_calculator
                generic map(
                    upper_limit_vector => dr_orm_upper_limit_vector,
                    lower_limit_vector => dr_orm_lower_limit_vector
                )
                port map(
                    deta => deta_orm(i,k),
                    dphi => dphi_orm(i,k),
                    dr_comp => dr_orm_comp_13(i,k)
                );
            end generate dr_orm_cut_i;
        end generate cuts_orm_13_l_2;
    end generate cuts_orm_13_l_1;

    cuts_orm_2plus1_true_i: if obj_2plus1 = true generate
        cuts_orm_23_l_1: for i in slice_low_obj2 to slice_high_obj2 generate 
            cuts_orm_23_l_2: for k in slice_low_obj3 to slice_high_obj3 generate
                deta_orm_cut_i: if deta_orm_cut = true generate
                    deta_orm_comp_23(i,k) <= '1' when deta_orm(i,k) >= deta_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and deta_orm(i,k) <= deta_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
                end generate deta_orm_cut_i;
                dphi_orm_cut_i: if dphi_orm_cut = true generate
                    dphi_orm_comp_23(i,k) <= '1' when dphi_orm(i,k) >= dphi_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and dphi_orm(i,k) <= dphi_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
                end generate dphi_orm_cut_i;
                dr_orm_cut_i: if dr_orm_cut = true generate
                    dr_calculator_i: entity work.dr_calculator
                    generic map(
                        upper_limit_vector => dr_orm_upper_limit_vector,
                        lower_limit_vector => dr_orm_lower_limit_vector
                    )
                    port map(
                        deta => deta_orm(i,k),
                        dphi => dphi_orm(i,k),
                        dr_comp => dr_orm_comp_23(i,k)
                    );
                end generate dr_orm_cut_i;
            end generate cuts_orm_23_l_2;
        end generate cuts_orm_23_l_1;
    end generate cuts_orm_2plus1_true_i;

    obj_2plus1_true_cuts_i: if obj_2plus1 = true generate
        cuts_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
            cuts_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                cuts_instances_i: entity work.cuts_instances
                    generic map(
                            deta_cut => deta_cut,
                            dphi_cut => dphi_cut,
                            dr_cut => dr_cut,
                            mass_cut => mass_cut,
                            mass_type => mass_type,
                            twobody_pt_cut => twobody_pt_cut,
                            deta_upper_limit_vector => deta_upper_limit_vector,
                            deta_lower_limit_vector => deta_lower_limit_vector,
                            dphi_upper_limit_vector => dphi_upper_limit_vector,
                            dphi_lower_limit_vector => dphi_lower_limit_vector,
                            dr_upper_limit_vector => dr_upper_limit_vector,
                            dr_lower_limit_vector => dr_lower_limit_vector,
                            mass_upper_limit_vector => mass_upper_limit_vector,
                            mass_lower_limit_vector => mass_lower_limit_vector,
                            pt1_width => pt1_width, 
                            pt2_width => pt2_width, 
                            cosh_cos_precision => mass_cosh_cos_precision,
                            cosh_cos_width => cosh_cos_width,
                            pt_sq_threshold_vector => pt_sq_threshold_vector,
                            sin_cos_width => sin_cos_width,
                            pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                    )
                    port map(
                        deta => deta(i,j),
                        dphi => dphi(i,j),
                        pt1 => pt1(i),
                        pt2 => pt2(j),
                        cosh_deta => cosh_deta(i,j),
                        cos_dphi => cos_dphi(i,j),
                        cos_phi_1_integer => cos_phi_1_integer(i),
                        cos_phi_2_integer => cos_phi_2_integer(j),
                        sin_phi_1_integer => sin_phi_1_integer(i),
                        sin_phi_2_integer => sin_phi_2_integer(j),
                        deta_comp => deta_comp_12(i,j),
                        dphi_comp => dphi_comp_12(i,j),
                        dr_comp => dr_comp_12(i,j),
                        mass_comp => mass_comp_12(i,j),
                        twobody_pt_comp => twobody_pt_comp_12(i,j)
                    );
            end generate cuts_l_2;
        end generate cuts_l_1;
    end generate obj_2plus1_true_cuts_i;

    obj_2plus1_false_cuts_i: if obj_2plus1 = false generate
        cuts_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
            cuts_l_2: for j in slice_low_obj3 to slice_high_obj3 generate
                cuts_instances_i: entity work.cuts_instances
                    generic map(
                            deta_cut => deta_cut,
                            dphi_cut => dphi_cut,
                            dr_cut => dr_cut,
                            mass_cut => mass_cut,
                            mass_type => mass_type,
                            twobody_pt_cut => twobody_pt_cut,
                            deta_upper_limit_vector => deta_upper_limit_vector,
                            deta_lower_limit_vector => deta_lower_limit_vector,
                            dphi_upper_limit_vector => dphi_upper_limit_vector,
                            dphi_lower_limit_vector => dphi_lower_limit_vector,
                            dr_upper_limit_vector => dr_upper_limit_vector,
                            dr_lower_limit_vector => dr_lower_limit_vector,
                            mass_upper_limit_vector => mass_upper_limit_vector,
                            mass_lower_limit_vector => mass_lower_limit_vector,
                            pt1_width => pt1_width, 
                            pt2_width => pt2_width, 
                            cosh_cos_precision => mass_cosh_cos_precision,
                            cosh_cos_width => cosh_cos_width,
                            pt_sq_threshold_vector => pt_sq_threshold_vector,
                            sin_cos_width => sin_cos_width,
                            pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                    )
                    port map(
                        deta => deta(i,j),
                        dphi => dphi(i,j),
                        pt1 => pt1(i),
                        pt2 => pt2(j),
                        cosh_deta => cosh_deta(i,j),
                        cos_dphi => cos_dphi(i,j),
                        cos_phi_1_integer => cos_phi_1_integer(i),
                        cos_phi_2_integer => cos_phi_2_integer(j),
                        sin_phi_1_integer => sin_phi_1_integer(i),
                        sin_phi_2_integer => sin_phi_2_integer(j),
                        deta_comp => deta_comp_13(i,j),
                        dphi_comp => dphi_comp_13(i,j),
                        dr_comp => dr_comp_13(i,j),
                        mass_comp => mass_comp_13(i,j),
                        twobody_pt_comp => twobody_pt_comp_13(i,j)
                    );
            end generate cuts_l_2;
        end generate cuts_l_1;
    end generate obj_2plus1_false_cuts_i;

    comb_cuts_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ, calo3_obj_vs_templ, deta_orm_comp_13, dphi_orm_comp_13, dr_orm_comp_13, deta_orm_comp_23, dphi_orm_comp_23, dr_orm_comp_23, deta_comp_12, dphi_comp_12, dr_comp_12, mass_comp_12, twobody_pt_comp_12, deta_comp_13, dphi_comp_13, dr_comp_13, mass_comp_13, twobody_pt_comp_13)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
            deta_orm_comp_13_pipe <= deta_orm_comp_13;
            dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
            dr_orm_comp_13_pipe <= dr_orm_comp_13;
            deta_orm_comp_23_pipe <= deta_orm_comp_23;
            dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
            dr_orm_comp_23_pipe <= dr_orm_comp_23;
            deta_comp_12_pipe <= deta_comp_12;
            dphi_comp_12_pipe <= dphi_comp_12;
            dr_comp_12_pipe <= dr_comp_12;
            mass_comp_12_pipe <= mass_comp_12;
            twobody_pt_comp_12_pipe <= twobody_pt_comp_12;
            deta_comp_13_pipe <= deta_comp_13;
            dphi_comp_13_pipe <= dphi_comp_13;
            dr_comp_13_pipe <= dr_comp_13;
            mass_comp_13_pipe <= mass_comp_13;
            twobody_pt_comp_13_pipe <= twobody_pt_comp_13;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
                calo3_obj_vs_templ_pipe <= calo3_obj_vs_templ;
                deta_orm_comp_13_pipe <= deta_orm_comp_13;
                dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
                dr_orm_comp_13_pipe <= dr_orm_comp_13;
                deta_orm_comp_23_pipe <= deta_orm_comp_23;
                dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
                dr_orm_comp_23_pipe <= dr_orm_comp_23;
                deta_comp_12_pipe <= deta_comp_12;
                dphi_comp_12_pipe <= dphi_comp_12;
                dr_comp_12_pipe <= dr_comp_12;
                mass_comp_12_pipe <= mass_comp_12;
                twobody_pt_comp_12_pipe <= twobody_pt_comp_12;
                deta_comp_13_pipe <= deta_comp_13;
                dphi_comp_13_pipe <= dphi_comp_13;
                dr_comp_13_pipe <= dr_comp_13;
                mass_comp_13_pipe <= mass_comp_13;
                twobody_pt_comp_13_pipe <= twobody_pt_comp_13;
            end if;
        end if;
    end process;
    
-- HB 2017-03-27: values of orm cuts between orm limits -> removal !!!
    obj_2plus1_true_matrix_i: if obj_2plus1 = true generate
        matrix_and_or_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, calo3_obj_vs_templ_pipe, deta_orm_comp_13_pipe, dphi_orm_comp_13_pipe, dr_orm_comp_13_pipe, deta_orm_comp_23_pipe, dphi_orm_comp_23_pipe, dr_orm_comp_23_pipe, deta_comp_12_pipe, dphi_comp_12_pipe, dr_comp_12_pipe, mass_comp_12_pipe, twobody_pt_comp_12_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec, orm_vec: std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) :=
                (others => (others => (others => '0')));
            variable obj_vs_templ_or_tmp, obj_vs_templ_orm_vec, orm_vec_or_tmp: std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
            variable obj_vs_templ_orm_idx_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := 
                (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => (others => (others => '0')));
            obj_vs_templ_or_tmp := (others => (others => '0'));
            obj_vs_templ_orm_vec := (others => (others => '0'));
            obj_vs_templ_orm_idx_vec := (others => '0');
            orm_vec := (others => (others => (others => '0')));
            orm_vec_or_tmp := (others => (others => '0'));
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop 
                for j in slice_low_obj2 to slice_high_obj2 loop
                    if j/=i then
                        for k in slice_low_obj3 to slice_high_obj3 loop
                            obj_vs_templ_vec(i,j,k) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and calo3_obj_vs_templ_pipe(k,1) and
                                                      mass_comp_12_pipe(i,j) and dr_comp_12_pipe(i,j) and dphi_comp_12_pipe(i,j) and 
                                                      deta_comp_12_pipe(i,j) and twobody_pt_comp_12_pipe(i,j);
                            sim_obj_vs_templ_vec(i,j,k) <= obj_vs_templ_vec(i,j,k);
                            orm_vec(i,j,k) := (dr_orm_comp_13_pipe(i,k) or dr_orm_comp_23_pipe(j,k) or dphi_orm_comp_13_pipe(i,k) or
                                              dphi_orm_comp_23_pipe(j,k) or deta_orm_comp_13_pipe(i,k) or deta_orm_comp_23_pipe(j,k)) and
                                              calo3_obj_vs_templ_pipe(k,1);
                            sim_orm_vec(i,j,k) <= orm_vec(i,j,k);                          
                            orm_vec_or_tmp(i,j) := orm_vec_or_tmp(i,j) or orm_vec(i,j,k);
                            obj_vs_templ_or_tmp(i,j) := obj_vs_templ_or_tmp(i,j) or obj_vs_templ_vec(i,j,k);
                            sim_orm_vec_or_tmp(i,j) <= orm_vec_or_tmp(i,j);
                            sim_obj_vs_templ_or_tmp(i,j) <= obj_vs_templ_or_tmp(i,j);
                        end loop;
                        index := index + 1;
                        obj_vs_templ_orm_vec(i,j) := obj_vs_templ_or_tmp(i,j) and not orm_vec_or_tmp(i,j);
                        sim_obj_vs_templ_orm_vec(i,j) <= obj_vs_templ_orm_vec(i,j);
                        obj_vs_templ_orm_idx_vec(index) := obj_vs_templ_orm_vec(i,j);
                    end if;
                end loop;
            end loop;        
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_orm_idx_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;
    end generate obj_2plus1_true_matrix_i;

    obj_2plus1_false_matrix_i: if obj_2plus1 = false generate
        matrix_and_or_p: process(calo1_obj_vs_templ_pipe, calo3_obj_vs_templ_pipe, deta_orm_comp_13_pipe, dphi_orm_comp_13_pipe, dr_orm_comp_13_pipe, deta_comp_13_pipe, dphi_comp_13_pipe, dr_comp_13_pipe, mass_comp_13_pipe, twobody_pt_comp_13_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj3-slice_low_obj3+1)) downto 1) := 
                (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop 
                for j in slice_low_obj3 to slice_high_obj3 loop
                    index := index + 1;
                    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo3_obj_vs_templ_pipe(j,1) and
                                              mass_comp_13_pipe(i,j) and dr_comp_13_pipe(i,j) and dphi_comp_13_pipe(i,j) and deta_comp_13_pipe(i,j) and twobody_pt_comp_13_pipe(i,j) and
                                              not ((dr_orm_comp_13_pipe(i,j) or dphi_orm_comp_13_pipe(i,j) or deta_orm_comp_13_pipe(i,j)) and calo3_obj_vs_templ_pipe(j,1));
                end loop;
            end loop;        
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;
    end generate obj_2plus1_false_matrix_i;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
        begin
            if conditions_pipeline_stage = false then 
                condition_o <= condition_and_or;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;
    
end architecture rtl;
