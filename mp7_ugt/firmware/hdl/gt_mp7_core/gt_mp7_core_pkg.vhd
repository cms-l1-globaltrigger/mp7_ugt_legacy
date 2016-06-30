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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gt_mp7_core_pkg.vhd $
-- $Date: 2015-06-16 13:20:03 +0200 (Tue, 16 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4044 $
--------------------------------------------------------------------------------

-- actual versions:
--	frame v0.0.41
--	gtl   v0.0.10
--	fdl   v0.0.26

-- HB 2016-06-30: removed unused constants and cleaned up

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

use work.mp7_data_types.all;
use work.math_pkg.all;
use work.lhc_data_pkg.all;

use work.gt_mp7_top_pkg.all;

use work.top_decl.all;
use work.mp7_brd_decl.all;


package gt_mp7_core_pkg is

type ipb_regs_array is array (natural range <>) of std_logic_vector(31 downto 0);

-- ==================================================================================================
-- HB 2014-05-30: definitions (TOP_xxx) moved to gt_mp7_top_pkg.vhd
    constant TIMESTAMP : std_logic_vector(31 downto 0) := TOP_TIMESTAMP;
-- HB 2016-06-30: removed unused constants
--     constant MODULE_TYPE_PROTOCOL: std_logic_vector(3 downto 0) := TOP_TYPE_PROTOCOL; -- IP_BUS_2.0
--     constant MODULE_TYPE_TYPE: std_logic_vector(3 downto 0) := TOP_MODULE_TYPE; -- MP7
--     constant MODULE_SERIAL_NUMBER: std_logic_vector(23 downto 0) := X"000000"; -- dummy value - not used anymore
    constant MODULE_TYPE: std_logic_vector(31 downto 0) := (others => '0');
    constant USERNAME : std_logic_vector(32*8-1 downto 0) := TOP_USERNAME;
    constant HOSTNAME : std_logic_vector(32*8-1 downto 0) := TOP_HOSTNAME;
    constant BUILD_VERSION : std_logic_vector(31 downto 0) := TOP_BUILD_VERSION;

-- ==================================================================================================
-- FRAME version (given by the editor of frame.vhd)
    constant FRAME_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant FRAME_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant FRAME_REV_VERSION        : integer range 0 to 255 := 41;
	constant FRAME_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(FRAME_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_REV_VERSION, 8));

-- GTL firmware (fix part) version
    constant GTL_FW_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant GTL_FW_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant GTL_FW_REV_VERSION        : integer range 0 to 255 := 10;
-- FDL firmware version
    constant FDL_FW_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant FDL_FW_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant FDL_FW_REV_VERSION        : integer range 0 to 255 := 26;
-- ==================================================================================================

constant BUNCHES_PER_ORBIT : natural range 3564 to 3564 := LHC_BUNCH_COUNT;

-- HB 2014-07-08: ipbus_rst is high active, RST_ACT changed to '1' (for lhc_rst [in gt_mp7_core_pkg.vhd]) to get proper reset-conditions,
--                because in delay_line_sl.vhd and delay_line_slv.vhd both resets are used !!!
-- constant RST_ACT : std_logic := '0';
constant RST_ACT : std_logic := '1';
constant RST_ACT_ROP : std_logic := '0';

type vec32_array is array (NATURAL RANGE <>) of std_logic_vector(31 downto 0);
type vec16_array is array (NATURAL RANGE <>) of std_logic_vector(15 downto 0);
type vec8_array is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);

-- --------------------------------------------------------------------------------
-- --  LMP (Lane Mapping Process)
-- --------------------------------------------------------------------------------
    constant OBJECTS_PER_LANE : integer := 6; -- CLOCK_RATIO defined in top_decl.vhd 6 objects with 32 bits per lane (CLOCK_RATIO = 6 => 240MHZ / 40MHZ)
    type lane_objects_array_t is array (OBJECTS_PER_LANE-1 downto 0 ) of std_logic_vector(LWORD_WIDTH-1 downto 0);
    type lane_objects_array_valid_t is array (OBJECTS_PER_LANE-1 downto 0 ) of std_logic;
    type demux_lanes_data_objects_array_t is array (NATURAL RANGE <>) of lane_objects_array_t;
    type demux_lanes_data_objects_array_valid_t is array (NATURAL RANGE <>) of lane_objects_array_valid_t;

--------------------------------------------------------------------------------
-- TCM
--------------------------------------------------------------------------------
constant BGOS_WIDTH                   : integer := 4;
constant BX_NR_WIDTH                  : integer := log2c(BUNCHES_PER_ORBIT);
constant ORBIT_NR_WIDTH               : integer := 48;

constant LUM_SEG_NR_WIDTH             : integer := 32;
constant EVENT_NR_WIDTH               : integer := 32;
constant EVENT_TYPE_WIDTH             : integer := 4;
constant LUM_SEG_PERIOD_WIDTH         : integer := 32;
constant LUM_SEG_PERIOD_MSK_WIDTH     : integer := 32;
constant TRIGGER_NR_WIDTH             : natural := 48;

