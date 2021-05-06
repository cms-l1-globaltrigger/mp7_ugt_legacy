
-- Desription:
-- Generates the charge correlations for muon conditions.

-- Version history:
-- HB 2015-11-20: inserted charge correlation (double) for different Bx (needed for muon muon correlation conditions)
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_charge_correlations is
    port(
-- HB 2015-11-20: charge correlation for different Bx needed for muon muon correlation conditions, therefore data1 and data2
        data1: in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        data2: in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        ls_charcorr_double: out std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        os_charcorr_double: out std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        ls_charcorr_triple: out std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        os_charcorr_triple: out std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        ls_charcorr_quad: out std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        os_charcorr_quad: out std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1)
    );
end muon_charge_correlations;

architecture rtl of muon_charge_correlations is
    type charge_bits_array is array (0 to NR_MUON_OBJECTS-1) of std_logic_vector(d_s_i_muon.charge_high-d_s_i_muon.charge_low downto 0);
    signal charge_bits1, charge_bits2 : charge_bits_array;
    signal ls_charcorr_double_int : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal os_charcorr_double_int : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal ls_charcorr_triple_int : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal os_charcorr_triple_int : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal ls_charcorr_quad_int : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
    signal os_charcorr_quad_int : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
begin

-- *********************************************************
-- CHARGE: 2 bits, charge_valid and charge_sign
-- assumptions:
-- charge_sign = '0' => positive muon
-- charge_sign = '1' => negative muon
-- d_s_i_muon.charge_high = charge_valid
-- d_s_i_muon.charge_low = charge_sign
-- *********************************************************

-- HB 2014-04-14:
-- "ls" = "like sign", "os" = "opposite sign" (see mail from VG "Re: Definition der muon-conditions", 2014-04-11)

charge_bits_l: for i in 0 to NR_MUON_OBJECTS-1 generate
-- HB 2015-11-20: charge correlation for different Bx needed for muon muon correlation conditions, therefore charge_bits1 and charge_bits2
    charge_bits1(i) <= data1(i)(d_s_i_muon.charge_high downto d_s_i_muon.charge_low);
    charge_bits2(i) <= data2(i)(d_s_i_muon.charge_high downto d_s_i_muon.charge_low);
end generate charge_bits_l;

-- HB 2014-04-14: charge correlation not useful for one object

loop_2_1: for i in 0 to NR_MUON_OBJECTS-1 generate
    loop_2_2: for j in 0 to NR_MUON_OBJECTS-1 generate
-- HB 2015-11-20: charge correlation for different Bx needed for muon muon correlation conditions, therefore removed "if j/=i generate"
--         index_2: if j/=i generate
            ls_charcorr_double_int(i,j) <= '1' when charge_bits1(i) = "10" and charge_bits2(j) = "10" else -- + + : LS both positive muons
                                           '1' when charge_bits1(i) = "11" and charge_bits2(j) = "11" else -- - - : LS both negative muons
                                           '0';

            os_charcorr_double_int(i,j) <= '1' when charge_bits1(i) = "10" and charge_bits2(j) = "11" else -- + - : OS two muons of opposite sign
                                           '1' when charge_bits1(i) = "11" and charge_bits2(j) = "10" else -- - + : OS two muons of opposite sign
                                           '0';
--         end generate index_2;
    end generate loop_2_2;
end generate loop_2_1;

ls_charcorr_double <= ls_charcorr_double_int;
os_charcorr_double <= os_charcorr_double_int;

loop_3_1: for i in 0 to NR_MUON_OBJECTS-1 generate
    loop_3_2: for j in 0 to NR_MUON_OBJECTS-1 generate
        loop_3_3: for k in 0 to NR_MUON_OBJECTS-1 generate
            index_3: if (j/=i and k/=i and k/=j) generate
                ls_charcorr_triple_int(i,j,k) <= '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10" and charge_bits1(k) = "10" else -- + + + : LS three muons of positive charge
                                                 '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11" and charge_bits1(k) = "11" else -- - - - : LS three muons of negative charge
                                                 '0';

                os_charcorr_triple_int(i,j,k) <= '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11" and charge_bits1(k) = "11" else -- + - - : OS a pair plus a negative muon
                                                 '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10" and charge_bits1(k) = "11" else -- + + - : OS a pair plus a positive muon
                                                 '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11" and charge_bits1(k) = "10" else -- + - + : OS a pair plus a positive muon
                                                 '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10" and charge_bits1(k) = "10" else -- - + + : OS a pair plus a positive muon
                                                 '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11" and charge_bits1(k) = "10" else -- - - + : OS a pair plus a negative muon
                                                 '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10" and charge_bits1(k) = "11" else -- - + - : OS a pair plus a negative muon
                                                 '0';
