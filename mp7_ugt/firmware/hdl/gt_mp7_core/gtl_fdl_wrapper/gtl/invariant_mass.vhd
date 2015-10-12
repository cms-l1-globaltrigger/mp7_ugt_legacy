--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL$
-- $Date$
-- $Author$
-- $Revision$
--------------------------------------------------------------------------------

-- Desription:
-- Calculation of invariant mass based on LUTs and comparison with limits 

-- Version history:
-- HB 2015-10-01: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity invariant_mass is
    generic (
-- limits for comparison of invariant mass, given for M**2/2 [=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)]
	upper_limit: real := 15.0;
	lower_limit: real := 10.0;
	pt1_width: positive := 12;
	pt2_width: positive := 12;
	cosh_cos_width: positive := 28;
	INV_MASS_PRECISION : positive := 1 -- 1 => first digit after decimal point
    );
    port(
	pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
	cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        inv_mass_comp : out std_logic;
        upper_limit_vector_debug : out std_logic_vector(51 downto 0);
        lower_limit_vector_debug : out std_logic_vector(51 downto 0);
        inv_mass_sq_div2_debug : out std_logic_vector(51 downto 0)
    );
end invariant_mass;

architecture rtl of invariant_mass is

    constant INV_MASS_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;
--     constant INV_MASS_PRECISION : positive range 1 to 3 := 1; -- 1 => first digit after decimal point
    constant INV_MASS_PRECISION_FACTOR : real := real(10**INV_MASS_PRECISION);
    constant FACTOR_4_VECTOR : std_logic_vector(19 downto 0) := conv_std_logic_vector(integer(real(10**(2*INV_MASS_PT_PRECISION+INV_MASS_COSH_COS_PRECISION-INV_MASS_PRECISION))),20);

    signal inv_mass_sq_div2 : std_logic_vector(INV_MASS_WIDTH-1 downto 0);
    signal upper_limit_vector : std_logic_vector(INV_MASS_WIDTH-1 downto 0);
    signal lower_limit_vector : std_logic_vector(INV_MASS_WIDTH-1 downto 0);

    begin

-- HB 2015-10-01: converting limits to std_logic_vector for comparison
    upper_limit_vector <= conv_std_logic_vector((integer(upper_limit*INV_MASS_PRECISION_FACTOR)),(INV_MASS_WIDTH-FACTOR_4_VECTOR'length))*FACTOR_4_VECTOR;
    lower_limit_vector <= conv_std_logic_vector((integer(lower_limit*INV_MASS_PRECISION_FACTOR)),(INV_MASS_WIDTH-FACTOR_4_VECTOR'length))*FACTOR_4_VECTOR;

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)
    inv_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);

-- HB 2015-10-01: comparison
    inv_mass_comp <= '1' when (inv_mass_sq_div2 >= lower_limit_vector and inv_mass_sq_div2 <= upper_limit_vector) else '0';
    
-- HB 2015-10-01: debug outputs for simulation
    upper_limit_vector_debug <= upper_limit_vector;
    lower_limit_vector_debug <= lower_limit_vector;
    inv_mass_sq_div2_debug <= inv_mass_sq_div2;
    
end architecture rtl;
