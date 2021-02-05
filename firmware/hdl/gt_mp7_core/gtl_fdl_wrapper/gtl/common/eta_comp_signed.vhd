
-- Desription:
-- Comparator for pseudorapidity (eta)
-- Eta scale is defined with Two's Complement notation values for HW index.
-- Therefore a comparison with "signed" is implemented, which needs ieee.std_logic_signed.all library.
-- This module is for use in calo_comparators.vhd and muon_comparators.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all; -- for eta comparison with "signed", because of Eta-scale with Two's Complement notation for HW index.

entity eta_comp_signed is
	generic	(
        eta_upper_limit: std_logic_vector;
        eta_lower_limit: std_logic_vector
    );
    port(
        eta: in std_logic_vector;
        eta_comp: out std_logic
    );
end eta_comp_signed;

architecture rtl of eta_comp_signed is
begin

    eta_comp <= '1' when eta >= eta_lower_limit and eta <= eta_upper_limit else '0';

end architecture rtl;
