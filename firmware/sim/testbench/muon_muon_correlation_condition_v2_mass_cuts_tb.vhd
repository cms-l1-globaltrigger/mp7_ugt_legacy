
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity muon_muon_correlation_condition_v2_mass_cuts_TB is
end muon_muon_correlation_condition_v2_mass_cuts_TB;

architecture rtl of muon_muon_correlation_condition_v2_mass_cuts_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant same_bx : boolean := true;
    
    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := false;
    constant mass_cut : boolean := true;
    constant mass_type : natural := INVARIANT_MASS_TYPE;
--     constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := true;
    
    constant MASS_PRECISION : positive := MU_MU_MASS_PRECISION;
    constant PT_VECTOR_WIDTH : positive := MU_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := MU_MU_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := MU_MU_COSH_COS_VECTOR_WIDTH;	

    constant muon_object_low: natural := 0;
    constant muon_object_high: natural := 2;
    constant nr_muon_objects: natural := muon_object_high-muon_object_low+1;
    constant pt_ge_mode_muon1: boolean := true;
    constant pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_muon1: boolean := true;
    constant eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_muon1: boolean := true;
    constant eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_muon1: boolean := true;
    constant phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_muon1: boolean := true;
    constant phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant requested_charge_muon1: string(1 to 3) := "ign";
    constant qual_lut_muon1: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon1: std_logic_vector(3 downto 0) := X"F";

    constant pt_ge_mode_muon2: boolean := true;
    constant pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0010";
    constant eta_full_range_muon2: boolean := true;
    constant eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_ignore_muon2: boolean := true;
    constant eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_full_range_muon2: boolean := true;
    constant phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_ignore_muon2: boolean := true;
    constant phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0):= X"0000";
    constant requested_charge_muon2: string(1 to 3) := "ign";
    constant qual_lut_muon2: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon2: std_logic_vector(3 downto 0) := X"F";
        
    constant requested_charge_correlation: string(1 to 2) := "ig";

    constant dr_upper_limit : dr_squared_range_real := 1.0;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
    constant mass_upper_limit : real := 200.1;
    constant mass_lower_limit : real := 3.0;

    constant pt_sq_threshold : real := 1900.0;
        
-- ************************************************************************************************

    signal muon, mu_bx_0: muon_objects_array(0 to nr_muon_objects-1) := (others => X"0000000000000000");

    signal mu_eta_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_phi_integer_bx_0: diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);

    signal diff_mu_mu_eta_integer_bx_0_bx_0 : dim2_max_eta_range_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));      
    signal diff_mu_mu_phi_integer_bx_0_bx_0 : dim2_max_phi_range_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));      
    signal diff_mu_mu_eta_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));      
    signal diff_mu_mu_phi_vector_bx_0_bx_0 : deta_dphi_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));      

    signal mu_pt_vector_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal mu_mu_cosh_deta_vector_bx_0_bx_0: muon_cosh_cos_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal mu_mu_cos_dphi_vector_bx_0_bx_0: muon_cosh_cos_vector_array(0 to nr_muon_objects-1, 0 to nr_muon_objects-1) := (others => (others => (others => '0')));
    signal mu_cos_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);
    signal mu_sin_phi_bx_0: muon_sin_cos_integer_array(0 to nr_muon_objects-1) := (others => 0);

    signal ls_charcorr_double_bx_0_bx_0, os_charcorr_double_bx_0_bx_0 : muon_charcorr_double_array := (others => (others => '0'));

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
        muon <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("01"&X"ff")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"0F")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"02")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"0f")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        muon <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
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
           mu_bx_0 <= muon;
        end if;
end process;

mu_l: for i in 0 to nr_muon_objects-1 generate
  mu_pt_vector_bx_0(i)(MU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low))), MU_PT_VECTOR_WIDTH);
  mu_eta_integer_bx_0(i) <= CONV_INTEGER(signed(mu_bx_0(i)(D_S_I_MU_V2.eta_high downto D_S_I_MU_V2.eta_low)));
  mu_phi_integer_bx_0(i) <= CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
  mu_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
  mu_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
end generate;

diff_mu_mu_eta_bx_0_i: entity work.sub_eta_integer_obj_vs_obj
  generic map(nr_muon_objects, nr_muon_objects)
  port map(mu_eta_integer_bx_0, mu_eta_integer_bx_0, diff_mu_mu_eta_integer_bx_0_bx_0);      
diff_mu_mu_phi_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
  generic map(nr_muon_objects, nr_muon_objects, MUON_PHI_HALF_RANGE_BINS)
  port map(mu_phi_integer_bx_0, mu_phi_integer_bx_0, diff_mu_mu_phi_integer_bx_0_bx_0);

