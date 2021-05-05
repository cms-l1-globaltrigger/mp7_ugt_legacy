
-- actual versions:
-- use "FRAME_VERSION" as mp7_ugt release fw version (used for tag name).
-- mp7_ugt (=FRAME_VERSION): v1.14.1
--
-- frame: v1.2.3 (see frame.vhd)
-- gtl: v1.14.1 (see gtl_module_tpl.vhd)
-- fdl: v1.3.6 (see fdl_module.vhd)

-- gtl history:
-- HB 2021-05-05: v1.14.1: Bug fixed in sum_mass.vhd (comparison for mass 3 body).
-- HB 2021-04-16: v1.14.0: Added modules for correlation cuts calculations outside of conditions (correlation_cuts_calculation.vhd). Renamed files (differences.vhd => deta_dphi_calculations.vhd, ...). Added new modules for all and-or matrix instantiations (matrix_corr_cond.vhd, matrix_calo_cond.vhd, ...).
-- HB 2021-02-08: v1.13.0: Changed directory structure in gtl (created sub dir "common" for modules, wihich are not instantiated in gtl_module.vhd).
-- HB 2021-03-18: v1.12.1: Bug fix in correlation_conditions_muon.vhd.
-- HB 2021-02-05: v1.12.0: Implemented comb_conditions.vhd, correlation_conditions_calo.vhd and correlation_conditions_muon.vhd instead of calo_conditions.vhd, muon_conditions.vhd and calo_calo_correlation_condition.vhd, muon_muon_correlation_condition.vhd, etc.
-- HB 2020-12-14: v1.11.0: Changes logic for phi cuts (similar to eta cuts). Same order in generics calo and muon conditions and for all correlation conditions (simplifies templates of VHDL Producer).
-- HB 2020-10-09: v1.10.1: Added module pipelines (including modules for ext_cond_pipe and centrality_pipe processes). Changed files for correlation conditions of calos and muons.
-- HB 2020-08-25: v1.10.0: Implemented new muon structure with "unconstraint pt" and "impact parameter". Added files for "invariant mass with 3 objects" and "invariant mass divided by delta R".
-- HB 2020-02-03: v1.9.4: Changed output pipeline code in esums_comparators.vhd and min_bias_hf_conditions.vhd.
-- HB 2020-01-30: v1.9.3: Cleaned up code in esums_comparators.vhd and min_bias_hf_conditions.vhd.

-- [HB 2016-10-11: mp7_ugt v1.9.3 - for correct tag (typo in tag name in CHANGELOG.md)]
-- HB 2016-09-19: removed more unused constants
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

-- ==================================================================================================
-- HB 2014-05-30: definitions (TOP_xxx) moved to gt_mp7_top_pkg.vhd
    constant TIMESTAMP : std_logic_vector(31 downto 0) := TOP_TIMESTAMP;
    constant MODULE_TYPE: std_logic_vector(31 downto 0) := (others => '0');
    constant USERNAME : std_logic_vector(32*8-1 downto 0) := TOP_USERNAME;
    constant HOSTNAME : std_logic_vector(32*8-1 downto 0) := TOP_HOSTNAME;
    constant BUILD_VERSION : std_logic_vector(31 downto 0) := TOP_BUILD_VERSION;

-- ==================================================================================================
-- FRAME version
    constant FRAME_MAJOR_VERSION      : integer range 0 to 255 := 1;
    constant FRAME_MINOR_VERSION      : integer range 0 to 255 := 14;
    constant FRAME_REV_VERSION        : integer range 0 to 255 := 1;
	constant FRAME_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(FRAME_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_REV_VERSION, 8));
-- GTL firmware (fix part) version
    constant GTL_FW_MAJOR_VERSION      : integer range 0 to 255 := 1;
    constant GTL_FW_MINOR_VERSION      : integer range 0 to 255 := 14;
    constant GTL_FW_REV_VERSION        : integer range 0 to 255 := 1;
-- FDL firmware version
    constant FDL_FW_MAJOR_VERSION      : integer range 0 to 255 := 1;
    constant FDL_FW_MINOR_VERSION      : integer range 0 to 255 := 3;
    constant FDL_FW_REV_VERSION        : integer range 0 to 255 := 6;
-- ==================================================================================================

    constant BUNCHES_PER_ORBIT : natural range 3564 to 3564 := LHC_BUNCH_COUNT;

-- HB, 24-10-2013: proposed MAX_NR_ALGOS instead of NR_ALGOS
    constant MAX_NR_ALGOS        : integer := 512;

    type ipb_regs_array is array (natural range <>) of std_logic_vector(31 downto 0);

    constant FINOR_WIDTH : integer := 4; -- for read-out record

-- HB 2014-07-08: ipbus_rst is high active, RST_ACT changed to '1' (for lhc_rst [in gt_mp7_core_pkg.vhd]) to get proper reset-conditions,
--                because in delay_line_sl.vhd and delay_line_slv.vhd both resets are used !!!
-- constant RST_ACT : std_logic := '0';
    constant RST_ACT : std_logic := '1';
    constant RST_ACT_ROP : std_logic := '0';

    type vec32_array is array (NATURAL RANGE <>) of std_logic_vector(31 downto 0);
    type vec16_array is array (NATURAL RANGE <>) of std_logic_vector(15 downto 0);
    type vec8_array is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);

--------------------------------------------------------------------------------
--  LMP (Lane Mapping Process)
--------------------------------------------------------------------------------
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

    type bx_nr_array_t is array(integer range<>) of bx_nr_t;

    constant BC_TOP                       : integer := BUNCHES_PER_ORBIT-1;
    constant LUM_SEG_PERIOD_MSK_RESET     : luminosity_seg_period_msk_t := X"00040000";

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



