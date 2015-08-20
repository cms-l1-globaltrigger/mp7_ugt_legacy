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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/tdf_mp7/trunk/src/tdf_mp7_core/tdf_mp7_core_addr_decode.vhd $
-- $Date: 2014-05-20 10:37:27 +0200 (Tue, 20 May 2014) $
-- $Author: bergauer $
-- $Revision: 2924 $
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

package tdf_mp7_core_addr_decode is

    constant NR_IPB_SLV_TDF : positive:= 64;

    constant C_IPB_TDF_MODULE_INFO : integer := 0;
    constant C_IPB_TDF_CONTROL : integer := 1;
    constant C_IPB_TDF3 : integer := 2;
    constant C_IPB_TDF4 : integer := 3;

    type ipb_tdfmem_index_array is array (0 to 59) of natural;
    constant C_IPB_TDFMEM : ipb_tdfmem_index_array := (4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                                                             20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                                                             40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
                                                             60, 61, 62, 63);

    function tdf_mp7_core_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;

end tdf_mp7_core_addr_decode;


package body tdf_mp7_core_addr_decode is

  function tdf_mp7_core_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is

    variable sel : integer;

  begin
        if       std_match(addr, "100000000000000000000000000-----") then sel := C_IPB_TDF_MODULE_INFO; --0x80000000
        elsif    std_match(addr, "1000------00--------------10----") then sel := C_IPB_TDF_CONTROL; --0x80000010
        elsif    std_match(addr, "1000------00--------------11----") then sel := C_IPB_TDF3; --0x80000020
        elsif    std_match(addr, "1000------00-------------100----") then sel := C_IPB_TDF4; --0x80000030
        elsif    std_match(addr, "10000000001100000000------------") then sel := C_IPB_TDFMEM(0); -- 0x80300000 .. 0x80300FFF
        elsif    std_match(addr, "10000000001100000001------------") then sel := C_IPB_TDFMEM(1); -- 0x80301000 .. 0x80301FFF
        elsif    std_match(addr, "10000000001100000010------------") then sel := C_IPB_TDFMEM(2);
        elsif    std_match(addr, "10000000001100000011------------") then sel := C_IPB_TDFMEM(3);
        elsif    std_match(addr, "10000000001100000100------------") then sel := C_IPB_TDFMEM(4);
        elsif    std_match(addr, "10000000001100000101------------") then sel := C_IPB_TDFMEM(5);
        elsif    std_match(addr, "10000000001100000110------------") then sel := C_IPB_TDFMEM(6);
        elsif    std_match(addr, "10000000001100000111------------") then sel := C_IPB_TDFMEM(7);
        elsif    std_match(addr, "10000000001100001000------------") then sel := C_IPB_TDFMEM(8);
        elsif    std_match(addr, "10000000001100001001------------") then sel := C_IPB_TDFMEM(9);
        elsif    std_match(addr, "10000000001100001010------------") then sel := C_IPB_TDFMEM(10);
        elsif    std_match(addr, "10000000001100001011------------") then sel := C_IPB_TDFMEM(11);
        elsif    std_match(addr, "10000000001100001100------------") then sel := C_IPB_TDFMEM(12);
        elsif    std_match(addr, "10000000001100001101------------") then sel := C_IPB_TDFMEM(13);
        elsif    std_match(addr, "10000000001100001110------------") then sel := C_IPB_TDFMEM(14);
        elsif    std_match(addr, "10000000001100001111------------") then sel := C_IPB_TDFMEM(15); -- 0x8030F000 .. 0x8030FFFF
        elsif    std_match(addr, "10000000001100010000------------") then sel := C_IPB_TDFMEM(16); -- 0x80310000 .. 0x80310FFF
        elsif    std_match(addr, "10000000001100010001------------") then sel := C_IPB_TDFMEM(17);
        elsif    std_match(addr, "10000000001100010010------------") then sel := C_IPB_TDFMEM(18);
        elsif    std_match(addr, "10000000001100010011------------") then sel := C_IPB_TDFMEM(19);
        elsif    std_match(addr, "10000000001100010100------------") then sel := C_IPB_TDFMEM(20);
        elsif    std_match(addr, "10000000001100010101------------") then sel := C_IPB_TDFMEM(21);
        elsif    std_match(addr, "10000000001100010110------------") then sel := C_IPB_TDFMEM(22);
        elsif    std_match(addr, "10000000001100010111------------") then sel := C_IPB_TDFMEM(23);
        elsif    std_match(addr, "10000000001100011000------------") then sel := C_IPB_TDFMEM(24);
        elsif    std_match(addr, "10000000001100011001------------") then sel := C_IPB_TDFMEM(25);
        elsif    std_match(addr, "10000000001100011010------------") then sel := C_IPB_TDFMEM(26);
        elsif    std_match(addr, "10000000001100011011------------") then sel := C_IPB_TDFMEM(27);
        elsif    std_match(addr, "10000000001100011100------------") then sel := C_IPB_TDFMEM(28);
        elsif    std_match(addr, "10000000001100011101------------") then sel := C_IPB_TDFMEM(29);
        elsif    std_match(addr, "10000000001100011110------------") then sel := C_IPB_TDFMEM(30);
        elsif    std_match(addr, "10000000001100011111------------") then sel := C_IPB_TDFMEM(31); -- 0x8031F000 .. 0x8031FFFF
        elsif    std_match(addr, "10000000001100100000------------") then sel := C_IPB_TDFMEM(32); -- 0x80320000 .. 0x80320FFF
        elsif    std_match(addr, "10000000001100100001------------") then sel := C_IPB_TDFMEM(33);
        elsif    std_match(addr, "10000000001100100010------------") then sel := C_IPB_TDFMEM(34);
        elsif    std_match(addr, "10000000001100100011------------") then sel := C_IPB_TDFMEM(35);
        elsif    std_match(addr, "10000000001100100100------------") then sel := C_IPB_TDFMEM(36);
        elsif    std_match(addr, "10000000001100100101------------") then sel := C_IPB_TDFMEM(37);
        elsif    std_match(addr, "10000000001100100110------------") then sel := C_IPB_TDFMEM(38);
        elsif    std_match(addr, "10000000001100100111------------") then sel := C_IPB_TDFMEM(39);
        elsif    std_match(addr, "10000000001100101000------------") then sel := C_IPB_TDFMEM(40);
        elsif    std_match(addr, "10000000001100101001------------") then sel := C_IPB_TDFMEM(41);
        elsif    std_match(addr, "10000000001100101010------------") then sel := C_IPB_TDFMEM(42);
        elsif    std_match(addr, "10000000001100101011------------") then sel := C_IPB_TDFMEM(43);
        elsif    std_match(addr, "10000000001100101100------------") then sel := C_IPB_TDFMEM(44);
        elsif    std_match(addr, "10000000001100101101------------") then sel := C_IPB_TDFMEM(45);
        elsif    std_match(addr, "10000000001100101110------------") then sel := C_IPB_TDFMEM(46);
        elsif    std_match(addr, "10000000001100101111------------") then sel := C_IPB_TDFMEM(47); -- 0x8032F000 .. 0x8032FFFF
        elsif    std_match(addr, "10000000001100110000------------") then sel := C_IPB_TDFMEM(48); -- 0x80320000 .. 0x80330FFF
        elsif    std_match(addr, "10000000001100110001------------") then sel := C_IPB_TDFMEM(49);
        elsif    std_match(addr, "10000000001100110010------------") then sel := C_IPB_TDFMEM(50);
        elsif    std_match(addr, "10000000001100110011------------") then sel := C_IPB_TDFMEM(51);
        elsif    std_match(addr, "10000000001100110100------------") then sel := C_IPB_TDFMEM(52);
        elsif    std_match(addr, "10000000001100110101------------") then sel := C_IPB_TDFMEM(53);
        elsif    std_match(addr, "10000000001100110110------------") then sel := C_IPB_TDFMEM(54);
        elsif    std_match(addr, "10000000001100110111------------") then sel := C_IPB_TDFMEM(55);
        elsif    std_match(addr, "10000000001100111000------------") then sel := C_IPB_TDFMEM(56);
        elsif    std_match(addr, "10000000001100111001------------") then sel := C_IPB_TDFMEM(57);
        elsif    std_match(addr, "10000000001100111010------------") then sel := C_IPB_TDFMEM(58);
        elsif    std_match(addr, "10000000001100111011------------") then sel := C_IPB_TDFMEM(59);
		else sel := 99;
		end if;
		return sel;

	end tdf_mp7_core_addr_sel;

end tdf_mp7_core_addr_decode;