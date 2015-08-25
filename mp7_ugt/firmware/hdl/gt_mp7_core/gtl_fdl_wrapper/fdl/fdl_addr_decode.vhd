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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_addr_decode.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

use work.math_pkg.ALL;
use work.gt_mp7_core_pkg.all;
use work.gtl_pkg.ALL;

package fdl_addr_decode is

    type ipb_algo_bx_mem_index_array is array (0 to 15) of natural;

    constant NR_IPB_SLV_FDL : positive:= 21;

    constant C_IPB_ALGO_BX_MEM : ipb_algo_bx_mem_index_array := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    constant C_IPB_RATE_CNT_BEFORE_PRESCALER : natural := 16;
    constant C_IPB_PRESCALE_FACTOR : natural := 17;
    constant C_IPB_MASKS : natural := 18;
    constant C_IPB_CONTROL : natural := 19;
    constant C_IPB_READ_VERSIONS : natural := 20;

-- -- algo-bx-memories
--     constant ADDR_WIDTH_ALGO_BX_MEM: natural := 12;
--     constant OFFSET_BEG_ALGO_BX_MEM: natural := 0;
--     constant OFFSET_END_ALGO_BX_MEM: natural := 4095;
    
-- rate counter before prescaler
    constant ADDR_WIDTH_RATE_CNT_BEFORE_PRESCALER: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_RATE_CNT_BEFORE_PRESCALER: natural := 0;
    constant OFFSET_END_RATE_CNT_BEFORE_PRESCALER: natural := MAX_NR_ALGOS-1;
    
-- prescale factor range
    constant ADDR_WIDTH_PRESCALE_FACTOR: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_PRESCALE_FACTOR: natural := 0;
    constant OFFSET_END_PRESCALE_FACTOR: natural := MAX_NR_ALGOS-1;
    
-- finor and veto masks range
    constant ADDR_WIDTH_MASKS: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_MASKS: natural := 0;
    constant OFFSET_END_MASKS: natural := MAX_NR_ALGOS-1;
    
-- for versions values (ipb_read_regs.vhd)
    constant OFFSET_L1TM_NAME: natural := 0; 
    constant OFFSET_L1TM_UID: natural := OFFSET_L1TM_NAME + L1TM_NAME'length/32;
    constant OFFSET_L1TM_COMPILER_VERSION: natural := OFFSET_L1TM_UID + L1TM_UID'length/32;
    constant OFFSET_GTL_FW_VERSION: natural := OFFSET_L1TM_COMPILER_VERSION + L1TM_COMPILER_VERSION'length/32;
    constant OFFSET_FDL_FW_VERSION: natural := OFFSET_GTL_FW_VERSION + GTL_FW_VERSION'length/32;
    
    constant ADDR_WIDTH_READ_VERSIONS: natural := 6;
    constant OFFSET_BEG_READ_VERSIONS: natural := OFFSET_L1TM_NAME;
    constant OFFSET_END_READ_VERSIONS: natural := OFFSET_FDL_FW_VERSION;

--     constant OFFSET_L1TM_NAME: natural := 0; 
--     constant OFFSET_L1TM_UID: natural := OFFSET_L1TM_NAME + L1TM_NAME'length/32;
--     constant OFFSET_L1TM_COMPILER_VERSION: natural := OFFSET_L1TM_UID + L1TM_UID'length/32;
--     constant OFFSET_GTL_FW_VERSION: natural := OFFSET_L1TM_COMPILER_VERSION + L1TM_COMPILER_VERSION'length/32;
--     constant OFFSET_FDL_FW_VERSION: natural := OFFSET_GTL_FW_VERSION + GTL_FW_VERSION'length/32;
--     
--     constant ADDR_WIDTH_READ_VERSIONS: natural := 6;
--     constant OFFSET_BEG_READ_VERSIONS: natural := OFFSET_L1TM_NAME;
--     constant OFFSET_END_READ_VERSIONS: natural := OFFSET_FDL_FW_VERSION;
-- 
    function fdl_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return natural;

end fdl_addr_decode;


package body fdl_addr_decode is

    function fdl_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return natural is

        variable sel : natural;

    begin
        if    std_match(addr, "10010000000000000000------------") then sel := C_IPB_ALGO_BX_MEM(0); -- 0x90000000 .. 0x90000FFF
        elsif std_match(addr, "10010000000000000001------------") then sel := C_IPB_ALGO_BX_MEM(1); -- 0x90001000 .. 0x90001FFF
        elsif std_match(addr, "10010000000000000010------------") then sel := C_IPB_ALGO_BX_MEM(2);
        elsif std_match(addr, "10010000000000000011------------") then sel := C_IPB_ALGO_BX_MEM(3);
        elsif std_match(addr, "10010000000000000100------------") then sel := C_IPB_ALGO_BX_MEM(4);
        elsif std_match(addr, "10010000000000000101------------") then sel := C_IPB_ALGO_BX_MEM(5);
        elsif std_match(addr, "10010000000000000110------------") then sel := C_IPB_ALGO_BX_MEM(6);
        elsif std_match(addr, "10010000000000000111------------") then sel := C_IPB_ALGO_BX_MEM(7);
        elsif std_match(addr, "10010000000000001000------------") then sel := C_IPB_ALGO_BX_MEM(8);
        elsif std_match(addr, "10010000000000001001------------") then sel := C_IPB_ALGO_BX_MEM(9);
        elsif std_match(addr, "10010000000000001010------------") then sel := C_IPB_ALGO_BX_MEM(10);
        elsif std_match(addr, "10010000000000001011------------") then sel := C_IPB_ALGO_BX_MEM(11);
        elsif std_match(addr, "10010000000000001100------------") then sel := C_IPB_ALGO_BX_MEM(12);
        elsif std_match(addr, "10010000000000001101------------") then sel := C_IPB_ALGO_BX_MEM(13);
        elsif std_match(addr, "10010000000000001110------------") then sel := C_IPB_ALGO_BX_MEM(14);
        elsif std_match(addr, "10010000000000001111------------") then sel := C_IPB_ALGO_BX_MEM(15); -- 0x9000F000 .. 0x9000FFFF
        elsif std_match(addr, "10010000000000010000000---------") then sel := C_IPB_RATE_CNT_BEFORE_PRESCALER; -- 0x90010000 .. 0x900101FF
        elsif std_match(addr, "10010000000000010000001---------") then sel := C_IPB_PRESCALE_FACTOR; -- 0x90010200 .. 0x900103FF
        elsif std_match(addr, "10010000000000010000010---------") then sel := C_IPB_MASKS; -- 0x90010400 .. 0x900105FF
        elsif std_match(addr, "10010000000010010001100010001000") then sel := C_IPB_CONTROL; -- 0x90091888
        elsif std_match(addr, "10010000000010010001100011------") then sel := C_IPB_READ_VERSIONS; -- 0x900918C0
		else sel := 99;
		end if;
		return sel;

	end fdl_addr_sel;

end fdl_addr_decode;
