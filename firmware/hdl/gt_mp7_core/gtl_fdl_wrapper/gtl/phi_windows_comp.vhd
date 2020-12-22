
-- Desription:
-- Comparators for azimuth angle of calo objects

-- Version history:
-- HB 2020-12-21: bug fixed.
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now.
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

entity phi_windows_comp is
    generic	(
        nr_phi_windows : natural;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector
    );
    port(
        phi	    : in std_logic_vector;
        phi_comp_o  : out std_logic
    );
end phi_windows_comp;

architecture rtl of phi_windows_comp is
    signal phi_comp_w1 : std_logic := '0';
    signal phi_comp_w2 : std_logic := '0';
begin

    assert (nr_phi_windows >= 0 and nr_phi_windows <= 2) report 
        "wrong number of phi windows (has to be between 0 and 2) - nr_phi_windows=" & integer'image(nr_phi_windows)
    severity failure;

-- Comparator for azimuth angle (phi)
-- Two "windows"-comparators used.
-- Changed logic: if upper_limit = lower_limit than phi must be equal upper_limit (= lower_limit).

    no_phi_window_i: if nr_phi_windows = 0 generate
        phi_comp_o <= '1';
    end generate no_phi_window_i;

    phi_w1_sel_i: if nr_phi_windows >= 1 generate
        phi_comp_w1 <= '1' when phi_w1_upper_limit < phi_w1_lower_limit and (phi <= phi_w1_upper_limit or phi >= phi_w1_lower_limit) else
                       '1' when phi_w1_upper_limit >= phi_w1_lower_limit and (phi <= phi_w1_upper_limit and phi >= phi_w1_lower_limit) else
                       '0';
        phi_comp_o <= phi_comp_w1 or phi_comp_w2;
    end generate phi_w1_sel_i;

    phi_w2_sel_i: if nr_phi_windows = 2 generate
        phi_comp_w2 <= '1' when phi_w2_upper_limit < phi_w2_lower_limit and (phi <= phi_w2_upper_limit or phi >= phi_w2_lower_limit) else
                       '1' when phi_w2_upper_limit >= phi_w2_lower_limit and (phi <= phi_w2_upper_limit and phi >= phi_w2_lower_limit) else
                       '0';
    end generate phi_w2_sel_i;

end architecture rtl;
