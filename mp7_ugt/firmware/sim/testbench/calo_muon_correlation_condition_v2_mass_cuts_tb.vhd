
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_muon_correlation_condition_v2_mass_cuts_TB is
end calo_muon_correlation_condition_v2_mass_cuts_TB;

architecture rtl of calo_muon_correlation_condition_v2_mass_cuts_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
--     constant same_bx : boolean := true;
    
    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := false;
    constant mass_cut : boolean := true;
    constant mass_type : natural := INVARIANT_MASS_TYPE;
--     constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := false;
    
    constant MASS_PRECISION : positive := JET_MU_MASS_PRECISION;
    constant PT1_VECTOR_WIDTH : positive := JET_PT_VECTOR_WIDTH;
    constant PT2_VECTOR_WIDTH : positive := MU_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := JET_MU_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := JET_MU_COSH_COS_VECTOR_WIDTH;	

    constant calo_object_low: natural := 0;
    constant calo_object_high: natural := 2;
    constant nr_calo_objects: natural := calo_object_high-calo_object_low+1;
    constant et_ge_mode_calo: boolean := true;
    constant obj_type_calo: natural := JET_TYPE;
    constant et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_calo: boolean := true;
    constant eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_calo: boolean := true;
    constant eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_calo: boolean := true;
    constant phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_calo: boolean := true;
    constant phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := X"F";

    constant muon_object_low: natural := 0;
    constant muon_object_high: natural := 2;
    constant nr_muon_objects: natural := muon_object_high-muon_object_low+1;
    constant pt_ge_mode_muon: boolean := true;
    constant pt_threshold_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_muon: boolean := true;
    constant eta_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_muon: boolean := true;
    constant eta_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_muon: boolean := true;
    constant phi_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_muon: boolean := true;
    constant phi_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant requested_charge_muon: string(1 to 3) := "ign";
    constant qual_lut_muon: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon: std_logic_vector(3 downto 0) := X"F";

    constant dr_upper_limit : dr_squared_range_real := 1.0;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
    constant mass_upper_limit : real := 200.1;
    constant mass_lower_limit : real := 1.0;

    constant pt_sq_threshold : real := 1100.0;
        
-- ************************************************************************************************

    signal jet, jet_bx_0: calo_objects_array(0 to nr_calo_objects-1) := (others => X"00000000");
    signal muon, mu_bx_0: muon_objects_array(0 to nr_muon_objects-1) := (others => X"0000000000000000");

    signal mu_pt_vector_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal mu_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_cos_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_sin_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);
    signal jet_pt_vector_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal jet_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_eta_conv_2_muon_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_phi_conv_2_muon_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_cos_phi_bx_0: calo_sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
    signal jet_sin_phi_bx_0: calo_sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
    signal conv_jet_cos_phi_bx_0: muon_sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
    signal conv_jet_sin_phi_bx_0: muon_sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
    signal diff_jet_mu_bx_0_bx_0_phi_integer: dim2_max_phi_range_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_jet_mu_bx_0_bx_0_phi_vector: deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal diff_jet_mu_bx_0_bx_0_eta_integer: dim2_max_eta_range_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_jet_mu_bx_0_bx_0_eta_vector: deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal jet_mu_cosh_deta_vector_bx_0_bx_0: calo_muon_cosh_cos_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal jet_mu_cos_dphi_vector_bx_0_bx_0: calo_muon_cosh_cos_vector_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));

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
        jet <= (("00000"&X"00"&X"01"&("000"&X"38")), ("00000"&X"40"&X"30"&("000"&X"11")), ("00000"&X"42"&X"31"&("000"&X"11")), others => X"00000000");
--         muon <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("01"&X"ff")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("00"&X"01")));
        muon <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")));
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"00"&X"01"&("000"&X"38")), ("00000"&X"40"&X"30"&("000"&X"30")), ("00000"&X"42"&X"31"&("000"&X"31")), others => X"00000000");
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")));
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        muon <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("01"&X"ff")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, muon)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           jet_bx_0 <= jet;
           mu_bx_0 <= muon;
        end if;
end process;

