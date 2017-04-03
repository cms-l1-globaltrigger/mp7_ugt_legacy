
-- Desription:
-- Calculation of invariant mass or transverse mass based on LUTs and calculation of "twobody_pt" (pt**2) based on LUTs.
-- Limits for mass and threshold for pt**2 comparison provided.
-- Trigger on mass, only if pt**2 grater/equal threshold (if twobody_pt cut is selected).

-- Definition of mass_type:
-- 0 => invariant mass
-- 1 => invariant mass with twobody_pt cut
-- 2 => transverse mass
-- 3 => transverse mass with twobody_pt cut

-- Version history:
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

entity mass_cuts is
    generic (
	mass_type : natural := 0;
-- limits for comparison of invariant mass, given for M**2/2 [=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)]
-- or transverse mass, given for M**2/2 [=pt1*pt2*(1-cos(phi1-phi2)]
	mass_upper_limit: real := 15.0;
	mass_lower_limit: real := 10.0;
	pt1_width: positive := 12;
	pt2_width: positive := 12;
	cosh_cos_width: positive := 28;
	MASS_PRECISION : positive := 1; -- 1 => first digit after decimal point
	MASS_COSH_COS_PRECISION : positive := 3;
-- HB 2016-11-08: calculation of twobody_pt
	pt_sq_threshold: real := 15.0;
	sin_cos_width: positive := 11;
	PT_PRECISION : positive := 1;
	PT_SQ_SIN_COS_PRECISION : positive := 3
    );
    port(
	pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
	cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_phi_1_integer : in integer;
        cos_phi_2_integer : in integer;
        sin_phi_1_integer : in integer;
        sin_phi_2_integer : in integer;
        mass_comp : out std_logic;
-- HB 2016-11-08: simulation outputs
        sim_pt_square_comp : out std_logic;
	sim_invariant_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0); 
        sim_inv_mass_comp : out std_logic;
	sim_transverse_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0); 
        sim_transverse_mass_comp : out std_logic
    );
end mass_cuts;

architecture rtl of mass_cuts is

    signal pt_square_comp : std_logic := '0';

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;
-- HB 2015-10-21: multiplication factor for limits (number of relevant position after decimal point - MASS_PRECISION => 1, globaly set in gtl.pkg).
    constant MASS_PRECISION_FACTOR : real := real(10**MASS_PRECISION);
-- HB 2015-10-21: multiplication factor for limits vectors. INV_MASS_COSH_COS_PRECISION: number of relevant position after decimal point for cosh_deta and cos_dphi, globaly set in gtl.pkg.
    constant FACTOR_MASS_VECTOR : std_logic_vector((MASS_COSH_COS_PRECISION+1)*4-1 downto 0) := conv_std_logic_vector(10**(MASS_COSH_COS_PRECISION+1),(MASS_COSH_COS_PRECISION+1)*4);

    signal invariant_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal transverse_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal mass_upper_limit_vector : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0);
    signal mass_lower_limit_vector : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0);
    
    signal inv_mass_comp, transverse_mass_comp : std_logic := '0';
    
-- HB 2017-02-06: inserted "attribute use_dsp48" for calculation of mass
    attribute use_dsp48 : string;
    attribute use_dsp48 of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp48 of transverse_mass_sq_div2 : signal is "yes";

begin

-- HB 2017-03-23: calculation of twobody_pt
    twobody_pt_calculator_i: entity work.twobody_pt_calculator
	generic map(pt1_width, pt2_width, pt_sq_threshold, sin_cos_width, PT_PRECISION, PT_SQ_SIN_COS_PRECISION)
	port map(pt1, pt2, cos_phi_1_integer, cos_phi_2_integer, sin_phi_1_integer, sin_phi_2_integer, pt_square_comp);

    sim_pt_square_comp <= pt_square_comp;
    
-- HB 2015-10-01: converting mass limits to std_logic_vector for comparison. Integer (32-bits in VHDL) would be exeeded, therefore std_logic_vector.
    mass_upper_limit_vector <= conv_std_logic_vector((integer(mass_upper_limit*MASS_PRECISION_FACTOR)),MASS_VECTOR_WIDTH-FACTOR_MASS_VECTOR'length)*FACTOR_MASS_VECTOR;
    mass_lower_limit_vector <= conv_std_logic_vector((integer(mass_lower_limit*MASS_PRECISION_FACTOR)),MASS_VECTOR_WIDTH-FACTOR_MASS_VECTOR'length)*FACTOR_MASS_VECTOR;
    
-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
    sim_invariant_mass_sq_div2 <= invariant_mass_sq_div2;
    
    inv_mass_comp <= '1' when invariant_mass_sq_div2 >= mass_lower_limit_vector and invariant_mass_sq_div2 <= mass_upper_limit_vector else '0';
    sim_inv_mass_comp <= inv_mass_comp;
    
-- HB 2016-12-12: calculation of transverse mass with formular M**2/2=pt1*pt2*(1-cos(phi1-phi2))
-- HB 2016-12-12: "conv_std_logic_vector((10**MASS_COSH_COS_PRECISION), cosh_cos_width)" means 1 multiplied with 10**MASS_COSH_COS_PRECISION, converted to std_logic_vector with cosh_cos_width
    transverse_mass_sq_div2 <= pt1 * pt2 * ((conv_std_logic_vector((10**MASS_COSH_COS_PRECISION), cosh_cos_width)) - cos_dphi);
    sim_transverse_mass_sq_div2 <= transverse_mass_sq_div2;
    
    transverse_mass_comp <= '1' when transverse_mass_sq_div2 >= mass_lower_limit_vector and transverse_mass_sq_div2 <= mass_upper_limit_vector else '0';
    sim_transverse_mass_comp <= transverse_mass_comp;
    
-- HB 2016-12-13: selection of comparision for mass types
    invariant_mass_sel: if mass_type=0 generate
	mass_comp <= '1' when inv_mass_comp = '1' else '0';
    end generate invariant_mass_sel;
    invariant_mass_w_pt_sel: if mass_type=1 generate
	mass_comp <= '1' when (inv_mass_comp = '1' and pt_square_comp = '1') else '0';
    end generate invariant_mass_w_pt_sel;
    transverse_mass_sel: if mass_type=2 generate
	mass_comp <= '1' when transverse_mass_comp = '1' else '0';
    end generate transverse_mass_sel;
    transverse_mass_w_pt_sel: if mass_type=3 generate
	mass_comp <= '1' when (transverse_mass_comp = '1' and pt_square_comp = '1') else '0';
    end generate transverse_mass_w_pt_sel;
    
end architecture rtl;
