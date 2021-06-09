
-- Description:
-- Comparator with LUTs

-- Version history:
-- HB 2021-03-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity lut_comp is
	generic	(
        lut : std_logic_vector
    );
    port(
        data : in std_logic_vector;
        comp_o : out std_logic
    );
end lut_comp;

architecture rtl of lut_comp is

begin

    comp_o <= lut(CONV_INTEGER(data));

end architecture rtl;
