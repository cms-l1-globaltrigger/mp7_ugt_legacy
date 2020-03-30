
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
        deta_dphi_prec: positive;
        cosh_cos_prec: positive;
        pt_prec: positive;
        deta_int_digits: positive;
        dphi_int_digits: positive;
        pt_int_digits: positive;
        cosh_deta_int_digits: positive;
        fract_digits: positive;
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit_r: real;
        mass_div_dr_lower_limit_r: real
    );
    port(
        diff_eta_int : in natural;
        diff_phi_int : in natural;
        pt1_int : in natural;
        pt2_int : in natural;
        cosh_deta_int : in natural;
        cos_dphi_int : in integer;
        mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    constant dr_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+1;
    constant mass_div_dr_int_digits : positive := mass_int_digits+fract_digits;
    constant dr_fract_digits : positive := fract_digits*2;
    constant mass_fract_digits : positive := fract_digits*2;
    constant mass_div_dr_fract_digits : positive := fract_digits+dr_int_digits+1;
    
    constant zero : ufixed(mass_div_dr_int_digits downto -dr_fract_digits) := (others => '0');
    
    signal mass_div_dr_upper_limit: ufixed(mass_div_dr_int_digits downto -fract_digits);
    signal mass_div_dr_lower_limit: ufixed(mass_div_dr_int_digits downto -fract_digits);

    signal dr_int : natural;
    signal dr : ufixed(dr_int_digits downto -fract_digits);
    signal cosh_cos_int : natural;
    signal cosh_cos : ufixed(cosh_deta_int_digits downto -fract_digits);
    signal pt1_pt2_int : natural;
    signal pt1_pt2 : ufixed(pt_int_digits*2 downto -fract_digits);
    signal mass_uf : ufixed(mass_int_digits downto -mass_fract_digits);
    signal mass : ufixed(mass_int_digits downto -fract_digits);
    signal mass_div_dr_uf : ufixed(mass_div_dr_int_digits downto -mass_div_dr_fract_digits);
    signal mass_div_dr : ufixed(mass_div_dr_int_digits downto -fract_digits) := (others => '0');

    attribute use_dsp : string;
    attribute use_dsp of dr : signal is "yes";
    attribute use_dsp of mass : signal is "yes";
    attribute use_dsp of mass_div_dr : signal is "yes";
    
begin

    mass_div_dr_upper_limit <= to_ufixed(mass_div_dr_upper_limit_r, mass_div_dr_upper_limit);
    mass_div_dr_lower_limit <= to_ufixed(mass_div_dr_lower_limit_r, mass_div_dr_lower_limit);

-- Calculation is done with M^2/2 divided by DR^2 !
   
    dr_int <= diff_eta_int*diff_eta_int+diff_phi_int*diff_phi_int;
    dr <= to_ufixed((real(dr_int)/real(10**(2*deta_dphi_prec))), dr);
    
    pt1_pt2_int <= pt1_int * pt2_int;
    pt1_pt2 <= to_ufixed((real(pt1_pt2_int)/real(10**(2*pt_prec))), pt1_pt2);
    
    cosh_cos_int <= cosh_deta_int - cos_dphi_int;
    cosh_cos <= to_ufixed((real(cosh_cos_int)/real(10**cosh_cos_prec)), cosh_cos);    
    
    mass_uf <= pt1_pt2 * cosh_cos;
    mass <= mass_uf(mass_int_digits downto -fract_digits);
        
    mass_div_dr_uf <= (mass / dr) when (dr /= (to_ufixed((0), dr))) else (to_ufixed((0), mass_div_dr_uf));
    mass_div_dr <= mass_div_dr_uf(mass_div_dr_int_digits downto -fract_digits);
    
    mass_div_dr_comp <= '1' when mass_div_dr >= mass_div_dr_lower_limit and mass_div_dr <= mass_div_dr_upper_limit else '0';

end architecture rtl;
