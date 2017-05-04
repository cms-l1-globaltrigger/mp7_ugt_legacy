-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: ROP
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
--- $Revision: 0.1 $
--------------------------------------------------------------------------------

-- HB 2106-05-31: memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
-- HEPHY:21-05-2015 TOP_SERIAL_VENDOR is not more relevant, because in future we will read from hardware over ipmi just MAC address
-- HEPHY:21-05-2015: test version with spy2_algos and spy2_finor instantiated with ipb_dpmem_4096_32 modules, too.
-- HEPHY:21-05-2015: test version with simspymem instantiated with ipb_dpmem_4096_32 modules.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.gt_mp7_core_pkg.all;

package frame_addr_decode is
--
    constant NR_IPB_SLV_FRAME : positive:= 97;

    constant C_IPB_MODULE_INFO : natural := 0;
    constant C_IPB_TEST_REGS : natural := 1;
    constant C_IPB_DEMUX_LANE_ADJ : natural := 2;
    constant C_IPB_RB : natural := 3;

--    constant C_IPB_SIMSPYMEM : natural := 4;

-- HB 2106-05-31: memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
-- 72 memory blocks with LHC_DATA_WIDTH = 2304
    type ipb_simspymem_index_array is array (0 to 71) of natural;
    constant C_IPB_SIMSPYMEM : ipb_simspymem_index_array := (4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                                                             20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                                                             40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
							     60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75);

--     constant C_IPB_SPYMEM2_ALGOS : natural := 64;
-- HEPHY:21-05-2015: test version with spy2_algos and spy2_finor instantiated with ipb_dpmem_4096_32 modules.
--                16 memory blocks for 512 algos, 1 block for finor

    type ipb_spy2_algos_index_array is array (0 to 15) of natural;
    constant C_IPB_SPYMEM2_ALGOS : ipb_spy2_algos_index_array := (76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91);

    constant C_IPB_SPYMEM2_FINOR : natural := 92;
    constant C_IPB_SPYMEM3 : natural := 93;
    constant C_IPB_PULSEREG : natural := 94;  --ipbus event - pulse register
    constant C_IPB_MUX_CONTROL : natural := 95;  --output_mux ipbus control register
     constant C_IPB_SPYMEM3_P : natural := 96;

    constant OFFSET_TIMESTAMP: natural := 0; -- 1 x 32 bits
    constant OFFSET_HOSTNAME: natural := OFFSET_TIMESTAMP + TIMESTAMP'length/32; -- 256 bits = 8 x 32 bits
    constant OFFSET_USERNAME: natural := OFFSET_HOSTNAME + HOSTNAME'length/32; -- 256 bits = 8 x 32 bits
    constant OFFSET_MODULE_TYPE: natural := OFFSET_USERNAME + USERNAME'length/32; -- 1 x 32 bits
    constant OFFSET_FRAME_VERSION: natural := OFFSET_MODULE_TYPE + MODULE_TYPE'length/32; -- 1 x 32 bits
    constant OFFSET_BUILD_VERSION: natural := OFFSET_FRAME_VERSION + FRAME_VERSION'length/32; -- 1 x 32 bits

    constant C_MODINFO_REGS_ADDR_WIDTH : integer := 5;
    constant C_MODINFO_REGS_BEGIN_INDEX : integer := OFFSET_TIMESTAMP;
    constant C_MODINFO_REGS_END_INDEX : integer := OFFSET_BUILD_VERSION;

    constant C_TEST_REGS_ADDR_WIDTH : integer := 4;
    constant C_TEST_REGS_BEGIN_INDEX : integer := 0;
    constant C_TEST_REGS_END_INDEX : integer := 14;

-- HEPHY:21-05-2015: C_RB_ADDR_WIDTH fixed to 12 in rb.vhd
--     constant C_RB_ADDR_WIDTH : integer := 20;

    function frame_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return natural;

end frame_addr_decode;


package body frame_addr_decode is

    function frame_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return natural is

        variable sel : natural;

    begin
        if    std_match(addr, "100000000000000000000000000-----") then sel := C_IPB_MODULE_INFO;    -- 0x80000000
