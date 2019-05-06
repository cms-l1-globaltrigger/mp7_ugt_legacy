
-- Desription:
-- Condition module for muon objects.
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.
-- Charge correlation selection implemented with "LS" and "OS" (charge correlation calculated in muon_charge_correlations.vhd)

-- Version history:
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from muon_conditions_v7 to muon_conditions.
-- HB 2017-10-04: based on muon_conditions_v6 - used limit vector for pt_sq_threshold.
-- HB 2017-09-05: based on muon_conditions_v5, but inserted slice ranges in generic for correct use of object slices.
-- HB 2017-06-20: changed order in port for charge correlation signals.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-25: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "muon_object_low" and "muon_object_high" in generic (and replaced NR_MUON_OBJECTS by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions is
    generic (
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        pt_ge_mode : boolean;
        pt_thresholds: muon_templates_array;
        eta_full_range : muon_templates_boolean_array;
        eta_w1_upper_limits: muon_templates_array;
        eta_w1_lower_limits: muon_templates_array;
        eta_w2_ignore : muon_templates_boolean_array;
        eta_w2_upper_limits: muon_templates_array;
        eta_w2_lower_limits: muon_templates_array;
        phi_full_range : muon_templates_boolean_array;
        phi_w1_upper_limits: muon_templates_array;
        phi_w1_lower_limits: muon_templates_array;
        phi_w2_ignore : muon_templates_boolean_array;
        phi_w2_upper_limits: muon_templates_array;
        phi_w2_lower_limits: muon_templates_array;
        requested_charges: muon_templates_string_array;
        qual_luts: muon_templates_quality_array;
        iso_luts: muon_templates_iso_array;
        requested_charge_correlation: string(1 to 2);
        
        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1

    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
        condition_o : out std_logic;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        pt : in diff_inputs_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in muon_sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0);
        sin_phi_integer : in muon_sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0)
    );
end muon_conditions;

architecture rtl of muon_conditions is

    constant nr_objects_slice_1_int: natural := muon_object_slice_1_high-muon_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := muon_object_slice_2_high-muon_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := muon_object_slice_3_high-muon_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := muon_object_slice_4_high-muon_object_slice_4_low+1;

    -- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_slice_1_vs_template_array is array (muon_object_slice_1_low to muon_object_slice_1_high, 1 to 1) of std_logic;
    type object_slice_2_vs_template_array is array (muon_object_slice_2_low to muon_object_slice_2_high, 1 to 1) of std_logic;
    type object_slice_3_vs_template_array is array (muon_object_slice_3_low to muon_object_slice_3_high, 1 to 1) of std_logic;
    type object_slice_4_vs_template_array is array (muon_object_slice_4_low to muon_object_slice_4_high, 1 to 1) of std_logic;

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array;
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array;
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array;
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array;
    
--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
    signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
    signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal condition_and_or : std_logic;

    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_high, muon_object_slice_2_low to muon_object_slice_2_high) := (others => (others => '1'));

begin

-- HB 2017-05-16: TBPT only for Double condition
    check_tbpt_i: if twobody_pt_cut generate
        assert (nr_templates = 2) report 
            "two-body pt cut only for Double condition - nr_templates = " & integer'image(nr_templates) 
        severity failure;        
    end generate check_tbpt_i;
    
-- -- Instantiation of two-body pt cut.
--     twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
--         twobody_pt_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate 
--             twobody_pt_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
--                 if_j_gr_i: if j > i generate
--                     twobody_pt_calculator_i: entity work.twobody_pt_calculator
--                         generic map(
--                             pt1_width => pt_width, 
--                             pt2_width => pt_width, 
--                             pt_sq_threshold_vector => pt_sq_threshold_vector,
--                             sin_cos_width => sin_cos_width,
--                             pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
--                         )
--                         port map(
--                             pt1 => pt(i)(pt_width-1 downto 0),
--                             pt2 => pt(j)(pt_width-1 downto 0),
--                             cos_phi_1_integer => cos_phi_integer(i),
--                             cos_phi_2_integer => cos_phi_integer(j),
--                             sin_phi_1_integer => sin_phi_integer(i),
--                             sin_phi_2_integer => sin_phi_integer(j),
--                             pt_square_comp => twobody_pt_comp_temp(i,j)
--                     );
--                     twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
--                     twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
--                 end generate if_j_gr_i;
--             end generate twobody_pt_l_2;
--         end generate twobody_pt_l_1;
--     end generate twobody_pt_cut_i;
    
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

