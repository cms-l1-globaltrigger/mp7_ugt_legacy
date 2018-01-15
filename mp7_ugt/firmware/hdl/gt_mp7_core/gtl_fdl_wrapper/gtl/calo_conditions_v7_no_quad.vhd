
-- Desription:
-- Condition module for calorimeter object types (eg, jet and tau).
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.

-- Version history:
-- HB 2017-10-04: based on calo_conditions_v6_no_quad - used limit vector for pt_sq_threshold.
-- HB 2017-09-05: inserted slice ranges in generic for correct use of object slices.
-- HB 2017-06-13: module for single, double and triple conditions.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-20: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_v7_no_quad is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
        obj_type : natural := EG_TYPE;
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array;

        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1

    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        condition_o: out std_logic;
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS) := (others => (others => '0'));
        cos_phi_integer : in calo_sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0);
        sin_phi_integer : in calo_sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0)
   );
end calo_conditions_v7_no_quad;

architecture rtl of calo_conditions_v7_no_quad is

    constant nr_objects_slice_1_int: natural := calo_object_slice_1_high-calo_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo_object_slice_2_high-calo_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo_object_slice_3_high-calo_object_slice_3_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_slice_1_vs_template_array is array (calo_object_slice_1_low to calo_object_slice_1_high, 1 to 1) of std_logic;
    type object_slice_2_vs_template_array is array (calo_object_slice_2_low to calo_object_slice_2_high, 1 to 1) of std_logic;
    type object_slice_3_vs_template_array is array (calo_object_slice_3_low to calo_object_slice_3_high, 1 to 1) of std_logic;

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array;
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array;
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array;

    signal condition_and_or : std_logic;
    
    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high) := (others => (others => '1'));

begin

-- HB 2017-05-16: TBPT only for Double condition
    check_tbpt_i: if twobody_pt_cut generate
        assert (nr_templates = 2) report 
            "two-body pt cut only for Double condition - nr_templates = " & integer'image(nr_templates) 
        severity failure;        
    end generate check_tbpt_i;
    
-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
        twobody_pt_l_1: for i in calo_object_slice_1_low to calo_object_slice_1_high generate 
            twobody_pt_l_2: for j in calo_object_slice_2_low to calo_object_slice_2_high generate
                if_j_gr_i: if j > i generate
                    twobody_pt_calculator_i: entity work.twobody_pt_calculator_v2
                        generic map(
                            pt1_width => pt_width, 
                            pt2_width => pt_width, 
                            pt_sq_threshold_vector => pt_sq_threshold_vector,
                            sin_cos_width => sin_cos_width,
                            pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                        )
                        port map(
                            pt1 => pt(i)(pt_width-1 downto 0),
                            pt2 => pt(j)(pt_width-1 downto 0),
                            cos_phi_1_integer => cos_phi_integer(i),
                            cos_phi_2_integer => cos_phi_integer(j),
                            sin_phi_1_integer => sin_phi_integer(i),
                            sin_phi_2_integer => sin_phi_integer(j),
                            pt_square_comp => twobody_pt_comp_temp(i,j)
                    );
                    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
                end generate if_j_gr_i;
            end generate twobody_pt_l_2;
        end generate twobody_pt_l_1;
    end generate twobody_pt_cut_i;
    
-- Instance of comparators for calorimeter objects. All permutations between objects and thresholds/luts.
    obj_slice_1_l: for i in calo_object_slice_1_low to calo_object_slice_1_high generate
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                et_thresholds(1),
                eta_full_range(1),
                eta_w1_upper_limits(1),
                eta_w1_lower_limits(1),
                eta_w2_ignore(1),
                eta_w2_upper_limits(1),
                eta_w2_lower_limits(1),
                phi_full_range(1),
                phi_w1_upper_limits(1),
                phi_w1_lower_limits(1),
                phi_w2_ignore(1),
                phi_w2_upper_limits(1),
                phi_w2_lower_limits(1),
                iso_luts(1)
                )
            port map(data_i(i), obj_slice_1_vs_templ(i,1));
    end generate obj_slice_1_l;

    obj_slice_2_l: for i in calo_object_slice_2_low to calo_object_slice_2_high generate
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                et_thresholds(2),
                eta_full_range(2),
                eta_w1_upper_limits(2),
                eta_w1_lower_limits(2),
                eta_w2_ignore(2),
                eta_w2_upper_limits(2),
                eta_w2_lower_limits(2),
                phi_full_range(2),
                phi_w1_upper_limits(2),
                phi_w1_lower_limits(2),
                phi_w2_ignore(2),
                phi_w2_upper_limits(2),
                phi_w2_lower_limits(2),
                iso_luts(2)
                )
            port map(data_i(i), obj_slice_2_vs_templ(i,1));
    end generate obj_slice_2_l;

    obj_slice_3_l: for i in calo_object_slice_3_low to calo_object_slice_3_high generate
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                et_thresholds(3),
                eta_full_range(3),
                eta_w1_upper_limits(3),
                eta_w1_lower_limits(3),
                eta_w2_ignore(3),
                eta_w2_upper_limits(3),
                eta_w2_lower_limits(3),
                phi_full_range(3),
                phi_w1_upper_limits(3),
                phi_w1_lower_limits(3),
                phi_w2_ignore(3),
                phi_w2_upper_limits(3),
                phi_w2_lower_limits(3),
                iso_luts(3)
                )
            port map(data_i(i), obj_slice_3_vs_templ(i,1));
    end generate obj_slice_3_l;

-- Pipeline stage for obj_vs_templ and twobody_pt_comp
    obj_vs_templ_pipeline_p: process(clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, twobody_pt_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                twobody_pt_comp_pipe <= twobody_pt_comp;
            else
                if (clk'event and clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    twobody_pt_comp_pipe <= twobody_pt_comp;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "single".
    matrix_single_i: if nr_templates = 1 generate
        matrix_single_p: process(obj_slice_1_vs_templ_pipe)
            variable condition_and_or_tmp : std_logic := '0';
        begin
            condition_and_or_tmp := '0';
            for i in calo_object_slice_1_low to calo_object_slice_1_high loop
                condition_and_or_tmp := condition_and_or_tmp or obj_slice_1_vs_templ_pipe(i,1);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_single_p;
    end generate matrix_single_i;

-- Condition type: "double".
    matrix_double_i: if (nr_templates = 2) generate
        matrix_double_p: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, twobody_pt_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in calo_object_slice_1_low to calo_object_slice_1_high loop
                for j in calo_object_slice_2_low to calo_object_slice_2_high loop
                    if j/=i then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and twobody_pt_comp_pipe(i,j);
                    end if;
                end loop;
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_double_p;
    end generate matrix_double_i;

-- Condition type: "triple".
    matrix_triple_i: if nr_templates = 3 generate
        matrix_triple_p: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_objects_slice_3_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in calo_object_slice_1_low to calo_object_slice_1_high loop
                for j in calo_object_slice_2_low to calo_object_slice_2_high loop
                    for k in calo_object_slice_3_low to calo_object_slice_3_high loop
                        if (j/=i and k/=i and k/=j) then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1);
                        end if;
                    end loop;
                end loop;
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_triple_p;
    end generate matrix_triple_i;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(clk, condition_and_or)
        begin
            if conditions_pipeline_stage = false then
                condition_o <= condition_and_or;
            else
                if (clk'event and clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;

end architecture rtl;
