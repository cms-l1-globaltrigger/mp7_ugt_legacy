
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2021-04-20: changed name.
-- HB 2021-04-16: new input mass_inv_pt.
-- HB 2021-03-16: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_over_dr_calc is
    generic (
        mass_vector_width: positive := 52;
        inverted_dr_sq_width: positive := 26
    );
    port(
        mass_inv_pt : in std_logic_vector;
        inverted_dr_sq : in std_logic_vector;
        mass_over_dr : out std_logic_vector
    );
end mass_over_dr_calc;

architecture rtl of mass_over_dr_calc is

    constant mass_over_dr_vector_width : positive := mass_vector_width+inverted_dr_sq_width;
    constant max_mass_over_dr : std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '1');

    attribute use_dsp : string;
    attribute use_dsp of mass_over_dr : signal is "yes";

begin

-- mass_over_dr <= (mass_inv_pt * inverted_dr_sq) when (inverted_dr_sq > 0) else max_mass_over_dr;
    mass_over_dr_p: process(mass_inv_pt, inverted_dr_sq)
        begin
        if inverted_dr_sq > 0 then
            mass_over_dr(mass_over_dr_vector_width-1 downto 0) <= mass_inv_pt(mass_vector_width-1 downto 0) * inverted_dr_sq(inverted_dr_sq_width-1 downto 0);
        else
            mass_over_dr <= max_mass_over_dr;
        end if;
    end process;

end architecture rtl;
