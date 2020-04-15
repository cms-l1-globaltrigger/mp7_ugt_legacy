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

    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3;
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1;
    
    constant zero : ufixed(dr_sq_int_digits downto -fract_digits*2) := (others => '0');
    constant zero_deta : ufixed(deta_int_digits downto -fract_digits) := (others => '0');
    constant zero_dphi : ufixed(dphi_int_digits downto -fract_digits) := (others => '0');
    constant zero_invmass_sq_div2_div_dr_sq : ufixed(inv_mass_div_dr_int_digits downto -fract_digits) := (others => '0');
    signal dr_sq_temp : ufixed(dr_sq_int_digits downto -fract_digits*2);
    signal dr_sq : ufixed(dr_sq_int_digits downto -fract_digits);
    signal invariant_mass_sq_div2_temp : ufixed(inv_mass_int_digits downto -fract_digits*3);
    signal invariant_mass_sq_div2 : ufixed(inv_mass_int_digits downto -fract_digits);
    signal invmass_sq_div2_div_dr_sq_temp : ufixed(inv_mass_div_dr_int_digits downto -fract_digits-dr_sq_int_digits);
    signal invmass_sq_div2_div_dr_sq : ufixed(inv_mass_div_dr_int_digits downto -fract_digits) := (others => '0');

    attribute use_dsp : string;
    attribute use_dsp of dr_sq : signal is "yes";
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of invmass_sq_div2_div_dr_sq : signal is "yes";

begin
    
    dr_sq_temp <= diff_eta*diff_eta+diff_phi*diff_phi;
    dr_sq <= dr_sq_temp(dr_sq_int_digits downto -fract_digits);
    
    invariant_mass_sq_div2_temp <= (pt1 * pt2 * (cosh_deta - cos_dphi)) when (cos_dphi_sign = false) else (pt1 * pt2 * (cosh_deta + cos_dphi));
    invariant_mass_sq_div2 <= invariant_mass_sq_div2_temp(inv_mass_int_digits downto -fract_digits);
        
    div_zero_p: process(dr_sq)
    begin
--         if dr_sq /= zero then
        if diff_eta = zero_deta and diff_phi = zero_dphi then
            invmass_sq_div2_div_dr_sq <= zero_invmass_sq_div2_div_dr_sq;
        else
            invmass_sq_div2_div_dr_sq_temp <= invariant_mass_sq_div2 / dr_sq;
            invmass_sq_div2_div_dr_sq <= invmass_sq_div2_div_dr_sq_temp(inv_mass_div_dr_int_digits downto -fract_digits);
        end if;
    end process div_zero_p;
    
    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq >= mass_div_dr_lower_limit and invmass_sq_div2_div_dr_sq <= mass_div_dr_upper_limit else '0';
        
end architecture rtl;
