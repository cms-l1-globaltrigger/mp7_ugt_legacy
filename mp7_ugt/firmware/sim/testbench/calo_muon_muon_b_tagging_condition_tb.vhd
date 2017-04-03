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

entity calo_muon_muon_b_tagging_condition_TB is
end calo_muon_muon_b_tagging_condition_TB;

architecture rtl of calo_muon_muon_b_tagging_condition_TB is

    constant LHC_CLK_PERIOD  : time :=  24 ns;

    signal lhc_clk : std_logic;
    
--     constant TAU_ETA_SCALE_NON_LINEAR : boolean := false;
--     constant deta_cut : boolean := false;
--     constant dphi_cut : boolean := false;
    constant dr_cut : boolean := true;
    
    constant obj_type_calo : natural := JET_TYPE;
    constant calo_object_low : natural := 0;
    constant calo_object_high : natural := 1;
    constant nr_calo_objects : natural := calo_object_high-calo_object_low+1;
    constant et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0010";
    constant eta_full_range_calo : boolean := true;
    constant eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_calo : boolean := true;
    constant eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_calo : boolean := true;
    constant phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_calo : boolean := true;
    constant phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := X"F";

    constant muon_object_low : natural := 0;
    constant muon_object_high : natural := 2;
    constant nr_muon_objects : natural := muon_object_high-muon_object_low+1;
    constant pt_threshold_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_muon_1: boolean := true;
    constant eta_w1_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_muon_1: boolean := true;
    constant eta_w2_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_muon_1: boolean := true;
    constant phi_w1_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_muon_1: boolean := true;
    constant phi_w2_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant requested_charge_muon_1: string(1 to 3) := "pos";
    constant qual_lut_muon_1: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon_1: std_logic_vector(3 downto 0) := X"F";

    constant pt_threshold_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0030";
    constant eta_full_range_muon_2: boolean := true;
    constant eta_w1_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_muon_2: boolean := true;
    constant eta_w2_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_muon_2: boolean := true;
    constant phi_w1_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_muon_2: boolean := true;
    constant phi_w2_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant requested_charge_muon_2: string(1 to 3) := "neg";
    constant qual_lut_muon_2: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon_2: std_logic_vector(3 downto 0) := X"F";

    constant diff_eta_upper_limit: real := 0.0;
    constant diff_eta_lower_limit: real := 0.0;
--        
    constant diff_phi_upper_limit: real := 0.0;
    constant diff_phi_lower_limit: real := 0.0;
--        
--     constant dr_upper_limit : dr_squared_range_real := 5.2;
--     constant dr_lower_limit : dr_squared_range_real := 4.5;
    constant dr_upper_limit : dr_squared_range_real := 1.2;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
-- ************************************************************************************************

    signal jet_bx_0: calo_objects_array(0 to nr_calo_objects-1) := (others =>  X"00000000");
    signal jet_bx_0_ff: calo_objects_array(0 to nr_calo_objects-1);
    signal jet_eta_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal jet_phi_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal muon_bx_0: muon_objects_array(0 to nr_muon_objects-1) := (others => X"0000000000000000");
    signal muon_bx_0_ff: muon_objects_array(0 to nr_muon_objects-1);
    signal muon_phi_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal muon_eta_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal diff_jet_muon_eta_bins_bx_0: diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_jet_muon_phi_bins_bx_0: diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal jet_eta_jet_muon_bx_0 : diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal jet_phi_jet_muon_bx_0 : diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal muon_eta_jet_muon_bx_0 : diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal muon_phi_jet_muon_bx_0 : diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
 
    signal jet_eta_value_bx_0 : diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_phi_value_bx_0 : diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal muon_eta_value_bx_0 : diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal muon_phi_value_bx_0 : diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal diff_jet_muon_eta_integer_value_bx_0_bx_0 : diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1);      
    signal diff_jet_muon_phi_integer_value_bx_0_bx_0 : diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1);      

    signal mu_pt_vector_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal mu_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal jet_pt_vector_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal jet_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_eta_conv_2_muon_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_phi_conv_2_muon_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal diff_jet_mu_bx_0_bx_0_phi_integer: dim2_max_phi_range_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_jet_mu_bx_0_bx_0_phi_vector: deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal diff_jet_mu_bx_0_bx_0_eta_integer: dim2_max_eta_range_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_jet_mu_bx_0_bx_0_eta_vector: deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));

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
--                     spare  iso   phi   eta       et
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"0F")));
--         jet_bx_0 <= (("00000"&"00"&X"88"&X"90"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"0F")));
--                        spare    ch  iso       eta    qual      et          phi
        muon_bx_0 <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("01"&X"ff")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("00"&X"01")));
