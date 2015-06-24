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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/frame/demux_lane/demux_lane_data.vhd $
-- $Date: 2015-06-15 14:25:23 +0200 (Mon, 15 Jun 2015) $
-- $Author: vamosi $
-- $Revision: 4035 $
--------------------------------------------------------------------------------

-- Description: demultiplexer of 240MHz data (from optical links) to 40MHz data
-- HB 2015-02-05: cleaned up the code, removed port "del_a".
-- BR 2014-19-12: cross clock domain has been changed and the adjusment over register has been disabled. This feature is tested on Dec.19 with new Caloslicetest 2015. The adjusment is done over butler script.
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
-- HB 2015-02-05: cleaned up the code, removed port "del_a".
--         del_a : in std_logic_vector(2 downto 0);
        lane_data_in : in lword; -- 32 data bits & data_valid (see mp7 top.vhd)
        demux_data_o : out lane_objects_array_t;
        demux_data_valid_o : out lane_objects_array_valid_t
    );
end demux_lane_data;

architecture rtl of demux_lane_data is

    signal temp_1, temp_2, temp_3, temp_4, temp_5 : lword;
    signal lane_data_validated : lword;

begin

    input_validation: entity work.demux_lane_validation
        port map(lane_data_in  => lane_data_in,
                 lane_data_out => lane_data_validated);

-- Pipeline for data (240MHz) coming from Greg logic (GTHs)
    pipeline_240mhz_p: process(clk240, lane_data_validated)
        begin
        if (clk240'event and clk240 = '1') then
            temp_1 <= lane_data_validated;
            temp_2 <= temp_1;
            temp_3 <= temp_2;
            temp_4 <= temp_3;
            temp_5 <= temp_4;
        end if;
    end process;
    
--BR changing to use lhc-clock
      data_40mhz_p: process(lhc_clk, lane_data_validated, temp_1, temp_2, temp_3, temp_4, temp_5)
        begin
          if lhc_clk'event and lhc_clk = '1' then        
            demux_data_o <= (lane_data_validated.data, temp_1.data, temp_2.data, temp_3.data, temp_4.data, temp_5.data);
            demux_data_valid_o <= (lane_data_validated.valid, temp_1.valid, temp_2.valid, temp_3.valid, temp_4.valid, temp_5.valid);
        end if;
    end process;

end architecture rtl;