-- Instantiation of object cuts.
    obj_cuts_i: entity work.muon_obj_cuts
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates, pt_ge_mode,
            pt_thresholds,
            eta_full_range, eta_w1_upper_limits, eta_w1_lower_limits,
            eta_w2_ignore, eta_w2_upper_limits, eta_w2_lower_limits,
            phi_full_range, phi_w1_upper_limits, phi_w1_lower_limits,
            phi_w2_ignore, phi_w2_upper_limits, phi_w2_lower_limits,
            iso_luts
        )
        port map(
            data_i, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ
        );

--     -- Instance of comparators for muon objects. All permutations between objects and thresholds.
--     obj_slice_1_l: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
--         comp_i: entity work.muon_comparators
--             generic map(pt_ge_mode,
--                         pt_thresholds(1)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
--                         eta_full_range(1),
--                         eta_w1_upper_limits(1)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w1_lower_limits(1)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_ignore(1),
--                         eta_w2_upper_limits(1)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_lower_limits(1)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         phi_full_range(1),
--                         phi_w1_upper_limits(1)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w1_lower_limits(1)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_ignore(1),
--                         phi_w2_upper_limits(1)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_lower_limits(1)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         requested_charges(1),
--                         qual_luts(1),
--                         iso_luts(1)
--                         )
--             port map(data_i(i), obj_slice_1_vs_templ(i,1));
--     end generate obj_slice_1_l;
-- 
--     obj_slice_2_l: for i in muon_object_slice_2_low to muon_object_slice_2_high generate
--         comp_i: entity work.muon_comparators
--             generic map(pt_ge_mode,
--                         pt_thresholds(2)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
--                         eta_full_range(2),
--                         eta_w1_upper_limits(2)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w1_lower_limits(2)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_ignore(2),
--                         eta_w2_upper_limits(2)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_lower_limits(2)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         phi_full_range(2),
--                         phi_w1_upper_limits(2)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w1_lower_limits(2)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_ignore(2),
--                         phi_w2_upper_limits(2)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_lower_limits(2)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         requested_charges(2),
--                         qual_luts(2),
--                         iso_luts(2)
--                         )
--             port map(data_i(i), obj_slice_2_vs_templ(i,1));
--     end generate obj_slice_2_l;
-- 
--     obj_slice_3_l: for i in muon_object_slice_3_low to muon_object_slice_3_high generate
--         comp_i: entity work.muon_comparators
--             generic map(pt_ge_mode,
--                         pt_thresholds(3)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
--                         eta_full_range(3),
--                         eta_w1_upper_limits(3)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w1_lower_limits(3)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_ignore(3),
--                         eta_w2_upper_limits(3)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_lower_limits(3)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         phi_full_range(3),
--                         phi_w1_upper_limits(3)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w1_lower_limits(3)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_ignore(3),
--                         phi_w2_upper_limits(3)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_lower_limits(3)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         requested_charges(3),
--                         qual_luts(3),
--                         iso_luts(3)
--                         )
--             port map(data_i(i), obj_slice_3_vs_templ(i,1));
--     end generate obj_slice_3_l;
-- 
--     obj_slice_4_l: for i in muon_object_slice_4_low to muon_object_slice_4_high generate
--         comp_i: entity work.muon_comparators
--             generic map(pt_ge_mode,
--                         pt_thresholds(4)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
--                         eta_full_range(4),
--                         eta_w1_upper_limits(4)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w1_lower_limits(4)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_ignore(4),
--                         eta_w2_upper_limits(4)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         eta_w2_lower_limits(4)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
--                         phi_full_range(4),
--                         phi_w1_upper_limits(4)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w1_lower_limits(4)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_ignore(4),
--                         phi_w2_upper_limits(4)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         phi_w2_lower_limits(4)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
--                         requested_charges(4),
--                         qual_luts(4),
--                         iso_luts(4)
--                         )
--             port map(data_i(i), obj_slice_4_vs_templ(i,1));
--     end generate obj_slice_4_l;
-- 
-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                    twobody_pt_comp_pipe <= twobody_pt_comp;
                end if;
            end if;
    end process;

-- Instantiation of charge correlation matrix.
    charge__corr_matrix_i: entity work.muon_charge_corr_matrix
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates,
            requested_charge_correlation
        )
        port map(
            ls_charcorr_double, os_charcorr_double,
            ls_charcorr_triple, os_charcorr_triple
            ls_charcorr_quad, os_charcorr_quad
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe
        );

