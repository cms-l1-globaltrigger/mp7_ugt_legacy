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
-- HB 2016-04-11: v0.0.38 - implemented delays for EC0, OC0, RESYNC and START (same delay as BCRES) and inserted bcres_outputmux_o (delayed version of bcres for output mux) in dm.vhd.
--                Inserted reset of lumi-section number with OC0 and used signals of synchronized (and delayed) BGos in tcm.vhd. 
--                Used "algo_after_gtLogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") in output_mux.vhd (according to fdl_module v0.0.24).
--                Changed tp_mux.vhd for synchronized BGos.
-- JW 2016-04-06: v0.0.37 - added an additional delay for the bc0 output of the dm module (except for the output_mux bc0 signal)
-- HB 2016-02-26: v0.0.36 - removed unused fdl_status, bx_nr_d_FDL and tp in frame. Used fdl_module v0.0.22 and updated tp_mux.
-- JW 2015-10-20: v0.0.35 - added all lanes in the output mux code
-- JW 2015-02-24: v0.0.16 - based on v0.0.15, but added a pulse reg and connected its output to reset logic
-- JW 16.02.2015 -changing the calculation the read_pointer in delay element frame version 0.0.15
-- JW 11.02.2015 - changed logic for address calculation, because an bug was found:
--  if the MAX_DELAY is smaller than the whole instanciated ram, we have to take care,
--  that the read pointer does not jump to an unused position when the write pointer is set back to 0. frame version 0.0.14
-- HB 2015-02-05: v0.0.13 - based on v0.0.12, but cleaned up the code and changed demux_lane_data (removed port del_a).
--BR: 04.02.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package. frame version 0.0.12
-- BR 2015-02-03: "bcres_d" is used, which commes from DM, frame version 0.0.11
-- HB 2015-01-19: v0.0.10 - based on v0.0.24 from ../branches/hb_dev_1_4_1_r1, but merged to trunk

-- ******************************************
-- Development in ../branches/hb_dev_1_4_1_r1
-- HB 2014-12-12: v0.0.24: based on v0.0.21 and v0.0.8, used demux_lane_data from frame v0.0.8.
-- HB 2014-11-25: v0.0.21: based on v0.0.18, but used lmp.vhd for adapted muon lane data.
-- HB 2014-11-18: v0.0.20: based on v0.0.18, but gt_mp7.ucf not used in makefile. 16 lanes used, N_REGION = 9 (in top_decl.vhd) used for tests, because of timing errors. UCF file, mp7.ucf
--                         in customized_mp7_1_4_0 changed for N_REGION = 9 and for "align".
-- HB 2014-11-12: v0.0.19: based on v0.0.18, but new assignment for lanes (because of timing and placing problems).
-- HB 2014-10-30: v0.0.18: based on v0.0.16, but bug fixed at SPY2_FINOR input (used local_finor_with_veto_2_spy2 in this version). FDL v0.0.4 used.
--                         Added gt_mp7.ucf to makefile. Edited gt_mp7.ucf and inserted AREA_GROUP constraints for demux_lane_data.
-- HB 2014-10-30: v0.0.17: DO NOT USE !!! created only for tests - based on v0.0.16, but bug fixed at SPY2_FINOR input (used local_finor_with_veto_2_spy2 in this version) and
--                         implemented new data structure (lhc_data_2_spy1) to SPY1 (bypassed dm.vhd) to find ext-cond error (in SPY1). FDL v0.0.4 used.
-- HB 2014-10-29: v0.0.16: based on v0.0.15, but changed demux_lane_data.vhd logic and the implemantation for the lanes (and demux_lane_adjust_regs) in frame.vhd.
-- HB 2014-10-23: v0.0.15: based on v0.0.14, but "local_veto_rop" added ("finor_rop" = '0', not used anymore). Removed status test register.
-- HB 2014-10-07: v0.0.14: based on v0.0.13, but used output register (LHC clock domain) in demux_lane_data.vhd.
-- HB 2014-09-26: v0.0.13: based on v0.0.12, but used fix value of 16 instead of NR_LANES for demux_lane_data loop and lmp.
-- HB 2014-09-24: v0.0.12: based on v0.0.8, but extended demux_lane_adjust for 16 lanes and implemented data suppression in demux_lane_data.vhd.
-- HB 2014-09-23: v0.0.11: based on v0.0.8, but changed code of demux_lane_data.vhd - DID NOT WORK!!!
-- [HB 2014-09-23: v0.0.10 (BR) demux_lane_data.vhd without adjust]
-- [HB 2014-09-23: v0.0.9 (HB) did not work!!!]
-- ******************************************

-- ******************************************
-- Development in ../branches/1_4_1
-- BR 2014-12-09: v0.0.9 - changed demux_lane_data to data_demux.
-- BR:21-11-2014 TOP_SERIAL_VENDOR is not mor relevant, because in future we will read from hardware over ipmi just MAC address
-- ******************************************

