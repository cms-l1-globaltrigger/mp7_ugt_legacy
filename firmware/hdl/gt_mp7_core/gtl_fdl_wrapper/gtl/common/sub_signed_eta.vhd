
-- Desription:
-- Calculation of differences in eta.
-- Eta values have Two"s Complement notation, therefore differences calculated "signed".
-- Only positive values of the substraction are taken for the difference.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
use ieee.std_logic_signed.all;

use work.gtl_pkg.all;

entity sub_signed_eta is
    port(
        eta_1 : in std_logic_vector;
        eta_2 : in std_logic_vector;
        eta_diff_o : out natural;
        eta_1_value_o_sim : out integer;
        eta_2_value_o_sim : out integer;
        eta_diff_o_sim : out integer
    );
end sub_signed_eta;

architecture rtl of sub_signed_eta is
    signal eta_1_value : integer;
    signal eta_2_value : integer;
begin

    eta_1_value <= (CONV_INTEGER(signed(eta_1)));
    eta_1_value_o_sim <= eta_1_value;
    eta_2_value <= (CONV_INTEGER(signed(eta_2)));
    eta_2_value_o_sim <= eta_2_value;

-- only positive difference in eta
    eta_diff_o <= abs(eta_1_value - eta_2_value);
    eta_diff_o_sim <= abs(eta_1_value - eta_2_value);

end rtl;
