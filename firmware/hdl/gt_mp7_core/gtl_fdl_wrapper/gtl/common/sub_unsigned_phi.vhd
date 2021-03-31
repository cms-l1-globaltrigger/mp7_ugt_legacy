
-- Desription:
-- Calculation of differences in phi.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity sub_unsigned_phi is
    generic (
        PHI_BINS_DIV2: positive := 72
    );
	port(
        phi_1 : in std_logic_vector;
        phi_2 : in std_logic_vector;
        phi_diff_o : out natural;
        phi_diff_abs : out natural; -- for simulation
        phi_diff_o_sim : out natural -- for simulation
    );
end sub_unsigned_phi;

architecture rtl of sub_unsigned_phi is
    signal phi_1_value : integer;
    signal phi_2_value : integer;
begin

    phi_1_value <= (CONV_INTEGER(phi_1));

    phi_2_value <= (CONV_INTEGER(phi_2));

    phi_diff_p: process(phi_1_value, phi_2_value)
        variable phi_diff : integer;
    begin
-- only positive difference in phi
        phi_diff := abs(phi_1_value - phi_2_value);
        phi_diff_abs <= phi_diff;
-- if positive difference is greater than half range of phi, take full range of phi minus positive difference
        if phi_diff < PHI_BINS_DIV2 then
            phi_diff_o <= phi_diff;
        else
            phi_diff_o <= 2 * PHI_BINS_DIV2 - phi_diff;
        end if;
        
    end process phi_diff_p;

end architecture rtl;
