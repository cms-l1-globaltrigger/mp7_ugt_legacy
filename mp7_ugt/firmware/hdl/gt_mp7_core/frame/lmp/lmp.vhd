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
---Description:Lane Mapping Process, Developer HEPHY
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

-- HB 2106-05-31: lane mapping for all frames of calo links (for extended test-vector-file structure - see lhc_data_pkg.vhd)
-- HEPHY 2014-05-20: changed lane mapping for muons from 0,1,2,3 to 2,3,4,5 of 240MHz objects -

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
		demux_data_i		: in demux_lanes_data_objects_array_t(NR_LANES-1 downto 0);
		demux_data_valid_i	: in demux_lanes_data_objects_array_valid_t(NR_LANES-1 downto 0);
		lhc_data_o		: out lhc_data_t;
		lhc_data_valid_o	: out std_logic
	);
end;

architecture arch of lmp is

-- HB 2016-06-01: moved to lhc_data_pkg.vhd

--     constant OFFSET_MUON_LANES : natural := 0;
--     constant OFFSET_EG_LANES : natural := 4;
--     constant OFFSET_JET_LANES : natural := 6;
--     constant OFFSET_TAU_LANES : natural := 8;
--     constant OFFSET_ESUMS_LANES : natural := 10;
-- -- HB 2106-05-31: proposal for memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
--     constant OFFSET_LINK_11_LANES : natural := 11;
-- -- BR 2015-05-01: added external-conditions.
--     constant OFFSET_EXT_COND_LANES : natural := 12;
begin

    lhc_data_valid_o <= '1';

-- HEPHY 2015-05-20: changed lane mapping for muons 0,1,2,3 to 2,3,4,5 of 240MHz objects.
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
-- HB 2016-10-17: or memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
    lhc_data_o.tau(8)  <= demux_data_i(OFFSET_TAU_LANES+1)(2);
    lhc_data_o.tau(9)  <= demux_data_i(OFFSET_TAU_LANES+1)(3);
    lhc_data_o.tau(10)  <= demux_data_i(OFFSET_TAU_LANES+1)(4);
    lhc_data_o.tau(11)  <= demux_data_i(OFFSET_TAU_LANES+1)(5);

-- ET data
    lhc_data_o.ett <= demux_data_i(OFFSET_ESUMS_LANES)(0);
-- HT data
    lhc_data_o.ht  <= demux_data_i(OFFSET_ESUMS_LANES)(1);
-- ETm data
    lhc_data_o.etm <= demux_data_i(OFFSET_ESUMS_LANES)(2);
-- HTm data
    lhc_data_o.htm <= demux_data_i(OFFSET_ESUMS_LANES)(3);

-- HB 2016-10-17: or memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
    lhc_data_o.etmhf <= demux_data_i(OFFSET_ESUMS_LANES)(4);
    lhc_data_o.htmhf <= demux_data_i(OFFSET_ESUMS_LANES)(5);

    lhc_data_o.link_11_fr_0_data <= demux_data_i(OFFSET_LINK_11_LANES)(0);
    lhc_data_o.link_11_fr_1_data <= demux_data_i(OFFSET_LINK_11_LANES)(1);
    lhc_data_o.link_11_fr_2_data <= demux_data_i(OFFSET_LINK_11_LANES)(2);
    lhc_data_o.link_11_fr_3_data <= demux_data_i(OFFSET_LINK_11_LANES)(3);
    lhc_data_o.link_11_fr_4_data <= demux_data_i(OFFSET_LINK_11_LANES)(4);
    lhc_data_o.link_11_fr_5_data <= demux_data_i(OFFSET_LINK_11_LANES)(5);

-- HEPHY 2015-05-01: added external-conditions.
    lhc_data_o.external_conditions(31 downto 0) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(0);
    lhc_data_o.external_conditions(63 downto 32) <= demux_data_i(OFFSET_EXT_COND_LANES+0)(1);
    lhc_data_o.external_conditions(95 downto 64) <= demux_data_i(OFFSET_EXT_COND_LANES+1)(0);
    lhc_data_o.external_conditions(127 downto 96) <= demux_data_i(OFFSET_EXT_COND_LANES+1)(1);
    lhc_data_o.external_conditions(159 downto 128) <= demux_data_i(OFFSET_EXT_COND_LANES+2)(0);
    lhc_data_o.external_conditions(191 downto 160) <= demux_data_i(OFFSET_EXT_COND_LANES+2)(1);
    lhc_data_o.external_conditions(223 downto 192) <= demux_data_i(OFFSET_EXT_COND_LANES+3)(0);
    lhc_data_o.external_conditions(255 downto 224) <= demux_data_i(OFFSET_EXT_COND_LANES+3)(1);

end architecture;

