
-- Description:
-- Comparator for transverse momentum (pt)

-- Version history:
-- HB 2021-03-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity pt_comp is
	generic	(
        pt_ge_mode : boolean;
        pt_threshold: std_logic_vector
    );
    port(
        pt : in std_logic_vector;
        pt_comp_o : out std_logic
    );
end pt_comp;

architecture rtl of pt_comp is

begin

    pt_comp_o <= '1' when pt >= pt_threshold and pt_ge_mode else
                 '1' when pt = pt_threshold and not pt_ge_mode else '0';

end architecture rtl;
