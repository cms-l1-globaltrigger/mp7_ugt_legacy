
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
        mass_div_dr_upper_limit: sfixed;
        mass_div_dr_lower_limit: sfixed;
        fract_digits: positive := 20
    );
    port(
        diff_eta : in sfixed(deta_int_digits downto -fract_digits);
        diff_phi : in sfixed(dphi_int_digits downto -fract_digits);
        pt1 : in sfixed(pt_int_digits downto -fract_digits);
        pt2 : in sfixed(pt_int_digits downto -fract_digits);
        cosh_deta : in sfixed(cosh_deta_int_digits downto -fract_digits);
        cos_dphi : in sfixed(1 downto -fract_digits);
        mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3;
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1;
    
    constant zero : sfixed(dr_sq_int_digits downto -fract_digits*2) := (others => '0');
    signal dr_sq_temp : sfixed(dr_sq_int_digits downto -fract_digits*2);
    signal dr_sq : sfixed(dr_sq_int_digits downto -fract_digits);
    signal invariant_mass_sq_div2_temp : sfixed(inv_mass_int_digits downto -fract_digits*3);
    signal invariant_mass_sq_div2 : sfixed(inv_mass_int_digits downto -fract_digits);
    signal invmass_sq_div2_div_dr_sq_temp : sfixed(inv_mass_div_dr_int_digits downto -fract_digits-dr_sq_int_digits);
    signal invmass_sq_div2_div_dr_sq : sfixed(inv_mass_div_dr_int_digits downto -fract_digits) := (others => '0');

    attribute use_dsp : string;
    attribute use_dsp of dr_sq : signal is "yes";
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of invmass_sq_div2_div_dr_sq : signal is "yes";

begin

    
    dr_sq_temp <= diff_eta*diff_eta+diff_phi*diff_phi;
    dr_sq <= dr_sq_temp(dr_sq_int_digits downto -fract_digits);
    
    invariant_mass_sq_div2_temp <= pt1 * pt2 * (cosh_deta - cos_dphi);
    invariant_mass_sq_div2 <= invariant_mass_sq_div2_temp(inv_mass_int_digits downto -fract_digits);
        
    div_zero_p: process(dr_sq)
    begin
        if dr_sq /= zero then
            invmass_sq_div2_div_dr_sq_temp <= invariant_mass_sq_div2 / dr_sq;
            invmass_sq_div2_div_dr_sq <= invmass_sq_div2_div_dr_sq_temp(inv_mass_div_dr_int_digits downto -fract_digits);
        else
            invmass_sq_div2_div_dr_sq(inv_mass_int_digits downto -fract_digits) <= invariant_mass_sq_div2;
        end if;
    end process div_zero_p;

    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq >= mass_div_dr_lower_limit and invmass_sq_div2_div_dr_sq <= mass_div_dr_upper_limit else '0';
        
end architecture rtl;
