
-- Desription:
-- Condition module for calorimeter object types (eg, jet and tau).
-- All condition types ("single", "double", "triple" and "quad") are implemented in this module,
-- selected by nr_templates.

-- Version history:
-- HB 2017-02-01: based on muon_conditions_v3.vhd, but inserted "calo_object_low" and "calo_object_high" in generic (and replaced "nr_objects" by those).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_v4 is
     generic(
	calo_object_low: natural;
        calo_object_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
	obj_type : natural := EG_TYPE; -- eg=0, jet=1, tau=2
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
end calo_conditions_v4;

architecture rtl of calo_conditions_v4 is

    constant nr_objects_int: natural := calo_object_high-calo_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_vs_template_array is array (calo_object_low to calo_object_high, 1 to nr_templates) of std_logic;
    type diff_comp_array is array (calo_object_low to calo_object_high, calo_object_low to calo_object_high) of std_logic;

    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
    signal condition_and_or : std_logic;
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig4: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig5: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig6: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig7: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig8: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig9: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig10: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig11: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig12: std_logic_vector(1023 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;
    signal condition_and_or_sig4: std_logic;
    signal condition_and_or_sig5: std_logic;
    signal condition_and_or_sig6: std_logic;
    signal condition_and_or_sig7: std_logic;
    signal condition_and_or_sig8: std_logic;
    signal condition_and_or_sig9: std_logic;
    signal condition_and_or_sig10: std_logic;
    signal condition_and_or_sig11: std_logic;
    signal condition_and_or_sig12: std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;
    attribute keep of obj_vs_templ_vec_sig4  : signal is true;
    attribute keep of obj_vs_templ_vec_sig5  : signal is true;
    attribute keep of obj_vs_templ_vec_sig6  : signal is true;
    attribute keep of obj_vs_templ_vec_sig7  : signal is true;
    attribute keep of obj_vs_templ_vec_sig8  : signal is true;
    attribute keep of obj_vs_templ_vec_sig9  : signal is true;
    attribute keep of obj_vs_templ_vec_sig10 : signal is true;
    attribute keep of obj_vs_templ_vec_sig11 : signal is true;
    attribute keep of obj_vs_templ_vec_sig12 : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;
    attribute keep of condition_and_or_sig4  : signal is true;
    attribute keep of condition_and_or_sig5  : signal is true;
    attribute keep of condition_and_or_sig6  : signal is true;
    attribute keep of condition_and_or_sig7  : signal is true;
    attribute keep of condition_and_or_sig8  : signal is true;
    attribute keep of condition_and_or_sig9  : signal is true;
    attribute keep of condition_and_or_sig10 : signal is true;
    attribute keep of condition_and_or_sig11 : signal is true;
    attribute keep of condition_and_or_sig12 : signal is true;

begin

-- Instance of comparators for calorimeter objects. All permutations between objects and thresholds/luts.
obj_l: for i in calo_object_low to calo_object_high generate
    templ_l: for j in 1 to nr_templates generate
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                 et_thresholds(j),
                 eta_full_range(j),
                 eta_w1_upper_limits(j),
                 eta_w1_lower_limits(j),
                 eta_w2_ignore(j),
                 eta_w2_upper_limits(j),
                 eta_w2_lower_limits(j),
                 phi_full_range(j),
                 phi_w1_upper_limits(j),
                 phi_w1_lower_limits(j),
                 phi_w2_ignore(j),
                 phi_w2_upper_limits(j),
                 phi_w2_lower_limits(j),
                 iso_luts(j)
                 )
            port map(data_i(i), obj_vs_templ(i,j));
    end generate templ_l;
end generate obj_l;

-- Pipeline stage for obj_vs_templ
obj_vs_templ_pipeline_p: process(clk, obj_vs_templ)
    begin
        if obj_vs_templ_pipeline_stage = false then
            obj_vs_templ_pipe <= obj_vs_templ;
        else
            if (clk'event and clk = '1') then
                obj_vs_templ_pipe <= obj_vs_templ;
            end if;
        end if;
end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "single".
matrix_single_i: if nr_templates = 1 generate
    matrix_single_p: process(obj_vs_templ_pipe)
        variable condition_and_or_tmp : std_logic := '0';
    begin
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_pipe(i,1);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_single_p;
end generate matrix_single_i;

-- Condition type: "double".
matrix_double_i: if (nr_templates = 2) generate
    matrix_double_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects_int*(nr_objects_int-1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop
            for j in calo_object_low to calo_object_high loop
                if j/=i then
                    index := index + 1;
                    obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2);
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
    matrix_triple_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects_int*(nr_objects_int-1)*(nr_objects_int-2)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop
            for j in calo_object_low to calo_object_high loop
                for k in calo_object_low to calo_object_high loop
                    if (j/=i and k/=i and k/=j) then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3);
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

-- Condition type: "quad".
matrix_quad_i: if nr_templates = 4 generate
    matrix_quad_p_1: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable index2 : integer := 0;
        variable test_index : integer := 0;
        variable obj_vs_templ_vec1  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec2  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec3  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec4  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec5  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec6  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec7  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec8  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec9  : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec10 : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec11 : std_logic_vector(1023 downto 0) := (others => '0');
        variable obj_vs_templ_vec12 : std_logic_vector(1023 downto 0) := (others => '0');
    begin
        index := 0;
        index2 := 0;
        test_index := 0;
        obj_vs_templ_vec1  := (others => '0');
        obj_vs_templ_vec2  := (others => '0');
        obj_vs_templ_vec3  := (others => '0');
        obj_vs_templ_vec4  := (others => '0');
        obj_vs_templ_vec5  := (others => '0');
        obj_vs_templ_vec6  := (others => '0');
        obj_vs_templ_vec7  := (others => '0');
        obj_vs_templ_vec8  := (others => '0');
        obj_vs_templ_vec9  := (others => '0');
        obj_vs_templ_vec10 := (others => '0');
        obj_vs_templ_vec11 := (others => '0');
        obj_vs_templ_vec12 := (others => '0');
        for i in calo_object_low to calo_object_high loop
            for j in calo_object_low to calo_object_high loop
                for k in calo_object_low to calo_object_high loop
                    for l in calo_object_low to calo_object_high loop
                        if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                            if((index mod 1024) = 0) then
                                if(index /= 0) then
                                    index2 := 0;
                                    test_index := test_index + 1;
                                end if;
                            end if;
                            if(test_index = 0) then
                                obj_vs_templ_vec1(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 1) then
                                obj_vs_templ_vec2(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 2) then
                                obj_vs_templ_vec3(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 3) then
                                obj_vs_templ_vec4(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 4) then
                                obj_vs_templ_vec5(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 5) then
                                obj_vs_templ_vec6(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 6) then
                                obj_vs_templ_vec7(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 7) then
                                obj_vs_templ_vec8(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 8) then
                                obj_vs_templ_vec9(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 9) then
                                obj_vs_templ_vec10(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 10) then
                                obj_vs_templ_vec11(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
                            elsif(test_index = 11) then
                                obj_vs_templ_vec12(index2) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
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
        obj_vs_templ_vec_sig4 <= obj_vs_templ_vec4;
        obj_vs_templ_vec_sig5 <= obj_vs_templ_vec5;
        obj_vs_templ_vec_sig6 <= obj_vs_templ_vec6;
        obj_vs_templ_vec_sig7 <= obj_vs_templ_vec7;
	obj_vs_templ_vec_sig8 <= obj_vs_templ_vec8;
        obj_vs_templ_vec_sig9 <= obj_vs_templ_vec9;
        obj_vs_templ_vec_sig10 <= obj_vs_templ_vec10;
        obj_vs_templ_vec_sig11 <= obj_vs_templ_vec11;
        obj_vs_templ_vec_sig12 <= obj_vs_templ_vec12;
    end process matrix_quad_p_1;

    matrix_quad_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3, obj_vs_templ_vec_sig4, obj_vs_templ_vec_sig5, 
	obj_vs_templ_vec_sig6, obj_vs_templ_vec_sig7, obj_vs_templ_vec_sig8, obj_vs_templ_vec_sig9, obj_vs_templ_vec_sig10, obj_vs_templ_vec_sig11, obj_vs_templ_vec_sig12)
	variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3, condition_and_or_tmp4, condition_and_or_tmp5, condition_and_or_tmp6, 
	condition_and_or_tmp7, condition_and_or_tmp8, condition_and_or_tmp9, condition_and_or_tmp10, condition_and_or_tmp11, condition_and_or_tmp12 : std_logic := '0';
    begin
        condition_and_or_tmp1  := '0';
        condition_and_or_tmp2  := '0';
        condition_and_or_tmp3  := '0';
        condition_and_or_tmp4  := '0';
        condition_and_or_tmp5  := '0';
        condition_and_or_tmp6  := '0';
        condition_and_or_tmp7  := '0';
        condition_and_or_tmp8  := '0';
        condition_and_or_tmp9  := '0';
        condition_and_or_tmp10 := '0';
        condition_and_or_tmp11 := '0';
        condition_and_or_tmp12 := '0';
        for i in 0 to 1023 loop
	    condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
            condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
            condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
            condition_and_or_tmp4 := condition_and_or_tmp4 or obj_vs_templ_vec_sig4(i);
            condition_and_or_tmp5 := condition_and_or_tmp5 or obj_vs_templ_vec_sig5(i);
            condition_and_or_tmp6 := condition_and_or_tmp6 or obj_vs_templ_vec_sig6(i);
            condition_and_or_tmp7 := condition_and_or_tmp7 or obj_vs_templ_vec_sig7(i);
	    condition_and_or_tmp8 := condition_and_or_tmp8 or obj_vs_templ_vec_sig8(i);
            condition_and_or_tmp9 := condition_and_or_tmp9 or obj_vs_templ_vec_sig9(i);
            condition_and_or_tmp10 := condition_and_or_tmp10 or obj_vs_templ_vec_sig10(i);
            condition_and_or_tmp11 := condition_and_or_tmp11 or obj_vs_templ_vec_sig11(i);
            condition_and_or_tmp12 := condition_and_or_tmp12 or obj_vs_templ_vec_sig12(i);
        end loop;
	condition_and_or_sig1 <= condition_and_or_tmp1;
        condition_and_or_sig2 <= condition_and_or_tmp2;
        condition_and_or_sig3 <= condition_and_or_tmp3;
        condition_and_or_sig4 <= condition_and_or_tmp4;
        condition_and_or_sig5 <= condition_and_or_tmp5;
        condition_and_or_sig6 <= condition_and_or_tmp6;
        condition_and_or_sig7 <= condition_and_or_tmp7;
	condition_and_or_sig8 <= condition_and_or_tmp8;
        condition_and_or_sig9 <= condition_and_or_tmp9;
        condition_and_or_sig10 <= condition_and_or_tmp10;
        condition_and_or_sig11 <= condition_and_or_tmp11;
        condition_and_or_sig12 <= condition_and_or_tmp12;
    end process matrix_quad_p_2;
    condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3 or condition_and_or_sig4 or condition_and_or_sig5 or 
	condition_and_or_sig6 or condition_and_or_sig7 or condition_and_or_sig8 or condition_and_or_sig9 or condition_and_or_sig10 or condition_and_or_sig11 or condition_and_or_sig12;
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
