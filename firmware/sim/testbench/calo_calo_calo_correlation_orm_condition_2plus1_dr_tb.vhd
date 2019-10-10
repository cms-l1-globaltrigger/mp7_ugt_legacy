
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_calo_correlation_orm_condition_2plus1_dr_TB is
end calo_calo_calo_correlation_orm_condition_2plus1_dr_TB;

architecture rtl of calo_calo_calo_correlation_orm_condition_2plus1_dr_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant deta_orm_cut : boolean := false;
    constant dphi_orm_cut : boolean := false;
    constant dr_orm_cut : boolean := true;
    
    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := true;
--     constant dr_cut : boolean := false;
    constant mass_cut : boolean := false;
--     constant mass_cut : boolean := true;
    constant mass_type : natural := INVARIANT_MASS_TYPE;
--     constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := false;
--     
    constant MASS_PRECISION : positive := JET_JET_MASS_PRECISION;
    constant PT_VECTOR_WIDTH : positive := JET_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := JET_JET_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := JET_JET_COSH_COS_VECTOR_WIDTH;	

    constant calo1_object_low : natural := 0;
    constant calo1_object_high : natural := 11;
    constant nr_calo1_objects : natural := calo1_object_high-calo1_object_low+1;
    constant et_ge_mode_calo1: boolean := true;
    constant obj_type_calo1: natural := TAU_TYPE;
    constant et_thresholds_calo1: calo_templates_array := (X"0028", X"0028", X"0000", X"0000");
--     constant et_thresholds_calo1: calo_templates_array := (X"001E", X"001E", X"0000", X"0000");
    constant eta_full_range_calo1: calo_templates_boolean_array := (true, true, false, false);
    constant eta_w1_upper_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant eta_w1_lower_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant eta_w2_ignore_calo1: calo_templates_boolean_array := (true, true, false, false);
    constant eta_w2_upper_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant eta_w2_lower_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant phi_full_range_calo1: calo_templates_boolean_array := (true, true, false, false);
    constant phi_w1_upper_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant phi_w1_lower_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant phi_w2_ignore_calo1: calo_templates_boolean_array := (true, true, false, false);
    constant phi_w2_upper_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant phi_w2_lower_limits_calo1: calo_templates_array := (X"0000", X"0000", X"0000", X"0000");
    constant iso_luts_calo1: calo_templates_iso_array := (X"F", X"F", X"0", X"0");

    constant calo2_object_low : natural := 0;
    constant calo2_object_high : natural := 11;
    constant nr_calo2_objects : natural := calo2_object_high-calo2_object_low+1;
    constant et_ge_mode_calo2: boolean := true;
    constant obj_type_calo2: natural := JET_TYPE;
    constant et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"00C8";
    constant eta_full_range_calo2: boolean := true;
    constant eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_ignore_calo2: boolean := true;
    constant eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_full_range_calo2: boolean := true;
    constant phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_ignore_calo2: boolean := true;
    constant phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := X"F";
        
    constant dr_orm_upper_limit : dr_squared_range_real := 0.041;
    constant dr_orm_lower_limit : dr_squared_range_real := 0.0;
                
    constant dr_upper_limit : dr_squared_range_real := 10000.0;
    constant dr_lower_limit : dr_squared_range_real := 0.04;
        
    constant mass_upper_limit : real := 98000000.0;
    constant mass_lower_limit : real := 5000.0;
        
-- ************************************************************************************************

    signal tau, tau_bx_0: calo_objects_array(0 to NR_TAU_OBJECTS-1) := (others => X"00000000");
    signal jet, jet_bx_0: calo_objects_array(0 to NR_JET_OBJECTS-1) := (others => X"00000000");

    signal jet_eta_integer_bx_0: diff_integer_inputs_array(calo2_object_low to calo2_object_high) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(calo2_object_low to calo2_object_high) := (others => 0);
    signal tau_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);

    signal diff_tau_jet_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => 0));      
    signal diff_tau_jet_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => 0));      
    signal diff_tau_tau_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_tau_tau_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_tau_jet_eta_vector_bx_0_bx_0: deta_dphi_vector_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => (others => '0')));
    signal diff_tau_jet_phi_vector_bx_0_bx_0: deta_dphi_vector_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => (others => '0')));
    signal diff_tau_tau_eta_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));      
    signal diff_tau_tau_phi_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));      

    signal jet_pt_vector_bx_0: diff_inputs_array(0 to NR_JET_OBJECTS-1) := (others => (others => '0'));
    signal tau_pt_vector_bx_0: diff_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => (others => '0'));
    signal tau_tau_cosh_deta_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal tau_tau_cos_dphi_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_TAU_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));
    signal jet_cos_phi_bx_0: calo_sin_cos_integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_sin_phi_bx_0: calo_sin_cos_integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal tau_cos_phi_bx_0: calo_sin_cos_integer_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_sin_phi_bx_0: calo_sin_cos_integer_array(0 to NR_TAU_OBJECTS-1) := (others => 0);

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
        wait for LHC_CLK_PERIOD; 
        wait for 7 ns; 
