
-- Description:
-- Comparison of invariant mass divided by deltaR with requirements.

-- Version history:
-- HB 2020-05-29: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_div_dr_comp is
    generic (
        mass_div_dr_vector_width: positive := 84;
-- limits for comparison of invariant mass divided by deltaR
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0)
    );
    port(
        mass_div_dr : in std_logic_vector(mass_div_dr_vector_width-1 downto 0);
        mass_comp : out std_logic
    );
end mass_div_dr_comp;

architecture rtl of mass_div_dr_comp is

-- HB 2020-04-23: calculation of invariant mass divided by deltaR (M**2/2 multiplicated with inverse deltaR squared values)
    signal upper_limit : std_logic_vector(mass_div_dr_vector_width-1 downto 0);
    signal lower_limit : std_logic_vector(mass_div_dr_vector_width-1 downto 0);

begin

    upper_limit <= mass_upper_limit_vector(mass_div_dr_vector_width-1 downto 0);
    lower_limit <= mass_lower_limit_vector(mass_div_dr_vector_width-1 downto 0);
    
    mass_comp <= '1' when mass_div_dr >= lower_limit and mass_div_dr <= upper_limit else '0';
    
end architecture rtl;
