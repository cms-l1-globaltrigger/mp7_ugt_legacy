-- Description:
-- Muon condition matrix

-- Version history:
-- HB 2021-04-15: minor update. Changed name.
-- HB 2021-02-19: updated condition output pipeline.
-- HB 2020-08-10: inserted "twobody unconstraint pt".
-- HB 2019-04-30: first version (updated Dinyar/Hannes proposal).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity matrix_muon_cond is
    generic(
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive
    );
    port(
        clk : in std_logic;
        obj_slice_1_vs_templ : in std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_high, 1 to 1);
        obj_slice_2_vs_templ : in std_logic_2dim_array(muon_object_slice_2_low to muon_object_slice_2_high, 1 to 1);
        obj_slice_3_vs_templ : in std_logic_2dim_array(muon_object_slice_3_low to muon_object_slice_3_high, 1 to 1);
        obj_slice_4_vs_templ : in std_logic_2dim_array(muon_object_slice_4_low to muon_object_slice_4_high, 1 to 1);
        charge_comp_double : in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        charge_comp_triple : in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        charge_comp_quad : in std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        twobody_pt_comp : in std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_high, muon_object_slice_2_low to muon_object_slice_2_high);
        twobody_upt_comp : in std_logic_2dim_array(muon_object_slice_1_low to muon_object_slice_1_high, muon_object_slice_2_low to muon_object_slice_2_high);
        condition_o : out std_logic
    );
end matrix_muon_cond;

architecture Behavioral of matrix_muon_cond is
    constant nr_objects_slice_1_int: natural := muon_object_slice_1_high-muon_object_slice_1_low+1;
    constant nr_objects_slice_2_int: natural := muon_object_slice_2_high-muon_object_slice_2_low+1;
    constant nr_objects_slice_3_int: natural := muon_object_slice_3_high-muon_object_slice_3_low+1;
    constant nr_objects_slice_4_int: natural := muon_object_slice_4_high-muon_object_slice_4_low+1;

    signal condition_and_or : std_logic;

begin

    -- "Matrix" of permutations in an and-or-structure.
    -- Selection of muon condition types ("single", "double", "double_wsc", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

    -- Condition type: "single".
    matrix_single_i: if nr_templates = 1 generate
    -- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
        matrix_single_p: process(obj_slice_1_vs_templ)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector(nr_objects_slice_1_int downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_slice_1_low to muon_object_slice_1_high loop
                index := index + 1;
                obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1);
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_single_p;
    end generate matrix_single_i;

    -- Condition type: "double".
    -- matrix_double_i: if (nr_templates = 2 and double_wsc = false) generate
    matrix_double_i: if nr_templates = 2 generate
        matrix_double_p: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, charge_comp_double, twobody_pt_comp, twobody_upt_comp)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_slice_1_low to muon_object_slice_1_high loop
                for j in muon_object_slice_2_low to muon_object_slice_2_high loop
                    if j/=i then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and charge_comp_double(i,j) and twobody_pt_comp(i,j) and twobody_upt_comp(i,j);
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
        matrix_triple_p: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, charge_comp_triple)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_objects_slice_3_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_slice_1_low to muon_object_slice_1_high loop
                for j in muon_object_slice_2_low to muon_object_slice_2_high loop
                    for k in muon_object_slice_3_low to muon_object_slice_3_high loop
                        if (j/=i and k/=i and k/=j) then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1) and charge_comp_triple(i,j,k);
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
        matrix_quad_p: process(obj_slice_1_vs_templ, obj_slice_2_vs_templ, obj_slice_3_vs_templ, obj_slice_4_vs_templ, charge_comp_quad)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((nr_objects_slice_1_int*nr_objects_slice_2_int*nr_objects_slice_3_int*nr_objects_slice_4_int) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_slice_1_low to muon_object_slice_1_high loop
                for j in muon_object_slice_2_low to muon_object_slice_2_high loop
                    for k in muon_object_slice_3_low to muon_object_slice_3_high loop
                        for l in muon_object_slice_4_low to muon_object_slice_4_high loop
                            if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                                index := index + 1;
                                obj_vs_templ_vec(index) := obj_slice_1_vs_templ(i,1) and obj_slice_2_vs_templ(j,1) and obj_slice_3_vs_templ(k,1) and obj_slice_4_vs_templ(l,1) and charge_comp_quad(i,j,k,l);
                            end if;
                        end loop;
                    end loop;
                end loop;
            end loop;
            for i in 1 to index loop
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_quad_p;
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
