
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
        mass_div_dr_comp : out std_logic;
	sim_dr_sq_int_digits : out positive;
	sim_inv_mass_int_digits : out positive;
	sim_inv_mass_div_dr_int_digits : out positive
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3;
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1;
    
    constant zero : ufixed(dr_sq_int_digits downto -fract_digits*2) := (others => '0');
    constant zero_deta : ufixed(deta_int_digits downto -fract_digits) := (others => '0');
    constant zero_dphi : ufixed(dphi_int_digits downto -fract_digits) := (others => '0');
--    constant zero_invmass_sq_div2_div_dr_sq : ufixed(inv_mass_div_dr_int_digits downto -fract_digits) := (others => '0');
    constant zero_invmass_sq_div2_div_dr_sq : ufixed(inv_mass_div_dr_int_digits downto -fract_digits-dr_sq_int_digits) := (others => '0');
--    constant two : ufixed(1 downto -0) := "10";

    signal dr_sq_temp : ufixed(dr_sq_int_digits downto -fract_digits*2);
    signal dr_sq : ufixed(dr_sq_int_digits downto -fract_digits);
    signal inv_mass_sq_div2_temp : ufixed(inv_mass_int_digits downto -fract_digits*3);
    signal inv_mass_sq_div2 : ufixed(inv_mass_int_digits downto -fract_digits);
    signal inv_mass_sq_div2_div_dr_sq_temp : ufixed(inv_mass_div_dr_int_digits downto -fract_digits-dr_sq_int_digits);
    signal inv_mass_sq_div2_div_dr_sq_temp_srl : ufixed(inv_mass_div_dr_int_digits downto -fract_digits-dr_sq_int_digits);
    signal inv_mass_sq_div2_div_dr_sq : ufixed(inv_mass_div_dr_int_digits downto -fract_digits) := (others => '0');

    attribute use_dsp : string;
    attribute use_dsp of dr_sq : signal is "yes";
    attribute use_dsp of inv_mass_sq_div2 : signal is "yes";
    attribute use_dsp of inv_mass_sq_div2_div_dr_sq : signal is "yes";

begin

-- Calculation is done with M^2/2 divided by DR^2 !
   
    dr_sq_temp <= diff_eta*diff_eta+diff_phi*diff_phi;
    dr_sq <= dr_sq_temp(dr_sq_int_digits downto -fract_digits);
    
    inv_mass_sq_div2_temp <= (pt1 * pt2 * (cosh_deta - cos_dphi)) when (cos_dphi_sign = false) else (pt1 * pt2 * (cosh_deta + cos_dphi));
    inv_mass_sq_div2 <= inv_mass_sq_div2_temp(inv_mass_int_digits downto -fract_digits);
        
    inv_mass_sq_div2_div_dr_sq_temp <= inv_mass_sq_div2 / dr_sq when dr_sq /= zero else zero_invmass_sq_div2_div_dr_sq;
-- Value of invmass_sq_div2_div_dr_sq_temp in simulation two times higher as expected, therefore "srl 1" !?
    inv_mass_sq_div2_div_dr_sq_temp_srl <= inv_mass_sq_div2_div_dr_sq_temp srl 1;
    inv_mass_sq_div2_div_dr_sq <= inv_mass_sq_div2_div_dr_sq_temp_srl(inv_mass_div_dr_int_digits downto -fract_digits);
    
    mass_div_dr_comp <= '1' when inv_mass_sq_div2_div_dr_sq >= mass_div_dr_lower_limit and inv_mass_sq_div2_div_dr_sq <= mass_div_dr_upper_limit else '0';

sim_dr_sq_int_digits <= dr_sq_int_digits;
sim_inv_mass_int_digits <= inv_mass_int_digits;
sim_inv_mass_div_dr_int_digits <= inv_mass_div_dr_int_digits;
        
end architecture rtl;
