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

use work.math_pkg.all;
use work.gtl_pkg.all;

entity overlap_remover_condition_test_TB is
end overlap_remover_condition_test_TB;

architecture rtl of overlap_remover_condition_test_TB is

-- NOCH SINNVOLLE DATEN FÜR "jet", "tau" und "requirements" einbauen !!!

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant remove_calo1_obj: boolean := true; -- calo1 for inv. mass (JET)
    constant INV_MASS_PRECISION : positive := JET_JET_INV_MASS_PRECISION;
    constant PT_VECTOR_WIDTH : positive := JET_PT_VECTOR_WIDTH;
    constant INV_MASS_COSH_COS_PRECISION : positive := JET_JET_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := JET_JET_COSH_COS_VECTOR_WIDTH;	

--     constant remove_calo1_obj: boolean := false; -- calo2 for inv. mass (TAU)
--     constant INV_MASS_PRECISION : positive := TAU_TAU_INV_MASS_PRECISION;
--     constant PT_VECTOR_WIDTH : positive := TAU_PT_VECTOR_WIDTH;
--     constant INV_MASS_COSH_COS_PRECISION : positive := TAU_TAU_COSH_COS_PRECISION;
--     constant COSH_COS_VECTOR_WIDTH : positive := TAU_TAU_COSH_COS_VECTOR_WIDTH;	

    constant nr_calo1_delta_r_objects: positive := 3;
    constant et_ge_mode_calo1_delta_r: boolean := true;
    constant obj_type_calo1_delta_r: natural := JET_TYPE;
    constant et_threshold_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0020";
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
    constant obj_type_calo2_delta_r: natural := TAU_TYPE;
    constant et_threshold_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0010";
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
    
    constant nr_calo_inv_mass_objects: positive := 3;
    constant obj_type_calo_inv_mass: natural := JET_TYPE;
    
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
    
    constant dr_upper_limit : dr_squared_range_real := 1.0;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
    constant inv_mass_upper_limit : real := 200.1;
    constant inv_mass_lower_limit : real := 3.0;
        
-- ************************************************************************************************

    signal tau, tau_bx_p2, tau_temp, tau_bx_0: calo_objects_array(0 to NR_TAU_OBJECTS-1) := (others => X"00000000");
    signal jet, jet_bx_p2, jet_temp, jet_bx_0: calo_objects_array(0 to NR_JET_OBJECTS-1) := (others => X"00000000");
    signal calo_inv_mass_bx0: calo_objects_array(0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1) := (others => X"00000000");

    signal jet_eta_integer_bx_p2: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_phi_integer_bx_p2: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal tau_eta_integer_bx_p2: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_phi_integer_bx_p2: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);

    signal diff_jet_tau_eta_integer_bx_p2_bx_p2 : dim2_max_eta_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_tau_phi_integer_bx_p2_bx_p2 : dim2_max_phi_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_jet_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_jet_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_tau_eta_vector_bx_p2_bx_p2: deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal diff_jet_tau_phi_vector_bx_p2_bx_p2: deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal diff_tau_tau_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_tau_tau_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      

    signal jet_pt_vector_bx_0: diff_inputs_array(0 to NR_JET_OBJECTS-1) := (others => (others => '0'));
    signal jet_jet_cosh_deta_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal jet_jet_cos_dphi_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal tau_pt_vector_bx_0: diff_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => (others => '0'));
    signal tau_tau_cosh_deta_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal tau_tau_cos_dphi_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal pt_vector_bx_0: diff_inputs_array(0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1) := (others => (others => '0'));
    signal cosh_deta_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1, 0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1) := (others => (others => (others => '0')));
    signal cos_dphi_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1, 0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1) := (others => (others => (others => '0')));

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
        tau <= (("00000"&"00"&X"00"&X"00"&('0'&X"35")), ("00000"&"00"&X"88"&X"31"&('0'&X"33")), others => X"00000000");
        jet <= (("00000"&X"00"&X"01"&("000"&X"38")), ("00000"&X"40"&X"30"&("000"&X"30")), ("00000"&X"42"&X"31"&("000"&X"31")), others => X"00000000");
        wait for LHC_CLK_PERIOD; 
        tau <= (("00000"&"00"&X"02"&X"02"&('0'&X"30")), ("00000"&"00"&X"01"&X"01"&('0'&X"30")), others => X"00000000");
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, tau, jet)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           tau_bx_p2 <= tau;
           tau_temp <= tau_bx_p2;
           tau_bx_0 <= tau_temp;
           jet_bx_p2 <= jet;
           jet_temp <= jet_bx_p2;
           jet_bx_0 <= jet_temp;
        end if;
end process;

remove_calo1_obj_true: if remove_calo1_obj generate
    calo_inv_mass_bx0(0 to NR_JET_OBJECTS-1) <= jet_bx_0;
    pt_vector_bx_0(0 to NR_JET_OBJECTS-1) <= jet_pt_vector_bx_0;
--     cosh_deta_vector_bx_0_bx_0 <= jet_jet_cosh_deta_vector_bx_0_bx_0;
--     cos_dphi_vector_bx_0_bx_0 <= jet_jet_cos_dphi_vector_bx_0_bx_0;
end generate;

remove_calo1_obj_false: if not remove_calo1_obj generate
    calo_inv_mass_bx0(0 to NR_TAU_OBJECTS-1) <= tau_bx_0;
    pt_vector_bx_0(0 to NR_TAU_OBJECTS-1) <= tau_pt_vector_bx_0;
