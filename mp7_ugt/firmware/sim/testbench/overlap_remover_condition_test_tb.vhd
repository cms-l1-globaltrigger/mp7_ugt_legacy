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
-- $HeadURL: https://svn.cern.ch/reps/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/sim/testbench/calo_calo_correlation_condition_inv_mass_tb.vhd $
-- $Date: 2015-10-15 10:00:21 +0200 (Thu, 15 Oct 2015) $
-- $Author: hbergaue $
-- $Revision: 40100 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.gtl_pkg.all;

entity overlap_remover_condition_test_TB is
end overlap_remover_condition_test_TB;

architecture rtl of overlap_remover_condition_test_TB is

-- NOCH SINNVOLLE DATEN FÜR "jet_dr", "tau_dr" und "requirements" einbauen !!!

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant nr_calo1_delta_r_objects: positive := 2;
    constant et_ge_mode_calo1_delta_r: boolean := true;
    constant obj_type_calo1_delta_r: natural := TAU_TYPE;
    constant et_threshold_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0010";
    constant eta_full_range_calo1_delta_r: boolean := true;
    constant eta_w1_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_calo1_delta_r: boolean := true;
    constant eta_w2_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_calo1_delta_r: boolean := true;
    constant phi_w1_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_calo1_delta_r: boolean := true;
    constant phi_w2_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant iso_lut_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";

    constant nr_calo2_delta_r_objects: positive := 2;
    constant et_ge_mode_calo2_delta_r: boolean := true;
    constant obj_type_calo2_delta_r: natural := JET_TYPE;
    constant et_threshold_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_calo2_delta_r: boolean := true;
    constant eta_w1_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w1_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_ignore_calo2_delta_r: boolean := true;
    constant eta_w2_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_full_range_calo2_delta_r: boolean := true;
    constant phi_w1_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w1_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_ignore_calo2_delta_r: boolean := true;
    constant phi_w2_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant iso_lut_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";
    
    constant et_ge_mode_calo_inv_mass_1: boolean := true;
    constant et_threshold_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_calo_inv_mass_1: boolean := true;
    constant eta_w1_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w1_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_ignore_calo_inv_mass_1: boolean := true;
    constant eta_w2_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_full_range_calo_inv_mass_1: boolean := true;
    constant phi_w1_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w1_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_ignore_calo_inv_mass_1: boolean := true;
    constant phi_w2_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant iso_lut_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";
    
    constant et_ge_mode_calo_inv_mass_2: boolean := true;
    constant et_threshold_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0030";
    constant eta_full_range_calo_inv_mass_2: boolean := true;
    constant eta_w1_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w1_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_ignore_calo_inv_mass_2: boolean := true;
    constant eta_w2_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_full_range_calo_inv_mass_2: boolean := true;
    constant phi_w1_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w1_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_ignore_calo_inv_mass_2: boolean := true;
    constant phi_w2_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant iso_lut_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";
    
    constant dr_upper_limit : dr_squared_range_real := 0.0;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
    constant inv_mass_upper_limit : real := 13200.5;
    constant inv_mass_lower_limit : real := 13100.5;
        
