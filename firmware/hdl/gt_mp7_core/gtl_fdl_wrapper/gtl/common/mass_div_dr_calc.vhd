
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2021-03-16: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_div_dr_calc is
    generic (
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        inv_dr_sq_width: positive := 26
    );
    port(
        pt1 : in std_logic_vector;
        pt2 : in std_logic_vector;
        cosh_deta : in std_logic_vector;
        cos_dphi : in std_logic_vector;
        inv_dr_sq : in std_logic_vector;
        mass_div_dr : out std_logic_vector
    );
end mass_div_dr_calc;

architecture rtl of mass_div_dr_calc is

    constant mass_vector_width : positive := pt1_width+pt2_width+cosh_cos_width;
    constant mass_div_dr_vector_width : positive := mass_vector_width+inv_dr_sq_width;

    signal invariant_mass_sq_div2 : std_logic_vector(mass_vector_width-1 downto 0) := (others => '0');

    constant max_mass_div_dr : std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '1');

    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of mass_div_dr : signal is "yes";

begin

-- calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);

-- mass_div_dr <= (invariant_mass_sq_div2 * inv_dr_sq) when (inv_dr_sq > 0) else max_mass_div_dr;
    mass_div_dr_p: process(invariant_mass_sq_div2, inv_dr_sq)
        begin
        if inv_dr_sq > 0 then
            mass_div_dr(mass_div_dr_vector_width-1 downto 0) <= invariant_mass_sq_div2 * inv_dr_sq;
        else
            mass_div_dr <= max_mass_div_dr;
        end if;
    end process;

end architecture rtl;