--     cosh_deta_vector_bx_0_bx_0 <= tau_tau_cosh_deta_vector_bx_0_bx_0;
--     cos_dphi_vector_bx_0_bx_0 <= tau_tau_cos_dphi_vector_bx_0_bx_0;
end generate;

jet_l: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_pt_vector_bx_0(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
  jet_eta_integer_bx_p2(i) <= CONV_INTEGER(signed(jet_bx_p2(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_bx_p2(i) <= CONV_INTEGER(jet_bx_p2(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
  jet_eta_integer_bx_0(i) <= CONV_INTEGER(signed(jet_bx_0(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_bx_0(i) <= CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
end generate;

tau_l: for i in 0 to NR_TAU_OBJECTS-1 generate
  tau_pt_vector_bx_0(i)(TAU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.et_high downto D_S_I_TAU_V2.et_low))), TAU_PT_VECTOR_WIDTH);
  tau_eta_integer_bx_p2(i) <= CONV_INTEGER(signed(tau_bx_p2(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
  tau_phi_integer_bx_p2(i) <= CONV_INTEGER(tau_bx_p2(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low));
  tau_eta_integer_bx_0(i) <= CONV_INTEGER(signed(tau_bx_0(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
  tau_phi_integer_bx_0(i) <= CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low));
end generate;

diff_jet_tau_eta_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_TAU_OBJECTS)
  port map(jet_eta_integer_bx_p2, tau_eta_integer_bx_p2, diff_jet_tau_eta_integer_bx_p2_bx_p2);      
diff_jet_tau_phi_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_TAU_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
  port map(jet_phi_integer_bx_p2, tau_phi_integer_bx_p2, diff_jet_tau_phi_integer_bx_p2_bx_p2);

jet_jet_l1: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_tau_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    diff_jet_tau_eta_vector_bx_p2_bx_p2(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_ETA_LUT(diff_jet_tau_eta_integer_bx_p2_bx_p2(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_jet_tau_phi_vector_bx_p2_bx_p2(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_PHI_LUT(diff_jet_tau_phi_integer_bx_p2_bx_p2(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate jet_tau_l2;
end generate jet_jet_l1;

diff_jet_jet_eta_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_JET_OBJECTS)
  port map(jet_eta_integer_bx_0, jet_eta_integer_bx_0, diff_jet_jet_eta_integer_bx_0_bx_0);      
diff_jet_jet_phi_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_JET_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
  port map(jet_phi_integer_bx_0, jet_phi_integer_bx_0, diff_jet_jet_phi_integer_bx_0_bx_0);      

jet_jet_cosh_cos_l1: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_jet_cosh_cos_l2: for j in 0 to NR_JET_OBJECTS-1 generate
    jet_jet_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COSH_DETA_LUT(diff_jet_jet_eta_integer_bx_0_bx_0(i,j)), JET_JET_COSH_COS_VECTOR_WIDTH);
    jet_jet_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COS_DPHI_LUT(diff_jet_jet_phi_integer_bx_0_bx_0(i,j)), JET_JET_COSH_COS_VECTOR_WIDTH);
  end generate jet_jet_cosh_cos_l2;
end generate jet_jet_cosh_cos_l1;

diff_tau_tau_eta_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(NR_TAU_OBJECTS, NR_TAU_OBJECTS)
  port map(tau_eta_integer_bx_0, tau_eta_integer_bx_0, diff_tau_tau_eta_integer_bx_0_bx_0);      
diff_tau_tau_phi_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(NR_TAU_OBJECTS, NR_TAU_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
  port map(tau_phi_integer_bx_0, tau_phi_integer_bx_0, diff_tau_tau_phi_integer_bx_0_bx_0);      

tau_tau_cosh_cos_l1: for i in 0 to NR_TAU_OBJECTS-1 generate
  tau_tau_cosh_cos_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    tau_tau_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_COSH_DETA_LUT(diff_tau_tau_eta_integer_bx_0_bx_0(i,j)), TAU_TAU_COSH_COS_VECTOR_WIDTH);
    tau_tau_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_COS_DPHI_LUT(diff_tau_tau_phi_integer_bx_0_bx_0(i,j)), TAU_TAU_COSH_COS_VECTOR_WIDTH);
  end generate tau_tau_cosh_cos_l2;
end generate tau_tau_cosh_cos_l1;

dut: entity work.overlap_remover_condition
     generic map(
        
        remove_calo1_obj => remove_calo1_obj, -- "true" removes objects of calo1 inputs, "false" removes objects of calo2 inputs

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

	nr_calo_inv_mass_objects => nr_calo_inv_mass_objects,
        obj_type_calo_inv_mass => obj_type_calo_inv_mass,

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

        INV_MASS_PRECISION => INV_MASS_PRECISION,
	pt_width => PT_VECTOR_WIDTH,
	INV_MASS_COSH_COS_PRECISION => INV_MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH	

    )
    port map(
        lhc_clk => lhc_clk,
        calo1_delta_r => jet_bx_p2,
        calo2_delta_r => tau_bx_p2,
        calo_inv_mass => calo_inv_mass_bx0,
        diff_eta => diff_jet_tau_eta_vector_bx_p2_bx_p2,
        diff_phi => diff_jet_tau_phi_vector_bx_p2_bx_p2,
        pt => pt_vector_bx_0,
	cosh_deta => jet_jet_cosh_deta_vector_bx_0_bx_0,
        cos_dphi => jet_jet_cos_dphi_vector_bx_0_bx_0,
-- 	cosh_deta => tau_tau_cosh_deta_vector_bx_0_bx_0,
--         cos_dphi => tau_tau_cos_dphi_vector_bx_0_bx_0,
	condition_o => condition_o
    );

end rtl;

