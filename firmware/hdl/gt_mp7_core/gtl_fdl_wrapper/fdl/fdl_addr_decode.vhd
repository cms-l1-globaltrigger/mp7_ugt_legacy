
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

use work.math_pkg.ALL;
use work.gt_mp7_core_pkg.all;
use work.gtl_pkg.ALL;

package fdl_addr_decode is

    type ipb_algo_bx_mem_index_array is array (0 to 15) of natural;

    constant NR_IPB_SLV_FDL : positive:= 39;

    constant C_IPB_ALGO_BX_MEM : ipb_algo_bx_mem_index_array := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    constant C_IPB_RATE_CNT_BEFORE_PRESCALER : natural := 16;
    constant C_IPB_PRESCALE_FACTOR : natural := 17;
    constant C_IPB_RATE_CNT_AFTER_PRESCALER : natural := 18;
    constant C_IPB_RATE_CNT_POST_DEAD_TIME : natural := 19;
    constant C_IPB_MASKS : natural := 20;
    constant C_IPB_PRESCALE_FACTOR_SET_INDEX : natural := 21;
    constant C_IPB_CONTROL : natural := 22;
    constant C_IPB_READ_VERSIONS : natural := 23;
    constant C_IPB_COMMAND_PULSES : natural := 24;
    constant C_IPB_RATE_CNT_FINOR : natural := 25;
    constant C_IPB_L1A_LATENCY_DELAY : natural := 26;
    constant C_IPB_RATE_CNT_L1A : natural := 27;
    constant C_IPB_RATE_CNT_VETO : natural := 28;
    constant C_IPB_PRESCALE_FACTOR_SET_INDEX_UPDATED : natural := 29;
    constant C_IPB_CAL_TRIGGER_GAP : natural := 30;

    constant C_IPB_PRESCALE_FACTOR_PREVIEW : natural := 31;
    constant C_IPB_RATE_CNT_AFTER_PRESCALER_PREVIEW : natural := 32;
    constant C_IPB_PRESCALE_FACTOR_PREVIEW_SET_INDEX : natural := 33;
    constant C_IPB_RATE_CNT_FINOR_PREVIEW : natural := 34;
    constant C_IPB_PRESCALE_FACTOR_PREVIEW_SET_INDEX_UPDATED : natural := 35;

    constant C_IPB_PRESCALE_OTF_FLAGS : natural := 36;
    constant C_IPB_PRESCALE_OTF_UPDATED : natural := 37;
    constant C_IPB_PRESCALE_PREVIEW_OTF_UPDATED : natural := 38;

-- rate counter before prescaler
    constant ADDR_WIDTH_RATE_CNT_BEFORE_PRESCALER: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_RATE_CNT_BEFORE_PRESCALER: natural := 0;
    constant OFFSET_END_RATE_CNT_BEFORE_PRESCALER: natural := MAX_NR_ALGOS-1;

-- rate counter after prescaler
    constant ADDR_WIDTH_RATE_CNT_AFTER_PRESCALER: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_RATE_CNT_AFTER_PRESCALER: natural := 0;
    constant OFFSET_END_RATE_CNT_AFTER_PRESCALER: natural := MAX_NR_ALGOS-1;

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
    constant OFFSET_L1TM_FW_UID: natural := OFFSET_FDL_FW_VERSION + FDL_FW_VERSION'length/32;
    constant OFFSET_SVN_REVISION_NUMBER: natural := OFFSET_L1TM_FW_UID + L1TM_FW_UID'length/32;
    constant OFFSET_L1TM_UID_HASH: natural := OFFSET_SVN_REVISION_NUMBER + SVN_REVISION_NUMBER'length/32;
    constant OFFSET_FW_UID_HASH: natural := OFFSET_L1TM_UID_HASH + L1TM_UID_HASH'length/32;
    constant OFFSET_MODULE_ID: natural := OFFSET_FW_UID_HASH + FW_UID_HASH'length/32;

    constant ADDR_WIDTH_READ_VERSIONS: natural := 6;
    constant OFFSET_BEG_READ_VERSIONS: natural := OFFSET_L1TM_NAME;
    constant OFFSET_END_READ_VERSIONS: natural := OFFSET_MODULE_ID;

-- rate counter post dead time
    constant ADDR_WIDTH_RATE_CNT_POST_DEAD_TIME: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_RATE_CNT_POST_DEAD_TIME: natural := 0;
    constant OFFSET_END_RATE_CNT_POST_DEAD_TIME: natural := MAX_NR_ALGOS-1;

