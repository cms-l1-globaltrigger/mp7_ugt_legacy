
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

    constant deta_int_digits: positive := JET_DETA_INT_DIGITS;
    constant dphi_int_digits: positive := JET_DPHI_INT_DIGITS;
    constant pt_int_digits: positive := JET_PT_INT_DIGITS;
    constant cosh_deta_int_digits: positive := JET_COSH_DETA_INT_DIGITS;
    constant fract_digits: positive := FRACT_DIGITS_ALL;
    
    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2;
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3;
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1;
    
    constant mass_upper_limit: ufixed(inv_mass_div_dr_int_digits downto -1) := X"0000000000073A"&'0'; -- 1850
    constant mass_lower_limit: ufixed(inv_mass_div_dr_int_digits downto -1) := X"00000000000708"&'0'; -- 1800
    
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal jet_data : calo_objects_array(1 downto 0) := (X"00000000", X"00000000");
    signal pt1, pt2 : ufixed(pt_int_digits downto -fract_digits);
    signal jet_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal jet_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_jet_jet_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_jet_jet_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_eta : ufixed(deta_int_digits downto -fract_digits);
    signal diff_phi : ufixed(dphi_int_digits downto -fract_digits);
    signal cosh_deta : ufixed(cosh_deta_int_digits downto -fract_digits);
    signal cos_dphi : ufixed(0 downto -fract_digits);
    signal cos_dphi_sign : boolean;

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

pt1 <= JET_PT_LUT_UFIXED(CONV_INTEGER(jet_data(0)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low)));
pt2 <= JET_PT_LUT_UFIXED(CONV_INTEGER(jet_data(1)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low)));

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

diff_eta <= JET_JET_DIFF_ETA_LUT_UFIXED(diff_jet_jet_eta_integer(0,1));
diff_phi <= JET_JET_DIFF_PHI_LUT_UFIXED(diff_jet_jet_phi_integer(0,1));

cosh_deta <= JET_JET_COSH_DETA_LUT_UFIXED(diff_jet_jet_eta_integer(0,1));
cos_dphi <= JET_JET_COS_DPHI_LUT_UFIXED(diff_jet_jet_phi_integer(0,1));
cos_dphi_sign <= JET_JET_COS_DPHI_SIGN_LUT(diff_jet_jet_phi_integer(0,1));

dut: entity work.invmass_div_dr_calculator
    generic map(deta_int_digits, dphi_int_digits, pt_int_digits, cosh_deta_int_digits,
        mass_upper_limit, mass_lower_limit)
    port map(
        diff_eta,
        diff_phi,
        pt1, 
        pt2, 
        cosh_deta, 
        cos_dphi, 
        cos_dphi_sign,
        open);

end beh;

