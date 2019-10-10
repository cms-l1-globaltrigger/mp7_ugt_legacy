
-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and esums (etm, etm_hf and htm).

-- Version history:
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_esums_correlation_condition_v3 to calo_esums_correlation_condition.
-- HB 2017-10-02: based on calo_esums_correlation_condition_v2 - used limit vectors for correlation cuts (mass_calculator_v2 and twobody_pt_calculator_v2 used).
-- HB 2017-04-26: removed assert statement.
-- HB 2017-04-25: "twobody_pt" detached from "mass fixation". Used "mass_calculator.vhd" and "twobody_pt_calculator.vhd".
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DPHI). Using integer for cos and sin phi inputs.
-- HB 2017-02-01: used "calo_object_low" and "calo_object_high" for object ranges.
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2016-12-20: first design of version 2 - implemented transverse mass

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_esums_correlation_condition is
     generic(

        dphi_cut: boolean;
        mass_cut: boolean;
        mass_type : natural;
        twobody_pt_cut: boolean;

        calo_object_low: natural;
        calo_object_high: natural;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := EG_TYPE;
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

        et_ge_mode_esums: boolean;
        obj_type_esums: natural := ETM_TYPE;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_full_range_esums: boolean;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_esums: boolean;
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);

        diff_phi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_phi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);

        pt1_width: positive; 
        pt2_width: positive; 
        mass_cosh_cos_precision : positive;
        cosh_cos_width: positive;

        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0);
        sin_cos_width: positive;
        pt_sq_sin_cos_precision : positive

    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        esums_data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
        cos_dphi : in calo_cosh_cos_vector_array;
        cos_phi_1_integer : in sin_cos_integer_array;
        cos_phi_2_integer : in sin_cos_integer_array;
        sin_phi_1_integer : in sin_cos_integer_array;
        sin_phi_2_integer : in sin_cos_integer_array;
        condition_o: out std_logic
    );
end calo_esums_correlation_condition;

architecture rtl of calo_esums_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_vs_template_array is array (calo_object_low to calo_object_high, 1 to 1) of std_logic;

    signal cosh_deta_zero_vector: calo_cosh_cos_vector_array(calo_object_low to calo_object_high, 0 to 0) := (others => (others => (others => '0')));

    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal diff_phi_comp, diff_phi_comp_pipe, mass_comp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo_object_low to calo_object_high, 0 to 0) := (others => (others => '1'));

    signal esums_comp_o, esums_comp_o_pipe : std_logic;
    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************
    -- Comparison with limits.
    delta_l: for i in calo_object_low to calo_object_high generate
        diff_phi_i: if dphi_cut = true generate
            diff_phi_comp(i,0) <= '1' when diff_phi(i,0) >= diff_phi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                                  diff_phi(i,0) <= diff_phi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
        end generate diff_phi_i;
        mass_i: if mass_cut = true generate
            mass_calculator_i: entity work.mass_calculator
                generic map(
                    mass_type => mass_type,
                    mass_upper_limit_vector => mass_upper_limit_vector,
                    mass_lower_limit_vector => mass_lower_limit_vector,
                    pt1_width => pt1_width, 
                    pt2_width => pt2_width, 
                    cosh_cos_width => cosh_cos_width,
                    mass_cosh_cos_precision => mass_cosh_cos_precision
                )
                port map(
                    pt1 => pt1(i)(pt1_width-1 downto 0),
                    pt2 => pt2(0)(pt2_width-1 downto 0),
                    cosh_deta => cosh_deta_zero_vector(i,0),
                    cos_dphi => cos_dphi(i,0),
                    mass_comp => mass_comp(i,0)
                );
        end generate mass_i;
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

    -- Pipeline stage for cut comps
    diff_pipeline_p: process(lhc_clk, diff_phi_comp, mass_comp, twobody_pt_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
            diff_phi_comp_pipe <= diff_phi_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                diff_phi_comp_pipe <= diff_phi_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    obj_templ1_l: for i in calo_object_low to calo_object_high generate
        obj_templ1_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo, obj_type_calo,
                et_threshold_calo,
                nr_eta_windows_calo,
                eta_w1_upper_limit_calo,
                eta_w1_lower_limit_calo,
                eta_w2_upper_limit_calo,
                eta_w2_lower_limit_calo,
                eta_w3_upper_limit_calo,
                eta_w3_lower_limit_calo,
                eta_w4_upper_limit_calo,
                eta_w4_lower_limit_calo,
                eta_w5_upper_limit_calo,
                eta_w5_lower_limit_calo,
                phi_full_range_calo,
                phi_w1_upper_limit_calo,
                phi_w1_lower_limit_calo,
                phi_w2_ignore_calo,
                phi_w2_upper_limit_calo,
                phi_w2_lower_limit_calo,
                iso_lut_calo
            )
            port map(calo_data_i(i), obj_vs_templ(i,1));
    end generate obj_templ1_l;

    esums_comparators_i: entity work.esums_comparators
        generic map(
            et_ge_mode => et_ge_mode_esums,
            obj_type => obj_type_esums,
            et_threshold => et_threshold_esums,
            phi_full_range => phi_full_range_esums,
            phi_w1_upper_limit => phi_w1_upper_limit_esums,
            phi_w1_lower_limit => phi_w1_lower_limit_esums,
            phi_w2_ignore => phi_w2_ignore_esums,
            phi_w2_upper_limit => phi_w2_upper_limit_esums,
            phi_w2_lower_limit => phi_w2_lower_limit_esums
        )
        port map(
            data_i => esums_data_i,
            comp_o => esums_comp_o
        );

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_vs_templ, esums_comp_o)
    begin
        if obj_vs_templ_pipeline_stage = false then
            obj_vs_templ_pipe <= obj_vs_templ;
            esums_comp_o_pipe <= esums_comp_o;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                obj_vs_templ_pipe <= obj_vs_templ;
                esums_comp_o_pipe <= esums_comp_o;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_dphi_mass_p: process(obj_vs_templ_pipe, esums_comp_o_pipe, diff_phi_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((calo_object_high-calo_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop
                index := index + 1;
                obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and esums_comp_o_pipe and diff_phi_comp_pipe(i,0) and mass_comp_pipe(i,0) and twobody_pt_comp_pipe(i,0);
        end loop;
        for i in 1 to index loop
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_dphi_mass_p;

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









