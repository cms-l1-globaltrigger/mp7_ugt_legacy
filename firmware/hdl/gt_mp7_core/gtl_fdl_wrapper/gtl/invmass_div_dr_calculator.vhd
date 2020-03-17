
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;

use work.gtl_pkg.all;

entity invmass_div_dr_calculator is
    generic (
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit: sfixed(36 downto -1);
        mass_div_dr_lower_limit: sfixed(36 downto -1)
    );
    port(
        diff_eta : in sfixed(5 downto -19);
        diff_phi : in sfixed(4 downto -19);
        pt1 : in sfixed(9 downto -17);
        pt2 : in sfixed(9 downto -17);
        cosh_deta : in sfixed(15 downto -19);
        cos_dphi : in sfixed(2 downto -19);
        mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    signal dr_sq : sfixed(10 downto -12);
--     signal dr_sq_off : sfixed(10 downto -12);
--     signal offset : sfixed(10 downto -12) := "000"&X"00001";
    signal invariant_mass_sq_div2 : sfixed(36 downto -12);
    signal invmass_sq_div2_div_dr_sq : sfixed(58 downto -12);

    attribute use_dsp : string;
    attribute use_dsp of dr_squared : signal is "yes";
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of invmass_sq_div2_div_dr_sq : signal is "yes";

begin

    
    dr_sq <= diff_eta*diff_eta+diff_phi*diff_phi;
    
    invariant_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
        
    invmass_sq_div2_div_dr_sq <= invariant_mass_sq_div2 / dr_sq;
        
    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq(36 downto -12) >= mass_div_dr_lower_limit and invmass_sq_div2_div_dr_sq(36 downto -12) <= mass_div_dr_upper_limit else '0';
        
end architecture rtl;
