
-- Description:
-- Testbench for simulation of invmass_div_dr_calculator.vhd

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;
use work.gtl_pkg.all;
use work.ufixed_luts_pkg.all;

entity invmass_div_dr_calculator_jet_TB is
end invmass_div_dr_calculator_jet_TB;

architecture beh of invmass_div_dr_calculator_jet_TB is

    constant deta_dphi_prec : positive := JET_JET_DETA_DPHI_PRECISION;
    constant cosh_cos_prec : positive := JET_JET_COSH_COS_PRECISION;
    constant pt_prec : positive := JET_PT_PRECISION;

    constant deta_int_digits: positive := JET_DETA_INT_DIGITS;
    constant dphi_int_digits: positive := JET_DPHI_INT_DIGITS;
    constant pt_int_digits: positive := JET_PT_INT_DIGITS;
    constant cosh_deta_int_digits: positive := JET_COSH_DETA_INT_DIGITS;
    constant fract_digits: positive := FRACT_DIGITS_ALL;
    
    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2; -- = 8
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3; -- = 26
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1; -- = 47
    
    constant mass_upper_limit: real := 18.9;
    constant mass_lower_limit: real := 18.0;
    
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal jet_data : calo_objects_array(1 downto 0) := (X"00000000", X"00000000");
    type pt_array is array (1 downto 0) of std_logic_vector(JET_PT_HIGH-JET_PT_LOW downto 0);
    type phi_array is array (1 downto 0) of std_logic_vector(JET_PHI_HIGH-JET_PHI_LOW downto 0);
    type eta_array is array (1 downto 0) of std_logic_vector(JET_ETA_HIGH-JET_ETA_HIGH downto 0);
    signal pt: pt_array;
    signal phi: phi_array;
    signal eta: eta_array;
    signal jet_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal jet_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_jet_jet_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_jet_jet_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));

    signal diff_eta_int : natural range 0 to 9962;
    signal diff_phi_int : natural range 0 to 6240;
    signal pt1_int : natural range 0 to 10238;
    signal pt2_int : natural range 0 to 10238;
    signal cosh_deta_int : natural range 0 to 10597282;
    signal cos_dphi_int : integer range -1000 to 1000;

--*********************************Main Body of Code**********************************
begin
    
    process
    begin
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"024E0499", X"000384FD");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"024E04FD", X"000384CE");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"001B4070", X"000C8080");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"001B4070", X"000C8090");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"0024C014", X"00220012");
	wait for LHC_CLK_PERIOD; 
        jet_data <= (X"00000000", X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

 -- ****************************************************************************
--HB 2016-11-11: the following calculations of signals should be part of gtl_module.vhd
-- ****************************************************************************

pt1_int <= JET_PT_LUT(CONV_INTEGER(jet_data(0)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low)));
pt2_int <= JET_PT_LUT(CONV_INTEGER(jet_data(1)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low)));

jet_data_l: for i in 0 to 1 generate
    jet_eta_integer(i) <= CONV_INTEGER(signed(jet_data(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
    jet_phi_integer(i) <= CONV_INTEGER(jet_data(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
end generate;

diff_jet_jet_eta_i: entity work.sub_eta_integer_obj_vs_obj
    generic map(2, 2)
    port map(jet_eta_integer, jet_eta_integer, diff_jet_jet_eta_integer);
diff_jet_jet_phi_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(2, 2, CALO_PHI_HALF_RANGE_BINS)
    port map(jet_phi_integer, jet_phi_integer, diff_jet_jet_phi_integer);

diff_eta_int <= JET_JET_DIFF_ETA_LUT(diff_jet_jet_eta_integer(0,1));
diff_phi_int <= JET_JET_DIFF_PHI_LUT(diff_jet_jet_phi_integer(0,1));

cosh_deta_int <= JET_JET_COSH_DETA_LUT(diff_jet_jet_eta_integer(0,1));
cos_dphi_int <= JET_JET_COS_DPHI_LUT(diff_jet_jet_phi_integer(0,1));

dut: entity work.invmass_div_dr_calculator
    generic map(pt_prec, deta_dphi_prec, cosh_cos_prec,
        pt_int_digits, deta_int_digits, dphi_int_digits, cosh_deta_int_digits,
        mass_upper_limit, mass_lower_limit)
    port map(
        pt1_int, 
        pt2_in, 
        diff_eta_in,
        diff_phi_in,
        cosh_deta_in, 
        cos_dphi_in, 
        open);

end beh;

