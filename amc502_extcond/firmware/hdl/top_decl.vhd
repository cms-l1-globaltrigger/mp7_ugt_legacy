--
-- Defines constants for the whole device
--
-- Dave Newbold, June 2014

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.mp7_top_decl.all;
use work.gt_mp7_top_pkg.all;

package top_decl is

        constant ALGO_REV: std_logic_vector(31 downto 0) := TOP_BUILD_VERSION;
        constant BUILDSYS_BUILD_TIME: std_logic_vector(31 downto 0) := TOP_TIMESTAMP; -- To be overwritten at build time
        constant BUILDSYS_BLAME_HASH: std_logic_vector(31 downto 0) := TOP_USERNAME(31 downto 0); -- To be overwritten at build time

        constant LHC_BUNCH_COUNT: integer := 3564;
        constant LB_ADDR_WIDTH: integer := 10;
        constant DR_ADDR_WIDTH: integer := 9;
        constant RO_CHUNKS: integer := 32;
        constant CLOCK_RATIO: integer := 6;
        constant CLOCK_RATIO_PAYLOAD: integer := 1;
        constant PAYLOAD_LATENCY: integer := 2;
        constant DAQ_N_BANKS: integer := 4; -- Number of readout banks
        constant DAQ_TRIGGER_MODES: integer := 2; -- Number of trigger modes for readout
        constant DAQ_N_CAP_CTRLS: integer := 4; -- Number of capture controls per trigger mode

  -- Alternative refclk (4th entry in table) is
  -- not used in R1 card, but is used in XE.
  -- 3rd column is therefore just duplicated.

        constant REGION_CONF: region_conf_array_t := (
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 3, 3), -- 0 / 118
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 3, 3), -- 1 / 117*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 4, 4), -- 2 / 116
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 4, 4), -- 3 / 115*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 5, 5), -- 4 / 114
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 5, 5), -- 5 / 113*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 7, 7), -- 6 / 112
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 7, 7), -- 7 / 111*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 7, 7), -- 8 / 110
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 6, 6), -- 9 / 210
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 6, 6), -- 10 / 211*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 2, 2), -- 11 / 212
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 2, 2), -- 12 / 213*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 1, 1), -- 13 / 214
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 1, 1), -- 14 / 215*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 0, 0), -- 15 / 216
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 0, 0), -- 16 / 217*
                (gth_10g, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g, 0, 0) -- 17 / 218
        );

end top_decl;