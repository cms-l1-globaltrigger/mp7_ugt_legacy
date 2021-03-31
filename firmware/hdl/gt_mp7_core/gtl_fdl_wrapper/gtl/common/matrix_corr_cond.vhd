-- Description:

-- Matrix for correlation conditions with 2 objects

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
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_EG_OBJECTS-1;
        type_obj1: natural := EG_TYPE;
        type_obj2: natural := EG_TYPE;
        same_bx: boolean := false
    );
    port(
        obj1_vs_templ : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
        obj2_vs_templ : in std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
        deta_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dphi_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dr_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_div_dr_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        twobody_pt_comp : in std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        charge_comp_double : in muon_charcorr_double_array := (others => (others => '1'));
        condition_and_or: out std_logic
    );
end matrix_corr_cond;

architecture rtl of matrix_corr_cond is

begin

    matrix_and_or_p: process(obj1_vs_templ, obj2_vs_templ, deta_comp, dphi_comp, dr_comp, mass_comp, mass_div_dr_comp, twobody_pt_comp, charge_comp_double)
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
                            obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and twobody_pt_comp(i,j) and charge_comp_double(i,j);
                        else
                            obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and twobody_pt_comp(i,j);
                        end if;
                    end if;
                else
                    index := index + 1;
                    if (type_obj1 = MU_TYPE) and (type_obj2 = MU_TYPE) then
                        obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and twobody_pt_comp(i,j) and charge_comp_double(i,j);
                    else
                        obj_vs_templ_vec(index) := obj1_vs_templ(i,1) and obj2_vs_templ(j,1) and deta_comp(i,j) and dphi_comp(i,j) and dr_comp(i,j) and mass_comp(i,j) and mass_div_dr_comp(i,j) and twobody_pt_comp(i,j);
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

end architecture rtl;
