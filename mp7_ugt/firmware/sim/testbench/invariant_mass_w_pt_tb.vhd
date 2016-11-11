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

entity invariant_mass_w_pt_TB is
end invariant_mass_w_pt_TB;

architecture rtl of invariant_mass_w_pt_TB is

-- ****************************************************************************
--HB 2016-11-11: the following types and LUTs should be inserted in gtl_pkg.vhd
-- ****************************************************************************

type cos_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;

-- HB 2016-11-09: LUTs for calo objecttypes
-- HB 2016-11-09: center of phi bins for calculation of cosine and sine with 3 digits after decimal point
constant COS_PHI_LUT : cos_phi_lut_array := (
1000, 998, 994, 988, 981, 971, 960, 947, 932, 915, 897, 877, 855, 831, 806, 780,
752, 722, 692, 659, 626, 591, 556, 519, 481, 442, 403, 362, 321, 280, 238, 195,
152, 109, 65, 22, -22, -65, -109, -152, -195, -238, -280, -321, -362, -403, -442, -481,
-519, -556, -591, -626, -659, -692, -722, -752, -780, -806, -831, -855, -877, -897, -915, -932,
-947, -960, -971, -981, -988, -994, -998, -1000, -1000, -998, -994, -988, -981, -971, -960, -947,
-932, -915, -897, -877, -855, -831, -806, -780, -752, -722, -692, -659, -626, -591, -556, -519,
-481, -442, -403, -362, -321, -280, -238, -195, -152, -109, -65, -22, 22, 65, 109, 152,
195, 238, 280, 321, 362, 403, 442, 481, 519, 556, 591, 626, 659, 692, 722, 752,
780, 806, 831, 855, 877, 897, 915, 932, 947, 960, 971, 981, 988, 994, 998, 1000,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

type sin_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;

constant SIN_PHI_LUT : sin_phi_lut_array := (
22, 65, 109, 152, 195, 238, 280, 321, 362, 403, 442, 481, 519, 556, 591, 626,
659, 692, 722, 752, 780, 806, 831, 855, 877, 897, 915, 932, 947, 960, 971, 981,
988, 994, 998, 1000, 1000, 998, 994, 988, 981, 971, 960, 947, 932, 915, 897, 877,
855, 831, 806, 780, 752, 722, 692, 659, 626, 591, 556, 519, 481, 442, 403, 362,
321, 280, 238, 195, 152, 109, 65, 22, -22, -65, -109, -152, -195, -238, -280, -321,
-362, -403, -442, -481, -519, -556, -591, -626, -659, -692, -722, -752, -780, -806, -831, -855,
-877, -897, -915, -932, -947, -960, -971, -981, -988, -994, -998, -1000, -1000, -998, -994, -988,
-981, -971, -960, -947, -932, -915, -897, -877, -855, -831, -806, -780, -752, -722, -692, -659,
-626, -591, -556, -519, -481, -442, -403, -362, -321, -280, -238, -195, -152, -109, -65, -22,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

    constant sel_sig_pt_square_cut : boolean := true; -- "true" selects sig_pt_square_cut for simulation, "false" selects pt_square_cut in generic for synthesis
    constant pt_square_cut : boolean := true; -- generic parameter for synthesis
    constant pt_sq_upper_limit: real := 15000.5; -- upper limit for pt**2 (pt square)
    constant pt_sq_lower_limit: real := 10000.9; -- lower limit for pt**2 (pt square)
    constant EG_PT_SIN_COS_PRECISION  : positive := 3; -- digits after decimal point for calculation of sine and cosine values in LUTs
    constant SIN_COS_WIDTH  : positive :=  10; -- width for std_logic_vector of values for sine and cosine (1000 < 2**10=1024)

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
    signal sig_pt_square_cut_int : boolean := true;

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
        eg_data <= (X"0006D070", X"0000E080");
        sig_pt_square_cut_int <= false;
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
        sig_pt_square_cut_int <= true;
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

 -- ****************************************************************************
--HB 2016-11-11: the following calculations of signals should be part of gtl_module.vhd
-- ****************************************************************************

pt1(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low))), EG_PT_VECTOR_WIDTH);
pt2(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low))), EG_PT_VECTOR_WIDTH);

eg_data_l: for i in 0 to 1 generate
    eg_eta_integer(i) <= CONV_INTEGER(signed(eg_data(i)(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low)));
    eg_phi_integer(i) <= CONV_INTEGER(eg_data(i)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low));
end generate;

diff_eg_eg_eta_i: entity work.sub_eta_integer_obj_vs_obj
    generic map(2, 2)
    port map(eg_eta_integer, eg_eta_integer, diff_eg_eg_eta_integer);
diff_eg_eg_phi_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(2, 2, CALO_PHI_HALF_RANGE_BINS)
    port map(eg_phi_integer, eg_phi_integer, diff_eg_eg_phi_integer);

cosh_deta_vector <= CONV_STD_LOGIC_VECTOR(EG_EG_COSH_DETA_LUT(diff_eg_eg_eta_integer(0,1)), EG_EG_COSH_COS_VECTOR_WIDTH);
cos_dphi_vector <= CONV_STD_LOGIC_VECTOR(EG_EG_COS_DPHI_LUT(diff_eg_eg_phi_integer(0,1)), EG_EG_COSH_COS_VECTOR_WIDTH);

cos_phi_1 <= CONV_STD_LOGIC_VECTOR(COS_PHI_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low))), SIN_COS_WIDTH);
cos_phi_2 <= CONV_STD_LOGIC_VECTOR(COS_PHI_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low))), SIN_COS_WIDTH);
sin_phi_1 <= CONV_STD_LOGIC_VECTOR(SIN_PHI_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low))), SIN_COS_WIDTH);
sin_phi_2 <= CONV_STD_LOGIC_VECTOR(SIN_PHI_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low))), SIN_COS_WIDTH);

--HB 2016-11-11: simulation of invariant_mass_w_pt.vhd

dut: entity work.invariant_mass_w_pt
    generic map(sel_sig_pt_square_cut, 1300.1, 195.4, EG_PT_VECTOR_WIDTH, EG_PT_VECTOR_WIDTH, EG_EG_COSH_COS_VECTOR_WIDTH, EG_EG_INV_MASS_PRECISION, EG_EG_COSH_COS_PRECISION,
	 pt_square_cut, pt_sq_upper_limit, pt_sq_lower_limit, SIN_COS_WIDTH, EG_ET_PRECISION, EG_PT_SIN_COS_PRECISION) -- M**2/2
    port map(pt1(EG_PT_VECTOR_WIDTH-1 downto 0), pt2(EG_PT_VECTOR_WIDTH-1 downto 0), cosh_deta_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0), cos_dphi_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0),
	cos_phi_1, cos_phi_2, sin_phi_1, sin_phi_2, sig_pt_square_cut_int, open, open, open, open);

end rtl;

