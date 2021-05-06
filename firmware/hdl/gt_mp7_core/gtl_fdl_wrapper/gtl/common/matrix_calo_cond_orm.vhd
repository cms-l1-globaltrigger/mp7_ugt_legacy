----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/07/2019 12:17:34 PM
-- Design Name:
-- Module Name: calo_cond_matrix - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
-- Description:
-- Calo condition matrix overlap removal

-- Version history:
-- HB 2021-04-15: minor update. Changed name.
-- HB 2021-02-19: updated condition output pipeline.
-- HB 2020-01-28: bug fix in "matrix_quad_p_1".
-- HB 2019-10-17: bug fix at twobody_pt_comp port.
-- HB 2019-04-30: first version (updated Dinyar/Hannes proposal).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity matrix_calo_cond_orm is
    generic(
        calo1_object_slice_1_low: natural;
        calo1_object_slice_1_high: natural;
        calo1_object_slice_2_low: natural;
        calo1_object_slice_2_high: natural;
        calo1_object_slice_3_low: natural;
        calo1_object_slice_3_high: natural;
        calo1_object_slice_4_low: natural;
        calo1_object_slice_4_high: natural;
        nr_templates: positive;
        calo2_object_low: natural;
        calo2_object_high: natural
    );
    port(
        clk : in std_logic;
        calo1_obj_slice_1_vs_templ : in std_logic_2dim_array(calo1_object_slice_1_low to calo1_object_slice_1_high, 1 to 1);
        calo1_obj_slice_2_vs_templ : in std_logic_2dim_array(calo1_object_slice_2_low to calo1_object_slice_2_high, 1 to 1);
        calo1_obj_slice_3_vs_templ : in std_logic_2dim_array(calo1_object_slice_3_low to calo1_object_slice_3_high, 1 to 1);
        calo1_obj_slice_4_vs_templ : in std_logic_2dim_array(calo1_object_slice_4_low to calo1_object_slice_4_high, 1 to 1);
        calo2_obj_vs_templ : in std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1);
        twobody_pt_comp : in std_logic_2dim_array(calo1_object_slice_1_low to calo1_object_slice_1_high, calo1_object_slice_2_low to calo1_object_slice_2_high);
        diff_eta_orm_comp : in std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high);
        diff_phi_orm_comp : in std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high);
        dr_orm_comp : in std_logic_2dim_array(0 to MAX_CALO_OBJECTS-1, calo2_object_low to calo2_object_high);
        condition_o : out std_logic
    );
end matrix_calo_cond_orm;

