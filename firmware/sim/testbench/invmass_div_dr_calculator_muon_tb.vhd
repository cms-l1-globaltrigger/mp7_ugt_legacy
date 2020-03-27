
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

entity invmass_div_dr_calculator_muon_TB is
end invmass_div_dr_calculator_muon_TB;

architecture beh of invmass_div_dr_calculator_muon_TB is

    constant deta_int_digits: positive := MU_DETA_INT_DIGITS;
    constant dphi_int_digits: positive := MU_DPHI_INT_DIGITS;
    constant pt_int_digits: positive := MU_PT_INT_DIGITS;
    constant cosh_deta_int_digits: positive := MU_COSH_DETA_INT_DIGITS;
    constant fract_digits: positive := FRACT_DIGITS_ALL;
    constant PHI_HALF_RANGE_BINS: positive := MUON_PHI_HALF_RANGE_BINS;
    
    constant dr_sq_int_digits : positive := max(deta_int_digits*2, dphi_int_digits*2)+2; -- = 8
    constant inv_mass_int_digits : positive := pt_int_digits*2+cosh_deta_int_digits+3; -- = 26
    constant inv_mass_div_dr_int_digits : positive := inv_mass_int_digits+fract_digits+1; -- = 47
    
    constant mass_upper_limit: ufixed(inv_mass_div_dr_int_digits downto -1) := '0'&X"0000000073A"&'0'; -- 1850
    constant mass_lower_limit: ufixed(inv_mass_div_dr_int_digits downto -1) := '0'&X"00000000708"&'0'; -- 1800
    
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal mu_data : muon_objects_array(1 downto 0) := (X"0000000000000000", X"0000000000000000");
    type pt_array is array (1 downto 0) of std_logic_vector(8 downto 0);
    type phi_array is array (1 downto 0) of std_logic_vector(9 downto 0);
    type eta_array is array (1 downto 0) of std_logic_vector(8 downto 0);
    signal pt: pt_array;
    signal phi: phi_array;
    signal eta: eta_array;
    signal pt1, pt2 : ufixed(pt_int_digits downto -fract_digits);
    signal mu_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal mu_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_mu_mu_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_mu_mu_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));
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
        phi <= ("01"&X"45", "01"&X"3D");
        pt <= ('0'&X"04", '0'&X"29");
        eta <= ('0'&X"64", '0'&X"2C");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "00"&X"00");
        pt <= ('0'&X"00", '0'&X"00");
        eta <= ('0'&X"00", '0'&X"00");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "01"&X"20");
        pt <= ('0'&X"56", '0'&X"89");
        eta <= ('1'&X"64", '0'&X"2C");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "00"&X"00");
        pt <= ('0'&X"00", '0'&X"00");
        eta <= ('0'&X"00", '0'&X"00");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "01"&X"21");
        pt <= ('0'&X"56", '0'&X"89");
        eta <= ('1'&X"64", '0'&X"2C");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "00"&X"00");
        pt <= ('0'&X"00", '0'&X"00");
        eta <= ('0'&X"00", '0'&X"00");
	wait for LHC_CLK_PERIOD; 
        phi <= ("01"&X"21", "01"&X"21");
        pt <= ('0'&X"56", '0'&X"89");
        eta <= ('0'&X"2C", '0'&X"2C");
	wait for LHC_CLK_PERIOD; 
        phi <= ("00"&X"00", "00"&X"00");
        pt <= ('0'&X"00", '0'&X"00");
        eta <= ('0'&X"00", '0'&X"00");
    wait;
    end process;

 ------------------- Instantiate  modules  -----------------

mu_data(0)(9 downto 0) <= phi(0);
mu_data(0)(18 downto 10) <= pt(0);
mu_data(0)(31 downto 23) <= eta(0);
mu_data(1)(9 downto 0) <= phi(1);
mu_data(1)(18 downto 10) <= pt(1);
mu_data(1)(31 downto 23) <= eta(1);

pt1 <= MU_PT_LUT_UFIXED(CONV_INTEGER(mu_data(0)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low)));
pt2 <= MU_PT_LUT_UFIXED(CONV_INTEGER(mu_data(1)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low)));

mu_data_l: for i in 0 to 1 generate
    mu_eta_integer(i) <= CONV_INTEGER(signed(mu_data(i)(D_S_I_MU_V2.eta_high downto D_S_I_MU_V2.eta_low)));
    mu_phi_integer(i) <= CONV_INTEGER(mu_data(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
end generate;

diff_mu_mu_eta_i: entity work.sub_eta_integer_obj_vs_obj
    generic map(2, 2)
    port map(mu_eta_integer, mu_eta_integer, diff_mu_mu_eta_integer);
diff_mu_mu_phi_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(2, 2, PHI_HALF_RANGE_BINS)
    port map(mu_phi_integer, mu_phi_integer, diff_mu_mu_phi_integer);

diff_eta <= MU_MU_DIFF_ETA_LUT_UFIXED(diff_mu_mu_eta_integer(0,1));
diff_phi <= MU_MU_DIFF_PHI_LUT_UFIXED(diff_mu_mu_phi_integer(0,1));

cosh_deta <= MU_MU_COSH_DETA_LUT_UFIXED(diff_mu_mu_eta_integer(0,1));
cos_dphi <= MU_MU_COS_DPHI_LUT_UFIXED(diff_mu_mu_phi_integer(0,1));
cos_dphi_sign <= MU_MU_COS_DPHI_SIGN_LUT(diff_mu_mu_phi_integer(0,1));

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

