
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity muon_esums_correlation_condition_v2_TB is
end muon_esums_correlation_condition_v2_TB;

architecture rtl of muon_esums_correlation_condition_v2_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant NR_MU_OBJECTS : natural := NR_MUON_OBJECTS;

    constant dphi_cut : boolean := false;
    constant mass_cut : boolean := true;
    constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := true;
    
    constant MASS_PRECISION : positive := MU_ETM_MASS_PRECISION;
    constant PT1_VECTOR_WIDTH : positive := MU_PT_VECTOR_WIDTH;
    constant PT2_VECTOR_WIDTH : positive := ETM_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := MU_ETM_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := MU_ETM_COSH_COS_VECTOR_WIDTH;	

    constant muon_object_low: natural := 0;
    constant muon_object_high: natural := 2;
--     constant nr_muon_objects: natural := muon_object_high-muon_object_low+1;
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

    constant et_ge_mode_esums: boolean := true;
    constant obj_type_esums: natural := ETM_TYPE;
    constant et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0200";
    constant phi_full_range_esums : boolean :=true;
    constant phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_esums : boolean := true;
    constant phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
        
    constant mass_upper_limit : real := 200.1;
    constant mass_lower_limit : real := 3.0;

    constant pt_sq_threshold : real := 1300.0;
        
-- ************************************************************************************************

    signal etm, etm_bx_0: std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := X"00000";
    signal mu, mu_bx_0: muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => X"0000000000000000");

    signal etm_phi_conv_2_muon_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_ETM_OBJECTS-1) := (others => 0);

    signal mu_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_MU_OBJECTS-1) := (others => 0);
    signal etm_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_ETM_OBJECTS-1) := (others => 0);

    signal diff_mu_etm_bx_0_bx_0_phi_integer : dim2_max_phi_range_array(0 to NR_MU_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => 0));      
    signal diff_mu_etm_bx_0_bx_0_phi_vector : deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => (others => '0')));      

    signal mu_pt_vector_bx_0: diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal mu_etm_bx_0_bx_0_cos_dphi_vector: calo_muon_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => (others => '0')));
    signal etm_pt_vector_bx_0: diff_inputs_array(0 to NR_ETM_OBJECTS-1) := (others => (others => '0'));
    signal mu_cos_phi_bx_0: muon_sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
    signal mu_sin_phi_bx_0: muon_sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
    signal conv_etm_cos_phi_bx_0: muon_sin_cos_integer_array(0 to NR_ETM_OBJECTS-1) := (others => 0);
    signal conv_etm_sin_phi_bx_0: muon_sin_cos_integer_array(0 to NR_ETM_OBJECTS-1) := (others => 0);

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
        mu <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"00")&X"0"&('0'&X"30")&("01"&X"ff")), others => X"0000000000000000");
        etm <= (X"04"&X"201");
        wait for LHC_CLK_PERIOD; 
        mu <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"11")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"10")&X"0"&('0'&X"10")&("01"&X"ff")), others => X"0000000000000000");
        etm <= (X"74"&X"1FE");
        wait for 3*LHC_CLK_PERIOD; 
        mu <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"21")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"10")&X"0"&('0'&X"10")&("01"&X"ff")), others => X"0000000000000000");
        etm <= (X"04"&X"201");
        wait for LHC_CLK_PERIOD; 
        mu <= ((X"0000000"&"10"&"00"&('0'&X"00")&X"0"&('0'&X"11")&("00"&X"02")), (X"0000000"&"11"&"00"&('0'&X"10")&X"0"&('0'&X"10")&("01"&X"ff")), others => X"0000000000000000");
        etm <= (X"04"&X"010");
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, etm, mu)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           etm_bx_0 <= etm;
           mu_bx_0 <= mu;
        end if;
end process;

mu_l: for i in 0 to NR_MU_OBJECTS-1 generate
    mu_pt_vector_bx_0(i)(MU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.pt_high downto D_S_I_MU_V2.pt_low))), MU_PT_VECTOR_WIDTH);
    mu_phi_integer_bx_0(i) <= CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low));
    mu_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
    mu_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(mu_bx_0(i)(D_S_I_MU_V2.phi_high downto D_S_I_MU_V2.phi_low)));
end generate;