architecture Behavioral of matrix_calo_cond_orm is
    constant and_partition_len: integer := 5280;

    constant nr_objects_slice_1_int: natural := calo1_object_slice_1_high-calo1_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := calo1_object_slice_2_high-calo1_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := calo1_object_slice_3_high-calo1_object_slice_3_low+1;
    constant nr_calo2_objects_int: natural := calo2_object_high-calo2_object_low+1;

    signal obj_vs_templ_vec_sig1: std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig4: std_logic_vector(and_partition_len-1 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;
    signal condition_and_or_sig4: std_logic;

    signal condition_and_or : std_logic;

begin

-- Condition type: "single".
    matrix_single_i: if nr_templates = 1 generate
        matrix_single_p: process(calo1_obj_slice_1_vs_templ, calo2_obj_vs_templ, diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_calo2_objects_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in calo1_object_slice_1_low to calo1_object_slice_1_high loop
                for j in calo2_object_low to calo2_object_high loop
                    index := index + 1;
                    obj_vs_templ_vec(index) := calo1_obj_slice_1_vs_templ(i,1) and calo2_obj_vs_templ(j,1) and
                        not (
                        (diff_eta_orm_comp(i,j) or diff_phi_orm_comp(i,j) or dr_orm_comp(i,j)) and calo2_obj_vs_templ(j,1)
                        );
                end loop;
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_single_p;
    end generate matrix_single_i;

-- Condition type: "double".
    matrix_double_i: if nr_templates = 2 generate
        matrix_double_p: process(calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo2_obj_vs_templ, diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp, twobody_pt_comp)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_calo2_objects_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in calo1_object_slice_1_low to calo1_object_slice_1_high loop
                for j in calo1_object_slice_2_low to calo1_object_slice_2_high loop
                    for k in calo2_object_low to calo2_object_high loop
                        if j/=i then
                            index := index + 1;
                            obj_vs_templ_vec(index) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo2_obj_vs_templ(k,1) and twobody_pt_comp(i,j) and
                            not (
                            (diff_eta_orm_comp(i,k) or diff_eta_orm_comp(j,k) or diff_phi_orm_comp(i,k) or
                            diff_phi_orm_comp(j,k) or dr_orm_comp(i,k) or dr_orm_comp(j,k))
                            and calo2_obj_vs_templ(k,1)
                            );
                        end if;
                    end loop;
                end loop;
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_double_p;
    end generate matrix_double_i;

-- HB 2017-09-06: max. 12 calo1 obj. and 12 calo2 obj. => max. length of obj_vs_templ_vec = 12*11*10*12 = 15840/5280 =3 splitted vectors
-- Condition type: "triple".
    matrix_triple_i: if nr_templates = 3 generate
        matrix_triple_p: process(calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo2_obj_vs_templ,
            diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
            variable index : integer := 0;
            variable index2 : integer := 0;
            variable test_index : integer := 0;
            variable obj_vs_templ_vec1  : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
            variable obj_vs_templ_vec2  : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
            variable obj_vs_templ_vec3  : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
        begin
            index := 0;
            index2 := 0;
            test_index := 0;
            obj_vs_templ_vec1  := (others => '0');
            obj_vs_templ_vec2  := (others => '0');
            obj_vs_templ_vec3  := (others => '0');
            for i in calo1_object_slice_1_low to calo1_object_slice_1_high loop
                for j in calo1_object_slice_2_low to calo1_object_slice_2_high loop
                    for k in calo1_object_slice_3_low to calo1_object_slice_3_high loop
                        for l in calo2_object_low to calo2_object_high loop
                            if (j/=i and k/=i and k/=j) then
                                if((index mod and_partition_len) = 0) then
                                    if(index /= 0) then
                                        index2 := 0;
                                        test_index := test_index + 1;
                                    end if;
                                end if;
                                if(test_index = 0) then
                                    obj_vs_templ_vec1(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo2_obj_vs_templ(l,1) and
                                    not (
                                    (diff_eta_orm_comp(i,l) or diff_eta_orm_comp(j,l) or diff_eta_orm_comp(k,l) or
                                    diff_phi_orm_comp(i,l) or diff_phi_orm_comp(j,l) or diff_phi_orm_comp(k,l) or
                                    dr_orm_comp(i,l) or dr_orm_comp(j,l) or dr_orm_comp(k,l))
                                    and calo2_obj_vs_templ(l,1)
                                    );
                                elsif(test_index = 1) then
                                    obj_vs_templ_vec2(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo2_obj_vs_templ(l,1) and
                                    not (
                                    (diff_eta_orm_comp(i,l) or diff_eta_orm_comp(j,l) or diff_eta_orm_comp(k,l) or
                                    diff_phi_orm_comp(i,l) or diff_phi_orm_comp(j,l) or diff_phi_orm_comp(k,l) or
                                    dr_orm_comp(i,l) or dr_orm_comp(j,l) or dr_orm_comp(k,l))
                                    and calo2_obj_vs_templ(l,1)
                                    );
                                elsif(test_index = 2) then
                                    obj_vs_templ_vec3(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo2_obj_vs_templ(l,1) and
                                    not (
                                    (diff_eta_orm_comp(i,l) or diff_eta_orm_comp(j,l) or diff_eta_orm_comp(k,l) or
                                    diff_phi_orm_comp(i,l) or diff_phi_orm_comp(j,l) or diff_phi_orm_comp(k,l) or
                                    dr_orm_comp(i,l) or dr_orm_comp(j,l) or dr_orm_comp(k,l))
                                    and calo2_obj_vs_templ(l,1)
                                    );
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
        end process matrix_triple_p;

        matrix_triple_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3)
            variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3 : std_logic := '0';
        begin
            condition_and_or_tmp1  := '0';
            condition_and_or_tmp2  := '0';
            condition_and_or_tmp3  := '0';
            for i in 0 to and_partition_len-1 loop
                condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
                condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
                condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
            end loop;
            condition_and_or_sig1 <= condition_and_or_tmp1;
            condition_and_or_sig2 <= condition_and_or_tmp2;
            condition_and_or_sig3 <= condition_and_or_tmp3;
        end process matrix_triple_p_2;
        condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3;
    end generate matrix_triple_i;

-- -- HB 2019-10-17: max. 8 calo1 obj. and 12 calo2 obj. => max. length of obj_vs_templ_vec = 8*7*6*5*12 = 20160/5280=3.81
-- Condition type: "quad".
    matrix_quad_i: if nr_templates = 4 generate
        matrix_quad_p_1: process(calo1_obj_slice_1_vs_templ, calo1_obj_slice_2_vs_templ, calo1_obj_slice_3_vs_templ, calo1_obj_slice_4_vs_templ,
            calo2_obj_vs_templ, diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
            variable index : integer := 0;
            variable index2 : integer := 0;
            variable test_index : integer := 0;
            variable obj_vs_templ_vec1 : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
            variable obj_vs_templ_vec2 : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
            variable obj_vs_templ_vec3 : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
            variable obj_vs_templ_vec4 : std_logic_vector(and_partition_len-1 downto 0) := (others => '0');
        begin
            index := 0;
            index2 := 0;
            test_index := 0;
            obj_vs_templ_vec1 := (others => '0');
            obj_vs_templ_vec2 := (others => '0');
            obj_vs_templ_vec3 := (others => '0');
            obj_vs_templ_vec4 := (others => '0');
            for i in calo1_object_slice_1_low to calo1_object_slice_1_high loop
                for j in calo1_object_slice_2_low to calo1_object_slice_2_high loop
                    for k in calo1_object_slice_3_low to calo1_object_slice_3_high loop
                        for l in calo1_object_slice_4_low to calo1_object_slice_4_high loop
                            for m in calo2_object_low to calo2_object_high loop
                                if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                                    if((index mod and_partition_len) = 0) then
                                        if(index /= 0) then
                                            index2 := 0;
                                            test_index := test_index + 1;
                                        end if;
                                    end if;
                                    if(test_index = 0) then
                                        obj_vs_templ_vec1(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo1_obj_slice_4_vs_templ(l,1) and calo2_obj_vs_templ(m,1) and
                                        not (
                                        (diff_eta_orm_comp(i,m) or diff_eta_orm_comp(j,m) or diff_eta_orm_comp(k,m) or diff_eta_orm_comp(l,m) or
                                        diff_phi_orm_comp(i,m) or diff_phi_orm_comp(j,m) or diff_phi_orm_comp(k,m) or diff_phi_orm_comp(l,m) or
                                        dr_orm_comp(i,m) or dr_orm_comp(j,m) or dr_orm_comp(k,m) or dr_orm_comp(l,m))
                                        and calo2_obj_vs_templ(m,1)
                                        );
                                    elsif(test_index = 1) then
                                        obj_vs_templ_vec2(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo1_obj_slice_4_vs_templ(l,1) and calo2_obj_vs_templ(m,1) and
                                        not (
                                        (diff_eta_orm_comp(i,m) or diff_eta_orm_comp(j,m) or diff_eta_orm_comp(k,m) or diff_eta_orm_comp(l,m) or
                                        diff_phi_orm_comp(i,m) or diff_phi_orm_comp(j,m) or diff_phi_orm_comp(k,m) or diff_phi_orm_comp(l,m) or
                                        dr_orm_comp(i,m) or dr_orm_comp(j,m) or dr_orm_comp(k,m) or dr_orm_comp(l,m))
                                        and calo2_obj_vs_templ(m,1)
                                        );
                                    elsif(test_index = 2) then
                                        obj_vs_templ_vec3(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo1_obj_slice_4_vs_templ(l,1) and calo2_obj_vs_templ(m,1) and
                                        not (
                                        (diff_eta_orm_comp(i,m) or diff_eta_orm_comp(j,m) or diff_eta_orm_comp(k,m) or diff_eta_orm_comp(l,m) or
                                        diff_phi_orm_comp(i,m) or diff_phi_orm_comp(j,m) or diff_phi_orm_comp(k,m) or diff_phi_orm_comp(l,m) or
                                        dr_orm_comp(i,m) or dr_orm_comp(j,m) or dr_orm_comp(k,m) or dr_orm_comp(l,m))
                                        and calo2_obj_vs_templ(m,1)
                                        );
                                    elsif(test_index = 3) then
                                        obj_vs_templ_vec4(index2) := calo1_obj_slice_1_vs_templ(i,1) and calo1_obj_slice_2_vs_templ(j,1) and calo1_obj_slice_3_vs_templ(k,1) and calo1_obj_slice_4_vs_templ(l,1) and calo2_obj_vs_templ(m,1) and
                                        not (
                                        (diff_eta_orm_comp(i,m) or diff_eta_orm_comp(j,m) or diff_eta_orm_comp(k,m) or diff_eta_orm_comp(l,m) or
                                        diff_phi_orm_comp(i,m) or diff_phi_orm_comp(j,m) or diff_phi_orm_comp(k,m) or diff_phi_orm_comp(l,m) or
                                        dr_orm_comp(i,m) or dr_orm_comp(j,m) or dr_orm_comp(k,m) or dr_orm_comp(l,m))
                                        and calo2_obj_vs_templ(m,1)
                                        );
                                    end if;
                                    index := index + 1;
                                    index2 := index2 +1;
                                end if;
                            end loop;
                        end loop;
                    end loop;
                end loop;
            end loop;
            obj_vs_templ_vec_sig1 <= obj_vs_templ_vec1;
            obj_vs_templ_vec_sig2 <= obj_vs_templ_vec2;
            obj_vs_templ_vec_sig3 <= obj_vs_templ_vec3;
            obj_vs_templ_vec_sig4 <= obj_vs_templ_vec4;
        end process matrix_quad_p_1;

        matrix_quad_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3, obj_vs_templ_vec_sig4)
            variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3, condition_and_or_tmp4 : std_logic := '0';
        begin
            condition_and_or_tmp1  := '0';
            condition_and_or_tmp2  := '0';
            condition_and_or_tmp3  := '0';
            condition_and_or_tmp4  := '0';
            for i in 0 to and_partition_len-1 loop
                condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
                condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
                condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
                condition_and_or_tmp4 := condition_and_or_tmp3 or obj_vs_templ_vec_sig4(i);
            end loop;
            condition_and_or_sig1 <= condition_and_or_tmp1;
            condition_and_or_sig2 <= condition_and_or_tmp2;
            condition_and_or_sig3 <= condition_and_or_tmp3;
            condition_and_or_sig4 <= condition_and_or_tmp4;
        end process matrix_quad_p_2;
        condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3 or condition_and_or_sig4;
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
