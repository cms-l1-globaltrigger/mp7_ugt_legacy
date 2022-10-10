-- top_decl
--
-- Defines constants for the whole device
--
-- Dave Newbold, June 2014

-- Description:
-- Package for declarations of ugt top.

-- Version history:
-- HB 2022-10-10: updated for ZDC 5G input and ZDC 10G distribution (to patchpanel for ZDC on link 11).
-- HB 2022-09-21: inserted gth_5g_std_lat on REGION 4, updated to N_REGION = 8

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

-- HB 2022-10-08: N_REGION = 10 (region 7 and 8 for ZDC 10G outputs, region 9 for ZDC 5G inputs)
    constant REGION_CONF: region_conf_array_t := (
        0 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 0 / 118 --> inputs from uGMT (muons)
        1 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 1 / 117*--> inputs from Calo-Layer-2 (eg, jets)
        2 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 3, 10), -- 2 / 116 --> inputs from Calo-Layer-2 (tau, esums) and ZDC
        3 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 3 / 115 --> inputs from External Conditions
        4 => (gth_10g_std_lat, u_crc32, buf, demux, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 4 / 114* --> read-out record outputs
        5 => (gth_10g_std_lat, u_crc32, buf, demux, buf, u_crc32, gth_10g_std_lat, 4, 11), -- 5 / 113 --> read-out record outputs
        6 => (gth_10g_std_lat, u_crc32, buf, demux, buf, u_crc32, gth_10g_std_lat, 5, 12), -- 6 / 112 --> read-out record outputs
        7 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 5, 12), -- 7 / 111* --> 4x ZDC 10G outputs to patch panel
        8 => (gth_10g_std_lat, u_crc32, buf, no_fmt, buf, u_crc32, gth_10g_std_lat, 5, 12), -- 8 / 110 --> 2x ZDC 10G outputs to patch panel
        9 => (gth_5g, u_crc32, buf, no_fmt, buf, u_crc32, gth_5g, 0, 7) -- 9 / 210 --> inputs from ZDC 5G optical
    );

end top_decl;