-- ***********************************************************************************************
-- HB 2016-12-01: register for "prescaler preview" in monitoring
    constant ADDR_WIDTH_RATE_CNT_AFTER_PRESCALER_PREVIEW: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_RATE_CNT_AFTER_PRESCALER_PREVIEW: natural := 0;
    constant OFFSET_END_RATE_CNT_AFTER_PRESCALER_PREVIEW: natural := MAX_NR_ALGOS-1;

    constant ADDR_WIDTH_PRESCALE_FACTOR_PREVIEW: natural := log2c(MAX_NR_ALGOS);
    constant OFFSET_BEG_PRESCALE_FACTOR_PREVIEW: natural := 0;
    constant OFFSET_END_PRESCALE_FACTOR_PREVIEW: natural := MAX_NR_ALGOS-1;

-- ***********************************************************************************************

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
        elsif std_match(addr, "10010000000000010000010---------") then sel := C_IPB_RATE_CNT_AFTER_PRESCALER; -- 0x90010400 .. 0x900105FF
        elsif std_match(addr, "10010000000000010000011---------") then sel := C_IPB_RATE_CNT_POST_DEAD_TIME; -- 0x90010600 .. 0x900107FF
        elsif std_match(addr, "10010000000000010000100---------") then sel := C_IPB_MASKS; -- 0x90010800 .. 0x900109FF
        elsif std_match(addr, "1001000000001001000110001000000-") then sel := C_IPB_PRESCALE_FACTOR_SET_INDEX; -- 0x90091880
        elsif std_match(addr, "10010000000010010001100010001000") then sel := C_IPB_CONTROL; -- 0x90091888
        elsif std_match(addr, "10010000000010010001100011------") then sel := C_IPB_READ_VERSIONS; -- 0x900918C0
        elsif std_match(addr, "1001000000001001000110010000000-") then sel := C_IPB_COMMAND_PULSES; -- 0x90091900
        elsif std_match(addr, "10010000000010010001100110000000") then sel := C_IPB_RATE_CNT_FINOR; -- 0x90091980
        elsif std_match(addr, "1001000000001001001000100000000-") then sel := C_IPB_L1A_LATENCY_DELAY; -- 0x90092200
        elsif std_match(addr, "10010000000010010011000000000000") then sel := C_IPB_RATE_CNT_L1A; -- 0x90093000
        elsif std_match(addr, "10010000000010010100000000000000") then sel := C_IPB_RATE_CNT_VETO; -- 0x90094000
        elsif std_match(addr, "1001000000001001010100000000000-") then sel := C_IPB_PRESCALE_FACTOR_SET_INDEX_UPDATED; -- 0x90095000
        elsif std_match(addr, "1001000000001001011000000000000-") then sel := C_IPB_CAL_TRIGGER_GAP; -- 0x90096000
        elsif std_match(addr, "1001000000001001100000000000000-") then sel := C_IPB_PRESCALE_OTF_FLAGS;   -- 0x90097000
        elsif std_match(addr, "1001000000001001100000000001000-") then sel := C_IPB_PRESCALE_OTF_UPDATED; -- 0x90097010
        elsif std_match(addr, "1001000000001001100000000010000-") then sel := C_IPB_PRESCALE_PREVIEW_OTF_UPDATED; -- 0x90097020

-- HB 2016-12-01: register for "prescaler preview" in monitoring
        elsif std_match(addr, "10010001000000010000001---------") then sel := C_IPB_PRESCALE_FACTOR_PREVIEW; -- 0x91010200 .. 0x910103FF
        elsif std_match(addr, "10010001000000010000010---------") then sel := C_IPB_RATE_CNT_AFTER_PRESCALER_PREVIEW; -- 0x91010400 .. 0x910105FF
        elsif std_match(addr, "1001000100001001000110001000000-") then sel := C_IPB_PRESCALE_FACTOR_PREVIEW_SET_INDEX; -- 0x91091880
        elsif std_match(addr, "10010001000010010001100110000000") then sel := C_IPB_RATE_CNT_FINOR_PREVIEW; -- 0x91091980
        elsif std_match(addr, "1001000100001001010100000000000-") then sel := C_IPB_PRESCALE_FACTOR_PREVIEW_SET_INDEX_UPDATED; -- 0x91095000

        else sel := 99;
		end if;
		return sel;

	end fdl_addr_sel;

end fdl_addr_decode;
