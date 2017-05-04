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
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/rop_2_buffer/src/gt_mp7_core/frame/demux_lane/demux_lane_data.vhd $
-- $Date: 2015-02-11 11:05:53 +0100 (Wed, 11 Feb 2015) $
-- $Author: HEPHY $
-- $Revision:  $
--------------------------------------------------------------------------------

-- Description: demultiplexer of 240MHz data (from optical links) to 40MHz data
-- HEPHY 2015-06-04: 50bc suppressing for a) correct behaviour of FINOR, b) catching the correct data in SPYMEM3 for ROP analyze
-- HB 2015-02-05: cleaned up the code, removed port "del_a".
-- HEPHY 2014-19-12: cross clock domain has been changed and the adjusment over register has been disabled. This feature is tested on Dec.19 with new Caloslicetest 2015. The adjusment is done over butler script.
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;

use work.mp7_data_types.all;
use work.gt_mp7_core_pkg.all;

entity demux_lane_data is
    port(
        clk240 : in std_logic;
        lhc_clk : in std_logic;
        lane_data_in : in lword;
        demux_data_o : out lane_objects_array_t;
        demux_data_valid_o : out lane_objects_array_valid_t
    );
end demux_lane_data;

architecture rtl of demux_lane_data is

    signal temp_1, temp_2, temp_3, temp_4, temp_5 	: lword;
    signal lane_data_out_50bc_suppress			: lword;
begin

-- HEPHY 2015-06-04: 50bc suppressing
	lane_data_out_50bc_suppress.data   <= (others => '0') when lane_data_in.valid = '0' else lane_data_in.data;
	lane_data_out_50bc_suppress.valid  <= lane_data_in.valid;
	lane_data_out_50bc_suppress.strobe <= lane_data_in.strobe;
	lane_data_out_50bc_suppress.start  <= lane_data_in.start;

-- Pipeline for data (240MHz) coming from Greg logic (GTHs)
    pipeline_240mhz_p: process(clk240, lane_data_out_50bc_suppress)
        begin
        if (clk240'event and clk240 = '1') then
            temp_1 <= lane_data_out_50bc_suppress;
            temp_2 <= temp_1;
            temp_3 <= temp_2;
            temp_4 <= temp_3;
            temp_5 <= temp_4;
        end if;
    end process;

-- HEPHY changing to use lhc-clock
      data_40mhz_p: process(lhc_clk, lane_data_out_50bc_suppress, temp_1, temp_2, temp_3, temp_4, temp_5)
        begin
          if lhc_clk'event and lhc_clk = '1' then
            demux_data_o <= (lane_data_out_50bc_suppress.data, temp_1.data, temp_2.data, temp_3.data, temp_4.data, temp_5.data);
            demux_data_valid_o <= (lane_data_out_50bc_suppress.valid, temp_1.valid, temp_2.valid, temp_3.valid, temp_4.valid, temp_5.valid);
        end if;
    end process;

end architecture rtl;
