
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
        mass_type: natural := TRANSVERSE_MASS_TYPE;
        mass_vector_width: natural;
        tbpt_cut: boolean := false;
        tbpt_vector_width: natural;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        tbpt_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');

        type_obj1: natural;
        nr_obj1: natural

    );
    port(
        lhc_clk: in std_logic;
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        obj1_vs_requ: in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to 0) := (others => (others => (others => '0')));
        mass_trans : in mass_dim2_array(0 to nr_obj1-1, 0 to 0) := (others => (others => (others => '0')));
        tbpt: in tbpt_dim2_array(0 to nr_obj1-1, 0 to 0) := (others => (others => (others => '0')));
        condition_and_or: out std_logic
    );
end esums_4_corr_cond;

architecture rtl of esums_4_corr_cond is

    signal esums_comp, esums_comp_pipe : std_logic := '0';
    signal dphi_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 0 to 0) := (others => (others => '1'));

begin

    corr_cuts_comp_i: entity work.correlation_cuts_wrapper
        generic map(
            nr_obj1 => nr_obj1,
            type_obj1 => type_obj1,
            nr_obj2 => 1,
            type_obj2 => obj_type_esums,
            slice_low_obj1 => slice_low_obj1,
            slice_high_obj1 => slice_high_obj1,
            slice_low_obj2 => 0,
            slice_high_obj2 => 0,
            dphi_cut => dphi_cut,
            dphi_upper_limit_vector => dphi_upper_limit_vector,
            dphi_lower_limit_vector => dphi_lower_limit_vector,
            mass_cut => mass_cut,
            mass_type => mass_type,
            mass_vector_width => mass_vector_width,
            mass_upper_limit_vector => mass_upper_limit_vector,
            mass_lower_limit_vector => mass_lower_limit_vector,
            tbpt_cut => tbpt_cut,
            tbpt_vector_width => tbpt_vector_width,
            tbpt_threshold_vector => tbpt_threshold_vector,
            same_bx => false
        )
        port map(
            lhc_clk,
            dphi => dphi,
            mass_trans => mass_trans,
            tbpt => tbpt,
            dphi_comp_o => dphi_comp_pipe,
            mass_comp_o => mass_comp_pipe,
            tbpt_comp_o => twobody_pt_comp_pipe
        );

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

    pipeline_p: process(lhc_clk, esums_comp)
        begin
        if INTERMEDIATE_PIPELINE = false then
            esums_comp_pipe <= esums_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                esums_comp_pipe <= esums_comp;
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
