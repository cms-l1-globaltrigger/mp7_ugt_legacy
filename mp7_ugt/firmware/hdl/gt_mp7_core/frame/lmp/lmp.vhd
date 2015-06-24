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
---Description:Lane Mapping Process, Developer Babak, Markus
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/lmp/lmp.vhd $
-- $Date: 2015-01-07 10:56:26 +0100 (Wed, 07 Jan 2015) $
-- $Author: rahbaran $
-- $Revision: 3605 $
--------------------------------------------------------------------------------

-- HB 2014-11-20: changed lane mapping for muons from 0,1,2,3 to 2,3,4,5 of 240MHz objects - proposed by Dinyar.
-- HB 2014-09-01: added external-conditions.
-- HB 2014-05-08: THIS IS A DUMMY VERSION OF lmp - only for first data flow tests
-- The containt of this file could be auto-generated with an XML-file as source.

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;

entity lmp is
	generic
	(
        NR_LANES: positive
	);
	port 
	(
        demux_data_i : in demux_lanes_data_objects_array_t(NR_LANES-1 downto 0);
        demux_data_valid_i : in demux_lanes_data_objects_array_valid_t(NR_LANES-1 downto 0);
		lhc_data_o : out lhc_data_t;
		lhc_data_valid_o : out std_logic
	); 
end;

architecture arch of lmp is
    constant OFFSET_MUON_LANES : natural := 0;
    constant OFFSET_EG_LANES : natural := 4;
    constant OFFSET_JET_LANES : natural := 6;
    constant OFFSET_TAU_LANES : natural := 8;
    constant OFFSET_ESUMS_LANES : natural := 10;
-- HB 2014-09-01: added external-conditions.
    constant OFFSET_EXT_COND_LANES : natural := 12;
begin

    lhc_data_valid_o <= '1';

-- HB 2014-05-12: the index of LANES is "Link #" of Greg's definition in "../ucf/MGT_placement_v8_QuadsReOrdered_mGT.xlsx"
    
-- muon data
--     lhc_data_o.muon(0)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+0)(0);
--     lhc_data_o.muon(0)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+0)(1);
--     lhc_data_o.muon(1)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+0)(2);
--     lhc_data_o.muon(1)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+0)(3);
--     lhc_data_o.muon(2)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+1)(0);
--     lhc_data_o.muon(2)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+1)(1);
--     lhc_data_o.muon(3)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+1)(2);
--     lhc_data_o.muon(3)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+1)(3);
--     lhc_data_o.muon(4)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+2)(0);
--     lhc_data_o.muon(4)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+2)(1);
--     lhc_data_o.muon(5)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+2)(2);
--     lhc_data_o.muon(5)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+2)(3);
--     lhc_data_o.muon(6)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+3)(0);
--     lhc_data_o.muon(6)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+3)(1);
--     lhc_data_o.muon(7)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+3)(2);
--     lhc_data_o.muon(7)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+3)(3);

-- HB 2014-11-20: changed lane mapping for muons 0,1,2,3 to 2,3,4,5 of 240MHz objects.
    lhc_data_o.muon(0)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+0)(2);
    lhc_data_o.muon(0)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+0)(3);
    lhc_data_o.muon(1)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+0)(4);
    lhc_data_o.muon(1)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+0)(5);
    lhc_data_o.muon(2)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+1)(2);
    lhc_data_o.muon(2)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+1)(3);
    lhc_data_o.muon(3)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+1)(4);
    lhc_data_o.muon(3)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+1)(5);
    lhc_data_o.muon(4)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+2)(2);
    lhc_data_o.muon(4)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+2)(3);
    lhc_data_o.muon(5)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+2)(4);
    lhc_data_o.muon(5)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+2)(5);
    lhc_data_o.muon(6)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+3)(2);
    lhc_data_o.muon(6)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+3)(3);
    lhc_data_o.muon(7)(31 downto 0)  <= demux_data_i(OFFSET_MUON_LANES+3)(4);
    lhc_data_o.muon(7)(63 downto 32) <= demux_data_i(OFFSET_MUON_LANES+3)(5);

