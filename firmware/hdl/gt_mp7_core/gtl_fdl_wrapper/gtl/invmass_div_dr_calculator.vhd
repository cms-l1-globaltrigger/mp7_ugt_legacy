
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity invmass_div_dr_calculator is
    generic (
        deta_int_digits: positive;
        dphi_int_digits: positive;
        pt_int_digits: positive;
        cosh_deta_int_digits: positive;
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit: ufixed;
        mass_div_dr_lower_limit: ufixed;
        fract_digits: positive := 20
    );
    port(
        diff_eta : in ufixed(deta_int_digits downto -fract_digits);
        diff_phi : in ufixed(dphi_int_digits downto -fract_digits);
        pt1 : in ufixed(pt_int_digits downto -fract_digits);
        pt2 : in ufixed(pt_int_digits downto -fract_digits);
        cosh_deta : in ufixed(cosh_deta_int_digits downto -fract_digits);
        cos_dphi : in ufixed(0 downto -fract_digits);
        cos_dphi_sign : in boolean;
        mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    constant dr_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3;
    constant mass_div_dr_int_digits : positive := mass_int_digits+fract_digits;
    constant dr_temp_fract_digits : positive := fract_digits*2;
    constant mass_temp_fract_digits : positive := fract_digits*3;
    constant mass_div_dr_temp_fract_digits : positive := fract_digits+dr_int_digits+1;
    
    constant zero : ufixed(mass_div_dr_int_digits downto -dr_temp_fract_digits) := (others => '0');

    signal dr_temp : ufixed(dr_int_digits downto -dr_temp_fract_digits);
    signal dr : ufixed(dr_int_digits downto -fract_digits);
    signal mass_temp : ufixed(mass_int_digits downto -mass_temp_fract_digits);
    signal mass : ufixed(mass_int_digits downto -fract_digits);
    signal mass_div_dr_temp : ufixed(mass_div_dr_int_digits downto -mass_div_dr_temp_fract_digits);
    signal mass_div_dr : ufixed(mass_div_dr_int_digits downto -fract_digits) := (others => '0');

    attribute use_dsp : string;
    attribute use_dsp of dr : signal is "yes";
    attribute use_dsp of mass : signal is "yes";
    attribute use_dsp of mass_div_dr : signal is "yes";
    
begin

-- Calculation is done with M^2/2 divided by DR^2 !
   
    dr_temp <= diff_eta*diff_eta+diff_phi*diff_phi;
    dr <= dr_temp(dr_int_digits downto -fract_digits);
    
    mass_temp <= (pt1 * pt2 * (cosh_deta - cos_dphi)) when (cos_dphi_sign = false) else (pt1 * pt2 * (cosh_deta + cos_dphi));
    mass <= mass_temp(mass_int_digits downto -fract_digits);
        
    mass_div_dr_temp <= (mass / dr) when (dr /= zero(dr_int_digits downto -fract_digits)) else zero(mass_div_dr_int_digits downto -mass_div_dr_temp_fract_digits);
    mass_div_dr <= mass_div_dr_temp(mass_div_dr_int_digits downto -fract_digits);
    
    mass_div_dr_comp <= '1' when mass_div_dr >= mass_div_dr_lower_limit and mass_div_dr <= mass_div_dr_upper_limit else '0';

end architecture rtl;
