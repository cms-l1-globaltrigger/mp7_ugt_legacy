
-- Description:
-- Testbench for simulation of mass div DR

-- Version history:
-- HB 2020-08-27: first design

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

entity mass_div_dr_calo_test_tb is
end mass_div_dr_calo_test_tb;

architecture beh of mass_div_dr_calo_test_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal bx_data : bx_data_record;

    signal eg_bx_0_pt_vector: diff_inputs_array(0 to NR_EG_OBJECTS-1) := (others => (others => '0'));
    signal eg_bx_0_eta_integer: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_phi_integer: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_cos_phi: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_sin_phi: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_conv_cos_phi: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_conv_sin_phi: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_eta_conv_2_muon_eta_integer: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);
    signal eg_bx_0_phi_conv_2_muon_phi_integer: integer_array(0 to NR_EG_OBJECTS-1) := (others => 0);

    signal eg_eg_bx_0_bx_0_deta_integer: dim2_max_eta_range_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => 0));
    signal eg_eg_bx_0_bx_0_deta_vector: deta_dphi_vector_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));
    signal eg_eg_bx_0_bx_0_dphi_integer: dim2_max_phi_range_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => 0));
    signal eg_eg_bx_0_bx_0_dphi_vector: deta_dphi_vector_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));
    signal eg_eg_bx_0_bx_0_mass_inv_pt : mass_dim2_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));
    signal eg_eg_bx_0_bx_0_mass_over_dr : mass_div_dr_vector_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));

    signal calo_deta_bin : common_deta_bin_vector_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));
    signal calo_dphi_bin : common_dphi_bin_vector_array(0 to NR_EG_OBJECTS-1, 0 to NR_EG_OBJECTS-1) := (others => (others => (others => '0')));

    signal dout : std_logic_vector(25 DOWNTO 0) := (others => '0');

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
        wait for 8 ns;
        bx_data.eg(2) <= (X"00000000", X"00000000", others => X"00000000");
        wait for LHC_CLK_PERIOD * 4;
        bx_data.eg(2) <= (X"00020F99", X"00000F99", others => X"00000000");
        wait for LHC_CLK_PERIOD;
        bx_data.eg(2) <= (X"00000000", X"00000000", others => X"00000000");
        wait for LHC_CLK_PERIOD * 4;
        bx_data.eg(2) <= (X"00010F9D", X"00000F9D", others => X"00000000");
        wait for LHC_CLK_PERIOD;
        bx_data.eg(2) <= (X"00000000", X"00000000", others => X"00000000");
        wait for LHC_CLK_PERIOD * 4;
        bx_data.eg(2) <= (X"00E4E49D", X"00010F9D", others => X"00000000");
        wait for LHC_CLK_PERIOD;
        bx_data.eg(2) <= (X"00000000", X"00000000", others => X"00000000");
        wait for LHC_CLK_PERIOD;
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

calo_deta_bin(0,1)(CALO_DETA_BINS_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(eg_eg_bx_0_bx_0_deta_integer(0,1), CALO_DETA_BINS_WIDTH);
calo_dphi_bin(0,1)(CALO_DPHI_BINS_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(eg_eg_bx_0_bx_0_dphi_integer(0,1), CALO_DPHI_BINS_WIDTH);

lut_all_i : entity work.rom_lut_calo_inv_dr_sq_all
    generic map(
        deta_width => CALO_DETA_BINS_WIDTH,
        dphi_width => CALO_DPHI_BINS_WIDTH
    )
    port map (
        clk => lhc_clk,
        deta => calo_deta_bin(0,1)(CALO_DETA_BINS_WIDTH-1 downto 0),
        dphi => calo_dphi_bin(0,1)(CALO_DPHI_BINS_WIDTH-1 downto 0),
        dout => dout
    );

calc_obj_parameter_eg_bx_0_i: entity work.obj_parameter
    generic map(
        nr_obj => NR_EG_OBJECTS,
        type_obj => EG_TYPE
    )
    port map(
        calo => bx_data.eg(2),
        phi_conv_2_muon_phi_integer => eg_bx_0_phi_conv_2_muon_phi_integer,
        pt_vector => eg_bx_0_pt_vector,
        eta_integer => eg_bx_0_eta_integer,
        phi_integer => eg_bx_0_phi_integer,
        cos_phi => eg_bx_0_cos_phi,
        sin_phi => eg_bx_0_sin_phi,
        conv_cos_phi => eg_bx_0_conv_cos_phi,
        conv_sin_phi => eg_bx_0_conv_sin_phi
    );
--
-- deta and dphi calculations for correlation conditions (used for DETA, DPHI)

calc_deta_dphi_integer_eg_eg_bx_0_bx_0_i: entity work.deta_dphi_calculations
    generic map(
        nr_obj1 => NR_EG_OBJECTS,
        type_obj1 => EG_TYPE,
        nr_obj2 => NR_EG_OBJECTS,
        type_obj2 => EG_TYPE
    )
    port map(
        eta_integer_obj1 => eg_bx_0_eta_integer,
        phi_integer_obj1 => eg_bx_0_phi_integer,
        eta_integer_obj2 => eg_bx_0_eta_integer,
        phi_integer_obj2 => eg_bx_0_phi_integer,
        deta_integer => eg_eg_bx_0_bx_0_deta_integer,
        dphi_integer => eg_eg_bx_0_bx_0_dphi_integer
    );

end beh;

