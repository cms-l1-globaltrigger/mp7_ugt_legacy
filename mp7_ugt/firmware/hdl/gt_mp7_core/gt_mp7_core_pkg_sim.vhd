-- Used for gtl-fdl-simulation

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

package gt_mp7_core_pkg is

    type ipb_regs_array is array (natural range <>) of std_logic_vector(31 downto 0);
    
    constant MAX_NR_ALGOS : integer := 512;
    
-- HB 2014-07-08: ipbus_rst is high active, RST_ACT changed to '1' (for lhc_rst [in gt_mp7_core_pkg.vhd]) to get proper reset-conditions,
--                because in delay_line_sl.vhd and delay_line_slv.vhd both resets are used !!!
    constant RST_ACT : std_logic := '1'; -- HB 2016-12-05: used in delay_element.vhd (in algo_post_dead_time_counter.vhd)

-- HB, 12-11-2013: GTL_FDL_LATENCY = 6 with fixed pipeline structure (2 = +/- 2bx, 3 = conditions and algos, 1 = FDL)
    constant GTL_FDL_LATENCY : integer := 6;

-- ==================================================================================================
-- HB 2016-12-05: dummy values for following constants (not important in gtl-fdl-simulation)

    constant TIMESTAMP : std_logic_vector(31 downto 0) := X"00000000";
    constant MODULE_TYPE: std_logic_vector(31 downto 0) := (others => '0');
    constant USERNAME : std_logic_vector(32*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
    constant HOSTNAME : std_logic_vector(32*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
    constant BUILD_VERSION : std_logic_vector(31 downto 0) := X"00000000";

    constant FRAME_MAJOR_VERSION      : integer range 0 to 255 := 255;
    constant FRAME_MINOR_VERSION      : integer range 0 to 255 := 255;
    constant FRAME_REV_VERSION        : integer range 0 to 255 := 255;
	constant FRAME_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(FRAME_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FRAME_REV_VERSION, 8));
    constant GTL_FW_MAJOR_VERSION      : integer range 0 to 255 := 255;
    constant GTL_FW_MINOR_VERSION      : integer range 0 to 255 := 255;
    constant GTL_FW_REV_VERSION        : integer range 0 to 255 := 255;
    constant FDL_FW_MAJOR_VERSION      : integer range 0 to 255 := 255;
    constant FDL_FW_MINOR_VERSION      : integer range 0 to 255 := 255;
    constant FDL_FW_REV_VERSION        : integer range 0 to 255 := 255;
-- ==================================================================================================

end package;



