library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;

use work.mp7_data_types.all;
use work.gt_mp7_core_pkg.all;

entity demux_lane_validation is
    port(
	-- just 1 in, 1 out:
        lane_data_in  : in  lword; -- 32 data bits & data_valid (see mp7 top.vhd)
        lane_data_out : out lword  -- 32 data bits & data_valid (see mp7 top.vhd)
    );
end demux_lane_validation;

architecture rtl of demux_lane_validation is
begin
	lane_data_out.data   <= (others => '0') when lane_data_in.valid = '0' else
	                          lane_data_in.data;

	lane_data_out.valid  <= lane_data_in.valid;
	lane_data_out.strobe <= lane_data_in.strobe;
	lane_data_out.start  <= lane_data_in.start;
end architecture rtl;