-- HB 2014-09-09: v0.0.8 - based on v0.0.7, but GTL and FDL firmware major, minor and revision versions moved to gt_mp7_core_pkg.vhd (GTL_FW_MAJOR_VERSION, etc.)
--                for creating a tag name by a script independent from L1Menu.
-- HB 2014-09-01: v0.0.7 - based on v0.0.4, but in frame.vhd added external-conditions data in lmp and added bcres_d_FDL_int to tp.
-- HB 2014-08-28: v0.0.6 - same as v0.0.5, but used bx_nr_d_spy2 for generating of spy2 in spytrigger.vhd - ATTENTION: this is only for tests with spy2, for tests with spy1 this delay might be different!!!
--                DO NOT USE, did not work porperly!
-- HB 2014-08-27: v0.0.5 - test version with register for delay for spy-address of spy2 (see also: dm.vhd, rb.vhd, rb_pkg.vhd and tcm.vhd).
--                DO NOT USE, did not work porperly!
-- HB 2014-08-26: v0.0.4 - test version with spy2_algos and spy2_finor instantiated with ipb_dpmem_4096_32 modules, too.
-- HB 2014-08-21: v0.0.3 - test version with simspymem instantiated with ipb_dpmem_4096_32 modules
-- BR 2014-08-08: changing on FDL version, or instantiate of all algo_bx_mems the version of FDL is 0.0.1
-- BR 2014-07-16:"Milestone" : lhc_rst is for doing the reset the counter in tcm module. It is implmented as resgister, which later should be re-implemented as event register.
--               :Framework version v0.0.2
-- HB 2014-07-08: ipbus_rst is high active, RST_ACT changed to '1' (for lhc_rst [in gt_mp7_core_pkg.vhd]) to get proper reset-conditions,
--                because in delay_line_sl.vhd and delay_line_slv.vhd both resets are used !!!

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
    constant MODULE_TYPE_PROTOCOL: std_logic_vector(3 downto 0) := TOP_TYPE_PROTOCOL; -- IP_BUS_2.0
    constant MODULE_TYPE_TYPE: std_logic_vector(3 downto 0) := TOP_MODULE_TYPE; -- MP7
    constant MODULE_SERIAL_NUMBER: std_logic_vector(23 downto 0) := X"000000"; -- dummy value - not used anymore
    constant MODULE_TYPE: std_logic_vector(31 downto 0) := MODULE_SERIAL_NUMBER & MODULE_TYPE_TYPE & MODULE_TYPE_PROTOCOL;
    constant USERNAME : std_logic_vector(32*8-1 downto 0) := TOP_USERNAME;
    constant HOSTNAME : std_logic_vector(32*8-1 downto 0) := TOP_HOSTNAME;
    constant BUILD_VERSION : std_logic_vector(31 downto 0) := TOP_BUILD_VERSION;

-- ==================================================================================================
-- FRAME version (given by the editor of frame.vhd)
    constant FRAME_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant FRAME_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant FRAME_REV_VERSION        : integer range 0 to 255 := 38;
	constant FRAME_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(FRAME_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_REV_VERSION, 8));

-- GTL firmware (fix part) version
    constant GTL_FW_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant GTL_FW_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant GTL_FW_REV_VERSION        : integer range 0 to 255 := 9;
-- FDL firmware version
    constant FDL_FW_MAJOR_VERSION      : integer range 0 to 255 := 0;
    constant FDL_FW_MINOR_VERSION      : integer range 0 to 255 := 0;
    constant FDL_FW_REV_VERSION        : integer range 0 to 255 := 24;
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
-- constant LANE_COUNT : integer := 6;
-- constant LANE_WIDTH : integer := 32;
-- type lane_objects_array_t is array (NATURAL RANGE <>) of std_logic_vector(LWORD_WIDTH-1 downto 0);
-- type lane_objects_array_valid_t is array (NATURAL RANGE <>) of std_logic;
    constant OBJECTS_PER_LANE : integer := 6; -- CLOCK_RATIO defined in top_decl.vhd 6 objects with 32 bits per lane (CLOCK_RATIO = 6 => 240MHZ / 40MHZ)
--     type lane_objects_array_t is array (0 to OBJECTS_PER_LANE-1) of std_logic_vector(LWORD_WIDTH-1 downto 0);
--     type lane_objects_array_valid_t is array (0 to OBJECTS_PER_LANE-1) of std_logic;
--     type demux_lanes_data_objects_array_t is array (NATURAL RANGE <>) of lane_objects_array_t;
--     type demux_lanes_data_objects_array_valid_t is array (NATURAL RANGE <>) of lane_objects_array_valid_t;
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
--BR Aug. 29 2013
--1. change the width in tcm.xml
--2. change package
--3. trunk/make distribute-xml
--4. script/autogenRb/autogenRb.py
--5. change xml/rop_frame_format.xml
--6. script/rop_frame_generator/make frame
--7 script/rop_frame_generator/make distribute-frame

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
--constant DM_MAX_DELAY_OBJECTS : integer  range 0 to BUNCHES_PER_ORBIT := 31;--:= BUNCHES_PER_ORBIT;
-- constant DM_MAX_DELAY_OBJECTS : integer  range 0 to BUNCHES_PER_ORBIT := BUNCHES_PER_ORBIT;
constant DM_MAX_DELAY_OBJECTS : integer  range 0 to BUNCHES_PER_ORBIT := BUNCHES_PER_ORBIT/2;
constant DM_MAX_DELAY_BCRES : integer  range 0 to BUNCHES_PER_ORBIT := BUNCHES_PER_ORBIT;

--------------------------------------------------------------------------------
-- SIM/SPY Memory + Spytrigger
--------------------------------------------------------------------------------
-- HB, 12-11-2013: GTL_FDL_LATENCY = 6 with fixed pipeline structure (2 = +/- 2bx, 3 = conditions and algos, 1 = FDL)
constant GTL_FDL_LATENCY : integer := 6;

-- l1a sim

-- dsmux

-- tcm

-- reset logic

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