-- 	jet <= (X"01c8a8a9",X"0060a895",X"04610880",X"02e0185c",X"0338c842",X"0238782f",X"0189b026",X"0381a026",X"02f08826",X"03d7801f",X"022e881d",X"04578813");
-- 	tau <= (X"0a722aa9",X"08182a95",X"0b184280",X"08b8065c",X"08ce3242",X"0a8e1e2f",X"08626c26",X"0ae06826",X"00000000",X"00000000",X"00000000",X"00000000");
--         wait for LHC_CLK_PERIOD; 
-- 	jet <= (X"035770f7",X"0188e88e",X"001f306b",X"005fd068",X"00d8e05a",X"02870834",X"020d202a",X"02511018",X"0413680e",X"01e8e809",X"01277009",X"042af809");
-- 	tau <= (X"08d5dcf7",X"08623a8e",X"0807cc6b",X"0817f468",X"0836385a",X"08a1c234",X"0883482a",X"0a944418",X"00000000",X"00000000",X"00000000",X"00000000");
--         wait for LHC_CLK_PERIOD; 
-- 	jet <= (X"02592129",X"045f70ca",X"004850b4",X"0220881e",X"0171b016",X"02a0800d",X"0069e80c",X"009f380b",X"02436806",X"02e37806",X"0307d806",X"00000000");
-- 	tau <= (X"0a121428",X"0a9648ff",X"0917dcca",X"0a1214b4",X"0888221e",X"085c6c16",X"0aa8200d",X"0a1a7a0c",X"00000000",X"00000000",X"00000000",X"00000000");
-- 	wait for LHC_CLK_PERIOD; 
-- 	jet <= (X"041eb095",X"02f9908a",X"00678888",X"0277c06a",X"016f0068",X"02df1039",X"012f8038",X"016fe032",X"007b5814",X"03c9100f",X"03e8c80a",X"01d7f80a");
-- 	tau <= (X"0907ac95",X"08be648a",X"0819e288",X"089df06a",X"0a5bc068",X"08b7c439",X"0a4be038",X"085bf832",X"00000000",X"00000000",X"00000000",X"00000000");
--         wait for LHC_CLK_PERIOD; 
-- 	jet <= (X"00b0f0ad",X"03016861",X"0238705e",X"04618053",X"0346a047",X"01e7b01b",X"0019e81a",X"01c25810",X"015ab00f",X"020cb00e",X"0318f00c",X"00be800b");
-- 	tau <= (X"082c3cac",X"0a2c3cad",X"0ac05a61",X"088e1c5e",X"09186053",X"0ad1a847",X"0879ec1b",X"08067a1a",X"00000000",X"00000000",X"00000000",X"00000000");
--         wait for LHC_CLK_PERIOD; 
-- 	jet <= (X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000");
-- 	tau <= (X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000");
--         wait for LHC_CLK_PERIOD; 
	jet <= (X"02592129",X"045f70ca",X"004850b4",X"0220881e",X"0171b016",X"02a0800d",X"0069e80c",X"009f380b",X"02436806",X"02e37806",X"0307d806",X"00000000");
	tau <= (X"0a121428",X"0a9648ff",X"0917dcca",X"0a1214b4",X"0888221e",X"085c6c16",X"0aa8200d",X"0a1a7a0c",X"00000000",X"00000000",X"00000000",X"00000000");
	wait for LHC_CLK_PERIOD; 
	jet <= (X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000");
	tau <= (X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000");
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, tau, jet)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           tau_bx_0 <= tau;
           jet_bx_0 <= jet;
        end if;
end process;

tau_l: for i in calo1_object_low to calo1_object_high generate
  tau_pt_vector_bx_0(i)(TAU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.et_high downto D_S_I_TAU_V2.et_low))), TAU_PT_VECTOR_WIDTH);
  tau_eta_integer_bx_0(i) <= CONV_INTEGER(signed(tau_bx_0(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
  tau_phi_integer_bx_0(i) <= CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low));
  tau_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
  tau_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
end generate;

jet_l: for i in calo2_object_low to calo2_object_high generate
  jet_pt_vector_bx_0(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
  jet_eta_integer_bx_0(i) <= CONV_INTEGER(signed(jet_bx_0(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_bx_0(i) <= CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
  jet_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
  jet_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
end generate;

diff_tau_jet_eta_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(nr_calo1_objects, nr_calo2_objects)
  port map(tau_eta_integer_bx_0, jet_eta_integer_bx_0, diff_tau_jet_eta_integer_bx_0_bx_0);      
diff_tau_jet_phi_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(nr_calo1_objects, nr_calo2_objects, CALO_PHI_HALF_RANGE_BINS)
  port map(tau_phi_integer_bx_0, jet_phi_integer_bx_0, diff_tau_jet_phi_integer_bx_0_bx_0);

diff_tau_tau_eta_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(NR_TAU_OBJECTS, NR_TAU_OBJECTS)
  port map(tau_eta_integer_bx_0, tau_eta_integer_bx_0, diff_tau_tau_eta_integer_bx_0_bx_0);      
diff_tau_tau_phi_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(NR_TAU_OBJECTS, NR_TAU_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
  port map(tau_phi_integer_bx_0, tau_phi_integer_bx_0, diff_tau_tau_phi_integer_bx_0_bx_0);

tau_tau_l1: for i in 0 to NR_TAU_OBJECTS-1 generate
  tau_tau_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    diff_tau_tau_eta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_DIFF_ETA_LUT(diff_tau_tau_eta_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_tau_tau_phi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_DIFF_PHI_LUT(diff_tau_tau_phi_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate tau_tau_l2;
end generate tau_tau_l1;

tau_jet_l1: for i in calo1_object_low to calo1_object_high generate
  tau_jet_l2: for j in calo2_object_low to calo2_object_high generate
    diff_tau_jet_eta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_JET_DIFF_ETA_LUT(diff_tau_jet_eta_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_tau_jet_phi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_JET_DIFF_PHI_LUT(diff_tau_jet_phi_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate tau_jet_l2;
end generate tau_jet_l1;

tau_tau_cosh_cos_l1: for i in 0 to NR_TAU_OBJECTS-1 generate
  tau_tau_cosh_cos_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    tau_tau_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_COSH_DETA_LUT(diff_tau_tau_eta_integer_bx_0_bx_0(i,j)), TAU_TAU_COSH_COS_VECTOR_WIDTH);
    tau_tau_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(TAU_TAU_COS_DPHI_LUT(diff_tau_tau_phi_integer_bx_0_bx_0(i,j)), TAU_TAU_COSH_COS_VECTOR_WIDTH);
  end generate tau_tau_cosh_cos_l2;
end generate tau_tau_cosh_cos_l1;

dut: entity work.calo_calo_calo_correlation_orm_condition
     generic map(
        
        obj_2plus1 => true,

        deta_orm_cut => deta_orm_cut,
        dphi_orm_cut => dphi_orm_cut,
        dr_orm_cut => dr_orm_cut,
        
        deta_cut => deta_cut,
        dphi_cut => dphi_cut,
        dr_cut => dr_cut,
        mass_cut => mass_cut,
        mass_type => mass_type,
	twobody_pt_cut => twobody_pt_cut,

        calo1_object_low => calo1_object_low,
        calo1_object_high => calo1_object_high,
        et_ge_mode_calo1 => et_ge_mode_calo1,
        obj_type_calo1 => obj_type_calo1,
        et_thresholds_calo1 => et_thresholds_calo1,
        eta_full_range_calo1 => eta_full_range_calo1,
        eta_w1_upper_limits_calo1 => eta_w1_upper_limits_calo1,
        eta_w1_lower_limits_calo1 => eta_w1_lower_limits_calo1,
        eta_w2_ignore_calo1 => eta_w2_ignore_calo1,
        eta_w2_upper_limits_calo1 => eta_w2_upper_limits_calo1,
        eta_w2_lower_limits_calo1 => eta_w2_lower_limits_calo1,
        phi_full_range_calo1 => phi_full_range_calo1,
        phi_w1_upper_limits_calo1 => phi_w1_upper_limits_calo1,
        phi_w1_lower_limits_calo1 => phi_w1_lower_limits_calo1,
        phi_w2_ignore_calo1 => phi_w2_ignore_calo1,
        phi_w2_upper_limits_calo1 => phi_w2_upper_limits_calo1,
        phi_w2_lower_limits_calo1 => phi_w2_lower_limits_calo1,
	iso_luts_calo1 => iso_luts_calo1,

	calo2_object_low => calo2_object_low,
        calo2_object_high => calo2_object_high,
        et_ge_mode_calo2 => et_ge_mode_calo2,
        obj_type_calo2 => obj_type_calo2,
        et_threshold_calo2 => et_threshold_calo2,
        eta_full_range_calo2 => eta_full_range_calo2,
        eta_w1_upper_limit_calo2 => eta_w1_upper_limit_calo2,
        eta_w1_lower_limit_calo2 => eta_w1_lower_limit_calo2,
        eta_w2_ignore_calo2 => eta_w2_ignore_calo2,
        eta_w2_upper_limit_calo2 => eta_w2_upper_limit_calo2,
        eta_w2_lower_limit_calo2 => eta_w2_lower_limit_calo2,
        phi_full_range_calo2 => phi_full_range_calo2,
        phi_w1_upper_limit_calo2 => phi_w1_upper_limit_calo2,
        phi_w1_lower_limit_calo2 => phi_w1_lower_limit_calo2,
        phi_w2_ignore_calo2 => phi_w2_ignore_calo2,
        phi_w2_upper_limit_calo2 => phi_w2_upper_limit_calo2,
        phi_w2_lower_limit_calo2 => phi_w2_lower_limit_calo2,
	iso_lut_calo2 => iso_lut_calo2,

	DETA_DPHI_ORM_PRECISION => TAU_JET_DETA_DPHI_PRECISION,

	diff_eta_orm_upper_limit => 0.0,
        diff_eta_orm_lower_limit => 0.0,
--        
        diff_phi_orm_upper_limit => 0.0,
        diff_phi_orm_lower_limit => 0.0,
--        
        dr_orm_upper_limit => dr_orm_upper_limit,
        dr_orm_lower_limit => dr_orm_lower_limit,
--        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => TAU_TAU_DETA_DPHI_PRECISION,

	diff_eta_upper_limit => 0.0,
        diff_eta_lower_limit => 0.0, 

        diff_phi_upper_limit => 0.0, 
        diff_phi_lower_limit => 0.0, 
        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
--        
        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt1_width => PT_VECTOR_WIDTH,
	pt2_width => PT_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	

	pt_sq_threshold => 0.0, 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => JET_JET_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => JET_JET_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        calo1 => tau_bx_0,
        calo2 => jet_bx_0,
        diff_eta_orm => diff_tau_jet_eta_vector_bx_0_bx_0,
        diff_phi_orm => diff_tau_jet_phi_vector_bx_0_bx_0,
        diff_eta => diff_tau_tau_eta_vector_bx_0_bx_0,
        diff_phi => diff_tau_tau_phi_vector_bx_0_bx_0,
        pt1 => tau_pt_vector_bx_0,
        pt2 => tau_pt_vector_bx_0,
	cosh_deta => tau_tau_cosh_deta_vector_bx_0_bx_0,
	cos_dphi => tau_tau_cos_dphi_vector_bx_0_bx_0,
        cos_phi_1_integer => tau_cos_phi_bx_0, 
        cos_phi_2_integer => tau_cos_phi_bx_0, 
        sin_phi_1_integer => tau_sin_phi_bx_0, 
        sin_phi_2_integer => tau_sin_phi_bx_0, 
	condition_o => condition_o,
	sim_orm_vec => open,
	sim_orm_vec_or_tmp => open,
	sim_obj_vs_templ_vec => open,
	sim_obj_vs_templ_or_tmp => open,
	sim_obj_vs_templ_orm_vec => open
    );

end rtl;

