
-- Description:
-- Correlation Condition module for:
-- 1. two calorimeter objects (eg, jet and tau).
-- 2. one or two calorimeter objects with calo overlap removal.
-- 3. mass for 3 objects (same type).
-- 4. calo esums.

-- Version history:
-- HB 2020-01-27: added calo esums correlation.
-- HB 2020-01-15: added mass for 3 objects (same type).
-- HB 2020-01-15: new design correlation_conditions_calo with and without overlap removal in one module.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity correlation_conditions_calo is
     generic(

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
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

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := 0; -- for esums as "obj2"
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

        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_JET_OBJECTS-1;
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

        sel_esums: boolean := false;
        obj_type_esums: natural := ETM_TYPE;
        et_ge_mode_esums: boolean := true;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_esums: natural := 0;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');

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
        mass_div_dr_vector_width: positive := EG_EG_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := EG_EG_COSH_COS_PRECISION;
        cosh_cos_width: positive := COMMON_COSH_COS_VECTOR_WIDTH;

        twobody_pt_cut: boolean := false;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := EG_EG_SIN_COS_PRECISION;

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
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;
        nr_obj3: natural := NR_JET_OBJECTS;
        type_obj3: natural := JET_TYPE;

        obj_2plus1: boolean := true;
        mass_3_obj: boolean := false;
        same_bx: boolean := false 

    );
    port(
        lhc_clk: in std_logic;
        obj1: in calo_objects_array(0 to nr_obj1-1) := (others => (others => '0'));
        obj2: in calo_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        obj3: in calo_objects_array(0 to nr_obj3-1) := (others => (others => '0'));
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        deta_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj3-1) := (others => (others => (others => '0')));
        dphi_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj3-1) := (others => (others => (others => '0')));
        deta: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        cosh_deta : in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi : in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        mass_div_dr : in mass_div_dr_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end correlation_conditions_calo; 

architecture rtl of correlation_conditions_calo is

-- fixed pipeline structure
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    constant mass_vector_width: positive := pt1_width+pt1_width+cosh_cos_width; 
    type sum_mass_array is array(0 to nr_obj1-1, 0 to nr_obj1-1, 0 to nr_obj1-1) of std_logic_vector(mass_vector_width+1 downto 0);
    signal sum_mass, sum_mass_temp : sum_mass_array := (others => (others => (others => (others => '0'))));   

    signal deta_orm_comp_12, deta_orm_comp_12_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal deta_orm_comp_13, deta_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal deta_orm_comp_23, deta_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dphi_orm_comp_12, dphi_orm_comp_12_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal dphi_orm_comp_13, dphi_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dphi_orm_comp_23, dphi_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dr_orm_comp_12, dr_orm_comp_12_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
    signal dr_orm_comp_13, dr_orm_comp_13_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal dr_orm_comp_23, dr_orm_comp_23_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '0'));
    signal obj1_vs_templ, obj1_vs_templ_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
    signal obj2_vs_templ, obj2_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
    signal obj3_vs_templ, obj3_vs_templ_pipe : std_logic_2dim_array(slice_low_obj3 to slice_high_obj3, 1 to 1) := (others => (others => '0'));
    signal esums_comp, esums_comp_pipe : std_logic := '0';
