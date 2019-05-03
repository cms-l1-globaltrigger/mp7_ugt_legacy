
-- Description:
-- Calculation of invariant mass or transverse mass based on LUTs.

-- Version history:
-- HB 2017-09-29: changed to "MAX_WIDTH_MASS_LIMIT_VECTOR" in limit vectors
-- HB 2017-09-21: changed attribute "use_dsp48" to "use_dsp"
-- HB 2017-09-20: based on "mass_calculator.vhd" but added mass_upper_limit_vector and mass_lower_limit_vector to generic.
-- HB 2017-04-19: based on "mass_cuts", but removed "twobody_pt" (detached from "mass fixation").
--                  Used boolean for mass cuts.
-- HB 2017-03-29: only one "sin_cos_width", using common scale for different object types
-- HB 2017-03-23: inserted instantiation of "twobody_pt_calculator"
-- HB 2017-02-06: inserted "attribute use_dsp48" for calculation of mass
-- HB 2017-01-18: added sin_cos_width_2 for different phi ranges (e.g.: calo and muon)
-- HB 2017-01-10: only one threshold for pt**2 (MJ 2017-01-09), trigger on mass, only if pt**2 greater/equal threshold
-- HB 2016-12-13: used "mass_type" for selection of comparision for mass types
-- HB 2016-12-12: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_calculator is
    generic (
        mass_type : natural;
-- limits for comparison of invariant mass, given for M**2/2 [=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)]
-- or transverse mass, given for M**2/2 [=pt1*pt2*(1-cos(phi1-phi2)]
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        mass_cosh_cos_precision : positive := 3
    );
    port(
        pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        mass_comp : out std_logic;
-- HB 2016-11-08: simulation outputs
        sim_invariant_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0); 
        sim_inv_mass_comp : out std_logic;
        sim_transverse_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0); 
        sim_transverse_mass_comp : out std_logic
    );
end mass_calculator;

architecture rtl of mass_calculator is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;

    signal invariant_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal transverse_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    
    signal inv_mass_comp, transverse_mass_comp : std_logic := '0';
    
-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of transverse_mass_sq_div2 : signal is "yes";

begin

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
    sim_invariant_mass_sq_div2 <= invariant_mass_sq_div2;
    
    inv_mass_comp <= '1' when invariant_mass_sq_div2 >= mass_lower_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) and invariant_mass_sq_div2 <= mass_upper_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) else '0';
    sim_inv_mass_comp <= inv_mass_comp;
    
-- HB 2016-12-12: calculation of transverse mass with formular M**2/2=pt1*pt2*(1-cos(phi1-phi2))
--                "conv_std_logic_vector((10**mass_cosh_cos_precision), cosh_cos_width)" means 1 multiplied with 10**mass_cosh_cos_precision, converted to std_logic_vector with cosh_cos_width
    transverse_mass_sq_div2 <= pt1 * pt2 * ((conv_std_logic_vector((10**mass_cosh_cos_precision), cosh_cos_width)) - cos_dphi);
    sim_transverse_mass_sq_div2 <= transverse_mass_sq_div2;
    
    transverse_mass_comp <= '1' when transverse_mass_sq_div2 >= mass_lower_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) and transverse_mass_sq_div2 <= mass_upper_limit_vector(MASS_VECTOR_WIDTH-1 downto 0) else '0';
    sim_transverse_mass_comp <= transverse_mass_comp;
    
-- HB 2016-12-13: selection of comparision for mass types
    invariant_mass_sel: if mass_type = INVARIANT_MASS_TYPE generate
        mass_comp <= '1' when inv_mass_comp = '1' else '0';
    end generate invariant_mass_sel;
    transverse_mass_sel: if mass_type = TRANSVERSE_MASS_TYPE generate
        mass_comp <= '1' when transverse_mass_comp = '1' else '0';
    end generate transverse_mass_sel;
    
end architecture rtl;
