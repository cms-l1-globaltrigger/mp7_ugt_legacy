
-- Description:
-- Calculation of invariant mass divided by deltaR.

-- Version history:
-- HB 2020-04-22: used LUT (in delta_r_lut_pkg) for 1/DR**2 values for "division"
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;
use work.delta_r_lut_pkg.all;

entity invmass_div_dr_calculator is
    generic (
-- limits for comparison of invariant mass divided by deltaR
        mass_div_dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);
        mass_div_dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        inv_dr_sq_width : positive := 26
    );
    port(
        inv_dr_sq : in std_logic_vector(inv_dr_sq_width-1 downto 0);
        pt1 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        pt2 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        mass_div_dr_comp : out std_logic;
-- simulation outputs
        sim_invariant_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0);
        sim_invmass_sq_div2_div_dr_sq : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width+inv_dr_sq_width-1 downto 0)        
    );
end invmass_div_dr_calculator;

architecture rtl of invmass_div_dr_calculator is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2).
    constant MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;
-- HB 2020-04-22: length of std_logic_vector for invariant mass divided by DR (invmass_sq_div2_div_dr_sq) and limits.
    constant MASS_DIV_DR_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width+inv_dr_sq_width;

    signal invariant_mass_sq_div2 : std_logic_vector(MASS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal invmass_sq_div2_div_dr_sq : std_logic_vector(MASS_DIV_DR_VECTOR_WIDTH-1 downto 0) := (others => '0');
    
    signal upper_limit : std_logic_vector(MASS_DIV_DR_VECTOR_WIDTH-1 downto 0);
    signal lower_limit : std_logic_vector(MASS_DIV_DR_VECTOR_WIDTH-1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of invmass_sq_div2_div_dr_sq : signal is "yes";

begin

    upper_limit <= mass_div_dr_upper_limit_vector(MASS_DIV_DR_VECTOR_WIDTH-1 downto 0);
    lower_limit <= mass_div_dr_lower_limit_vector(MASS_DIV_DR_VECTOR_WIDTH-1 downto 0);

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
    invariant_mass_sq_div2 <= pt1(pt1_width-1 downto 0) * pt2(pt2_width-1 downto 0) * (cosh_deta - cos_dphi);

    invmass_sq_div2_div_dr_sq <=  invariant_mass_sq_div2 * inv_dr_sq;

    mass_div_dr_comp <= '1' when invmass_sq_div2_div_dr_sq >= lower_limit and invmass_sq_div2_div_dr_sq <= upper_limit else '0';

    sim_invariant_mass_sq_div2 <= invariant_mass_sq_div2;
    sim_invmass_sq_div2_div_dr_sq <= invmass_sq_div2_div_dr_sq;

end architecture rtl;
