
-- Description:
-- Comparators fro charge correlation

-- Version history:
-- HB 2020-05-06: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity charge_correlation_comp is
     generic(
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_MU_OBJECTS-1;
        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_MU_OBJECTS-1;
        requested_charge_correlation: string(1 to 2) := "ig";
        double_sel: boolean := false;
        triple_sel: boolean := false;
        same_bx: boolean
    );
    port(
        lhc_clk: in std_logic;
        ls_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        os_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        ls_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        os_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        charge_comp_double_o : out std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '1'));
        charge_comp_triple_o : out std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '1')))
    );
end charge_correlation_comp;

architecture rtl of charge_correlation_comp is

    signal charge_comp_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '1'));
    signal charge_comp_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '1')));

begin

    cc_double_sel: if double_sel generate
        charge_double_i: if requested_charge_correlation /= "ig" generate
        -- Charge correlation comparison
            charge_double_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
                charge_double_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                    obj_same_bx_l: if same_bx = true generate
                        charge_double_if: if j/=i generate
                            charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                '1' when requested_charge_correlation = "ig" else '0';
                        end generate charge_double_if;
                    end generate obj_same_bx_l;
                    obj_different_bx_l: if same_bx = false generate
                        charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                            '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                            '1' when requested_charge_correlation = "ig" else '0';
                    end generate obj_different_bx_l;
                end generate charge_double_l_2;
            end generate charge_double_l_1;
        end generate charge_double_i;
    end generate cc_double_sel;


    cc_triple_sel: if triple_sel generate
        charge_triple_i: if requested_charge_correlation /= "ig" generate
        -- Charge correlation comparison
            charge_triple_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
                charge_triple_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                    charge_triple_l_3: for k in slice_low_obj3 to slice_high_obj3 generate
                        obj_same_bx_l: if same_bx = true generate
                            charge_triple_if: if (j/=i and k/=i and k/=j) generate
                                charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                    '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                    '1' when requested_charge_correlation = "ig" else '0';
                            end generate charge_triple_if;
                        end generate obj_same_bx_l;
                        obj_different_bx_l: if same_bx = false generate
                            charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                '1' when requested_charge_correlation = "ig" else '0';
                        end generate obj_different_bx_l;
                    end generate charge_triple_l_3;
                end generate charge_triple_l_2;
            end generate charge_triple_l_1;
        end generate charge_triple_i;
    end generate cc_triple_sel;

    pipeline_p: process(lhc_clk, charge_comp_double, charge_comp_triple)
        begin
        if not INTERMEDIATE_PIPELINE then
            charge_comp_double_o <= charge_comp_double;
            charge_comp_triple_o <= charge_comp_triple;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                charge_comp_double_o <= charge_comp_double;
                charge_comp_triple_o <= charge_comp_triple;
            end if;
        end if;
    end process;

end architecture rtl;
