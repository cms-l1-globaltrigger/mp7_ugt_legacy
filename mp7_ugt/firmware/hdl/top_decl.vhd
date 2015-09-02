-- top_decl
--
-- Defines constants for the whole device
--
-- Dave Newbold, June 2014

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.mp7_top_decl.all;

package top_decl is

  constant ALGO_REV: std_logic_vector(31 downto 0) := X"00010000";

	constant LHC_BUNCH_COUNT: integer := 3564;
	constant LB_ADDR_WIDTH: integer := 10;
	constant DR_ADDR_WIDTH: integer := 9;
	constant RO_CHUNKS: integer := 32;
	constant CLOCK_RATIO: integer := 6;
	constant CLOCK_RATIO_PAYLOAD: integer := 1; --JW 2015-09-01: set to '1' for 40MHz payload clk!
	constant PAYLOAD_LATENCY: integer := 2;
	constant DAQ_N_BANKS: integer := 4;
	constant DAQ_TRIGGER_MODES: integer := 2;
	constant DAQ_N_CAP_CTRLS: integer := 4; -- Number of capture controls per trigger mode

	constant REGION_CONF: region_conf_array_t := (
		(gth_10g, none, 3, 10), -- 0 / 118
		(gth_10g, none, 3, 10), -- 1 / 117*
		(gth_10g, none, 3, 10), -- 2 / 116
		(gth_10g, none, 4, 11), -- 3 / 115
		(gth_10g, none, 4, 11), -- 4 / 114*
		(gth_10g, none, 4, 11), -- 5 / 113
		(gth_10g, none, 5, 12), -- 6 / 112
		(gth_10g, none, 5, 12), -- 7 / 111*
		(gth_10g, none, 5, 12), -- 8 / 110
		(gth_10g, none, 0, 7), -- 9 / 210
		(gth_10g, none, 0, 7), -- 10 / 211*
		(gth_10g, none, 0, 7), -- 11 / 212
		(gth_10g, none, 1, 8), -- 12 / 213
		(gth_10g, none, 1, 8), -- 13 / 214*
		(gth_10g, none, 1, 8), -- 14 / 215
		(gth_10g, none, 2, 9), -- 15 / 216
		(gth_10g, none, 2, 9), -- 16 / 217*
		(gth_10g, none, 2, 9) -- 17 / 218
	);

end top_decl;