etm_data_bx_0_l: for i in 0 to NR_ETM_OBJECTS-1 generate
    etm_pt_vector_bx_0(i)(ETM_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(ETM_PT_LUT(CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.et_high downto D_S_I_ETM_V2.et_low))), ETM_PT_VECTOR_WIDTH);
    etm_phi_integer_bx_0(i) <= CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low));
end generate;

etm_conv_2_muon_bx_0_l: for i in 0 to NR_ETM_OBJECTS-1 generate
    etm_phi_conv_2_muon_phi_integer_bx_0(i) <= ETM_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low)));
    conv_etm_cos_phi_bx_0(i) <= MUON_COS_PHI_LUT(etm_phi_conv_2_muon_phi_integer_bx_0(i));
    conv_etm_sin_phi_bx_0(i) <= MUON_SIN_PHI_LUT(etm_phi_conv_2_muon_phi_integer_bx_0(i));
end generate;

diff_mu_etm_phi_bx_0_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(NR_MU_OBJECTS, NR_ETM_OBJECTS, MUON_PHI_HALF_RANGE_BINS)
    port map(mu_phi_integer_bx_0, etm_phi_conv_2_muon_phi_integer_bx_0, diff_mu_etm_bx_0_bx_0_phi_integer);
mu_etm_bx_0_bx_0_l1: for i in 0 to NR_MU_OBJECTS-1 generate
    mu_etm_bx_0_bx_0_l2: for j in 0 to NR_ETM_OBJECTS-1 generate
        diff_mu_etm_bx_0_bx_0_phi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(MU_ETM_DIFF_PHI_LUT(diff_mu_etm_bx_0_bx_0_phi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    end generate mu_etm_bx_0_bx_0_l2;
end generate mu_etm_bx_0_bx_0_l1;

mu_etm_bx_0_bx_0_cosh_cos_l1: for i in 0 to NR_MU_OBJECTS-1 generate
    mu_etm_bx_0_bx_0_cosh_cos_l2: for j in 0 to NR_ETM_OBJECTS-1 generate
        mu_etm_bx_0_bx_0_cos_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(MU_ETM_COS_DPHI_LUT(diff_mu_etm_bx_0_bx_0_phi_integer(i,j)), MU_ETM_COSH_COS_VECTOR_WIDTH);
    end generate mu_etm_bx_0_bx_0_cosh_cos_l2;
end generate mu_etm_bx_0_bx_0_cosh_cos_l1;

dut: entity work.muon_esums_correlation_condition_v2
     generic map(
        
        dphi_cut => dphi_cut,
        mass_cut => mass_cut,
        mass_type => mass_type,
	twobody_pt_cut => twobody_pt_cut,

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
        et_ge_mode_esums => et_ge_mode_esums,
        obj_type_esums => obj_type_esums,
        et_threshold_esums => et_threshold_esums,
        phi_full_range_esums => phi_full_range_esums,
        phi_w1_upper_limit_esums => phi_w1_upper_limit_esums,
        phi_w1_lower_limit_esums => phi_w1_lower_limit_esums,
        phi_w2_ignore_esums => phi_w2_ignore_esums,
        phi_w2_upper_limit_esums => phi_w2_upper_limit_esums,
        phi_w2_lower_limit_esums => phi_w2_lower_limit_esums,

        diff_phi_upper_limit => 0.0, 
        diff_phi_lower_limit => 0.0, 
        
	DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
	DETA_DPHI_PRECISION => MUON_ETM_DPHI_PRECISION,

        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt1_width => PT1_VECTOR_WIDTH,
	pt2_width => PT2_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	
        pt_sq_threshold => pt_sq_threshold, 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => MU_ETM_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => MU_ETM_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        muon_data_i => mu_bx_0,
        esums_data_i => etm_bx_0,
        diff_phi => diff_mu_etm_bx_0_bx_0_phi_vector,
        pt1 => mu_pt_vector_bx_0,
        pt2 => etm_pt_vector_bx_0,
	cos_dphi => mu_etm_bx_0_bx_0_cos_dphi_vector,
        cos_phi_1_integer => mu_cos_phi_bx_0, 
        cos_phi_2_integer => conv_etm_cos_phi_bx_0, 
        sin_phi_1_integer => mu_sin_phi_bx_0, 
        sin_phi_2_integer => conv_etm_sin_phi_bx_0,
	condition_o => condition_o
    );

end rtl;