subtype bgos_t                      is std_logic_vector(BGOS_WIDTH-1 downto 0);
subtype bx_nr_t                     is std_logic_vector(BX_NR_WIDTH-1 downto 0);
subtype orbit_nr_t                  is std_logic_vector(ORBIT_NR_WIDTH-1 downto 0);
subtype luminosity_seg_nr_t         is std_logic_vector(LUM_SEG_NR_WIDTH-1 downto 0);
subtype event_nr_t                  is std_logic_vector(EVENT_NR_WIDTH-1 downto 0);
subtype event_type_t                is std_logic_vector(EVENT_TYPE_WIDTH-1 downto 0);
subtype luminosity_seg_period_t     is std_logic_vector(LUM_SEG_PERIOD_WIDTH-1 downto 0);
subtype luminosity_seg_period_msk_t is std_logic_vector(LUM_SEG_PERIOD_MSK_WIDTH-1 downto 0);
subtype trigger_nr_t                is std_logic_vector(TRIGGER_NR_WIDTH-1 downto 0);

constant BC_TOP                       : integer := BUNCHES_PER_ORBIT-1;
constant LUM_SEG_PERIOD_MSK_RESET     : luminosity_seg_period_msk_t := X"00040000";

-- BGos commands
constant BGOS_NOP                       : bgos_t := "0000";
constant BGOS_RESYNC                    : bgos_t := "0101";
constant BGOS_ORBIT_COUNTER_RESET       : bgos_t := "1000";
constant BGOS_START_RUN                 : bgos_t := "1001";
constant BGOS_EVENT_COUNTER_RESET       : bgos_t := "0111";

--------------------------------------------------------------------------------
-- l1a sim
--------------------------------------------------------------------------------

constant L1A_SIM_CNTRL_NOP : std_logic_vector(1 downto 0) := "00";
constant L1A_SIM_CNTRL_PATTERN_AT_ORBIT : std_logic_vector(1 downto 0) := "01";
constant L1A_SIM_CNTRL_ALTERNATING : std_logic_vector(1 downto 0) := "10";
type bx_nr_array_t is array(integer range<>) of bx_nr_t;

--------------------------------------------------------------------------------
-- ROP
--------------------------------------------------------------------------------

constant BX_IN_EVENT_WIDTH : integer := 4;

constant FINOR_WIDTH : integer := 4;

constant DAQ_INPUT_WIDTH : integer := 64; -- 16, 32 or 64, changing anything there, dann make frame

-- HB, 24-10-2013: Number of Algorithm given by TME in gtl_pkg.vhd !!!
-- constant NR_ALGOS        : integer := 512;
-- HB, 24-10-2013: proposed MAX_NR_ALGOS instead of NR_ALGOS
constant MAX_NR_ALGOS        : integer := 512;

constant MAX_BX_IN_EVENT : integer := 7;
constant MIN_L1A         : integer := 4;

constant MAIN_RAM_DATA_WIDTH : integer := FINOR_WIDTH + TRIGGER_NR_WIDTH + ORBIT_NR_WIDTH + BX_NR_WIDTH +
                                          LUM_SEG_NR_WIDTH + EVENT_NR_WIDTH + 3*MAX_NR_ALGOS +
                                          LHC_DATA_WIDTH;

--------------------------------------------------------------------------------
-- delay manager
--------------------------------------------------------------------------------
constant DM_MAX_DELAY_OBJECTS : integer  range 0 to BUNCHES_PER_ORBIT := BUNCHES_PER_ORBIT/2;
constant DM_MAX_DELAY_BCRES : integer  range 0 to BUNCHES_PER_ORBIT := BUNCHES_PER_ORBIT;

--------------------------------------------------------------------------------
-- SIM/SPY Memory + Spytrigger
--------------------------------------------------------------------------------
-- HB, 12-11-2013: GTL_FDL_LATENCY = 6 with fixed pipeline structure (2 = +/- 2bx, 3 = conditions and algos, 1 = FDL)
constant GTL_FDL_LATENCY : integer := 6;

--------------------------------------------------------------------------------
-- ADDRESS DECODER
--------------------------------------------------------------------------------
constant SYNC_STAGES : natural := 3;
constant ERROR_ADDRESS : std_logic_vector(31 downto 0) := X"0000EADD";

--------------------------------------------------------------------------------

	function to_obrit_nr(i : integer) return orbit_nr_t;
	function to_bx_nr(i : integer) return bx_nr_t;

end package;

package body gt_mp7_core_pkg is

	function to_obrit_nr(i : integer) return orbit_nr_t is
		variable ret_value : orbit_nr_t := (others=>'0');
	begin
		ret_value := std_logic_vector(to_unsigned(i, ret_value'length));
		return ret_value;
	end function;


	function to_bx_nr(i : integer) return bx_nr_t is
		variable ret_value : bx_nr_t := (others=>'0');
	begin
		assert(i < BUNCHES_PER_ORBIT) report "Unable to convert integer to bx_nr_t: value too large" severity error;
		ret_value := std_logic_vector(to_unsigned(i, ret_value'length));
		return ret_value;
	end function;

end;



