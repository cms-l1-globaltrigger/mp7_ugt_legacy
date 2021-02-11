
-- Description:
-- Correlation cuts module

-- Version history:
-- HB 2021-02-11: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity correlation_cuts is
     generic(
        slice_low_obj1: natural;
        slice_high_obj1: natural;
        slice_low_obj2: natural;
        slice_high_obj2: natural;

        deta_cut: boolean := false;
        dphi_cut: boolean := false;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        twobody_pt_cut: boolean := false;
        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        pt1_width: positive := MU_PT_VECTOR_WIDTH;
        pt2_width: positive := MU_PT_VECTOR_WIDTH;
        cosh_cos_precision: positive := MU_MU_COSH_COS_PRECISION;
        cosh_cos_width: positive := MU_MU_COSH_COS_VECTOR_WIDTH;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;

        nr_obj1: natural;
        type_obj1: natural;
        nr_obj2: natural;
        type_obj2: natural;

        same_bx: boolean
    );
    port(
        lhc_clk: in std_logic;
        deta: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2: in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        cosh_deta: in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi: in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_1_integer: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_2_integer: in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_1_integer: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_2_integer: in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        invariant_mass: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')));
        deta_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dphi_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dr_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        twobody_pt_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'))
    );
end correlation_cuts;

architecture rtl of correlation_cuts is

-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp, deta_comp_temp, dphi_comp, dphi_comp_temp, dr_comp, dr_comp_temp, mass_comp, mass_comp_temp, twobody_pt_comp, twobody_pt_comp_temp : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
    signal invariant_mass_temp : mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')));

begin

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
                            cosh_cos_precision => cosh_cos_precision,
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
                            cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                            cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
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
                        cosh_cos_precision => cosh_cos_precision,
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
                        cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                        cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
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

    pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_comp, twobody_pt_comp)
        begin
        if INTERMEDIATE_PIPELINE = false then
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                deta_comp_pipe <= deta_comp;
                dphi_comp_pipe <= dphi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
        end if;
    end process;

end architecture rtl;