--     --************************************************************
--     -- Charge correlation comparison
--     -- The definition of requested_charge_correlation has to be checked.
-- 
--     charge_double_i: if nr_templates = 2 generate
--         charge_double_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
--             charge_double_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
--                 charge_double_if: if j/=i generate
--                     charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
--                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
--                                               '1' when requested_charge_correlation = "ig" else
--                                               '0';
--                 end generate charge_double_if;
--             end generate charge_double_l_2;
--         end generate charge_double_l_1;
-- 
--     -- Pipeline stage for charge_comp_2
--         charge_comp_2_pipeline_p: process(lhc_clk, charge_comp_double)
--             begin
--                 if obj_vs_templ_pipeline_stage = false then
--                     charge_comp_double_pipe <= charge_comp_double;
--                 else
--                     if (lhc_clk'event and lhc_clk = '1') then
--                         charge_comp_double_pipe <= charge_comp_double;
--                     end if;
--                 end if;
--         end process;
--     end generate charge_double_i;
-- 
--     charge_triple_i: if nr_templates = 3 generate
--         charge_triple_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
--             charge_triple_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
--                 charge_triple_l_3: for k in muon_object_slice_3_low to muon_object_slice_3_high generate
--                     charge_triple_if: if (j/=i and k/=i and k/=j) generate
--                         charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
--                                                     '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
--                                                     '1' when requested_charge_correlation = "ig" else
--                                                     '0';
--                     end generate charge_triple_if;
--                 end generate charge_triple_l_3;
--             end generate charge_triple_l_2;
--         end generate charge_triple_l_1;
-- 
--     -- Pipeline stage for charge_comp_2
--         charge_comp_3_pipeline_p: process(lhc_clk, charge_comp_triple)
--             begin
--                 if obj_vs_templ_pipeline_stage = false then
--                     charge_comp_triple_pipe <= charge_comp_triple;
--                 else
--                     if (lhc_clk'event and lhc_clk = '1') then
--                         charge_comp_triple_pipe <= charge_comp_triple;
--                     end if;
--                 end if;
--         end process;
--     end generate charge_triple_i;
-- 
--     charge_quad_i: if nr_templates = 4 generate
--         charge_quad_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
--             charge_quad_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
--                 charge_quad_l_3: for k in muon_object_slice_3_low to muon_object_slice_3_high generate
--                     charge_quad_l_4: for l in muon_object_slice_4_low to muon_object_slice_4_high generate
--                         charge_quad_if: if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) generate
--                             charge_comp_quad(i,j,k,l) <= '1' when ls_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "ls" else
--                                                         '1' when os_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "os" else
--                                                         '1' when requested_charge_correlation = "ig" else
--                                                         '0';
--                         end generate charge_quad_if;
--                     end generate charge_quad_l_4;
--                 end generate charge_quad_l_3;
--             end generate charge_quad_l_2;
--         end generate charge_quad_l_1;
-- 
--     -- Pipeline stage for charge_comp_2
--         charge_comp_4_pipeline_p: process(lhc_clk, charge_comp_quad)
--             begin
--                 if obj_vs_templ_pipeline_stage = false then
--                     charge_comp_quad_pipe <= charge_comp_quad;
--                 else
--                     if (lhc_clk'event and lhc_clk = '1') then
--                         charge_comp_quad_pipe <= charge_comp_quad;
--                     end if;
--                 end if;
--         end process;
--     end generate charge_quad_i;
-- 
    -- "Matrix" of permutations in an and-or-structure.
    -- Selection of muon condition types ("single", "double", "double_wsc", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates'.
    cond_matrix_i: entity work.muon_cond_matrix
        generic map(
            muon_object_slice_1_low, muon_object_slice_1_high,
            muon_object_slice_2_low, muon_object_slice_2_high,
            muon_object_slice_3_low, muon_object_slice_3_high,
            muon_object_slice_4_low, muon_object_slice_4_high,
            nr_templates
        )
        port map(clk,
            obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe,
            charge_comp_double_pipe, charge_comp_triple_pipe, charge_comp_quad_pipe, twobody_pt_comp_pipe,
            condition_o
        );

--     -- Condition type: "single".
--     matrix_single_i: if nr_templates = 1 generate
--     --    matrix_single_p: process(obj_vs_templ_pipe, charge_comp_single_pipe)
--     -- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
--         matrix_single_p: process(obj_slice_1_vs_templ_pipe)
--             variable index : integer := 0;
--             variable obj_vs_templ_vec : std_logic_vector(nr_objects_slice_1_int downto 1) := (others => '0');
--             variable condition_and_or_tmp : std_logic := '0';
--         begin
--             index := 0;
--             obj_vs_templ_vec := (others => '0');
--             condition_and_or_tmp := '0';
--             for i in muon_object_slice_1_low to muon_object_slice_1_high loop
--                 index := index + 1;
--                 obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1);
--             end loop;
--             for i in 1 to index loop
--                 condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
--             end loop;
--             condition_and_or <= condition_and_or_tmp;
--         end process matrix_single_p;
--     end generate matrix_single_i;
-- 
--     -- Condition type: "double".
--     -- matrix_double_i: if (nr_templates = 2 and double_wsc = false) generate
--     matrix_double_i: if nr_templates = 2 generate
--         matrix_double_p: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, charge_comp_double_pipe, twobody_pt_comp_pipe)
--             variable index : integer := 0;
--             variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int) downto 1) := (others => '0');
--             variable condition_and_or_tmp : std_logic := '0';
--         begin
--             index := 0;
--             obj_vs_templ_vec := (others => '0');
--             condition_and_or_tmp := '0';
--             for i in muon_object_slice_1_low to muon_object_slice_1_high loop
--                 for j in muon_object_slice_2_low to muon_object_slice_2_high loop
--                     if j/=i then
--                         index := index + 1;
--     --                     obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2);
--                         obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and twobody_pt_comp_pipe(i,j);
--                     end if;
--                 end loop;
--             end loop;
--             for i in 1 to index loop
--                 condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
--             end loop;
--             condition_and_or <= condition_and_or_tmp;
--         end process matrix_double_p;
--     end generate matrix_double_i;
-- 
--     -- Condition type: "triple".
--     matrix_triple_i: if nr_templates = 3 generate
--         matrix_triple_p: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, charge_comp_triple_pipe)
--             variable index : integer := 0;
--             variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_objects_slice_3_int) downto 1) := (others => '0');
--             variable condition_and_or_tmp : std_logic := '0';
--         begin
--             index := 0;
--             obj_vs_templ_vec := (others => '0');
--             condition_and_or_tmp := '0';
--             for i in muon_object_slice_1_low to muon_object_slice_1_high loop
--                 for j in muon_object_slice_2_low to muon_object_slice_2_high loop
--                     for k in muon_object_slice_3_low to muon_object_slice_3_high loop
--                         if (j/=i and k/=i and k/=j) then
--                             index := index + 1;
--                             obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and charge_comp_triple_pipe(i,j,k);
--                         end if;
--                     end loop;
--                 end loop;
--             end loop;
--             for i in 1 to index loop
--                 condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
--             end loop;
--             condition_and_or <= condition_and_or_tmp;
--         end process matrix_triple_p;
--     end generate matrix_triple_i;
-- 
--     -- Condition type: "quad".
--     matrix_quad_i: if nr_templates = 4 generate
--         matrix_quad_p: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe, charge_comp_quad_pipe)
--             variable index : integer := 0;
--             variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_objects_slice_3_int*nr_objects_slice_4_int) downto 1) := (others => '0');
--             variable condition_and_or_tmp : std_logic := '0';
--         begin
--             index := 0;
--             obj_vs_templ_vec := (others => '0');
--             condition_and_or_tmp := '0';
--             for i in muon_object_slice_1_low to muon_object_slice_1_high loop
--                 for j in muon_object_slice_2_low to muon_object_slice_2_high loop
--                     for k in muon_object_slice_3_low to muon_object_slice_3_high loop
--                         for l in muon_object_slice_4_low to muon_object_slice_4_high loop
--                             if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
--                                 index := index + 1;
--                                 obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1) and charge_comp_quad_pipe(i,j,k,l);
--                             end if;
--                         end loop;
--                     end loop;
--                 end loop;
--             end loop;
--             for i in 1 to index loop
--                 condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
--             end loop;
--             condition_and_or <= condition_and_or_tmp;
--         end process matrix_quad_p;
--     end generate matrix_quad_i;
-- 
--     -- Pipeline stage for condition output.
--     condition_o_pipeline_p: process(lhc_clk, condition_and_or)
--         begin
--             if conditions_pipeline_stage = false then
--                 condition_o <= condition_and_or;
--             else
--                 if (lhc_clk'event and lhc_clk = '1') then
--                     condition_o <= condition_and_or;
--                 end if;
--             end if;
--     end process;
-- 
end architecture rtl;