-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp, deta_comp_temp, deta_comp_pipe, dphi_comp, dphi_comp_temp, dphi_comp_pipe, dr_comp, dr_comp_temp, dr_comp_pipe, mass_comp, mass_comp_temp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) :=
    (others => (others => '1'));
    signal invariant_mass, invariant_mass_temp, invariant_mass_pipe : mass_dim2_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => (others => '0')));
    signal mass_3_obj_comp, mass_3_obj_comp_pipe : 
        std_logic_3dim_array(0 to nr_obj1-1, 0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')));
    signal condition_and_or : std_logic;
    
begin
    
    obj1_l: for i in slice_low_obj1 to slice_high_obj1 generate
        obj1_comp_i: entity work.calo_comparators
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
            port map(obj1(i), obj1_vs_templ(i,1));
    end generate obj1_l;

    comp_obj2_sel: if not sel_esums generate
        obj2_l: for i in slice_low_obj2 to slice_high_obj2 generate
            obj2_comp_i: entity work.calo_comparators
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
                port map(obj2(i), obj2_vs_templ(i,1));
        end generate obj2_l;
    end generate comp_obj2_sel;

    comp_esums_sel: if sel_esums generate
        esums_comp_i: entity work.esums_comparators
            generic map(
                et_ge_mode => et_ge_mode_esums,
                obj_type => obj_type_esums,
                et_threshold => et_threshold_esums,
                nr_phi_windows => nr_phi_windows_esums,
                phi_w1_upper_limit => phi_w1_upper_limit_esums,
                phi_w1_lower_limit => phi_w1_lower_limit_esums,
                phi_w2_upper_limit => phi_w2_upper_limit_esums,
                phi_w2_lower_limit => phi_w2_lower_limit_esums
            )
            port map(
                data_i => esums,
                comp_o => esums_comp
            );
    end generate comp_esums_sel;

    cuts_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
        cuts_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
            same_obj_bx_range_i: if type_obj1 = type_obj2 and same_bx and (slice_low_obj1 = slice_low_obj2) and (slice_high_obj1 = slice_high_obj2) generate
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations of cuts only for one half of permutations, second half by assignment of "mirrored" indices.
                if_j_gr_i: if j > i generate
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
                            deta_comp => deta_comp_temp(i,j),
                            dphi_comp => dphi_comp_temp(i,j),
                            dr_comp => dr_comp_temp(i,j),
                            mass_comp => mass_comp_temp(i,j),
                            invariant_mass => invariant_mass_temp(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0),
                            twobody_pt_comp => twobody_pt_comp_temp(i,j)
                        );
                    deta_comp(i,j) <= deta_comp_temp(i,j);
                    deta_comp(j,i) <= deta_comp_temp(i,j);
                    dphi_comp(i,j) <= dphi_comp_temp(i,j);
                    dphi_comp(j,i) <= dphi_comp_temp(i,j);
                    dr_comp(i,j) <= dr_comp_temp(i,j);
                    dr_comp(j,i) <= dr_comp_temp(i,j);
                    mass_comp(i,j) <= mass_comp_temp(i,j);
                    mass_comp(j,i) <= mass_comp_temp(i,j);
                    invariant_mass(i,j) <= invariant_mass_temp(i,j);
                    invariant_mass(j,i) <= invariant_mass_temp(i,j);
                    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
                end generate if_j_gr_i;
            end generate same_obj_bx_range_i;
            
            diffrent_obj_bx_range_i: if type_obj1 /= type_obj2 or not same_bx or (slice_low_obj1 /= slice_low_obj2) or (slice_high_obj1 /= slice_high_obj2) generate
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
                        deta_comp => deta_comp(i,j),
                        dphi_comp => dphi_comp(i,j),
                        dr_comp => dr_comp(i,j),
                        mass_comp => mass_comp(i,j),
                        invariant_mass => invariant_mass(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0),
                        twobody_pt_comp => twobody_pt_comp(i,j)
                    );
            end generate diffrent_obj_bx_range_i;
        end generate cuts_l_2;
    end generate cuts_l_1;
    
    pipeline_p: process(lhc_clk, obj1_vs_templ, obj2_vs_templ, obj3_vs_templ, deta_orm_comp_12, dphi_orm_comp_12, dr_orm_comp_12, deta_orm_comp_13, dphi_orm_comp_13, dr_orm_comp_13, deta_orm_comp_23, dphi_orm_comp_23, dr_orm_comp_23, deta_comp, dphi_comp, dr_comp, mass_comp, mass_3_obj_comp, twobody_pt_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            obj1_vs_templ_pipe <= obj1_vs_templ;
            obj2_vs_templ_pipe <= obj2_vs_templ;
            obj3_vs_templ_pipe <= obj3_vs_templ;
            esums_comp_pipe <= esums_comp;
            deta_orm_comp_12_pipe <= deta_orm_comp_12;
            dphi_orm_comp_12_pipe <= dphi_orm_comp_12;
            dr_orm_comp_12_pipe <= dr_orm_comp_12;
            deta_orm_comp_13_pipe <= deta_orm_comp_13;
            dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
            dr_orm_comp_13_pipe <= dr_orm_comp_13;
            deta_orm_comp_23_pipe <= deta_orm_comp_23;
            dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
            dr_orm_comp_23_pipe <= dr_orm_comp_23;
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            mass_3_obj_comp_pipe <= mass_3_obj_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                obj1_vs_templ_pipe <= obj1_vs_templ;
                obj2_vs_templ_pipe <= obj2_vs_templ;
                obj3_vs_templ_pipe <= obj3_vs_templ;
                esums_comp_pipe <= esums_comp;
                deta_orm_comp_12_pipe <= deta_orm_comp_12;
                dphi_orm_comp_12_pipe <= dphi_orm_comp_12;
                dr_orm_comp_12_pipe <= dr_orm_comp_12;
                deta_orm_comp_13_pipe <= deta_orm_comp_13;
                dphi_orm_comp_13_pipe <= dphi_orm_comp_13;
                dr_orm_comp_13_pipe <= dr_orm_comp_13;
                deta_orm_comp_23_pipe <= deta_orm_comp_23;
                dphi_orm_comp_23_pipe <= dphi_orm_comp_23;
                dr_orm_comp_23_pipe <= dr_orm_comp_23;
                deta_comp_pipe <= deta_comp;
                dphi_comp_pipe <= dphi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                mass_3_obj_comp_pipe <= mass_3_obj_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
        end if;
    end process;
    
-- condition without overlap removal
    no_orm_i: if not(deta_orm_cut and dphi_orm_cut and dr_orm_cut) generate
    
    -- HB 2020-08-27: comparison for invariant mass divided by delta R.
        mass_div_dr_sel: if mass_cut = true and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
            mass_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
                mass_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                    mass_comp_l1: if (type_obj1 = type_obj2) and (same_bx = true) and j>i generate
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
                    mass_comp_l2: if (type_obj1 /= type_obj2) or (same_bx = false) generate
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
    
        matrix_and_or_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, esums_comp_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_comp_pipe, mass_div_dr_comp_pipe, twobody_pt_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop 
                for j in slice_low_obj2 to slice_high_obj2 loop
                    if type_obj1 = type_obj2 and same_bx and not sel_esums then
                        if j/=i then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
                        end if;
                    elsif (type_obj1 /= type_obj2 or not same_bx) and not sel_esums then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
                    elsif sel_esums then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and esums_comp_pipe and dphi_comp_pipe(i,j) and mass_comp_pipe(i,j) and  twobody_pt_comp_pipe(i,j);
                    end if;
                end loop;
            end loop;
            for i in 1 to index loop 
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;
    end generate no_orm_i;

-- comparator for obj3 (two calos with one calo overlap removal or mass 3 objects)
    comp_obj3_i: if ((deta_orm_cut or dphi_orm_cut or dr_orm_cut) and obj_2plus1) or mass_3_obj generate
    
        obj3_l: for i in slice_low_obj3 to slice_high_obj3 generate
            obj3_comp_i: entity work.calo_comparators
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
                port map(obj3(i), obj3_vs_templ(i,1));
        end generate obj3_l;
    end generate comp_obj3_i;

-- condition with overlap removal
    orm_i: if deta_orm_cut or dphi_orm_cut or dr_orm_cut generate
    -- two calos with one calo overlap removal(obj_2plus1 = true)
        obj_2plus1_true_i: if obj_2plus1 = true generate
        
            cuts_orm_13_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
                cuts_orm_13_l_2: for k in slice_low_obj3 to slice_high_obj3 generate
                    deta_orm_cut_i: if deta_orm_cut = true generate
                        deta_orm_comp_13(i,k) <= '1' when deta_orm(i,k) >= deta_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and deta_orm(i,k) <= deta_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
                    end generate deta_orm_cut_i;
                    dphi_orm_cut_i: if dphi_orm_cut = true generate
                        dphi_orm_comp_13(i,k) <= '1' when dphi_orm(i,k) >= dphi_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and dphi_orm(i,k) <= dphi_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
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

            matrix_and_or_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, obj3_vs_templ_pipe, deta_orm_comp_13_pipe, dphi_orm_comp_13_pipe, dr_orm_comp_13_pipe, deta_orm_comp_23_pipe, dphi_orm_comp_23_pipe, dr_orm_comp_23_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
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
                                obj_vs_templ_vec(i,j,k) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and obj3_vs_templ_pipe(k,1) and mass_comp_pipe(i,j) and dr_comp_pipe(i,j) and dphi_comp_pipe(i,j) and deta_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
                                orm_vec(i,j,k) := (dr_orm_comp_13_pipe(i,k) or dr_orm_comp_23_pipe(j,k) or dphi_orm_comp_13_pipe(i,k) or
                                                dphi_orm_comp_23_pipe(j,k) or deta_orm_comp_13_pipe(i,k) or deta_orm_comp_23_pipe(j,k)) and
                                                obj3_vs_templ_pipe(k,1);
                                orm_vec_or_tmp(i,j) := orm_vec_or_tmp(i,j) or orm_vec(i,j,k);
                                obj_vs_templ_or_tmp(i,j) := obj_vs_templ_or_tmp(i,j) or obj_vs_templ_vec(i,j,k);
                            end loop;
                            index := index + 1;
                            obj_vs_templ_orm_vec(i,j) := obj_vs_templ_or_tmp(i,j) and not orm_vec_or_tmp(i,j);
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
        end generate obj_2plus1_true_i;

    -- one calo with one calo overlap removal(obj_2plus1 = false)
        obj_2plus1_false_i: if obj_2plus1 = false generate

            cuts_orm_12_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
                cuts_orm_12_l_2: for k in slice_low_obj2 to slice_high_obj2 generate
                    deta_orm_cut_i: if deta_orm_cut = true generate
                        deta_orm_comp_12(i,k) <= '1' when deta_orm(i,k) >= deta_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                                            deta_orm(i,k) <= deta_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
                    end generate deta_orm_cut_i;
                    dphi_orm_cut_i: if dphi_orm_cut = true generate
                        dphi_orm_comp_12(i,k) <= '1' when dphi_orm(i,k) >= dphi_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
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
                            dr_comp => dr_orm_comp_12(i,k)
                        );
                    end generate dr_orm_cut_i;
                end generate cuts_orm_12_l_2;
            end generate cuts_orm_12_l_1;

            matrix_and_or_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, deta_orm_comp_12_pipe, dphi_orm_comp_12_pipe, dr_orm_comp_12_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
                variable index : integer := 0;
                variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := 
                    (others => '0');
                variable condition_and_or_tmp : std_logic := '0';
            begin
                index := 0;
                obj_vs_templ_vec := (others => '0');
                condition_and_or_tmp := '0';
                for i in slice_low_obj1 to slice_high_obj1 loop 
                    for j in slice_low_obj2 to slice_high_obj2 loop
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and
                                                mass_comp_pipe(i,j) and dr_comp_pipe(i,j) and dphi_comp_pipe(i,j) and deta_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j) and
                                                not ((dr_orm_comp_12_pipe(i,j) or dphi_orm_comp_12_pipe(i,j) or deta_orm_comp_12_pipe(i,j)) and obj2_vs_templ_pipe(j,1));
                    end loop;
                end loop;        
                for i in 1 to index loop 
                    -- ORs for matrix
                    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
                end loop;
                condition_and_or <= condition_and_or_tmp;
            end process;
        end generate obj_2plus1_false_i;
    end generate orm_i;

