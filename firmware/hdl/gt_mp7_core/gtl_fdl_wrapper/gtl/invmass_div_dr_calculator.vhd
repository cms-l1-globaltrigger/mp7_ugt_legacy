
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-10: using real
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity invmass_div_dr_calculator is
    generic (
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_div_dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0)
    );
    port(
        diff_eta : in integer;
        diff_phi : in integer;
        pt1 : in integer;
        pt2 : in integer;
        cosh_deta : in integer;
        cos_dphi : in integer;
        mass_div_dr_comp : out std_logic;
        sim_pt1_real : out real;
        sim_pt2_real : out real;
        sim_cosh_deta_real : out real;
        sim_cos_dphi_real : out real;
        sim_diff_eta_real : out real;
        sim_diff_phi_real : out real;
        sim_invariant_mass_sq_div2 : out integer;
        sim_dr_squared : out integer;
        sim_invmass_sq_div2_div_dr_sq : out integer;
        sim_mass_div_dr_lower_limit : out integer;
        sim_mass_div_dr_upper_limit : out integer
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

    signal mass_div_dr_upper_limit, mass_div_dr_lower_limit : integer;
    
-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    signal pt1_real, pt2_real, cosh_deta_real, cos_dphi_real : real;
    signal invariant_mass_sq_div2 : integer;
    
    signal diff_eta_real, diff_eta_squared : real;
    signal diff_phi_real, diff_phi_squared : real;
    signal dr_squared : integer;

    signal invmass_sq_div2_div_dr_sq : integer;

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of diff_eta_squared : signal is "yes";
    attribute use_dsp of diff_phi_squared : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";

begin

    mass_div_dr_upper_limit <= CONV_INTEGER(mass_div_dr_upper_limit_vector(31 downto 0));
    mass_div_dr_lower_limit <= CONV_INTEGER(mass_div_dr_lower_limit_vector(31 downto 0));
    
-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    pt1_real <= real(pt1)/10.0;
    pt2_real <= real(pt2)/10.0;
    cosh_deta_real <= real(cosh_deta)/1000.0;
    cos_dphi_real <= real(cos_dphi)/1000.0;
    
    invariant_mass_sq_div2 <= integer(pt1_real * pt2_real * (cosh_deta_real - cos_dphi_real));
    
-- HB 2015-11-26: calculation of ΔR**2 with formular ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2
    diff_eta_real <= real(diff_eta)/1000.0;
    diff_phi_real <= real(diff_phi)/1000.0;
    diff_eta_squared <= diff_eta_real*diff_eta_real;
    diff_phi_squared <= diff_phi_real*diff_phi_real;
    dr_squared <= integer(diff_eta_squared+diff_phi_squared);
    
    invmass_sq_div2_div_dr_sq <= invariant_mass_sq_div2 / (dr_squared+1);
    
    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq >= mass_div_dr_lower_limit and invmass_sq_div2_div_dr_sq <= mass_div_dr_upper_limit else '0';
    
    sim_pt1_real <= pt1_real;
    sim_pt2_real <= pt2_real;
    sim_cosh_deta_real <= cosh_deta_real;
    sim_cos_dphi_real <= cos_dphi_real;
    sim_diff_eta_real <= diff_eta_real;
    sim_diff_phi_real <= diff_phi_real;
    sim_invariant_mass_sq_div2 <= invariant_mass_sq_div2;
    sim_dr_squared <= dr_squared;
    sim_invmass_sq_div2_div_dr_sq <= invmass_sq_div2_div_dr_sq;
    sim_mass_div_dr_lower_limit <= mass_div_dr_lower_limit;
    sim_mass_div_dr_upper_limit <= mass_div_dr_upper_limit;
    
end architecture rtl;
