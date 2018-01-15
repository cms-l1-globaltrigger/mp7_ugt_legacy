--------------------------------------------------------------------------------
-- Simulator   : Modelsim 10.1
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Simulation
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: https://svn.cern.ch/reps/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/sim/testbench/invariant_mass_tb.vhd $
-- $Date: 2015-10-23 11:55:54 +0200 (Fri, 23 Oct 2015) $
-- $Author: hbergaue $
-- $Revision: 40316 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity twobody_pt_calculator_v2_TB is
end twobody_pt_calculator_v2_TB;

architecture rtl of twobody_pt_calculator_v2_TB is

    constant pt_sq_threshold: real := 14481.7; -- threshold for pt**2 (pt square)
    constant pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := X"000001512DA88E80"; -- 14481.7 * 10**(PT1_PRECISION+PT2_PRECISION+PT_SIN_COS_PRECISION*2)

    constant EG_PT_SIN_COS_PRECISION  : positive := 3; -- digits after decimal point for calculation of sine and cosine values in LUTs
-- HB 2017-03-22: width for std_logic_vector of values for sine and cosine (1000 < 2**10=1024) plus 1 for negative values !!!
    constant SIN_COS_WIDTH  : positive :=  CALO_SIN_COS_VECTOR_WIDTH;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal eg_data : calo_objects_array(1 downto 0) := (X"00000000", X"00000000");
    signal pt1, pt2 : std_logic_vector(EG_PT_VECTOR_WIDTH-1 downto 0);
    signal eg_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal eg_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_eg_eg_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_eg_eg_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal cosh_deta_vector : std_logic_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal cos_dphi_vector : std_logic_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal cos_phi_1, sin_phi_2 : std_logic_vector(SIN_COS_WIDTH-1 downto 0);
    signal cos_phi_2, sin_phi_1 : std_logic_vector(SIN_COS_WIDTH-1 downto 0);

    signal pt1_integer, pt2_integer : integer;
    signal cos_phi_1_integer, sin_phi_1_integer, cos_phi_2_integer, sin_phi_2_integer : integer;

--*********************************Main Body of Code**********************************
begin
    
    process
    begin
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00978199", X"0000E1FD");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"009781FD", X"0000E1CE");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"0006D070", X"0000E080");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"0006D070", X"0000E090");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

 -- ****************************************************************************
--HB 2016-11-11: the following calculations of signals should be part of gtl_module.vhd
-- ****************************************************************************

pt1_integer <= EG_PT_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low)));
pt2_integer <= EG_PT_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low)));
pt1(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(pt1_integer, EG_PT_VECTOR_WIDTH);
pt2(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(pt2_integer, EG_PT_VECTOR_WIDTH);

cos_phi_1_integer <= CALO_COS_PHI_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));
cos_phi_2_integer <= CALO_COS_PHI_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));
sin_phi_1_integer <= CALO_SIN_PHI_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));
sin_phi_2_integer <= CALO_SIN_PHI_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));

dut: entity work.twobody_pt_calculator_v2
    generic map(EG_PT_VECTOR_WIDTH, EG_PT_VECTOR_WIDTH, pt_sq_threshold_vector, SIN_COS_WIDTH, EG_PT_SIN_COS_PRECISION)
    port map(pt1(EG_PT_VECTOR_WIDTH-1 downto 0), pt2(EG_PT_VECTOR_WIDTH-1 downto 0),
	cos_phi_1_integer, cos_phi_2_integer, sin_phi_1_integer, sin_phi_2_integer, open, open);

end rtl;

