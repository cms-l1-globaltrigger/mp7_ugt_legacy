
-- Description:
-- Correlation cut comparator

-- Version history:
-- HB 2021-04-09: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity correlation_cut_comp is
     generic(
        threshold_type: boolean := false;
        upper_limit: std_logic_vector;
        lower_limit: std_logic_vector
   );
    port(
        data_in: in std_logic_vector;
        comp_o: out std_logic
    );
end correlation_cut_comp;

architecture rtl of correlation_cut_comp is

begin

    range_sel: if not threshold_type generate
        comp_o <= '1' when data_in >= lower_limit and data_in <= upper_limit else '0';
    end generate range_sel;
    threshold_sel: if threshold_type  generate
        comp_o <= '1' when data_in >= lower_limit else '0';
    end generate threshold_sel;

end architecture rtl;
