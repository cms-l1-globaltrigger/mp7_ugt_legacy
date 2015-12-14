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
-- HB 2015-12-14: removed INV_MASS_PT_PRECISION from generic - not used anymore.
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
	INV_MASS_PRECISION : positive := 1; -- 1 => first digit after decimal point
-- 	INV_MASS_PT_PRECISION : positive := 1;
	INV_MASS_COSH_COS_PRECISION : positive := 3
    );
    port(
	pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
	cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        inv_mass_comp : out std_logic;
        sim_inv_mass_sq_div2 : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0)
    );
end invariant_mass;

architecture rtl of invariant_mass is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (inv_mass_sq_div2) and limits.
    constant INV_MASS_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;
-- HB 2015-10-21: multiplication factor for limits (number of relevant position after decimal point - INV_MASS_PRECISION => 1, globaly set in gtl.pkg).
    constant INV_MASS_PRECISION_FACTOR : real := real(10**INV_MASS_PRECISION);
-- HB 2015-10-21: multiplication factor for limits vectors. INV_MASS_COSH_COS_PRECISION: number of relevant position after decimal point for cosh_deta and cos_dphi, globaly set in gtl.pkg.
    constant FACTOR_4_VECTOR : std_logic_vector((INV_MASS_COSH_COS_PRECISION+1)*4-1 downto 0) := conv_std_logic_vector(10**(INV_MASS_COSH_COS_PRECISION+1),(INV_MASS_COSH_COS_PRECISION+1)*4);

    signal inv_mass_sq_div2 : std_logic_vector(INV_MASS_VECTOR_WIDTH-1 downto 0);
    signal upper_limit_vector : std_logic_vector(INV_MASS_VECTOR_WIDTH-1 downto 0);
    signal lower_limit_vector : std_logic_vector(INV_MASS_VECTOR_WIDTH-1 downto 0);

    begin

-- HB 2015-10-01: converting limits to std_logic_vector for comparison. Integer (32-bits in VHDL) would be exeeded, therefore std_logic_vector.
    upper_limit_vector <= conv_std_logic_vector((integer(upper_limit*INV_MASS_PRECISION_FACTOR)),INV_MASS_VECTOR_WIDTH-FACTOR_4_VECTOR'length)*FACTOR_4_VECTOR;
    lower_limit_vector <= conv_std_logic_vector((integer(lower_limit*INV_MASS_PRECISION_FACTOR)),INV_MASS_VECTOR_WIDTH-FACTOR_4_VECTOR'length)*FACTOR_4_VECTOR;

-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2)
    inv_mass_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
    sim_inv_mass_sq_div2 <= inv_mass_sq_div2;

-- HB 2015-10-01: comparison
    inv_mass_comp <= '1' when (inv_mass_sq_div2 >= lower_limit_vector and inv_mass_sq_div2 <= upper_limit_vector) else '0';
    
end architecture rtl;
