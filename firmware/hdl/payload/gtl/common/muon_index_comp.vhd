
-- Description:
-- Muon index comparator

-- Version history:
-- HB 2023-04-15: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity muon_index_comp is
	generic	(
        idx_upper_limit: std_logic_vector;
        idx_lower_limit: std_logic_vector
    );
    port(
        idx: in std_logic_vector;
        idx_comp: out std_logic
    );
end muon_index_comp;

architecture rtl of muon_index_comp is
begin

    idx_comp <= '1' when idx >= idx_lower_limit and idx <= idx_upper_limit else '0';

end architecture rtl;