-- eg data
    lhc_data_o.eg(0)  <= demux_data_i(OFFSET_EG_LANES+0)(0);
    lhc_data_o.eg(1)  <= demux_data_i(OFFSET_EG_LANES+0)(1);
    lhc_data_o.eg(2)  <= demux_data_i(OFFSET_EG_LANES+0)(2);
    lhc_data_o.eg(3)  <= demux_data_i(OFFSET_EG_LANES+0)(3);
    lhc_data_o.eg(4)  <= demux_data_i(OFFSET_EG_LANES+0)(4);
    lhc_data_o.eg(5)  <= demux_data_i(OFFSET_EG_LANES+0)(5);
    lhc_data_o.eg(6)  <= demux_data_i(OFFSET_EG_LANES+1)(0);
    lhc_data_o.eg(7)  <= demux_data_i(OFFSET_EG_LANES+1)(1);
    lhc_data_o.eg(8)  <= demux_data_i(OFFSET_EG_LANES+1)(2);
    lhc_data_o.eg(9)  <= demux_data_i(OFFSET_EG_LANES+1)(3);
    lhc_data_o.eg(10) <= demux_data_i(OFFSET_EG_LANES+1)(4);
    lhc_data_o.eg(11) <= demux_data_i(OFFSET_EG_LANES+1)(5);

-- jet data
    lhc_data_o.jet(0)  <= demux_data_i(OFFSET_JET_LANES+0)(0);
    lhc_data_o.jet(1)  <= demux_data_i(OFFSET_JET_LANES+0)(1);
    lhc_data_o.jet(2)  <= demux_data_i(OFFSET_JET_LANES+0)(2);
    lhc_data_o.jet(3)  <= demux_data_i(OFFSET_JET_LANES+0)(3);
    lhc_data_o.jet(4)  <= demux_data_i(OFFSET_JET_LANES+0)(4);
    lhc_data_o.jet(5)  <= demux_data_i(OFFSET_JET_LANES+0)(5);
    lhc_data_o.jet(6)  <= demux_data_i(OFFSET_JET_LANES+1)(0);
    lhc_data_o.jet(7)  <= demux_data_i(OFFSET_JET_LANES+1)(1);
    lhc_data_o.jet(8)  <= demux_data_i(OFFSET_JET_LANES+1)(2);
    lhc_data_o.jet(9)  <= demux_data_i(OFFSET_JET_LANES+1)(3);
    lhc_data_o.jet(10) <= demux_data_i(OFFSET_JET_LANES+1)(4);
    lhc_data_o.jet(11) <= demux_data_i(OFFSET_JET_LANES+1)(5);

-- tau data
    lhc_data_o.tau(0)  <= demux_data_i(OFFSET_TAU_LANES+0)(0);
    lhc_data_o.tau(1)  <= demux_data_i(OFFSET_TAU_LANES+0)(1);
    lhc_data_o.tau(2)  <= demux_data_i(OFFSET_TAU_LANES+0)(2);
    lhc_data_o.tau(3)  <= demux_data_i(OFFSET_TAU_LANES+0)(3);
    lhc_data_o.tau(4)  <= demux_data_i(OFFSET_TAU_LANES+0)(4);
    lhc_data_o.tau(5)  <= demux_data_i(OFFSET_TAU_LANES+0)(5);
    lhc_data_o.tau(6)  <= demux_data_i(OFFSET_TAU_LANES+1)(0);
    lhc_data_o.tau(7)  <= demux_data_i(OFFSET_TAU_LANES+1)(1);

-- ET data
    lhc_data_o.ett <= demux_data_i(OFFSET_ESUMS_LANES)(0);
-- HT data
    lhc_data_o.ht  <= demux_data_i(OFFSET_ESUMS_LANES)(1);
-- ETm data
    lhc_data_o.etm <= demux_data_i(OFFSET_ESUMS_LANES)(2);
-- HTm data
    lhc_data_o.htm <= demux_data_i(OFFSET_ESUMS_LANES)(3);

-- HB 2014-09-01: added external-conditions.
    lhc_data_o.external_conditions(31 downto 0) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(0);
    lhc_data_o.external_conditions(63 downto 32) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(1);
    lhc_data_o.external_conditions(95 downto 64) <= demux_data_i(OFFSET_EXT_COND_LANES+1)(0);
    lhc_data_o.external_conditions(127 downto 96) <= demux_data_i(OFFSET_EXT_COND_LANES+1)(1);
    lhc_data_o.external_conditions(159 downto 128) <= demux_data_i(OFFSET_EXT_COND_LANES+2)(0);
    lhc_data_o.external_conditions(191 downto 160) <= demux_data_i(OFFSET_EXT_COND_LANES+2)(1);
    lhc_data_o.external_conditions(223 downto 192) <= demux_data_i(OFFSET_EXT_COND_LANES+3)(0);
    lhc_data_o.external_conditions(255 downto 224) <= demux_data_i(OFFSET_EXT_COND_LANES+3)(1);