-- condition with mass of 3 objects
    mass_3_obj_i: if mass_3_obj generate
    
        l1_sum: for i in 0 to nr_obj1-1 generate
            l2_sum: for j in 0 to nr_obj1-1 generate
                l3_sum: for k in 0 to nr_obj1-1 generate
                    sum_mass_l: if j>i and k>i and k>j generate
                        sum_mass_calc_i: entity work.sum_mass_calc
                            generic map(mass_vector_width)  
                            port map(invariant_mass(i,j), invariant_mass(i,k), invariant_mass(j,k), sum_mass_temp(i,j,k));
                        sum_mass(i,j,k) <= sum_mass_temp(i,j,k);
                        sum_mass(i,k,j) <= sum_mass_temp(i,j,k);
                        sum_mass(j,i,k) <= sum_mass_temp(i,j,k);
                        sum_mass(j,k,i) <= sum_mass_temp(i,j,k);
                        sum_mass(k,i,j) <= sum_mass_temp(i,j,k);
                        sum_mass(k,j,i) <= sum_mass_temp(i,j,k);
                    end generate sum_mass_l;
                end generate l3_sum;    
            end generate l2_sum;
        end generate l1_sum;
        
        l1_comp: for i in slice_low_obj1 to slice_high_obj1 generate
            l2_comp: for j in slice_low_obj2 to slice_high_obj2 generate
                l3_comp: for k in slice_low_obj3 to slice_high_obj3 generate
                    mass_3_obj_comp(i,j,k) <= '1' when sum_mass(i,j,k) >= mass_lower_limit_vector(mass_vector_width-1 downto 0) and
                        sum_mass(i,j,k) <= mass_upper_limit_vector(mass_vector_width-1 downto 0) else '0';
                end generate l3_comp;    
            end generate l2_comp;
        end generate l1_comp;
        
        -- "Matrix" of permutations in an and-or-structure.
        matrix_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, obj3_vs_templ_pipe, mass_3_obj_comp_pipe)
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
                                mass_3_obj_comp_pipe(i,j,k);
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
