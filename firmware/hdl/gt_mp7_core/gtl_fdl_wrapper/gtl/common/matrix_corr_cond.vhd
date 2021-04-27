-- Description:

-- Matrix for correlation conditions

-- Version history:
-- HB 2021-03-16: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity matrix_corr_cond is
     generic(
        no_orm: boolean := false;
        obj_2plus1: boolean := true;
        mass_3_obj: boolean := false;
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_EG_OBJECTS-1;
        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_EG_OBJECTS-1;
        type_obj1: natural := EG_TYPE;
        type_obj2: natural := EG_TYPE;
        same_bx: boolean := false
    );
    port(
        obj1_vs_templ : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
        obj2_vs_templ : in std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
        obj3_vs_templ : in std_logic_2dim_array(slice_low_obj3 to slice_high_obj3, 1 to 1) := (others => (others => '0'));
        deta_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dphi_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dr_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_div_dr_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_3_obj_comp : std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => (others => '0')));
        tbpt_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        charge_comp_double : in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '1'));
        charge_comp_triple : in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '1')));
        deta_orm_comp_12 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        deta_orm_comp_13 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        deta_orm_comp_23 : in std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        dphi_orm_comp_12 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dphi_orm_comp_13 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        dphi_orm_comp_23 : in std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        dr_orm_comp_12 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dr_orm_comp_13 : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        dr_orm_comp_23 : in std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => '1'));
        condition_and_or: out std_logic
    );
end matrix_corr_cond;

architecture rtl of matrix_corr_cond is