jet_l: for i in 0 to nr_calo_objects-1 generate
  jet_pt_vector_bx_0(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
  jet_eta_integer_bx_0(i) <= CONV_INTEGER(signed(jet_bx_0(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_bx_0(i) <= CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
  jet_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
  jet_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
  conv_jet_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(jet_phi_conv_2_muon_phi_integer_bx_0(i));
  conv_jet_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(jet_phi_conv_2_muon_phi_integer_bx_0(i));
end generate;

mu_l: for i in 0 to nr_muon_objects-1 generate
  mu_pt_vector_bx_0(i)(MU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low))), MU_PT_VECTOR_WIDTH);
  mu_eta_integer_bx_0(i) <= CONV_INTEGER(signed(mu_bx_0(i)(D_S_I_MU_V2.eta_high downto D_S_I_MU_V2.eta_low)));
  mu_phi_integer_bx_0(i) <= CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
  mu_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
  mu_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
end generate;

jet_conv_2_muon_bx_0_l: for i in 0 to nr_calo_objects-1 generate
    jet_eta_conv_2_muon_eta_integer_bx_0(i) <= JET_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
    jet_phi_conv_2_muon_phi_integer_bx_0(i) <= JET_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
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

jet_mu_cosh_cos_l1: for i in 0 to nr_calo_objects-1 generate
  jet_mu_cosh_cos_l2: for j in 0 to nr_muon_objects-1 generate
    jet_mu_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_MU_COSH_DETA_LUT(diff_jet_mu_bx_0_bx_0_eta_integer(i,j)), JET_MU_COSH_COS_VECTOR_WIDTH);
    jet_mu_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_MU_COS_DPHI_LUT(diff_jet_mu_bx_0_bx_0_phi_integer(i,j)), JET_MU_COSH_COS_VECTOR_WIDTH);
  end generate jet_mu_cosh_cos_l2;
end generate jet_mu_cosh_cos_l1;

dut: entity work.calo_muon_correlation_condition_v2
     generic map(
        
        deta_cut => deta_cut,
        dphi_cut => dphi_cut,
        dr_cut => dr_cut,
        mass_cut => mass_cut,
        mass_type => mass_type,
	twobody_pt_cut => twobody_pt_cut,

        calo_object_low => calo_object_low,
        calo_object_high => calo_object_high,
        et_ge_mode_calo => et_ge_mode_calo,
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
        pt_ge_mode_muon => pt_ge_mode_muon,
        pt_threshold_muon => pt_threshold_muon,
        eta_full_range_muon => eta_full_range_muon,
        eta_w1_upper_limit_muon => eta_w1_upper_limit_muon,
        eta_w1_lower_limit_muon => eta_w1_lower_limit_muon,
        eta_w2_ignore_muon => eta_w2_ignore_muon,
        eta_w2_upper_limit_muon => eta_w2_upper_limit_muon,
        eta_w2_lower_limit_muon => eta_w2_lower_limit_muon,
        phi_full_range_muon => phi_full_range_muon,
        phi_w1_upper_limit_muon => phi_w1_upper_limit_muon,
        phi_w1_lower_limit_muon => phi_w1_lower_limit_muon,
        phi_w2_ignore_muon => phi_w2_ignore_muon,
        phi_w2_upper_limit_muon => phi_w2_upper_limit_muon,
        phi_w2_lower_limit_muon => phi_w2_lower_limit_muon,
        requested_charge_muon => requested_charge_muon,
        qual_lut_muon => qual_lut_muon,
	iso_lut_muon => iso_lut_muon,
--
	diff_eta_upper_limit => 0.0,
        diff_eta_lower_limit => 0.0, 

        diff_phi_upper_limit => 0.0, 
        diff_phi_lower_limit => 0.0, 
        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
--        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => JET_MUON_DETA_DPHI_PRECISION,

        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt1_width => PT1_VECTOR_WIDTH,
	pt2_width => PT2_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	
        -- generics for pt**2
        pt_sq_threshold => pt_sq_threshold, 
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => JET_MU_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => JET_MU_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        calo_data_i => jet_bx_0,
        muon_data_i => mu_bx_0,
        diff_eta => diff_jet_mu_bx_0_bx_0_eta_vector,
        diff_phi => diff_jet_mu_bx_0_bx_0_phi_vector,
        pt1 => jet_pt_vector_bx_0,
        pt2 => mu_pt_vector_bx_0,
	cosh_deta => jet_mu_cosh_deta_vector_bx_0_bx_0,
	cos_dphi => jet_mu_cos_dphi_vector_bx_0_bx_0,
        cos_phi_1_integer => conv_jet_cos_phi_bx_0, 
        cos_phi_2_integer => mu_cos_phi_bx_0, 
        sin_phi_1_integer => conv_jet_sin_phi_bx_0, 
        sin_phi_2_integer => mu_sin_phi_bx_0,
	condition_o => condition_o
    );

end rtl;

