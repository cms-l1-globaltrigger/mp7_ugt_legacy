
-- Description:
-- Correlation cuts module

-- Version history:
-- HB 2021-02-12: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity esums_4_corr_cond is
     generic(
        slice_low_obj1: natural;
        slice_high_obj1: natural;

        obj_type_esums: natural := ETM_TYPE;
        et_ge_mode_esums: boolean := true;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_esums: natural := 0;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type : natural := TRANSVERSE_MASS_TYPE;
        twobody_pt_cut: boolean := false;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        pt1_width: positive := MU_PT_VECTOR_WIDTH;
        pt2_width: positive := ETM_PT_VECTOR_WIDTH;
        cosh_cos_precision: positive := MU_ETM_COSH_COS_PRECISION;
        cosh_cos_width: positive := MU_ETM_COSH_COS_VECTOR_WIDTH;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_ETM_SIN_COS_PRECISION;

        nr_obj1: natural

    );
    port(
        lhc_clk: in std_logic;
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        obj1_vs_requ: in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to 0) := (others => (others => (others => '0')));
        pt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2: in diff_inputs_array(0 to 0) := (others => (others => '0'));
        cos_dphi: in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to 0) := (others => (others => (others => '0')));
        cos_phi_1_integer: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_2_integer: in sin_cos_integer_array(0 to 0) := (others => 0);
        sin_phi_1_integer: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_2_integer: in sin_cos_integer_array(0 to 0) := (others => 0);
        condition_and_or: out std_logic
    );
end esums_4_corr_cond;

architecture rtl of esums_4_corr_cond is

    signal esums_comp, esums_comp_pipe : std_logic := '0';
    signal dphi_comp, dphi_comp_pipe, mass_comp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 0 to 0) := (others => (others => '1'));

begin

    -- correlation cuts comparators
    delta_l: for i in slice_low_obj1 to slice_high_obj1 generate
    -- delta phi comparator
        dphi_i: if dphi_cut = true generate
            dphi_comp(i,0) <= '1' when dphi(i,0) >= dphi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and
                dphi(i,0) <= dphi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
        end generate dphi_i;
    -- mass comparator
        mass_i: if mass_cut = true generate
            mass_calculator_i: entity work.mass_calculator
                generic map(
                    mass_type => mass_type,
                    mass_upper_limit_vector => mass_upper_limit_vector,
                    mass_lower_limit_vector => mass_lower_limit_vector,
                    pt1_width => pt1_width,
                    pt2_width => pt2_width,
                    cosh_cos_width => cosh_cos_width,
                    mass_cosh_cos_precision => cosh_cos_precision
                )
                port map(
                    pt1 => pt1(i)(pt1_width-1 downto 0),
                    pt2 => pt2(0)(pt2_width-1 downto 0),
                    cos_dphi => cos_dphi(i,0)(cosh_cos_width-1 downto 0),
                    mass_comp => mass_comp(i,0)
                );
        end generate mass_i;
    -- two-body pt comparator
        twobody_pt_i: if twobody_pt_cut = true generate
            twobody_pt_calculator_i: entity work.twobody_pt_calculator
                generic map(
                    pt1_width => pt1_width,
                    pt2_width => pt2_width,
                    pt_sq_threshold_vector => pt_sq_threshold_vector,
                    sin_cos_width => sin_cos_width,
                    pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                )
                port map(
                    pt1 => pt1(i)(pt1_width-1 downto 0),
                    pt2 => pt2(0)(pt2_width-1 downto 0),
                    cos_phi_1_integer => cos_phi_1_integer(i),
                    cos_phi_2_integer => cos_phi_2_integer(0),
                    sin_phi_1_integer => sin_phi_1_integer(i),
                    sin_phi_2_integer => sin_phi_2_integer(0),
                    pt_square_comp => twobody_pt_comp(i,0)
            );
        end generate twobody_pt_i;
    end generate delta_l;

    -- object cuts comparators
    esums_comparators_i: entity work.esums_comparators
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

    pipeline_p: process(lhc_clk, dphi_comp, mass_comp, twobody_pt_comp)
        begin
        if INTERMEDIATE_PIPELINE = false then
            esums_comp_pipe <= esums_comp;
            dphi_comp_pipe <= dphi_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                esums_comp_pipe <= esums_comp;
                dphi_comp_pipe <= dphi_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_dphi_mass_p: process(obj1_vs_requ, esums_comp_pipe, dphi_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in slice_low_obj1 to slice_high_obj1 loop
                index := index + 1;
                obj_vs_templ_vec(index) := obj1_vs_requ(i,1) and esums_comp_pipe and dphi_comp_pipe(i,0) and mass_comp_pipe(i,0) and twobody_pt_comp_pipe(i,0);
        end loop;
        for i in 1 to index loop
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_dphi_mass_p;

end architecture rtl;