begin

    no_orm_i: if no_orm and not mass_3_obj generate

        matrix_and_or_p: process(obj1_vs_templ, obj2_vs_templ, deta_comp, dphi_comp, dr_comp, mass_comp, mass_div_dr_comp, tbpt_comp, charge_comp_double)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop
                for j in slice_low_obj2 to slice_high_obj2 loop
                    if type_obj1 = type_obj2 and same_bx then
                        if j/=i then
                            index := index + 1;
                            if (type_obj1 = MU_TYPE) and (type_obj2 = MU_TYPE) then
                                obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and      dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and tbpt_comp(i,j) and charge_comp_double(i,j);
                            else
                                obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and tbpt_comp(i,j);
                            end if;
                        end if;
                    else
                        index := index + 1;
                        if (type_obj1 = MU_TYPE) and (type_obj2 = MU_TYPE) then
                            obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and tbpt_comp(i,j) and charge_comp_double(i,j);
                        else
                            obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and tbpt_comp(i,j);
                        end if;
                    end if;
                end loop;
            end loop;
            for i in 1 to index loop
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process;

    end generate no_orm_i;

    orm_i: if not no_orm and not mass_3_obj generate
        obj_2plus1_true_i: if obj_2plus1 generate

            matrix_and_or_p: process(obj1_vs_templ, obj2_vs_templ, obj3_vs_templ, deta_orm_comp_13, dphi_orm_comp_13, dr_orm_comp_13, deta_orm_comp_23, dphi_orm_comp_23, dr_orm_comp_23, deta_comp, dphi_comp, dr_comp, mass_comp, tbpt_comp)
                variable index : integer := 0;
                variable obj_vs_templ_vec, orm_vec: std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) :=
                    (others => (others => (others => '0')));
                variable obj_vs_templ_or_tmp, obj_vs_templ_orm_vec, orm_vec_or_tmp: std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
                variable obj_vs_templ_orm_idx_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) :=
                    (others => '0');
                variable condition_and_or_tmp : std_logic := '0';
            begin
                index := 0;
                obj_vs_templ_vec := (others => (others => (others => '0')));
                obj_vs_templ_or_tmp := (others => (others => '0'));
                obj_vs_templ_orm_vec := (others => (others => '0'));
                obj_vs_templ_orm_idx_vec := (others => '0');
                orm_vec := (others => (others => (others => '0')));
                orm_vec_or_tmp := (others => (others => '0'));
                condition_and_or_tmp := '0';
                for i in slice_low_obj1 to slice_high_obj1 loop
                    for j in slice_low_obj2 to slice_high_obj2 loop
                        if j/=i then
                            for k in slice_low_obj3 to slice_high_obj3 loop
                                obj_vs_templ_vec(i,j,k) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and obj3_vs_templ(k,1) and mass_comp(i,j) and dr_comp(i,j) and dphi_comp(i,j) and deta_comp(i,j) and tbpt_comp(i,j);
                                orm_vec(i,j,k) := (dr_orm_comp_13(i,k) or dr_orm_comp_23(j,k) or dphi_orm_comp_13(i,k) or
                                    dphi_orm_comp_23(j,k) or deta_orm_comp_13(i,k) or deta_orm_comp_23(j,k)) and obj3_vs_templ(k,1);
                                orm_vec_or_tmp(i,j) := orm_vec_or_tmp(i,j) or orm_vec(i,j,k);
                                obj_vs_templ_or_tmp(i,j) := obj_vs_templ_or_tmp(i,j) or obj_vs_templ_vec(i,j,k);
                            end loop;
                            index := index + 1;
                            obj_vs_templ_orm_vec(i,j) := obj_vs_templ_or_tmp(i,j) and not orm_vec_or_tmp(i,j);
                            obj_vs_templ_orm_idx_vec(index) := obj_vs_templ_orm_vec(i,j);
                        end if;
                    end loop;
                end loop;
                for i in 1 to index loop
                    -- ORs for matrix
                    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_orm_idx_vec(i);
                end loop;
                condition_and_or <= condition_and_or_tmp;
            end process;

        end generate obj_2plus1_true_i;

        obj_2plus1_false_i: if not obj_2plus1 generate

            matrix_and_or_p: process(obj1_vs_templ, obj2_vs_templ, deta_orm_comp_12, dphi_orm_comp_12, dr_orm_comp_12, deta_comp, dphi_comp, dr_comp, mass_comp, tbpt_comp)
                variable index : integer := 0;
                variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) :=
                    (others => '0');
                variable condition_and_or_tmp : std_logic := '0';
            begin
                index := 0;
                obj_vs_templ_vec := (others => '0');
                condition_and_or_tmp := '0';
                for i in slice_low_obj1 to slice_high_obj1 loop
                    for j in slice_low_obj2 to slice_high_obj2 loop
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and
                            mass_comp(i,j) and dr_comp(i,j) and dphi_comp(i,j) and deta_comp(i,j) and tbpt_comp(i,j) and
                            not ((dr_orm_comp_12(i,j) or dphi_orm_comp_12(i,j) or deta_orm_comp_12(i,j)) and obj2_vs_templ(j,1));
                    end loop;
                end loop;
                for i in 1 to index loop
                    -- ORs for matrix
                    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
                end loop;
                condition_and_or <= condition_and_or_tmp;
            end process;

        end generate obj_2plus1_false_i;
    end generate orm_i;

    mass_3_obj_i: if mass_3_obj generate

        matrix_p: process(obj1_vs_templ, obj2_vs_templ, obj3_vs_templ, mass_3_obj_comp, charge_comp_triple)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)*(slice_high_obj3-slice_low_obj3+1) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in slice_low_obj1 to slice_high_obj1 loop
                for j in slice_low_obj2 to slice_high_obj2 loop
                    for k in slice_low_obj3 to slice_high_obj3 loop
                        if j/=i and i/=k and j/=k then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and obj3_vs_templ(k,1) and
                                mass_3_obj_comp(i,j,k) and charge_comp_triple(i,j,k);
                        end if;
                    end loop;
                end loop;
            end loop;
            for i in 1 to index loop
                -- ORs for matrix
                condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
            end loop;
            condition_and_or <= condition_and_or_tmp;
        end process matrix_p;

    end generate mass_3_obj_i;

end architecture rtl;
