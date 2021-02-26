
-- Description:
-- Testbench for simulation of mass_div_dr_calculator.vhd

-- Version history:
-- HB 2020-08-25: first design

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

entity mass_div_dr_calculator_eg_tb is
end mass_div_dr_calculator_eg_tb;

architecture beh of mass_div_dr_calculator_eg_tb is

    constant mass_upper_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
    constant mass_lower_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
    constant mass_div_dr_width: natural := 2*EG_PT_VECTOR_WIDTH+EG_EG_COSH_COS_VECTOR_WIDTH+EG_EG_INV_DR_SQ_VECTOR_WIDTH;

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal eg_data : calo_objects_array(0 to 1) := (X"00000000", X"00000000");

    signal eg_eta_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal eg_phi_integer: diff_integer_inputs_array(0 to 1) := (others => 0);
    signal diff_eg_eg_eta_integer: dim2_max_eta_range_array(0 to 1, 0 to 1) := (others => (others => 0));
    signal diff_eg_eg_phi_integer: dim2_max_phi_range_array(0 to 1, 0 to 1) := (others => (others => 0));

    signal pt1_vec : std_logic_vector(EG_PT_VECTOR_WIDTH-1 downto 0);
    signal pt2_vec : std_logic_vector(EG_PT_VECTOR_WIDTH-1 downto 0);
    signal deta_bin_vec : std_logic_vector(EG_EG_DETA_BINS_WIDTH-1 downto 0);
    signal dphi_bin_vec : std_logic_vector(EG_EG_DPHI_BINS_WIDTH-1 downto 0);
    signal cosh_deta_vec : std_logic_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0);
    signal cos_dphi_vec : std_logic_vector(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0);
    signal mass_div_dr : std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

--*********************************Main Body of Code**********************************
begin

    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

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

pt1_vec(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(eg_data(0)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low))), EG_PT_VECTOR_WIDTH);

pt2_vec(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(eg_data(1)(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low))), EG_PT_VECTOR_WIDTH);

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

deta_bin_vec <= CONV_STD_LOGIC_VECTOR(diff_eg_eg_eta_integer(0,1), EG_EG_DETA_BINS_WIDTH);
dphi_bin_vec <= CONV_STD_LOGIC_VECTOR(diff_eg_eg_phi_integer(0,1), EG_EG_DPHI_BINS_WIDTH);
cosh_deta_vec <= CONV_STD_LOGIC_VECTOR(EG_EG_COSH_DETA_LUT(diff_eg_eg_eta_integer(0,1)), EG_EG_COSH_COS_VECTOR_WIDTH);
cos_dphi_vec <= CONV_STD_LOGIC_VECTOR(EG_EG_COS_DPHI_LUT(diff_eg_eg_phi_integer(0,1)), EG_EG_COSH_COS_VECTOR_WIDTH);

dut: entity work.mass_div_dr
    generic map(
        nr_obj1 => NR_EG_OBJECTS,
        nr_obj2 => NR_EG_OBJECTS,
        rom_sel => CALO_CALO_ROM,
        deta_bins_width => EG_EG_DETA_BINS_WIDTH,
        dphi_bins_width => EG_EG_DPHI_BINS_WIDTH,
        pt1_width => EG_PT_VECTOR_WIDTH,
        pt2_width => EG_PT_VECTOR_WIDTH,
        cosh_cos_width => EG_EG_COSH_COS_VECTOR_WIDTH,
        inv_dr_sq_width => EG_EG_INV_DR_SQ_VECTOR_WIDTH
    )
    port map(
        lhc_clk,
        deta_bin_vec,
        dphi_bin_vec,
        pt1_vec,
        pt2_vec,
        cosh_deta_vec,
        cos_dphi_vec,
        mass_div_dr
    );

end beh;

