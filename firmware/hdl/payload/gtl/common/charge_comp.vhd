
-- Description:
-- Comparator formuon charge

-- Version history:
-- HB 2021-03-08: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity charge_comp is
	generic	(
        requested_charge : string(1 to 3)
    );
    port(
        charge : in std_logic_vector;
        comp_o : out std_logic
    );
end charge_comp;

architecture rtl of charge_comp is

begin

-- charge_high = charge valid, charge_low = charge sign (positive or negative),
    comp_o <= '1' when charge = "10" and requested_charge = "pos" else -- charge sign = '0' => positive
              '1' when charge = "11" and requested_charge = "neg" else -- charge sign = '1' => negative
              '1' when requested_charge = "ign" else '0';

end architecture rtl;