mu_mu_l1: for i in 0 to nr_muon_objects-1 generate
  mu_mu_l2: for j in 0 to nr_muon_objects-1 generate
    diff_mu_mu_eta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(diff_mu_mu_eta_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_mu_mu_phi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_PHI_LUT(diff_mu_mu_phi_integer_bx_0_bx_0(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
  end generate mu_mu_l2;
end generate mu_mu_l1;

mu_mu_cosh_cos_l1: for i in 0 to nr_muon_objects-1 generate
  mu_mu_cosh_cos_l2: for j in 0 to nr_muon_objects-1 generate
    mu_mu_cosh_deta_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(diff_mu_mu_eta_integer_bx_0_bx_0(i,j)), MU_MU_COSH_COS_VECTOR_WIDTH);
    mu_mu_cos_dphi_vector_bx_0_bx_0(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_COS_DPHI_LUT(diff_mu_mu_phi_integer_bx_0_bx_0(i,j)), MU_MU_COSH_COS_VECTOR_WIDTH);
  end generate mu_mu_cosh_cos_l2;
end generate mu_mu_cosh_cos_l1;

dut: entity work.muon_muon_correlation_condition_v2
     generic map(
        
        same_bx => same_bx,

        deta_cut => deta_cut,
        dphi_cut => dphi_cut,
        dr_cut => dr_cut,
        mass_cut => mass_cut,
        mass_type => mass_type,
	twobody_pt_cut => twobody_pt_cut,

        muon_object_low => muon_object_low,
        muon_object_high => muon_object_high,
        pt_ge_mode_muon1 => pt_ge_mode_muon1,
        pt_threshold_muon1 => pt_threshold_muon1,
        eta_full_range_muon1 => eta_full_range_muon1,
        eta_w1_upper_limit_muon1 => eta_w1_upper_limit_muon1,
        eta_w1_lower_limit_muon1 => eta_w1_lower_limit_muon1,
        eta_w2_ignore_muon1 => eta_w2_ignore_muon1,
        eta_w2_upper_limit_muon1 => eta_w2_upper_limit_muon1,
        eta_w2_lower_limit_muon1 => eta_w2_lower_limit_muon1,
        phi_full_range_muon1 => phi_full_range_muon1,
        phi_w1_upper_limit_muon1 => phi_w1_upper_limit_muon1,
        phi_w1_lower_limit_muon1 => phi_w1_lower_limit_muon1,
        phi_w2_ignore_muon1 => phi_w2_ignore_muon1,
        phi_w2_upper_limit_muon1 => phi_w2_upper_limit_muon1,
        phi_w2_lower_limit_muon1 => phi_w2_lower_limit_muon1,
        requested_charge_muon1 => requested_charge_muon1,
        qual_lut_muon1 => qual_lut_muon1,
	iso_lut_muon1 => iso_lut_muon1,
--
        pt_ge_mode_muon2 => pt_ge_mode_muon2,
        pt_threshold_muon2 => pt_threshold_muon2,
        eta_full_range_muon2 => eta_full_range_muon2,
        eta_w1_upper_limit_muon2 => eta_w1_upper_limit_muon2,
        eta_w1_lower_limit_muon2 => eta_w1_lower_limit_muon2,
        eta_w2_ignore_muon2 => eta_w2_ignore_muon2,
        eta_w2_upper_limit_muon2 => eta_w2_upper_limit_muon2,
        eta_w2_lower_limit_muon2 => eta_w2_lower_limit_muon2,
        phi_full_range_muon2 => phi_full_range_muon2,
        phi_w1_upper_limit_muon2 => phi_w1_upper_limit_muon2,
        phi_w1_lower_limit_muon2 => phi_w1_lower_limit_muon2,
        phi_w2_ignore_muon2 => phi_w2_ignore_muon2,
        phi_w2_upper_limit_muon2 => phi_w2_upper_limit_muon2,
        phi_w2_lower_limit_muon2 => phi_w2_lower_limit_muon2,
        requested_charge_muon2 => requested_charge_muon2,
        qual_lut_muon2 => qual_lut_muon2,
	iso_lut_muon2 => iso_lut_muon2,

	requested_charge_correlation => requested_charge_correlation,
--
	diff_eta_upper_limit => 0.0,
        diff_eta_lower_limit => 0.0, 

        diff_phi_upper_limit => 0.0, 
        diff_phi_lower_limit => 0.0, 
        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
--        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => MUON_MUON_DETA_DPHI_PRECISION,

        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt_width => PT_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	
        -- generics for pt**2
        pt_sq_threshold => pt_sq_threshold, 
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => MU_MU_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => MU_MU_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        muon1_data_i => mu_bx_0,
        muon2_data_i => mu_bx_0,
        ls_charcorr_double => ls_charcorr_double_bx_0_bx_0,
        os_charcorr_double => os_charcorr_double_bx_0_bx_0,
        diff_eta => diff_mu_mu_eta_vector_bx_0_bx_0,
        diff_phi => diff_mu_mu_phi_vector_bx_0_bx_0,
        pt1 => mu_pt_vector_bx_0,
        pt2 => mu_pt_vector_bx_0,
	cosh_deta => mu_mu_cosh_deta_vector_bx_0_bx_0,
	cos_dphi => mu_mu_cos_dphi_vector_bx_0_bx_0,
        cos_phi_1_integer => mu_cos_phi_bx_0, 
        cos_phi_2_integer => mu_cos_phi_bx_0, 
        sin_phi_1_integer => mu_sin_phi_bx_0, 
        sin_phi_2_integer => mu_sin_phi_bx_0,
	condition_o => condition_o
    );

end rtl;