-- HEPHY:21-05-2015: added test status register addresses
        elsif std_match(addr, "1000000000000000000000000010----") then sel := C_IPB_TEST_REGS;      -- 0x80000020
        elsif std_match(addr, "10000000000000000000000001000000") then sel := C_IPB_DEMUX_LANE_ADJ; -- 0x80000040
        elsif std_match(addr, "10000000000000000000100000000000") then sel := C_IPB_PULSEREG;       -- 0x80000800
        elsif std_match(addr, "1000000000000000000010010000----") then sel := C_IPB_MUX_CONTROL;    -- 0x80000900 .. 0x8000090F
        elsif std_match(addr, "10000000011100000000------------") then sel := C_IPB_RB;             -- 0x80700000
--         elsif std_match(addr, "100000000011--------------------") then sel := C_IPB_SIMSPYMEM;   -- 0x80300000
        elsif std_match(addr, "10000000001100000000------------") then sel := C_IPB_SIMSPYMEM(0);   -- 0x80300000 .. 0x80300FFF
        elsif std_match(addr, "10000000001100000001------------") then sel := C_IPB_SIMSPYMEM(1);   -- 0x80301000 .. 0x80301FFF
        elsif std_match(addr, "10000000001100000010------------") then sel := C_IPB_SIMSPYMEM(2);
        elsif std_match(addr, "10000000001100000011------------") then sel := C_IPB_SIMSPYMEM(3);
        elsif std_match(addr, "10000000001100000100------------") then sel := C_IPB_SIMSPYMEM(4);
        elsif std_match(addr, "10000000001100000101------------") then sel := C_IPB_SIMSPYMEM(5);
        elsif std_match(addr, "10000000001100000110------------") then sel := C_IPB_SIMSPYMEM(6);
        elsif std_match(addr, "10000000001100000111------------") then sel := C_IPB_SIMSPYMEM(7);
        elsif std_match(addr, "10000000001100001000------------") then sel := C_IPB_SIMSPYMEM(8);
        elsif std_match(addr, "10000000001100001001------------") then sel := C_IPB_SIMSPYMEM(9);
        elsif std_match(addr, "10000000001100001010------------") then sel := C_IPB_SIMSPYMEM(10);
        elsif std_match(addr, "10000000001100001011------------") then sel := C_IPB_SIMSPYMEM(11);
        elsif std_match(addr, "10000000001100001100------------") then sel := C_IPB_SIMSPYMEM(12);
        elsif std_match(addr, "10000000001100001101------------") then sel := C_IPB_SIMSPYMEM(13);
        elsif std_match(addr, "10000000001100001110------------") then sel := C_IPB_SIMSPYMEM(14);
        elsif std_match(addr, "10000000001100001111------------") then sel := C_IPB_SIMSPYMEM(15);  -- 0x8030F000 .. 0x8030FFFF
        elsif std_match(addr, "10000000001100010000------------") then sel := C_IPB_SIMSPYMEM(16);  -- 0x80310000 .. 0x80310FFF
        elsif std_match(addr, "10000000001100010001------------") then sel := C_IPB_SIMSPYMEM(17);
        elsif std_match(addr, "10000000001100010010------------") then sel := C_IPB_SIMSPYMEM(18);
        elsif std_match(addr, "10000000001100010011------------") then sel := C_IPB_SIMSPYMEM(19);
        elsif std_match(addr, "10000000001100010100------------") then sel := C_IPB_SIMSPYMEM(20);
        elsif std_match(addr, "10000000001100010101------------") then sel := C_IPB_SIMSPYMEM(21);
        elsif std_match(addr, "10000000001100010110------------") then sel := C_IPB_SIMSPYMEM(22);
        elsif std_match(addr, "10000000001100010111------------") then sel := C_IPB_SIMSPYMEM(23);
        elsif std_match(addr, "10000000001100011000------------") then sel := C_IPB_SIMSPYMEM(24);
        elsif std_match(addr, "10000000001100011001------------") then sel := C_IPB_SIMSPYMEM(25);
        elsif std_match(addr, "10000000001100011010------------") then sel := C_IPB_SIMSPYMEM(26);
        elsif std_match(addr, "10000000001100011011------------") then sel := C_IPB_SIMSPYMEM(27);
        elsif std_match(addr, "10000000001100011100------------") then sel := C_IPB_SIMSPYMEM(28);
        elsif std_match(addr, "10000000001100011101------------") then sel := C_IPB_SIMSPYMEM(29);
        elsif std_match(addr, "10000000001100011110------------") then sel := C_IPB_SIMSPYMEM(30);
        elsif std_match(addr, "10000000001100011111------------") then sel := C_IPB_SIMSPYMEM(31);  -- 0x8031F000 .. 0x8031FFFF
        elsif std_match(addr, "10000000001100100000------------") then sel := C_IPB_SIMSPYMEM(32);  -- 0x80320000 .. 0x80320FFF
        elsif std_match(addr, "10000000001100100001------------") then sel := C_IPB_SIMSPYMEM(33);
        elsif std_match(addr, "10000000001100100010------------") then sel := C_IPB_SIMSPYMEM(34);
        elsif std_match(addr, "10000000001100100011------------") then sel := C_IPB_SIMSPYMEM(35);
        elsif std_match(addr, "10000000001100100100------------") then sel := C_IPB_SIMSPYMEM(36);
        elsif std_match(addr, "10000000001100100101------------") then sel := C_IPB_SIMSPYMEM(37);
        elsif std_match(addr, "10000000001100100110------------") then sel := C_IPB_SIMSPYMEM(38);
        elsif std_match(addr, "10000000001100100111------------") then sel := C_IPB_SIMSPYMEM(39);
        elsif std_match(addr, "10000000001100101000------------") then sel := C_IPB_SIMSPYMEM(40);
        elsif std_match(addr, "10000000001100101001------------") then sel := C_IPB_SIMSPYMEM(41);
        elsif std_match(addr, "10000000001100101010------------") then sel := C_IPB_SIMSPYMEM(42);
        elsif std_match(addr, "10000000001100101011------------") then sel := C_IPB_SIMSPYMEM(43);
        elsif std_match(addr, "10000000001100101100------------") then sel := C_IPB_SIMSPYMEM(44);
        elsif std_match(addr, "10000000001100101101------------") then sel := C_IPB_SIMSPYMEM(45);
        elsif std_match(addr, "10000000001100101110------------") then sel := C_IPB_SIMSPYMEM(46);
        elsif std_match(addr, "10000000001100101111------------") then sel := C_IPB_SIMSPYMEM(47);  -- 0x8032F000 .. 0x8032FFFF
        elsif std_match(addr, "10000000001100110000------------") then sel := C_IPB_SIMSPYMEM(48);  -- 0x80330000 .. 0x80330FFF
        elsif std_match(addr, "10000000001100110001------------") then sel := C_IPB_SIMSPYMEM(49);
        elsif std_match(addr, "10000000001100110010------------") then sel := C_IPB_SIMSPYMEM(50);
        elsif std_match(addr, "10000000001100110011------------") then sel := C_IPB_SIMSPYMEM(51);
        elsif std_match(addr, "10000000001100110100------------") then sel := C_IPB_SIMSPYMEM(52);
        elsif std_match(addr, "10000000001100110101------------") then sel := C_IPB_SIMSPYMEM(53);
        elsif std_match(addr, "10000000001100110110------------") then sel := C_IPB_SIMSPYMEM(54);
        elsif std_match(addr, "10000000001100110111------------") then sel := C_IPB_SIMSPYMEM(55);
        elsif std_match(addr, "10000000001100111000------------") then sel := C_IPB_SIMSPYMEM(56);
        elsif std_match(addr, "10000000001100111001------------") then sel := C_IPB_SIMSPYMEM(57);
        elsif std_match(addr, "10000000001100111010------------") then sel := C_IPB_SIMSPYMEM(58);
        elsif std_match(addr, "10000000001100111011------------") then sel := C_IPB_SIMSPYMEM(59);
