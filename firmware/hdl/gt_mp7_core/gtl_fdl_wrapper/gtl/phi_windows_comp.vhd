
-- Desription:
-- Comparators for azimuth angle of calo objects

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

entity phi_windows_comp is
    generic	(
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector
    );
    port(
        phi	    : in std_logic_vector;
        phi_comp_o  : out std_logic
    );
end phi_windows_comp;

architecture rtl of phi_windows_comp is
    signal phi_comp : std_logic;
    signal phi_comp_w1 : std_logic;
    signal phi_comp_w2 : std_logic;
begin

-- Comparator for azimuth angle (phi)
-- Two "windows"-comparartors used.
-- Changed logic: if upper_limit = lower_limit than phi must be equal upper_limit (= lower_limit).
    phi_full_range_i: if phi_full_range = true generate
        phi_comp <= '1';
    end generate phi_full_range_i;

    not_phi_full_range_i: if phi_full_range = false generate
        phi_comp_w1 <= '1' when phi_w1_upper_limit < phi_w1_lower_limit and (phi <= phi_w1_upper_limit or phi >= phi_w1_lower_limit) else
                       '1' when phi_w1_upper_limit >= phi_w1_lower_limit and (phi <= phi_w1_upper_limit and phi >= phi_w1_lower_limit) else
                       '0';

        not_phi_w2_ignore_i: if phi_w2_ignore = false generate
            phi_comp_w2 <= '1' when phi_w2_upper_limit < phi_w2_lower_limit and (phi <= phi_w2_upper_limit or phi >= phi_w2_lower_limit) else
                           '1' when phi_w2_upper_limit >= phi_w2_lower_limit and (phi <= phi_w2_upper_limit and phi >= phi_w2_lower_limit) else
                           '0';
        end generate not_phi_w2_ignore_i;

        phi_w2_ignore_i: if phi_w2_ignore = true generate
            phi_comp_w2 <= '0';
        end generate phi_w2_ignore_i;

        phi_comp <= phi_comp_w1 or phi_comp_w2;

    end generate not_phi_full_range_i;

    phi_comp_o <= phi_comp;

end architecture rtl;
