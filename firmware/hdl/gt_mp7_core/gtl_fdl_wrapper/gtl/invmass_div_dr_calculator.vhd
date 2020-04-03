
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity invmass_div_dr_calculator is
    generic (
        pt_prec: positive;
        deta_dphi_prec: positive;
        cosh_cos_prec: positive;
        pt_int_digits: positive;
        deta_int_digits: positive;
        dphi_int_digits: positive;
        cosh_deta_int_digits: positive;
        fract_digits: positive;
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit: real;
        mass_div_dr_lower_limit: real;
        pt_max_value : positive;
        cosh_deta_max_value : positive;
        cos_dphi_int_digits : positive := 1
    );
    port(
        pt1_int : in natural;
        pt2_int : in natural;
        diff_eta_int : in natural;
        diff_phi_int : in natural;
        cosh_deta_int : in natural;
        cos_dphi_int : in integer range -(10**cosh_cos_prec) to +(10**cosh_cos_prec);
        mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    constant deta_max_lut : real := ETA_RANGE_REAL*real(10**deta_dphi_prec);
    constant dphi_max_lut : real := PHI_MAX*real(10**deta_dphi_prec);

    constant pt_t_int_digits : positive := log2c(pt_max_value);
    constant pt1_pt2_int_digits : positive := pt_t_int_digits*2+1;
    constant diff_eta_t_int_digits : positive := log2c(integer(deta_max_lut));
    constant diff_phi_t_int_digits : positive := log2c(integer(dphi_max_lut));
    constant dr_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant cosh_cos_t_int_digits : positive := log2c(cosh_deta_max_value);
    constant cosh_cos_int_digits : positive := cosh_deta_int_digits+cos_dphi_int_digits;
    constant mass_int_digits : positive := pt1_pt2_int_digits+cosh_cos_int_digits+1;
    constant mass_div_dr_int_digits : positive := mass_int_digits+fract_digits;

    constant pt_div_fract_digits : positive := fract_digits+5; -- ????
    constant pt1_pt2_t_fract_digits : positive := fract_digits*2;
    constant deta_div_fract_digits : positive := fract_digits+3+8; -- ???? 
    constant dphi_div_fract_digits : positive := fract_digits+3+8; -- ???? 
    constant dr_calc_fract_digits : positive := fract_digits*2;
    constant cosh_cos_fract_digits : positive := fract_digits+15; -- ????
    constant mass_fract_digits : positive := fract_digits*2;
    constant mass_div_dr_fract_digits : positive := fract_digits+dr_int_digits+1;
    
    signal upper_limit: ufixed(mass_div_dr_int_digits downto -fract_digits);
    signal lower_limit: ufixed(mass_div_dr_int_digits downto -fract_digits);

    signal pt1_t : ufixed(pt_t_int_digits downto -fract_digits);
    signal pt2_t : ufixed(pt_t_int_digits downto -fract_digits);
    signal pt1_div : ufixed(pt_t_int_digits downto -pt_div_fract_digits);
    signal pt2_div : ufixed(pt_t_int_digits downto -pt_div_fract_digits);
    signal pt1 : ufixed(pt_t_int_digits downto -fract_digits);
    signal pt2 : ufixed(pt_t_int_digits downto -fract_digits);
    signal pt1_pt2_t : ufixed(pt1_pt2_int_digits downto -fract_digits*2);
    signal pt1_pt2 : ufixed(pt1_pt2_int_digits downto -fract_digits);

    signal diff_eta_t : ufixed(diff_eta_t_int_digits downto -fract_digits);
    signal diff_eta_div : ufixed(diff_eta_t_int_digits downto -deta_div_fract_digits);
    signal diff_eta : ufixed(deta_int_digits downto -fract_digits);
    signal diff_phi_t : ufixed(diff_phi_t_int_digits downto -fract_digits);
    signal diff_phi_div : ufixed(diff_phi_t_int_digits downto -dphi_div_fract_digits);
    signal diff_phi : ufixed(dphi_int_digits downto -fract_digits);

    signal dr_calc : ufixed(dr_int_digits downto -dr_calc_fract_digits);
    signal dr : ufixed(dr_int_digits downto -fract_digits);

    signal cosh_deta_t : ufixed(cosh_deta_int_digits downto -fract_digits);
    signal cosh_deta_div : ufixed(cosh_deta_int_digits downto -cosh_cos_fract_digits);
    signal cosh_deta : ufixed(cosh_deta_int_digits downto -fract_digits);
    
    signal cos_dphi_int_pos : integer range 0 to +(10**cosh_cos_prec);
    signal cos_dphi_t : ufixed(cos_dphi_int_digits downto -fract_digits);
    signal cos_dphi_div : ufixed(cos_dphi_int_digits downto -cosh_cos_fract_digits);
    signal cos_dphi : ufixed(cos_dphi_int_digits downto -fract_digits);
    
    signal cosh_cos_int : natural;
    signal cosh_cos_t : ufixed(cosh_cos_t_int_digits downto -fract_digits);
    signal cosh_cos_div : ufixed(cosh_cos_t_int_digits downto -cosh_cos_fract_digits);
    signal cosh_cos : ufixed(cosh_cos_int_digits downto -fract_digits);

    signal mass_uf : ufixed(mass_int_digits downto -mass_fract_digits);
    signal mass : ufixed(mass_int_digits downto -fract_digits);
    signal mass_div_dr_uf : ufixed(mass_div_dr_int_digits downto -mass_div_dr_fract_digits);
    signal mass_div_dr : ufixed(mass_div_dr_int_digits downto -fract_digits) := (others => '0');
    
    signal div_diff : ufixed(log2c(10**deta_dphi_prec) downto -0);
    signal div_pt : ufixed(log2c(10**pt_prec) downto -0);
    signal div_cosh_cos : ufixed(log2c(10**cosh_cos_prec) downto -0);

    attribute use_dsp : string;
    attribute use_dsp of dr : signal is "yes";
    attribute use_dsp of mass : signal is "yes";
    attribute use_dsp of mass_div_dr : signal is "yes";
    
begin

    upper_limit <= to_ufixed(mass_div_dr_upper_limit, upper_limit);
    lower_limit <= to_ufixed(mass_div_dr_lower_limit, lower_limit);

-- Calculation is done with M^2/2 divided by DR^2 !
   
    div_pt <= to_ufixed(10**pt_prec, div_pt);

    pt1_t <= to_ufixed(pt1_int, pt1_t);
    pt2_t <= to_ufixed(pt2_int, pt2_t);
    pt1_div <= pt1_t / div_pt;
    pt2_div <= pt2_t / div_pt;
    pt1 <= pt1_div(pt_t_int_digits downto -fract_digits);
    pt2 <= pt2_div(pt_t_int_digits downto -fract_digits);
    
    pt1_pt2_t <= pt1 * pt2;
    pt1_pt2 <= pt1_pt2_t(pt1_pt2_int_digits downto -fract_digits);

    div_diff <= to_ufixed(10**deta_dphi_prec, div_diff);

    diff_eta_t <= to_ufixed(diff_eta_int, diff_eta_t);
    diff_eta_div <= diff_eta_t / div_diff;
    diff_eta <= diff_eta_div(deta_int_digits downto -fract_digits);
    
    diff_phi_t <= to_ufixed(diff_phi_int, diff_phi_t);
    diff_phi_div <= diff_phi_t / div_diff;
    diff_phi <= diff_phi_div(dphi_int_digits downto -fract_digits);
    
    dr_calc <= diff_eta*diff_eta+diff_phi*diff_phi;
    dr <= dr_calc(dr_int_digits downto -fract_digits);
    
    div_cosh_cos <= to_ufixed(10**cosh_cos_prec, div_cosh_cos);

    cosh_cos_int <= cosh_deta_int - cos_dphi_int when cosh_deta_int >= cos_dphi_int else 0; -- dummy check
    cosh_cos_t <= to_ufixed(cosh_cos_int, cosh_cos_t);
    cosh_cos_div <= cosh_cos_t / div_cosh_cos;
    cosh_cos <= cosh_cos_div(cosh_cos_int_digits downto -fract_digits);
    
    mass_uf <= pt1_pt2 * cosh_cos;
    mass <= mass_uf(mass_int_digits downto -fract_digits);
        
    mass_div_dr_uf <= (mass / dr) when (dr /= (to_ufixed((0), dr))) else (to_ufixed((0), mass_div_dr_uf));
    mass_div_dr <= mass_div_dr_uf(mass_div_dr_int_digits downto -fract_digits);
    
    mass_div_dr_comp <= '1' when mass_div_dr >= lower_limit and mass_div_dr <= upper_limit else '0';

end architecture rtl;