-- HB 2106-05-31: memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
-- 72 memory blocks with LHC_DATA_WIDTH = 2304
        elsif std_match(addr, "10000000001100111100------------") then sel := C_IPB_SIMSPYMEM(60);
        elsif std_match(addr, "10000000001100111101------------") then sel := C_IPB_SIMSPYMEM(61);
        elsif std_match(addr, "10000000001100111110------------") then sel := C_IPB_SIMSPYMEM(62);
        elsif std_match(addr, "10000000001100111111------------") then sel := C_IPB_SIMSPYMEM(63);
        elsif std_match(addr, "10000000001101000000------------") then sel := C_IPB_SIMSPYMEM(64);
        elsif std_match(addr, "10000000001101000001------------") then sel := C_IPB_SIMSPYMEM(65);
        elsif std_match(addr, "10000000001101000010------------") then sel := C_IPB_SIMSPYMEM(66);
        elsif std_match(addr, "10000000001101000011------------") then sel := C_IPB_SIMSPYMEM(67);
        elsif std_match(addr, "10000000001101000100------------") then sel := C_IPB_SIMSPYMEM(68);
        elsif std_match(addr, "10000000001101000101------------") then sel := C_IPB_SIMSPYMEM(69);
        elsif std_match(addr, "10000000001101000110------------") then sel := C_IPB_SIMSPYMEM(70);
        elsif std_match(addr, "10000000001101000111------------") then sel := C_IPB_SIMSPYMEM(71);  -- 0x80347000 .. 0x80347FFF

        elsif std_match(addr, "10000000001001000000------------") then sel := C_IPB_SPYMEM2_ALGOS(0); -- 0x80240000 .. 0x80240FFF
        elsif std_match(addr, "10000000001001000001------------") then sel := C_IPB_SPYMEM2_ALGOS(1);
        elsif std_match(addr, "10000000001001000010------------") then sel := C_IPB_SPYMEM2_ALGOS(2);
        elsif std_match(addr, "10000000001001000011------------") then sel := C_IPB_SPYMEM2_ALGOS(3);
        elsif std_match(addr, "10000000001001000100------------") then sel := C_IPB_SPYMEM2_ALGOS(4);
        elsif std_match(addr, "10000000001001000101------------") then sel := C_IPB_SPYMEM2_ALGOS(5);
        elsif std_match(addr, "10000000001001000110------------") then sel := C_IPB_SPYMEM2_ALGOS(6);
        elsif std_match(addr, "10000000001001000111------------") then sel := C_IPB_SPYMEM2_ALGOS(7);
        elsif std_match(addr, "10000000001001001000------------") then sel := C_IPB_SPYMEM2_ALGOS(8);
        elsif std_match(addr, "10000000001001001001------------") then sel := C_IPB_SPYMEM2_ALGOS(9);
        elsif std_match(addr, "10000000001001001010------------") then sel := C_IPB_SPYMEM2_ALGOS(10);
        elsif std_match(addr, "10000000001001001011------------") then sel := C_IPB_SPYMEM2_ALGOS(11);
        elsif std_match(addr, "10000000001001001100------------") then sel := C_IPB_SPYMEM2_ALGOS(12);
        elsif std_match(addr, "10000000001001001101------------") then sel := C_IPB_SPYMEM2_ALGOS(13);
        elsif std_match(addr, "10000000001001001110------------") then sel := C_IPB_SPYMEM2_ALGOS(14);
        elsif std_match(addr, "10000000001001001111------------") then sel := C_IPB_SPYMEM2_ALGOS(15);
        elsif std_match(addr, "10000000001000000000------------") then sel := C_IPB_SPYMEM2_FINOR;  -- 0x80200000
        elsif std_match(addr, "1000000000101000----------------") then sel := C_IPB_SPYMEM3;        -- 0x80280000
        elsif std_match(addr, "1000000001000000----------------") then sel := C_IPB_SPYMEM3_P;      -- 0x80400000
		else sel := 99;
		end if;
		return sel;

	end frame_addr_sel;

end frame_addr_decode;
