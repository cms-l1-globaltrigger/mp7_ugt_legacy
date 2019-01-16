
-- Desription:
-- Comparators for pseudorapidity of calo objects

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

entity eta_windows_comp is
    generic	(
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector
    );
    port(
        eta	    : in std_logic_vector;
        eta_comp_o  : out std_logic
    );
end eta_windows_comp;

architecture rtl of eta_windows_comp is
    signal eta_comp : std_logic;
    signal eta_comp_w1 : std_logic;
    signal eta_comp_w2 : std_logic;
begin

-- Comparator for pseudorapidity (eta)
-- Eta scale is defined with Two's Complement notation values for HW index.
-- Therefore a comparison with "signed" is implemented, which needs ieee.std_logic_signed.all library.
-- The comparators for et and phi work unsigned, so a module for Eta comparators is instantiated,
-- in which ieee.std_logic_signed.all library is used.

    eta_full_range_i: if eta_full_range = true generate
        eta_comp <= '1';
    end generate eta_full_range_i;

    not_eta_full_range_i: if eta_full_range = false generate
        eta_w1_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w1_upper_limit,
                eta_lower_limit => eta_w1_lower_limit
            )    
        port map( 
                eta => eta,
                eta_comp => eta_comp_w1
        );

        not_eta_w2_ignore_i: if eta_w2_ignore = false generate
            eta_w2_comp_i: entity work.eta_comp_signed
                generic map(
                    eta_upper_limit => eta_w2_upper_limit,
                    eta_lower_limit => eta_w2_lower_limit
                )    
                port map( 
                    eta => eta,
                    eta_comp => eta_comp_w2
                );
        end generate not_eta_w2_ignore_i;

        eta_w2_ignore_i: if eta_w2_ignore = true generate
            eta_comp_w2 <= '0';
        end generate eta_w2_ignore_i;

        eta_comp <= eta_comp_w1 or eta_comp_w2;

    end generate not_eta_full_range_i;

    eta_comp_o <= eta_comp;

end architecture rtl;
