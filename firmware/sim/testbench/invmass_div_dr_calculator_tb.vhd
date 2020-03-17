
-- Description:
-- Testbench for simulation of invmass_div_dr_calculator.vhd

-- Version history:
-- HB 2020-03-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;
use work.sfixed_luts_pkg.all;

entity invmass_div_dr_calculator_TB is
end invmass_div_dr_calculator_TB;

architecture beh of invmass_div_dr_calculator_TB is

--     constant mass_upper_limit: integer := 500;
--     constant mass_lower_limit: integer := 400;
    constant mass_upper_limit: sfixed(36 downto -1) := X"0000001F4"&'0'; -- 500
    constant mass_lower_limit: sfixed(36 downto -1) := X"000000190"&'0'; -- 400
    
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal eg_data : calo_objects_array(1 downto 0) := (X"00000000", X"00000000");
    signal pt1, pt2 : sfixed(9 downto -17);
    signal eg_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal eg_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_eg_eg_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_eg_eg_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_eta : sfixed(5 downto -19);
    signal diff_phi : sfixed(4 downto -19);
    signal cosh_deta : sfixed(15 downto -19);
    signal cos_dphi : sfixed(2 downto -19);

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
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00093014", X"00084012");
	wait for LHC_CLK_PERIOD; 
        eg_data <= (X"00000000", X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

 -- ****************************************************************************
--HB 2016-11-11: the following calculations of signals should be part of gtl_module.vhd
-- ****************************************************************************

pt1 <= EG_PT_LUT_SFIXED(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low)));
pt2 <= EG_PT_LUT_SFIXED(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low)));

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

diff_eta <= EG_EG_DIFF_ETA_LUT_SFIXED(diff_eg_eg_eta_integer(0,1));
diff_phi <= EG_EG_DIFF_PHI_LUT_SFIXED(diff_eg_eg_phi_integer(0,1));

cosh_deta <= EG_EG_COSH_DETA_LUT_SFIXED(diff_eg_eg_eta_integer(0,1));
cos_dphi <= EG_EG_COS_DPHI_LUT_SFIXED(diff_eg_eg_phi_integer(0,1));

dut: entity work.invmass_div_dr_calculator
    generic map(mass_upper_limit, mass_lower_limit)
    port map(
        diff_eta,
        diff_phi,
        pt1, 
        pt2, 
        cosh_deta, 
        cos_dphi, 
        open);

end beh;

