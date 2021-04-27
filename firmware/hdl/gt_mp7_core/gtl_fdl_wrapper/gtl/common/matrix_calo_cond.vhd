-- Description:
-- Calo condition matrix

-- Version history:
-- HB 2021-04-15: minor update. Changed name.
-- HB 2021-02-19: updated condition output pipeline.
-- HB 2019-04-30: first version (updated Dinyar/Hannes proposal).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity matrix_calo_cond is
    generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        calo_object_slice_4_low: natural;
        calo_object_slice_4_high: natural;
        nr_templates: positive
    );
    port(
        clk : in std_logic;
        obj_slice_1_vs_templ : in std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, 1 to 1);
        obj_slice_2_vs_templ : in std_logic_2dim_array(calo_object_slice_2_low to calo_object_slice_2_high, 1 to 1);
        obj_slice_3_vs_templ : in std_logic_2dim_array(calo_object_slice_3_low to calo_object_slice_3_high, 1 to 1);
        obj_slice_4_vs_templ : in std_logic_2dim_array(calo_object_slice_4_low to calo_object_slice_4_high, 1 to 1);
        twobody_pt_comp : in std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high);
        condition_o : out std_logic
    );
end matrix_calo_cond;

architecture Behavioral of matrix_calo_cond is
    constant nr_objects_slice_1_int: natural := calo_object_slice_1_high-calo_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo_object_slice_2_high-calo_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo_object_slice_3_high-calo_object_slice_3_low+1;

    signal obj_vs_templ_vec_sig1: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(4095 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(4095 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    signal condition_and_or : std_logic;
begin

-- Condition type: "single".
    matrix_single_i: if nr_templates = 1 generate
        matrix_single_p: process(obj_slice_1_vs_templ)
            variable condition_and_or_tmp : std_logic := '0';
        begin
            condition_and_or_tmp := '0';
            for i in calo_object_slice_1_low to calo_object_slice_1_high loop
                condition_and_or_tmp := condition_and_or_tmp or obj_slice_1_vs_templ(i,1);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_single_p;
    end generate matrix_single_i;

-- Condition type: "double".
    matrix_double_i: if (nr_templates = 2) generate
        matrix_double_p: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, twobody_pt_comp)
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
                        obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and twobody_pt_comp(i,j);
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
        matrix_triple_p: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ)
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
                            obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1);
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
        matrix_quad_p_1: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ)
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
                                    obj_vs_templ_vec1(index2) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1) and obj_slice_4_vs_templ(l,1);
                                elsif(test_index = 1) then
                                    obj_vs_templ_vec2(index2) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1) and obj_slice_4_vs_templ(l,1);
                                elsif(test_index = 2) then
                                    obj_vs_templ_vec3(index2) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1) and obj_slice_4_vs_templ(l,1);
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
            if not CONDITIONS_PIPELINE then
                condition_o <= condition_and_or;
            else
                if (clk'event and clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;

end Behavioral;
