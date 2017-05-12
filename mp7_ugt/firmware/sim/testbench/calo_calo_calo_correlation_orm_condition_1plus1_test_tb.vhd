
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_calo_correlation_orm_condition_1plus1_test_TB is
end calo_calo_calo_correlation_orm_condition_1plus1_test_TB;

architecture rtl of calo_calo_calo_correlation_orm_condition_1plus1_test_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant deta_orm_cut : boolean := false;
    constant dphi_orm_cut : boolean := false;
    constant dr_orm_cut : boolean := true;

    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := false;
    constant mass_cut : boolean := true;
    constant mass_type : natural := INVARIANT_MASS_TYPE;
--     constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := false;
    
    constant MASS_PRECISION : positive := JET_TAU_INV_MASS_PRECISION;
    constant PT1_VECTOR_WIDTH : positive := JET_PT_VECTOR_WIDTH;
    constant PT2_VECTOR_WIDTH : positive := TAU_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := JET_TAU_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := JET_TAU_COSH_COS_VECTOR_WIDTH;	

--     constant calo1_object_low : natural := 0;
--     constant calo1_object_high : natural := 2;
--     constant nr_calo1_objects : natural := calo1_object_high-calo1_object_low+1;
-- --     constant nr_calo1_objects: positive := 3;
--     constant et_ge_mode_calo1: boolean := true;
--     constant obj_type_calo1: natural := JET_TYPE;
--     constant et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0020";
--     constant eta_full_range_calo1: boolean := true;
--     constant eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant eta_w2_ignore_calo1: boolean := true;
--     constant eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant phi_full_range_calo1: boolean := true;
--     constant phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant phi_w2_ignore_calo1: boolean := true;
--     constant phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := X"F";

    constant calo1_object_low : natural := 0;
    constant calo1_object_high : natural := 2;
    constant nr_calo1_objects : natural := calo1_object_high-calo1_object_low+1;
    constant et_ge_mode_calo1: boolean := true;
    constant obj_type_calo1: natural := JET_TYPE;
    constant et_thresholds_calo1: calo_templates_array := (X"0020", X"0000", X"0000", X"0000");
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
    constant iso_luts_calo1: calo_templates_iso_array := (X"F", X"0", X"0", X"0");

    constant calo2_object_low : natural := 0;
    constant calo2_object_high : natural := 1;
    constant nr_calo2_objects : natural := calo2_object_high-calo2_object_low+1;
--     constant nr_calo2_objects: positive := 2;
    constant et_ge_mode_calo2: boolean := true;
    constant obj_type_calo2: natural := TAU_TYPE;
    constant et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0010";
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
        
    constant dr_orm_upper_limit : dr_squared_range_real := 1.0;
    constant dr_orm_lower_limit : dr_squared_range_real := 0.0;
        
    constant mass_upper_limit : real := 200.1;
    constant mass_lower_limit : real := 3.0;
        
-- ************************************************************************************************

    signal tau, tau_bx_p2, tau_temp, tau_bx_0: calo_objects_array(0 to NR_TAU_OBJECTS-1) := (others => X"00000000");
    signal jet, jet_bx_p2, jet_temp, jet_bx_0: calo_objects_array(0 to NR_JET_OBJECTS-1) := (others => X"00000000");
    signal calo_inv_mass_bx0: calo_objects_array(0 to (max(NR_JET_OBJECTS, NR_TAU_OBJECTS))-1) := (others => X"00000000");

    signal jet_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal tau_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);
    signal tau_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => 0);

    signal diff_jet_tau_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_tau_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_tau_eta_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));      
    signal diff_jet_tau_phi_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_TAU_OBJECTS-1) := (others => (others => (others => '0')));      

    signal jet_pt_vector_bx_0: diff_inputs_array(0 to NR_JET_OBJECTS-1) := (others => (others => '0'));
    signal jet_tau_cosh_deta_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal jet_tau_cos_dphi_vector_bx_0_bx_0: calo_cosh_cos_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_JET_OBJECTS-1) := (others => (others => (others => '0')));
    signal tau_pt_vector_bx_0: diff_inputs_array(0 to NR_TAU_OBJECTS-1) := (others => (others => '0'));
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
        wait for 3 * LHC_CLK_PERIOD; 
        wait for 7 ns; 
        tau <= (("00000"&"00"&X"00"&X"00"&('1'&X"40")), ("00000"&"00"&X"88"&X"31"&('0'&X"33")), others => X"00000000");
        jet <= (("00000"&X"00"&X"01"&("000"&X"38")), ("00000"&X"40"&X"30"&("000"&X"30")), ("00000"&X"42"&X"31"&("000"&X"31")), others => X"00000000");
        wait for LHC_CLK_PERIOD; 
        tau <= (("00000"&"00"&X"02"&X"02"&('0'&X"30")), ("00000"&"00"&X"01"&X"01"&('0'&X"30")), others => X"00000000");
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        wait for 3*LHC_CLK_PERIOD; 
        tau <= (("00000"&"00"&X"20"&X"00"&('0'&X"10")), ("00000"&"00"&X"88"&X"31"&('0'&X"33")), others => X"00000000");
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
           tau_bx_0 <= tau;
           jet_bx_0 <= jet;
        end if;
