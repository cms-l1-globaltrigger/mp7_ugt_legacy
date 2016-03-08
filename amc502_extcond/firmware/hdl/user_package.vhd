library ieee;
use ieee.std_logic_1164.all;

package user_package is
-- type definition for unconstraint range of IPbus register blocks
    type ipb_regs_array is array (natural range <>) of std_logic_vector(31 downto 0);

    constant RST_ACT : std_logic := '1';
end user_package;