--         muon_bx_0 <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("01"&X"ff")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('1'&X"00")&X"0"&('0'&X"20")&("00"&X"01")), (X"0000000"&"00"&"00"&('1'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        jet_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
data_in_ff_p: process(lhc_clk, jet_bx_0, muon_bx_0)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           jet_bx_0_ff <= jet_bx_0;
           muon_bx_0_ff <= muon_bx_0;
        end if;
end process;

mu_data_bx_0_l: for i in 0 to nr_muon_objects-1 generate
    mu_pt_vector_bx_0(i)(MU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(muon_bx_0_ff(i)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low))), MU_PT_VECTOR_WIDTH);
    mu_eta_integer_bx_0(i) <= CONV_INTEGER(signed(muon_bx_0_ff(i)(D_S_I_MU_V2.eta_high downto D_S_I_MU_V2.eta_low)));
    mu_phi_integer_bx_0(i) <= CONV_INTEGER(muon_bx_0_ff(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
end generate;
jet_data_bx_0_l: for i in 0 to nr_calo_objects-1 generate
    jet_pt_vector_bx_0(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_bx_0_ff(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
    jet_eta_integer_bx_0(i) <= CONV_INTEGER(signed(jet_bx_0_ff(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
    jet_phi_integer_bx_0(i) <= CONV_INTEGER(jet_bx_0_ff(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
end generate;

jet_conv_2_muon_bx_0_l: for i in 0 to nr_calo_objects-1 generate
    jet_eta_conv_2_muon_eta_integer_bx_0(i) <= JET_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(jet_bx_0_ff(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
    jet_phi_conv_2_muon_phi_integer_bx_0(i) <= JET_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(jet_bx_0_ff(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
end generate;

diff_jet_mu_eta_bx_0_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
    generic map(nr_calo_objects, nr_muon_objects)
    port map(jet_eta_conv_2_muon_eta_integer_bx_0, mu_eta_integer_bx_0, diff_jet_mu_bx_0_bx_0_eta_integer);
diff_jet_mu_phi_bx_0_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(nr_calo_objects, nr_muon_objects, MUON_PHI_HALF_RANGE_BINS)
    port map(jet_phi_conv_2_muon_phi_integer_bx_0, mu_phi_integer_bx_0, diff_jet_mu_bx_0_bx_0_phi_integer);
jet_mu_bx_0_bx_0_l1: for i in 0 to nr_calo_objects-1 generate
    jet_mu_bx_0_bx_0_l2: for j in 0 to nr_muon_objects-1 generate
        diff_jet_mu_bx_0_bx_0_eta_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_MU_DIFF_ETA_LUT(diff_jet_mu_bx_0_bx_0_eta_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        diff_jet_mu_bx_0_bx_0_phi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_MU_DIFF_PHI_LUT(diff_jet_mu_bx_0_bx_0_phi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    end generate jet_mu_bx_0_bx_0_l2;
end generate jet_mu_bx_0_bx_0_l1;

dut: entity work.calo_muon_muon_b_tagging_condition
     generic map(
        dr_cut => dr_cut,
        
        calo_object_low => calo_object_low,
        calo_object_high => calo_object_high,
        et_ge_mode_calo => true,
        obj_type_calo => obj_type_calo,
        et_threshold_calo => et_threshold_calo,
        eta_full_range_calo => eta_full_range_calo,
        eta_w1_upper_limit_calo => eta_w1_upper_limit_calo,
        eta_w1_lower_limit_calo => eta_w1_lower_limit_calo,
        eta_w2_ignore_calo => eta_w2_ignore_calo,
        eta_w2_upper_limit_calo => eta_w2_upper_limit_calo,
        eta_w2_lower_limit_calo => eta_w2_lower_limit_calo,
        phi_full_range_calo => phi_full_range_calo,
        phi_w1_upper_limit_calo => phi_w1_upper_limit_calo,
        phi_w1_lower_limit_calo => phi_w1_lower_limit_calo,
        phi_w2_ignore_calo => phi_w2_ignore_calo,
        phi_w2_upper_limit_calo => phi_w2_upper_limit_calo,
        phi_w2_lower_limit_calo => phi_w2_lower_limit_calo,
	iso_lut_calo => iso_lut_calo,
--
        muon_object_low => muon_object_low,
        muon_object_high => muon_object_high,
        pt_ge_mode_muon_1 => true,
        pt_threshold_muon_1 => pt_threshold_muon_1,
        eta_full_range_muon_1 => eta_full_range_muon_1,
        eta_w1_upper_limit_muon_1 => eta_w1_upper_limit_muon_1,
        eta_w1_lower_limit_muon_1 => eta_w1_lower_limit_muon_1,
        eta_w2_ignore_muon_1 => eta_w2_ignore_muon_1,
        eta_w2_upper_limit_muon_1 => eta_w2_upper_limit_muon_1,
        eta_w2_lower_limit_muon_1 => eta_w2_lower_limit_muon_1,
        phi_full_range_muon_1 => phi_full_range_muon_1,
        phi_w1_upper_limit_muon_1 => phi_w1_upper_limit_muon_1,
        phi_w1_lower_limit_muon_1 => phi_w1_lower_limit_muon_1,
        phi_w2_ignore_muon_1 => phi_w2_ignore_muon_1,
        phi_w2_upper_limit_muon_1 => phi_w2_upper_limit_muon_1,
        phi_w2_lower_limit_muon_1 => phi_w2_lower_limit_muon_1,
        requested_charge_muon_1 => requested_charge_muon_1,
        qual_lut_muon_1 => qual_lut_muon_1,
        iso_lut_muon_1 => iso_lut_muon_1,
--
        pt_ge_mode_muon_2 => true,
        pt_threshold_muon_2 => pt_threshold_muon_2,
        eta_full_range_muon_2 => eta_full_range_muon_2,
        eta_w1_upper_limit_muon_2 => eta_w1_upper_limit_muon_2,
        eta_w1_lower_limit_muon_2 => eta_w1_lower_limit_muon_2,
        eta_w2_ignore_muon_2 => eta_w2_ignore_muon_2,
        eta_w2_upper_limit_muon_2 => eta_w2_upper_limit_muon_2,
        eta_w2_lower_limit_muon_2 => eta_w2_lower_limit_muon_2,
        phi_full_range_muon_2 => phi_full_range_muon_2,
        phi_w1_upper_limit_muon_2 => phi_w1_upper_limit_muon_2,
        phi_w1_lower_limit_muon_2 => phi_w1_lower_limit_muon_2,
        phi_w2_ignore_muon_2 => phi_w2_ignore_muon_2,
        phi_w2_upper_limit_muon_2 => phi_w2_upper_limit_muon_2,
        phi_w2_lower_limit_muon_2 => phi_w2_lower_limit_muon_2,
        requested_charge_muon_2 => requested_charge_muon_2,
        qual_lut_muon_2 => qual_lut_muon_2,
        iso_lut_muon_2 => iso_lut_muon_2,
--        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => JET_MUON_DETA_DPHI_PRECISION
    )
    port map(
        lhc_clk => lhc_clk,
        calo_data_i => jet_bx_0_ff,
        muon_data_i => muon_bx_0_ff,
        diff_eta => diff_jet_mu_bx_0_bx_0_eta_vector,
        diff_phi => diff_jet_mu_bx_0_bx_0_phi_vector,
	condition_o => open
    );

end rtl;

