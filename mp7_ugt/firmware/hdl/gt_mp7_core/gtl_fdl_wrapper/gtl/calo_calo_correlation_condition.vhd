
-- Description:
-- Correlation Condition module for two calorimeter object types (eg, jet and tau).

-- Version history:
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_calo_correlation_condition_v4 to calo_calo_correlation_condition.
-- HB 2017-10-02: added limit vectors for correlation cuts.
-- HB 2017-09-20: changed to calo_calo_correlation_condition_v4 - added mass_upper_limit_vector and mass_lower_limit_vector to generic.
-- HB 2017-09-13: inserted port calo2_data_i again - bug fix.
-- HB 2017-09-05: removed port calo2_data_i, used calo1_data_i instead in logic.
-- HB 2017-08-18: improved cuts_instances loops.
-- HB 2017-07-04: changed to calo_calo_correlation_condition_v3 for correct use of different object slices for same object type.
-- HB 2017-04-20: implemented use of "cuts_instances" module.
-- HB 2017-04-19: "twobody_pt" detached from "mass fixation". Used "mass_calculator.vhd" and "twobody_pt_calculator.vhd".
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations of cuts only for one half of permutations, second half by assignment of "mirrored" indices.
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "calox_object_low" and "calox_object_high" for object ranges.
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2016-12-13: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_calo_correlation_condition is
    generic(
        same_bx: boolean; 
    
        deta_cut: boolean;
        dphi_cut: boolean;
        dr_cut: boolean;
        mass_cut: boolean;
        mass_type : natural;
        twobody_pt_cut: boolean;

        calo1_object_low: natural;
        calo1_object_high: natural;
        et_ge_mode_calo1: boolean;
        obj_type_calo1: natural := EG_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo1 : natural;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1: boolean;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1: boolean;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        calo2_object_low: natural;
        calo2_object_high: natural;
        et_ge_mode_calo2: boolean;
        obj_type_calo2: natural := JET_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo2 : natural;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2: boolean;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2: boolean;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        diff_eta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_eta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        diff_phi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_phi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);

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
        calo1_data_i: in calo_objects_array;
        calo2_data_i: in calo_objects_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
        cosh_deta : in calo_cosh_cos_vector_array;
        cos_dphi : in calo_cosh_cos_vector_array;
        cos_phi_1_integer : in sin_cos_integer_array;
        cos_phi_2_integer : in sin_cos_integer_array;
        sin_phi_1_integer : in sin_cos_integer_array;
        sin_phi_2_integer : in sin_cos_integer_array;
        condition_o: out std_logic
    );
end calo_calo_correlation_condition; 

architecture rtl of calo_calo_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, 1 to 1);
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1);