-- ************************************************************************************************

    signal tau_dr, tau_dr_pipe: calo_objects_array(0 to nr_calo1_delta_r_objects-1) := (X"00000000", X"00000000");
    signal jet_dr, jet_dr_pipe, jet_dr_2, jet_inv_mass: calo_objects_array(0 to nr_calo2_delta_r_objects-1) := (X"00000000", X"00000000");

    signal jet_eta_integer: diff_integer_inputs_array(0 to nr_calo2_delta_r_objects-1) := (others => 0);
    signal jet_phi_integer: diff_integer_inputs_array(0 to nr_calo2_delta_r_objects-1) := (others => 0);
    signal jet_eta_integer_inv_mass: diff_integer_inputs_array(0 to nr_calo2_delta_r_objects-1) := (others => 0);
    signal jet_phi_integer_inv_mass: diff_integer_inputs_array(0 to nr_calo2_delta_r_objects-1) := (others => 0);
    signal tau_eta_integer: diff_integer_inputs_array(0 to nr_calo1_delta_r_objects-1) := (others => 0);
    signal tau_phi_integer: diff_integer_inputs_array(0 to nr_calo1_delta_r_objects-1) := (others => 0);

    signal diff_jet_tau_eta_integer : dim2_max_eta_range_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo1_delta_r_objects-1) := (others => (others => 0));      
    signal diff_jet_tau_phi_integer : dim2_max_phi_range_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo1_delta_r_objects-1) := (others => (others => 0));      
    signal diff_jet_jet_eta_integer_inv_mass : dim2_max_eta_range_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => 0));      
    signal diff_jet_jet_phi_integer_inv_mass : dim2_max_phi_range_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => 0));      
    signal diff_jet_tau_eta_vector: deta_dphi_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo1_delta_r_objects-1) := (others => (others => (others => '0')));
    signal diff_jet_tau_phi_vector: deta_dphi_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo1_delta_r_objects-1) := (others => (others => (others => '0')));
    signal diff_jet_jet_eta_vector_inv_mass: deta_dphi_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => (others => '0')));
    signal diff_jet_jet_phi_vector_inv_mass: deta_dphi_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => (others => '0')));

    signal jet_pt_vector: diff_inputs_array(0 to nr_calo2_delta_r_objects-1) := (others => (others => '0'));
    signal jet_jet_cosh_deta_vector: calo_cosh_cos_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => (others => '0')));
    signal jet_jet_cos_dphi_vector: calo_cosh_cos_vector_array(0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => (others => '0')));

    signal condition_o: std_logic;

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
        wait for 5 * LHC_CLK_PERIOD; 
        wait for 7 ns; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        tau_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        jet_dr <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, jet_dr)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           tau_dr_pipe <= tau_dr;
           jet_dr_pipe <= jet_dr;
           jet_dr_2 <= jet_dr_pipe;
           jet_inv_mass <= jet_dr_2;
        end if;
end process;

