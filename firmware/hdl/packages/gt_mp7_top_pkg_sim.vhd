
-- HB 2022-09-02: created for simulation (used instead of gt_mp7_core_pkg_sim.pkg).

library IEEE;
use ieee.std_logic_1164.all;

package gt_mp7_top_pkg is

constant TOP_TIMESTAMP : std_logic_vector(31 downto 0) := X"00000000";
constant TOP_USERNAME : std_logic_vector(32*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
constant TOP_HOSTNAME : std_logic_vector(32*8-1 downto 0) := X"0000000000000000000000000000000000000000000000000000000000000000";
constant TOP_BUILD_VERSION : std_logic_vector(31 downto 0) := X"00000000";

end;