-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal diff_eta_comp, diff_eta_comp_temp, diff_eta_comp_pipe, diff_phi_comp, diff_phi_comp_temp, diff_phi_comp_pipe, dr_comp, dr_comp_temp, dr_comp_pipe, 
        mass_comp, mass_comp_temp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    -- *** section: CUTs - begin ***************************************************************************************
    
    -- Comparison with limits.
    cuts_l_1: for i in calo1_object_low to calo1_object_high generate 
        cuts_l_2: for j in calo2_object_low to calo2_object_high generate
            same_obj_type_same_bx_same_range_i: if obj_type_calo1 = obj_type_calo2 and same_bx and (calo1_object_low = calo2_object_low) and (calo1_object_high = calo2_object_high) generate
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
                            diff_eta_upper_limit_vector => diff_eta_upper_limit_vector,
                            diff_eta_lower_limit_vector => diff_eta_lower_limit_vector,
                            diff_phi_upper_limit_vector => diff_phi_upper_limit_vector,
                            diff_phi_lower_limit_vector => diff_phi_lower_limit_vector,
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
                            diff_eta => diff_eta(i,j),
                            diff_phi => diff_phi(i,j),
                            pt1 => pt1(i),
                            pt2 => pt2(j),
                            cosh_deta => cosh_deta(i,j),
                            cos_dphi => cos_dphi(i,j),
                            cos_phi_1_integer => cos_phi_1_integer(i),
                            cos_phi_2_integer => cos_phi_2_integer(j),
                            sin_phi_1_integer => sin_phi_1_integer(i),
                            sin_phi_2_integer => sin_phi_2_integer(j),
                            diff_eta_comp => diff_eta_comp_temp(i,j),
                            diff_phi_comp => diff_phi_comp_temp(i,j),
                            dr_comp => dr_comp_temp(i,j),
                            mass_comp => mass_comp_temp(i,j),
                            twobody_pt_comp => twobody_pt_comp_temp(i,j)
                        );
                    diff_eta_comp(i,j) <= diff_eta_comp_temp(i,j);
                    diff_eta_comp(j,i) <= diff_eta_comp_temp(i,j);
                    diff_phi_comp(i,j) <= diff_phi_comp_temp(i,j);
                    diff_phi_comp(j,i) <= diff_phi_comp_temp(i,j);
                    dr_comp(i,j) <= dr_comp_temp(i,j);
                    dr_comp(j,i) <= dr_comp_temp(i,j);
                    mass_comp(i,j) <= mass_comp_temp(i,j);
                    mass_comp(j,i) <= mass_comp_temp(i,j);
                    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
                end generate if_j_gr_i;
            end generate same_obj_type_same_bx_same_range_i;
            diffrent_obj_type_different_bx_different_range_i: if obj_type_calo1 /= obj_type_calo2 or not same_bx or (calo1_object_low /= calo2_object_low) or (calo1_object_high /= calo2_object_high) generate
                cuts_instances_i: entity work.cuts_instances
                    generic map(
                        deta_cut => deta_cut,
                        dphi_cut => dphi_cut,
                        dr_cut => dr_cut,
                        mass_cut => mass_cut,
                        mass_type => mass_type,
                        twobody_pt_cut => twobody_pt_cut,
                        diff_eta_upper_limit_vector => diff_eta_upper_limit_vector,
                        diff_eta_lower_limit_vector => diff_eta_lower_limit_vector,
                        diff_phi_upper_limit_vector => diff_phi_upper_limit_vector,
                        diff_phi_lower_limit_vector => diff_phi_lower_limit_vector,
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
                        diff_eta => diff_eta(i,j),
                        diff_phi => diff_phi(i,j),
                        pt1 => pt1(i),
                        pt2 => pt2(j),
                        cosh_deta => cosh_deta(i,j),
                        cos_dphi => cos_dphi(i,j),
                        cos_phi_1_integer => cos_phi_1_integer(i),
                        cos_phi_2_integer => cos_phi_2_integer(j),
                        sin_phi_1_integer => sin_phi_1_integer(i),
                        sin_phi_2_integer => sin_phi_2_integer(j),
                        diff_eta_comp => diff_eta_comp(i,j),
                        diff_phi_comp => diff_phi_comp(i,j),
                        dr_comp => dr_comp(i,j),
                        mass_comp => mass_comp(i,j),
                        twobody_pt_comp => twobody_pt_comp(i,j)
                    );
            end generate diffrent_obj_type_different_bx_different_range_i;
        end generate cuts_l_2;
    end generate cuts_l_1;
    
    -- Pipeline stage for cut comps
    diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp, dr_comp, mass_comp, twobody_pt_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            diff_eta_comp_pipe <= diff_eta_comp;
            diff_phi_comp_pipe <= diff_phi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                diff_eta_comp_pipe <= diff_eta_comp;
                diff_phi_comp_pipe <= diff_phi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    calo1_obj_l: for i in calo1_object_low to calo1_object_high generate
        calo1_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo1, obj_type_calo1,
                et_threshold_calo1,
                nr_eta_windows_calo1,
                eta_w1_upper_limit_calo1,
                eta_w1_lower_limit_calo1,
                eta_w2_upper_limit_calo1,
                eta_w2_lower_limit_calo1,
                eta_w3_upper_limit_calo1,
                eta_w3_lower_limit_calo1,
                eta_w4_upper_limit_calo1,
                eta_w4_lower_limit_calo1,
                eta_w5_upper_limit_calo1,
                eta_w5_lower_limit_calo1,
                phi_full_range_calo1,
                phi_w1_upper_limit_calo1,
                phi_w1_lower_limit_calo1,
                phi_w2_ignore_calo1,
                phi_w2_upper_limit_calo1,
                phi_w2_lower_limit_calo1,
                iso_lut_calo1
            )
            port map(calo1_data_i(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
        calo2_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo2, obj_type_calo2,
                et_threshold_calo2,
                nr_eta_windows_calo2,
                eta_w1_upper_limit_calo2,
                eta_w1_lower_limit_calo2,
                eta_w2_upper_limit_calo2,
                eta_w2_lower_limit_calo2,
                eta_w3_upper_limit_calo2,
                eta_w3_lower_limit_calo2,
                eta_w4_upper_limit_calo2,
                eta_w4_lower_limit_calo2,
                eta_w5_upper_limit_calo2,
                eta_w5_lower_limit_calo2,
                phi_full_range_calo2,
                phi_w1_upper_limit_calo2,
                phi_w1_lower_limit_calo2,
                phi_w2_ignore_calo2,
                phi_w2_upper_limit_calo2,
                phi_w2_lower_limit_calo2,
                iso_lut_calo2
            )
            port map(calo2_data_i(i), calo2_obj_vs_templ(i,1));
    end generate calo2_obj_l;

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.

    matrix_deta_dphi_dr_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo1_object_low to calo1_object_high loop 
            for j in calo2_object_low to calo2_object_high loop
            if obj_type_calo1 = obj_type_calo2 and same_bx = true then
                if j/=i then
                index := index + 1;
                obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j)
                                        and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
                end if;
            else
                index := index + 1;
                obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j)
                                        and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
            end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_deta_dphi_dr_p;

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
