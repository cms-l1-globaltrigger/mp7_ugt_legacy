
-- Description:
-- Comparator for unconstrained pt

-- Version history:
-- HB 2021-03-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity upt_comp is
    generic	(
        upt_upper_limit : std_logic_vector;
        upt_lower_limit : std_logic_vector
    );
    port(
        upt : in std_logic_vector;
        upt_comp_o : out std_logic
    );
end upt_comp;

architecture rtl of upt_comp is

begin

-- Comparator for Pt unconstraint
    upt_cut_p: process(upt)
    begin
        if (upt >= upt_lower_limit and upt <= upt_upper_limit) then
            upt_comp_o <= '1';
        else
            upt_comp_o <= '0';
        end if;
    end process;

end architecture rtl;