jet_l: for i in 0 to nr_calo2_delta_r_objects-1 generate
  jet_pt_vector(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_inv_mass(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
  jet_eta_integer(i) <= CONV_INTEGER(signed(jet_dr_pipe(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer(i) <= CONV_INTEGER(jet_dr_pipe(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
  jet_eta_integer_inv_mass(i) <= CONV_INTEGER(signed(jet_inv_mass(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_inv_mass(i) <= CONV_INTEGER(jet_inv_mass(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
end generate;

tau_l: for i in 0 to nr_calo1_delta_r_objects-1 generate
  tau_eta_integer(i) <= CONV_INTEGER(signed(tau_dr_pipe(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
  tau_phi_integer(i) <= CONV_INTEGER(tau_dr_pipe(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low));
end generate;

diff_jet_tau_eta_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(nr_calo2_delta_r_objects, nr_calo1_delta_r_objects)
  port map(jet_eta_integer, tau_eta_integer, diff_jet_tau_eta_integer);      
diff_jet_tau_phi_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(nr_calo2_delta_r_objects, nr_calo1_delta_r_objects, CALO_PHI_HALF_RANGE_BINS)
  port map(jet_phi_integer, tau_phi_integer, diff_jet_tau_phi_integer);      
jet_tau_l1: for i in 0 to nr_calo2_delta_r_objects-1 generate
  jet_tau_l2: for j in 0 to nr_calo1_delta_r_objects-1 generate
    diff_jet_tau_eta_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_ETA_LUT(diff_jet_tau_eta_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_jet_tau_phi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_PHI_LUT(diff_jet_tau_phi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate jet_tau_l2;
end generate jet_tau_l1;

diff_jet_jet_eta_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(nr_calo2_delta_r_objects, nr_calo2_delta_r_objects)
  port map(jet_eta_integer_inv_mass, jet_eta_integer_inv_mass, diff_jet_jet_eta_integer_inv_mass);      
diff_jet_jet_phi_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(nr_calo2_delta_r_objects, nr_calo2_delta_r_objects, CALO_PHI_HALF_RANGE_BINS)
  port map(jet_phi_integer_inv_mass, jet_phi_integer_inv_mass, diff_jet_jet_phi_integer_inv_mass);      
jet_jet_l1: for i in 0 to nr_calo2_delta_r_objects-1 generate
  jet_jet_l2: for j in 0 to nr_calo2_delta_r_objects-1 generate
    diff_jet_jet_eta_vector_inv_mass(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_DIFF_ETA_LUT(diff_jet_jet_eta_integer_inv_mass(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_jet_jet_phi_vector_inv_mass(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_DIFF_PHI_LUT(diff_jet_jet_phi_integer_inv_mass(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate jet_jet_l2;
end generate jet_jet_l1;

jet_jet_cosh_cos_l1: for i in 0 to nr_calo2_delta_r_objects-1 generate
  jet_jet_cosh_cos_l2: for j in 0 to nr_calo2_delta_r_objects-1 generate
    jet_jet_cosh_deta_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COSH_DETA_LUT(diff_jet_jet_eta_integer_inv_mass(i,j)), JET_JET_COSH_COS_VECTOR_WIDTH);
    jet_jet_cos_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COS_DPHI_LUT(diff_jet_jet_phi_integer_inv_mass(i,j)), JET_JET_COSH_COS_VECTOR_WIDTH);
  end generate jet_jet_cosh_cos_l2;
end generate jet_jet_cosh_cos_l1;

dut: entity work.overlap_remover_condition
     generic map(
        
        nr_calo1_delta_r_objects => nr_calo1_delta_r_objects,
        et_ge_mode_calo1_delta_r => et_ge_mode_calo1_delta_r,
        obj_type_calo1_delta_r => obj_type_calo1_delta_r,
        et_threshold_calo1_delta_r => et_threshold_calo1_delta_r,
        eta_full_range_calo1_delta_r => eta_full_range_calo1_delta_r,
        eta_w1_upper_limit_calo1_delta_r => eta_w1_upper_limit_calo1_delta_r,
        eta_w1_lower_limit_calo1_delta_r => eta_w1_lower_limit_calo1_delta_r,
        eta_w2_ignore_calo1_delta_r => eta_w2_ignore_calo1_delta_r,
        eta_w2_upper_limit_calo1_delta_r => eta_w2_upper_limit_calo1_delta_r,
        eta_w2_lower_limit_calo1_delta_r => eta_w2_lower_limit_calo1_delta_r,
        phi_full_range_calo1_delta_r => phi_full_range_calo1_delta_r,
        phi_w1_upper_limit_calo1_delta_r => phi_w1_upper_limit_calo1_delta_r,
        phi_w1_lower_limit_calo1_delta_r => phi_w1_lower_limit_calo1_delta_r,
        phi_w2_ignore_calo1_delta_r => phi_w2_ignore_calo1_delta_r,
        phi_w2_upper_limit_calo1_delta_r => phi_w2_upper_limit_calo1_delta_r,
        phi_w2_lower_limit_calo1_delta_r => phi_w2_lower_limit_calo1_delta_r,
	iso_lut_calo1_delta_r => iso_lut_calo1_delta_r,
--
        nr_calo2_delta_r_objects => nr_calo2_delta_r_objects,
        et_ge_mode_calo2_delta_r => et_ge_mode_calo2_delta_r,
        obj_type_calo2_delta_r => obj_type_calo2_delta_r,
        et_threshold_calo2_delta_r => et_threshold_calo2_delta_r,
        eta_full_range_calo2_delta_r => eta_full_range_calo2_delta_r,
        eta_w1_upper_limit_calo2_delta_r => eta_w1_upper_limit_calo2_delta_r,
        eta_w1_lower_limit_calo2_delta_r => eta_w1_lower_limit_calo2_delta_r,
        eta_w2_ignore_calo2_delta_r => eta_w2_ignore_calo2_delta_r,
        eta_w2_upper_limit_calo2_delta_r => eta_w2_upper_limit_calo2_delta_r,
        eta_w2_lower_limit_calo2_delta_r => eta_w2_lower_limit_calo2_delta_r,
        phi_full_range_calo2_delta_r => phi_full_range_calo2_delta_r,
        phi_w1_upper_limit_calo2_delta_r => phi_w1_upper_limit_calo2_delta_r,
        phi_w1_lower_limit_calo2_delta_r => phi_w1_lower_limit_calo2_delta_r,
        phi_w2_ignore_calo2_delta_r => phi_w2_ignore_calo2_delta_r,
        phi_w2_upper_limit_calo2_delta_r => phi_w2_upper_limit_calo2_delta_r,
        phi_w2_lower_limit_calo2_delta_r => phi_w2_lower_limit_calo2_delta_r,
	iso_lut_calo2_delta_r => iso_lut_calo2_delta_r,

	et_ge_mode_calo_inv_mass_1 => et_ge_mode_calo_inv_mass_1,
        et_threshold_calo_inv_mass_1 => et_threshold_calo_inv_mass_1,
        eta_full_range_calo_inv_mass_1 => eta_full_range_calo_inv_mass_1,
        eta_w1_upper_limit_calo_inv_mass_1 => eta_w1_upper_limit_calo_inv_mass_1,
        eta_w1_lower_limit_calo_inv_mass_1 => eta_w1_lower_limit_calo_inv_mass_1,
        eta_w2_ignore_calo_inv_mass_1 => eta_w2_ignore_calo_inv_mass_1,
        eta_w2_upper_limit_calo_inv_mass_1 => eta_w2_upper_limit_calo_inv_mass_1,
        eta_w2_lower_limit_calo_inv_mass_1 => eta_w2_lower_limit_calo_inv_mass_1,
        phi_full_range_calo_inv_mass_1 => phi_full_range_calo_inv_mass_1,
        phi_w1_upper_limit_calo_inv_mass_1 => phi_w1_upper_limit_calo_inv_mass_1,
        phi_w1_lower_limit_calo_inv_mass_1 => phi_w1_lower_limit_calo_inv_mass_1,
        phi_w2_ignore_calo_inv_mass_1 => phi_w2_ignore_calo_inv_mass_1,
        phi_w2_upper_limit_calo_inv_mass_1 => phi_w2_upper_limit_calo_inv_mass_1,
        phi_w2_lower_limit_calo_inv_mass_1 => phi_w2_lower_limit_calo_inv_mass_1,
	iso_lut_calo_inv_mass_1 => iso_lut_calo_inv_mass_1,
--
        et_ge_mode_calo_inv_mass_2 => et_ge_mode_calo_inv_mass_2,
        et_threshold_calo_inv_mass_2 => et_threshold_calo_inv_mass_2,
        eta_full_range_calo_inv_mass_2 => eta_full_range_calo_inv_mass_2,
        eta_w1_upper_limit_calo_inv_mass_2 => eta_w1_upper_limit_calo_inv_mass_2,
        eta_w1_lower_limit_calo_inv_mass_2 => eta_w1_lower_limit_calo_inv_mass_2,
        eta_w2_ignore_calo_inv_mass_2 => eta_w2_ignore_calo_inv_mass_2,
        eta_w2_upper_limit_calo_inv_mass_2 => eta_w2_upper_limit_calo_inv_mass_2,
        eta_w2_lower_limit_calo_inv_mass_2 => eta_w2_lower_limit_calo_inv_mass_2,
        phi_full_range_calo_inv_mass_2 => phi_full_range_calo_inv_mass_2,
        phi_w1_upper_limit_calo_inv_mass_2 => phi_w1_upper_limit_calo_inv_mass_2,
        phi_w1_lower_limit_calo_inv_mass_2 => phi_w1_lower_limit_calo_inv_mass_2,
        phi_w2_ignore_calo_inv_mass_2 => phi_w2_ignore_calo_inv_mass_2,
        phi_w2_upper_limit_calo_inv_mass_2 => phi_w2_upper_limit_calo_inv_mass_2,
        phi_w2_lower_limit_calo_inv_mass_2 => phi_w2_lower_limit_calo_inv_mass_2,
	iso_lut_calo_inv_mass_2 => iso_lut_calo_inv_mass_2,
--
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
--        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => JET_TAU_DETA_DPHI_PRECISION,

        inv_mass_upper_limit => inv_mass_upper_limit,
        inv_mass_lower_limit => inv_mass_lower_limit,

        INV_MASS_PRECISION => JET_JET_INV_MASS_PRECISION,
	pt_width => JET_PT_VECTOR_WIDTH,
	INV_MASS_COSH_COS_PRECISION => JET_JET_COSH_COS_PRECISION,
	cosh_cos_width => JET_JET_COSH_COS_VECTOR_WIDTH	
    )
    port map(
        lhc_clk => lhc_clk,
        calo1_delta_r => tau_dr_pipe,
        calo2_delta_r => jet_dr_pipe,
        calo_inv_mass => jet_inv_mass,
        diff_eta => diff_jet_tau_eta_vector,
        diff_phi => diff_jet_tau_phi_vector,
        pt => jet_pt_vector,
	cosh_deta => jet_jet_cosh_deta_vector,
        cos_dphi => jet_jet_cos_dphi_vector,
	condition_o => condition_o
    );

end rtl;

