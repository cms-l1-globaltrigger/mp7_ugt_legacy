
-- Description:
-- Comparison for ML scores.

-- Version history:
-- HB 2024-04-19: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.gtl_pkg.all;

entity ml_comparison is
    generic	(
        threshold: integer := 4150;
        score_width: integer := 18
    );
    port(
        ml_score: in std_logic_vector(score_width-1 downto 0);
        ml_out: out std_logic
    );
end ml_comparison;

architecture rtl of ml_comparison is    
begin

    ml_out <= '1' when to_integer(unsigned(ml_score)) >= threshold else '0';

end architecture rtl;
