
-- HB 2015-01-09: v1.4.1.1: removed mp7_formatter (similar to UGMT from Dinyar), connected gt_mp7_core directly to mp7_datapath_2
-- HEPHY:21-11-2014 TOP_SERIAL_VENDOR is not mor relevant, because in future we will read from hardware over ipmi just MAC address
-- HB 2014-09-08: v1.4.0.0: package for mp7 fw version v1.4.0
-- HB 2014-09-08: v1.0.4.15: bug fixed in UCF (to use 4 quads), user constraint for quad(3) was set
-- HB 2014-09-02: v1.0.4.14: changed to 4 quads (for external-conditions) and added signals to mezz-board (bcres_d_FDL_int - for checking on scope) in gt_mp7_top.vhd

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mp7_brd_decl.all;

package gt_mp7_top_pkg is

-- Dummy values for simulation.
constant TOP_TIMESTAMP : std_logic_vector(31 downto 0) := X"00000000";
constant TOP_USERNAME : std_logic_vector(32*8-1 downto 0)  := X"0000000000000000000000000000000000000000000000000000000000000000";
constant TOP_HOSTNAME : std_logic_vector(32*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
constant TOP_BUILD_VERSION : std_logic_vector(31 downto 0) := X"00000000";

end;