-- HB 2014-05-12: future aspects looking at "trunk/cactusupgrades/components/mp7_links/firmware/hdl/protocol" 
-- external condition data (10Gb/s links - with "ext_align_gth_32b_10g_spartan")
--     lhc_data_o.external_conditions(31 downto 0)  <= demux_data_i(OFFSET_EXT_COND_LANES+0)(0);
--     lhc_data_o.external_conditions(63 downto 32) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(1);
-- ... and so on !!!

-- external condition data (5Gb/s links) - only lower 16 bits of 32 bit data of links used (with "ext_align_gth_16b_5g_spartan")
--     lhc_data_o.external_conditions(15 downto 0)  <= demux_data_i(OFFSET_EXT_COND_LANES+0)(0)(15 downto 0);
--     lhc_data_o.external_conditions(32 downto 16) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(1)(15 downto 0);
-- ... and so on !!!

-- ===========================================================

-- -- eg data on lane 0 and 1 (NR_LANES)
--     eg_lane_l: for i in 0 to 1 generate
--         eg_objects_l: for j in 0 to 5 generate
--             lhc_data_o.eg(i*6+j) <= demux_data_i(i+OFFSET_EG_LANES)(j);
--         end generate;
--     end generate;
-- -- jet data on lane 2 and 3 (NR_LANES)
--     jet_lane_l: for i in 0 to 1 generate
--         jet_objects_l: for j in 0 to 5 generate
--             lhc_data_o.jet(i*6+j) <= demux_data_i(i+OFFSET_JET_LANES)(j);
--         end generate;
--     end generate;
-- -- tau data on lane 4 and 5 (NR_LANES)
--     tau_lane_l: for j in 0 to 5 generate
--         lhc_data_o.tau(j) <= demux_data_i(OFFSET_TAU_LANES)(j);
--     end generate;
--     lhc_data_o.tau(6) <= demux_data_i(OFFSET_TAU_LANES+1)(0);
--     lhc_data_o.tau(7) <= demux_data_i(OFFSET_TAU_LANES+1)(1);
-- 
-- -- ET data on lane 6 (NR_LANES)
--     lhc_data_o.ett <= demux_data_i(OFFSET_ESUMS_LANES)(0);
-- -- HT data on lane 6 (NR_LANES)
--     lhc_data_o.ht <= demux_data_i(OFFSET_ESUMS_LANES)(1);
-- -- ETm data on lane 6 (NR_LANES)
--     lhc_data_o.etm <= demux_data_i(OFFSET_ESUMS_LANES)(2);
-- -- HTm data on lane 6 (NR_LANES)
--     lhc_data_o.htm <= demux_data_i(OFFSET_ESUMS_LANES)(3);
-- 
-- -- demux_data_i(7) reserved for spares
-- 
-- -- -- muon data on lane 8..11 (NR_LANES)
--     muon_lane_l_1: for i in 0 to 3 generate
--         muon_lane_l_2: for j in 0 to 1 generate
--             lhc_data_o.muon(i*2+j) <= demux_data_i(i+OFFSET_MUON_LANES)(j*2+1) & demux_data_i(i+OFFSET_MUON_LANES)(j*2);
--         end generate;
--     end generate;
-- 
-- -- -- muon data on lane 8 (NR_LANES)
-- --     lhc_data_o.muon(0) <= demux_data_i(8)(1) & demux_data_i(8)(0);
-- --     lhc_data_o.muon(1) <= demux_data_i(8)(3) & demux_data_i(8)(2);
-- -- -- muon data on lane 9 (NR_LANES)
-- --     lhc_data_o.muon(2) <= demux_data_i(9)(1) & demux_data_i(9)(0);
-- --     lhc_data_o.muon(3) <= demux_data_i(9)(3) & demux_data_i(9)(2);
-- -- -- muon data on lane 10 (NR_LANES)
-- --     lhc_data_o.muon(4) <= demux_data_i(10)(1) & demux_data_i(10)(0);
-- --     lhc_data_o.muon(5) <= demux_data_i(10)(3) & demux_data_i(10)(2);
-- -- -- muon data on lane 11 (NR_LANES)
-- --     lhc_data_o.muon(6) <= demux_data_i(11)(1) & demux_data_i(11)(0);
-- --     lhc_data_o.muon(7) <= demux_data_i(11)(3) & demux_data_i(11)(2);

end architecture;

