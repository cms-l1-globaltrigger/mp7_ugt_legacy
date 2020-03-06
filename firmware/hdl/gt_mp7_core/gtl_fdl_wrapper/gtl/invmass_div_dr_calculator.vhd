
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity invmass_div_dr_calculator is
    generic (
-- limits for comparison of invariant mass, given for M**2/2 [=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)]
-- or transverse mass, given for M**2/2 [=pt1*pt2*(1-cos(phi1-phi2)]
        mass_div_dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_div_dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        mass_cosh_cos_precision : positive := 3
    );
    port(
        diff_eta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        diff_phi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        mass_div_dr_comp : out std_logic;
-- simulation outputs
        sim_invariant_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0); 
        sim_dr_squared : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0); 
        sim_mass_div_dr_comp : out std_logic
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;

    signal invariant_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    
    signal diff_eta_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal diff_phi_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal dr_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of diff_eta_squared : signal is "yes";
    attribute use_dsp of diff_phi_squared : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";

begin

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
    
-- HB 2015-11-26: calculation of ΔR**2 with formular ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2
    diff_eta_squared <= diff_eta*diff_eta;
    diff_phi_squared <= diff_phi*diff_phi;
    dr_squared <= diff_eta_squared+diff_phi_squared;
    
    invmass_sq_div2_div_dr_sq <=  invariant_mass_sq_div2 / dr_squared;
    
    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq >= mass_div_dr_upper_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) and invmass_sq_div2_div_dr_sq <= mass_div_dr_lower_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) else '0';

    sim_invariant_mass_sq_div2 <= invariant_mass_sq_div2;
    sim_dr_squared <= dr_squared;
    sim_dr_squared <= dr_squared;
    
end architecture rtl;
