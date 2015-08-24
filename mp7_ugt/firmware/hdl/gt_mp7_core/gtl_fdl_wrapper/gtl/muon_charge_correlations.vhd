--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/muon_charge_correlations.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:
-- Generates the charge correlations for muon conditions.

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_charge_correlations is
    port(
        data: in muon_objects_array(0 to NR_MUON_OBJECTS-1);
-- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
--         positive_charge: out muon_charge_1_array;
--         negative_charge: out muon_charge_1_array;
        ls_charcorr_double: out muon_charcorr_double_array;
        os_charcorr_double: out muon_charcorr_double_array;
        ls_charcorr_triple: out muon_charcorr_triple_array;
        os_charcorr_triple: out muon_charcorr_triple_array;
        ls_charcorr_quad: out muon_charcorr_quad_array;
        os_charcorr_quad: out muon_charcorr_quad_array
    );
end muon_charge_correlations;

architecture rtl of muon_charge_correlations is
    type charge_bits_array is array (0 to NR_MUON_OBJECTS-1) of std_logic_vector(d_s_i_muon.charge_high-d_s_i_muon.charge_low downto 0);
    signal charge_bits : charge_bits_array;
    signal ls_charcorr_double_int : muon_charcorr_double_array := (others => (others => '0'));
    signal os_charcorr_double_int : muon_charcorr_double_array := (others => (others => '0'));
    signal ls_charcorr_triple_int : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal os_charcorr_triple_int : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal ls_charcorr_quad_int : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal os_charcorr_quad_int : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
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
    charge_bits(i) <= data(i)(d_s_i_muon.charge_high downto d_s_i_muon.charge_low);
end generate charge_bits_l;

-- HB 2014-04-14: charge correlation not useful for one object

loop_2_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
    loop_2_2: for j in 0 to NR_MUON_OBJECTS-1 generate 
        index_2: if j/=i generate
            ls_charcorr_double_int(i,j) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "10" else -- + + : LS both positive muons
                                           '1' when charge_bits(i) = "11" and charge_bits(j) = "11" else -- - - : LS both negative muons
                                           '0';

            os_charcorr_double_int(i,j) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "11" else -- + - : OS two muons of opposite sign
                                           '1' when charge_bits(i) = "11" and charge_bits(j) = "10" else -- - + : OS two muons of opposite sign
                                           '0';
        end generate index_2;
    end generate loop_2_2;
end generate loop_2_1;

ls_charcorr_double <= ls_charcorr_double_int;
os_charcorr_double <= os_charcorr_double_int;

loop_3_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
    loop_3_2: for j in 0 to NR_MUON_OBJECTS-1 generate 
        loop_3_3: for k in 0 to NR_MUON_OBJECTS-1 generate 
            index_3: if (j/=i and k/=i and k/=j) generate
                ls_charcorr_triple_int(i,j,k) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "10" and charge_bits(k) = "10" else -- + + + : LS three muons of positive charge
                                                 '1' when charge_bits(i) = "11" and charge_bits(j) = "11" and charge_bits(k) = "11" else -- - - - : LS three muons of negative charge
                                                 '0';

                os_charcorr_triple_int(i,j,k) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "11" and charge_bits(k) = "11" else -- + - - : OS a pair plus a negative muon
                                                 '1' when charge_bits(i) = "10" and charge_bits(j) = "10" and charge_bits(k) = "11" else -- + + - : OS a pair plus a positive muon
                                                 '1' when charge_bits(i) = "10" and charge_bits(j) = "11" and charge_bits(k) = "10" else -- + - + : OS a pair plus a positive muon
                                                 '1' when charge_bits(i) = "11" and charge_bits(j) = "10" and charge_bits(k) = "10" else -- - + + : OS a pair plus a positive muon
                                                 '1' when charge_bits(i) = "11" and charge_bits(j) = "11" and charge_bits(k) = "10" else -- - - + : OS a pair plus a negative muon
                                                 '1' when charge_bits(i) = "11" and charge_bits(j) = "10" and charge_bits(k) = "11" else -- - + - : OS a pair plus a negative muon
                                                 '0';
-- HB 2014-04-14: alternative code, to bechecked
--                     os_charcorr_triple_int(i,j,k) <= '1' when (charge_bits(i)(1) = '1' and charge_bits(j)(1) = '1'  and charge_bits(k)(1) = '1') 
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
                    ls_charcorr_quad_int(i,j,k,l) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "10" and charge_bits(k) = "10" and charge_bits(l) = "10" else -- + + + + : LS four muons of positive charge
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "11" and charge_bits(k) = "11" and charge_bits(l) = "11" else -- - - - - : LS four muons of negative charge
                                                     '0';
                    os_charcorr_quad_int(i,j,k,l) <= '1' when charge_bits(i) = "10" and charge_bits(j) = "10"  and charge_bits(k) = "10" and charge_bits(l) = "11" else -- + + + - : OS a pair plus two positive muons
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "10"  and charge_bits(k) = "11" and charge_bits(l) = "10" else -- + + - + : OS a pair plus two positive muons
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "10"  and charge_bits(k) = "11" and charge_bits(l) = "11" else -- + + - - : OS two pairs
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "11"  and charge_bits(k) = "10" and charge_bits(l) = "10" else -- + - + + : OS a pair plus two positive muons
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "11"  and charge_bits(k) = "10" and charge_bits(l) = "11" else -- + - + - : OS two pairs
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "11"  and charge_bits(k) = "11" and charge_bits(l) = "10" else -- + - - + : OS two pairs
                                                     '1' when charge_bits(i) = "10" and charge_bits(j) = "11"  and charge_bits(k) = "11" and charge_bits(l) = "11" else -- + - - - : OS a pair plus two negative muons
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "10"  and charge_bits(k) = "10" and charge_bits(l) = "10" else -- - + + + : OS a pair plus two positive muons
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "10"  and charge_bits(k) = "10" and charge_bits(l) = "11" else -- - + + - : OS two pairs
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "10"  and charge_bits(k) = "11" and charge_bits(l) = "10" else -- - + - + : OS two pairs
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "10"  and charge_bits(k) = "11" and charge_bits(l) = "11" else -- - + - - : OS a pair plus two negative muons
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "11"  and charge_bits(k) = "10" and charge_bits(l) = "10" else -- - - + + : OS two pairs
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "11"  and charge_bits(k) = "10" and charge_bits(l) = "11" else -- - - + - : OS a pair plus two negative muons
                                                     '1' when charge_bits(i) = "11" and charge_bits(j) = "11"  and charge_bits(k) = "11" and charge_bits(l) = "10" else -- - - - + : OS a pair plus two negative muons
                                                     '0';
-- HB 2014-04-14: alternative code, to bechecked
--                     os_charcorr_quad_int(i,j,k,l) <= '1' when (charge_bits(i)(1) = '1' and charge_bits(j)(1) = '1'  and charge_bits(k)(1) = '1' and charge_bits(l)(1) = '1') 
--                                                               and not ls_charcorr_quad_int(i,j,k,l) else '0'
                end generate index_4;
            end generate loop_4_4;
        end generate loop_4_3;
    end generate loop_4_2;
end generate loop_4_1;

ls_charcorr_quad <= ls_charcorr_quad_int;
os_charcorr_quad <= os_charcorr_quad_int;

end architecture rtl;