-- HB 2014-04-14: alternative code, to bechecked
--                     os_charcorr_triple_int(i,j,k) <= '1' when (charge_bits1(i)(1) = '1' and charge_bits1(j)(1) = '1'  and charge_bits1(k)(1) = '1')
--                                                               and not ls_charcorr_triple_int(i,j,k) else '0'
            end generate index_3;
        end generate loop_3_3;
    end generate loop_3_2;
end generate loop_3_1;

ls_charcorr_triple <= ls_charcorr_triple_int;
os_charcorr_triple <= os_charcorr_triple_int;

loop_4_1: for i in 0 to NR_MUON_OBJECTS-1 generate
    loop_4_2: for j in 0 to NR_MUON_OBJECTS-1 generate
        loop_4_3: for k in 0 to NR_MUON_OBJECTS-1 generate
            loop_4_4: for l in 0 to NR_MUON_OBJECTS-1 generate
                index_4: if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) generate
                    ls_charcorr_quad_int(i,j,k,l) <= '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10" and charge_bits1(k) = "10" and charge_bits1(l) = "10" else -- + + + + : LS four muons of positive charge
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11" and charge_bits1(k) = "11" and charge_bits1(l) = "11" else -- - - - - : LS four muons of negative charge
                                                     '0';
                    os_charcorr_quad_int(i,j,k,l) <= '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10"  and charge_bits1(k) = "10" and charge_bits1(l) = "11" else -- + + + - : OS a pair plus two positive muons
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10"  and charge_bits1(k) = "11" and charge_bits1(l) = "10" else -- + + - + : OS a pair plus two positive muons
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "10"  and charge_bits1(k) = "11" and charge_bits1(l) = "11" else -- + + - - : OS two pairs
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11"  and charge_bits1(k) = "10" and charge_bits1(l) = "10" else -- + - + + : OS a pair plus two positive muons
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11"  and charge_bits1(k) = "10" and charge_bits1(l) = "11" else -- + - + - : OS two pairs
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11"  and charge_bits1(k) = "11" and charge_bits1(l) = "10" else -- + - - + : OS two pairs
                                                     '1' when charge_bits1(i) = "10" and charge_bits1(j) = "11"  and charge_bits1(k) = "11" and charge_bits1(l) = "11" else -- + - - - : OS a pair plus two negative muons
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10"  and charge_bits1(k) = "10" and charge_bits1(l) = "10" else -- - + + + : OS a pair plus two positive muons
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10"  and charge_bits1(k) = "10" and charge_bits1(l) = "11" else -- - + + - : OS two pairs
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10"  and charge_bits1(k) = "11" and charge_bits1(l) = "10" else -- - + - + : OS two pairs
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "10"  and charge_bits1(k) = "11" and charge_bits1(l) = "11" else -- - + - - : OS a pair plus two negative muons
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11"  and charge_bits1(k) = "10" and charge_bits1(l) = "10" else -- - - + + : OS two pairs
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11"  and charge_bits1(k) = "10" and charge_bits1(l) = "11" else -- - - + - : OS a pair plus two negative muons
                                                     '1' when charge_bits1(i) = "11" and charge_bits1(j) = "11"  and charge_bits1(k) = "11" and charge_bits1(l) = "10" else -- - - - + : OS a pair plus two negative muons
                                                     '0';
-- HB 2014-04-14: alternative code, to bechecked
--                     os_charcorr_quad_int(i,j,k,l) <= '1' when (charge_bits1(i)(1) = '1' and charge_bits1(j)(1) = '1'  and charge_bits1(k)(1) = '1' and charge_bits1(l)(1) = '1')
--                                                               and not ls_charcorr_quad_int(i,j,k,l) else '0'
                end generate index_4;
            end generate loop_4_4;
        end generate loop_4_3;
    end generate loop_4_2;
end generate loop_4_1;

ls_charcorr_quad <= ls_charcorr_quad_int;
os_charcorr_quad <= os_charcorr_quad_int;

end architecture rtl;
