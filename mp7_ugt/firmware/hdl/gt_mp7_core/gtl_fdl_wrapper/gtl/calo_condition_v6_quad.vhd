
-- Desription:
-- Condition module for calorimeter object types (eg, jet and tau).
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.

-- Version history:
-- HB 2017-09-05: inserted slice ranges in generic for correct use of object slices.
-- HB 2017-08-28: increased length of vector signals (to 4096).
-- HB 2017-06-13: module for quad condition only.
-- HB 2017-05-16: inserted check for "twobody_pt" cut use only for Double condition.
-- HB 2017-05-11: changed order in port for instances without "twobody_pt" cut.
-- HB 2017-04-20: based on muon_conditions_v4.vhd, but inserted "twobody_pt" cut for Double condition.
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_condition_v6_quad is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        calo_object_slice_4_low: natural;
        calo_object_slice_4_high: natural;
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
        iso_luts: calo_templates_iso_array

    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        condition_o: out std_logic
   );
end calo_condition_v6_quad;

architecture rtl of calo_condition_v6_quad is

    constant nr_objects_slice_1_int: natural := calo_object_slice_1_high-calo_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo_object_slice_2_high-calo_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo_object_slice_3_high-calo_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := calo_object_slice_4_high-calo_object_slice_4_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_slice_1_vs_template_array is array (calo_object_slice_1_low to calo_object_slice_1_high, 1 to 1) of std_logic;
    type object_slice_2_vs_template_array is array (calo_object_slice_2_low to calo_object_slice_2_high, 1 to 1) of std_logic;
    type object_slice_3_vs_template_array is array (calo_object_slice_3_low to calo_object_slice_3_high, 1 to 1) of std_logic;
    type object_slice_4_vs_template_array is array (calo_object_slice_4_low to calo_object_slice_4_high, 1 to 1) of std_logic;

    signal obj_slice_1_vs_templ, obj_slice_1_vs_templ_pipe  : object_slice_1_vs_template_array;
    signal obj_slice_2_vs_templ, obj_slice_2_vs_templ_pipe  : object_slice_2_vs_template_array;
    signal obj_slice_3_vs_templ, obj_slice_3_vs_templ_pipe  : object_slice_3_vs_template_array;
    signal obj_slice_4_vs_templ, obj_slice_4_vs_templ_pipe  : object_slice_4_vs_template_array;
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    signal condition_and_or : std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

begin

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

    obj_slice_4_l: for i in calo_object_slice_4_low to calo_object_slice_4_high generate
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                et_thresholds(4),
                eta_full_range(4),
                eta_w1_upper_limits(4),
                eta_w1_lower_limits(4),
                eta_w2_ignore(4),
                eta_w2_upper_limits(4),
                eta_w2_lower_limits(4),
                phi_full_range(4),
                phi_w1_upper_limits(4),
                phi_w1_lower_limits(4),
                phi_w2_ignore(4),
                phi_w2_upper_limits(4),
                phi_w2_lower_limits(4),
                iso_luts(4)
                )
            port map(data_i(i), obj_slice_4_vs_templ(i,1));
    end generate obj_slice_4_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ)
        begin
            if obj_vs_templ_pipeline_stage = false then
                obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
            else
                if (clk'event and clk = '1') then
                    obj_slice_1_vs_templ_pipe <= obj_slice_1_vs_templ;
                    obj_slice_2_vs_templ_pipe <= obj_slice_2_vs_templ;
                    obj_slice_3_vs_templ_pipe <= obj_slice_3_vs_templ;
                    obj_slice_4_vs_templ_pipe <= obj_slice_4_vs_templ;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "quad".
    matrix_quad_i: if nr_templates = 4 generate
	matrix_quad_p_1: process(obj_slice_1_vs_templ_pipe, obj_slice_2_vs_templ_pipe, obj_slice_3_vs_templ_pipe, obj_slice_4_vs_templ_pipe)
	    variable index : integer := 0;
	    variable index2 : integer := 0;
	    variable test_index : integer := 0;
	    variable obj_vs_templ_vec1  : std_logic_vector(4095 downto 0) := (others => '0');
	    variable obj_vs_templ_vec2  : std_logic_vector(4095 downto 0) := (others => '0');
	    variable obj_vs_templ_vec3  : std_logic_vector(4095 downto 0) := (others => '0');
	begin
	    index := 0;
	    index2 := 0;
	    test_index := 0;
	    obj_vs_templ_vec1  := (others => '0');
	    obj_vs_templ_vec2  := (others => '0');
	    obj_vs_templ_vec3  := (others => '0');
            for i in calo_object_slice_1_low to calo_object_slice_1_high loop
                for j in calo_object_slice_2_low to calo_object_slice_2_high loop
                    for k in calo_object_slice_3_low to calo_object_slice_3_high loop
			for l in calo_object_slice_4_low to calo_object_slice_4_high loop
			    if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
				if((index mod 4096) = 0) then
				    if(index /= 0) then
					index2 := 0;
					test_index := test_index + 1;
				    end if;
				end if;
				if(test_index = 0) then
				    obj_vs_templ_vec1(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				elsif(test_index = 1) then
				    obj_vs_templ_vec2(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				elsif(test_index = 2) then
				    obj_vs_templ_vec3(index2) := obj_slice_1_vs_templ_pipe(i,1) and obj_slice_2_vs_templ_pipe(j,1) and obj_slice_3_vs_templ_pipe(k,1) and obj_slice_4_vs_templ_pipe(l,1);
				end if;
				index := index + 1;
				index2 := index2 +1;
			    end if;
			end loop;
		    end loop;
		end loop;
	    end loop;
	    obj_vs_templ_vec_sig1 <= obj_vs_templ_vec1;
	    obj_vs_templ_vec_sig2 <= obj_vs_templ_vec2;
	    obj_vs_templ_vec_sig3 <= obj_vs_templ_vec3;
	end process matrix_quad_p_1;

        matrix_quad_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3)
            variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3 : std_logic := '0';
	begin
	    condition_and_or_tmp1  := '0';
	    condition_and_or_tmp2  := '0';
	    condition_and_or_tmp3  := '0';
	    for i in 0 to 4095 loop
		condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
		condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
		condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
	    end loop;
	    condition_and_or_sig1 <= condition_and_or_tmp1;
	    condition_and_or_sig2 <= condition_and_or_tmp2;
	    condition_and_or_sig3 <= condition_and_or_tmp3;
	end process matrix_quad_p_2;
        condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3;
    end generate matrix_quad_i;

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