end process;

jet_l: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_pt_vector_bx_0(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low))), JET_PT_VECTOR_WIDTH);
  jet_eta_integer_bx_0(i) <= CONV_INTEGER(signed(jet_bx_0(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
  jet_phi_integer_bx_0(i) <= CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low));
  jet_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
  jet_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(jet_bx_0(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
end generate;

tau_l: for i in 0 to NR_TAU_OBJECTS-1 generate
  tau_pt_vector_bx_0(i)(TAU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.et_high downto D_S_I_TAU_V2.et_low))), TAU_PT_VECTOR_WIDTH);
  tau_eta_integer_bx_0(i) <= CONV_INTEGER(signed(tau_bx_0(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
  tau_phi_integer_bx_0(i) <= CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low));
  tau_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
  tau_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(tau_bx_0(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
end generate;

diff_jet_tau_eta_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_TAU_OBJECTS)
  port map(jet_eta_integer_bx_0, tau_eta_integer_bx_0, diff_jet_tau_eta_integer_bx_0_bx_0);      
diff_jet_tau_phi_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(NR_JET_OBJECTS, NR_TAU_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
  port map(jet_phi_integer_bx_0, tau_phi_integer_bx_0, diff_jet_tau_phi_integer_bx_0_bx_0);

jet_tau_l1: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_tau_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    diff_jet_tau_eta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_ETA_LUT(diff_jet_tau_eta_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_jet_tau_phi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_TAU_DIFF_PHI_LUT(diff_jet_tau_phi_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate jet_tau_l2;
end generate jet_tau_l1;

jet_tau_cosh_cos_l1: for i in 0 to NR_JET_OBJECTS-1 generate
  jet_tau_cosh_cos_l2: for j in 0 to NR_TAU_OBJECTS-1 generate
    jet_tau_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COSH_DETA_LUT(diff_jet_tau_eta_integer_bx_0_bx_0(i,j)), JET_TAU_COSH_COS_VECTOR_WIDTH);
    jet_tau_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(JET_JET_COS_DPHI_LUT(diff_jet_tau_phi_integer_bx_0_bx_0(i,j)), JET_TAU_COSH_COS_VECTOR_WIDTH);
  end generate jet_tau_cosh_cos_l2;
end generate jet_tau_cosh_cos_l1;

dut: entity work.calo_calo_calo_correlation_orm_condition
     generic map(
        
        obj_2plus1 => false,

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

	DETA_DPHI_ORM_PRECISION => JET_TAU_DETA_DPHI_PRECISION,

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
	DETA_DPHI_PRECISION => JET_JET_DETA_DPHI_PRECISION,

	diff_eta_upper_limit => 0.0,
        diff_eta_lower_limit => 0.0, 

        diff_phi_upper_limit => 0.0, 
        diff_phi_lower_limit => 0.0, 

        dr_upper_limit => 0.0,
        dr_lower_limit => 0.0,
--        
        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt1_width => PT1_VECTOR_WIDTH,
	pt2_width => PT2_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	
        -- generics for pt**2
        pt_sq_threshold => 0.0, 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => JET_TAU_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => JET_TAU_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        calo1 => jet_bx_0,
        calo2 => tau_bx_0,
        diff_eta_orm => diff_jet_tau_eta_vector_bx_0_bx_0,
        diff_phi_orm => diff_jet_tau_phi_vector_bx_0_bx_0,
        diff_eta => diff_jet_tau_eta_vector_bx_0_bx_0,
        diff_phi => diff_jet_tau_phi_vector_bx_0_bx_0,
        pt1 => jet_pt_vector_bx_0,
        pt2 => tau_pt_vector_bx_0,
	cosh_deta => jet_tau_cosh_deta_vector_bx_0_bx_0,
	cos_dphi => jet_tau_cos_dphi_vector_bx_0_bx_0,
        cos_phi_1_integer => jet_cos_phi_bx_0, 
        cos_phi_2_integer => tau_cos_phi_bx_0, 
        sin_phi_1_integer => jet_sin_phi_bx_0, 
        sin_phi_2_integer => tau_sin_phi_bx_0,
	condition_o => condition_o
    );

end rtl;

