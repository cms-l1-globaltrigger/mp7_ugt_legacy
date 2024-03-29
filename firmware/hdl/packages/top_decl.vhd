-- Description:
-- Package for declarations of ugt top.

-- top_decl
--
-- Defines constants for the whole device
--
-- Dave Newbold, June 2014

-- Version-history:
-- HB 2023-09-29: changed quads 8..16 to "no_mgt".
-- HB 2023-08-25: updated for new ZDC input.

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.mp7_top_decl.all;
use work.gt_mp7_top_pkg.all;

package top_decl is

        constant ALGO_REV: std_logic_vector(31 downto 0) := TOP_BUILD_VERSION; -- JW 11.11.2015 use unique uGT build version (eg. 0x1038) as algo_rev value
        constant BUILDSYS_BUILD_TIME: std_logic_vector(31 downto 0) := TOP_TIMESTAMP; -- JW 03.03.2016
        constant BUILDSYS_BLAME_HASH: std_logic_vector(31 downto 0) := TOP_USERNAME(31 downto 0); -- JW 03.03.2016

        constant LHC_BUNCH_COUNT: integer := 3564;
        constant LB_ADDR_WIDTH: integer := 10;
        constant DR_ADDR_WIDTH: integer := 9;
        constant RO_CHUNKS: integer := 32;
        constant CLOCK_RATIO: integer := 6;
        constant CLOCK_RATIO_PAYLOAD: integer := 1; --JW 2015-09-01: set to '1' for 40MHz payload clk!
        constant PAYLOAD_LATENCY: integer := 2;
        constant DAQ_N_BANKS: integer := 4; -- Number of readout banks
        constant DAQ_TRIGGER_MODES: integer := 2; -- Number of trigger modes for readout
        constant DAQ_N_CAP_CTRLS: integer := 4; -- Number of capture controls per trigger mode28
        constant ZS_ENABLED: boolean := FALSE;
        constant CLOCK_AUX_RATIO: clock_ratio_array_t := (1, 1, 1);

-- HB 2022-10-04: used "demux" in formatter for algo outputs to enable "orbit header" for scouting
-- HB 2023-08-25: used quad 17 for ZDC 5G input on link 71
        constant REGION_CONF: region_conf_array_t := (
            0 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 0 / 118
            1 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 1 / 117*
            2 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 2 / 116
            3 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 3 / 115
            4 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 4 / 114*
            5 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 5 / 113
            6 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 5, 12), -- 6 / 112
            7 => (gth_10g_std_lat, u_crc32, buf, demux, buf, u_crc32, gth_10g_std_lat, 5, 12), -- 7 / 111* --> scouting outputs
            8 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 5, 12), -- 8 / 110
            9 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 0, 7), -- 9 / 210
            10 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 0, 7), -- 10 / 211*
            11 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 0, 7), -- 11 / 212
            12 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 1, 8), -- 12 / 213
            13 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 1, 8), -- 13 / 214*
            14 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 1, 8), -- 14 / 215
            15 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 2, 9), -- 15 / 216
            16 => (no_mgt, no_chk, no_buf, no_fmt, no_buf, no_chk, no_mgt, 2, 9), -- 16 / 217*
            17 => (gth_5g, u_crc32, buf, no_fmt, buf, u_crc32, gth_5g, 2, 9) -- 17 / 218 --> ZDC 5G optical input
        );

end top_decl;
