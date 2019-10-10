
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_esums_correlation_condition_v2_TB is
end calo_esums_correlation_condition_v2_TB;

architecture rtl of calo_esums_correlation_condition_v2_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
        
    constant dphi_cut : boolean := false;
    constant mass_cut : boolean := true;
    constant mass_type : natural := TRANSVERSE_MASS_TYPE;
    constant twobody_pt_cut : boolean := false;
    
    constant MASS_PRECISION : positive := JET_ETM_MASS_PRECISION;
    constant PT1_VECTOR_WIDTH : positive := JET_PT_VECTOR_WIDTH;
    constant PT2_VECTOR_WIDTH : positive := ETM_PT_VECTOR_WIDTH;
    constant MASS_COSH_COS_PRECISION : positive := JET_ETM_COSH_COS_PRECISION;
    constant COSH_COS_VECTOR_WIDTH : positive := JET_ETM_COSH_COS_VECTOR_WIDTH;	

    constant calo_object_low: natural := 0;
    constant calo_object_high: natural := 2;
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

    constant pt_sq_threshold : real := 2805.0;
        
-- ************************************************************************************************

    signal etm, etm_bx_0: std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := X"00000";
    signal jet, jet_bx_0: calo_objects_array(0 to NR_JET_OBJECTS-1) := (others => X"00000000");

    signal jet_eta_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal etm_phi_integer_bx_0: diff_integer_inputs_array(0 to NR_ETM_OBJECTS-1) := (others => 0);

    signal diff_jet_etm_bx_0_bx_0_phi_integer : dim2_max_phi_range_array(0 to NR_JET_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => 0));      
    signal diff_jet_etm_bx_0_bx_0_phi_vector : deta_dphi_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => (others => '0')));      

    signal jet_pt_vector_bx_0: diff_inputs_array(0 to NR_JET_OBJECTS-1) := (others => (others => '0'));
    signal jet_etm_bx_0_bx_0_cos_dphi_vector: calo_cosh_cos_vector_array(0 to NR_JET_OBJECTS-1, 0 to NR_ETM_OBJECTS-1) := (others => (others => (others => '0')));
    signal etm_pt_vector_bx_0: diff_inputs_array(0 to NR_ETM_OBJECTS-1) := (others => (others => '0'));
    signal jet_cos_phi_bx_0: calo_sin_cos_integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal jet_sin_phi_bx_0: calo_sin_cos_integer_array(0 to NR_JET_OBJECTS-1) := (others => 0);
    signal etm_cos_phi_bx_0: calo_sin_cos_integer_array(0 to NR_ETM_OBJECTS-1) := (others => 0);
    signal etm_sin_phi_bx_0: calo_sin_cos_integer_array(0 to NR_ETM_OBJECTS-1) := (others => 0);

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
        etm <= (X"04"&X"201");
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"40"&X"92"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), ("00000"&X"89"&X"89"&("000"&X"11")), others => X"00000000");
        etm <= (X"74"&X"1FE");
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"01"&X"01"&("000"&X"38")), ("00000"&X"40"&X"30"&("000"&X"30")), ("00000"&X"42"&X"31"&("000"&X"31")), others => X"00000000");
        etm <= (X"04"&X"201");
        wait for LHC_CLK_PERIOD; 
        jet <= (("00000"&X"00"&X"92"&("000"&X"11")), ("00000"&X"00"&X"89"&("000"&X"11")), ("00000"&X"00"&X"89"&("000"&X"11")), others => X"00000000");
        etm <= (X"04"&X"010");
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
pipeline_p: process(lhc_clk, etm, jet)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           etm_bx_0 <= etm;
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

etm_data_bx_0_l: for i in 0 to NR_ETM_OBJECTS-1 generate
    etm_pt_vector_bx_0(i)(ETM_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(ETM_PT_LUT(CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.et_high downto D_S_I_ETM_V2.et_low))), ETM_PT_VECTOR_WIDTH);
    etm_phi_integer_bx_0(i) <= CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low));
    etm_cos_phi_bx_0(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low)));
    etm_sin_phi_bx_0(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(etm_bx_0(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low)));
end generate;

diff_jet_etm_phi_bx_0_bx_0_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(NR_JET_OBJECTS, NR_ETM_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
    port map(jet_phi_integer_bx_0, etm_phi_integer_bx_0, diff_jet_etm_bx_0_bx_0_phi_integer);
jet_etm_bx_0_bx_0_l1: for i in 0 to NR_JET_OBJECTS-1 generate
    jet_etm_bx_0_bx_0_l2: for j in 0 to NR_ETM_OBJECTS-1 generate
        diff_jet_etm_bx_0_bx_0_phi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_ETM_DIFF_PHI_LUT(diff_jet_etm_bx_0_bx_0_phi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
    end generate jet_etm_bx_0_bx_0_l2;
end generate jet_etm_bx_0_bx_0_l1;

jet_etm_bx_0_bx_0_cosh_cos_l1: for i in 0 to NR_JET_OBJECTS-1 generate
    jet_etm_bx_0_bx_0_cosh_cos_l2: for j in 0 to NR_ETM_OBJECTS-1 generate
        jet_etm_bx_0_bx_0_cos_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR(JET_ETM_COS_DPHI_LUT(diff_jet_etm_bx_0_bx_0_phi_integer(i,j)), JET_ETM_COSH_COS_VECTOR_WIDTH);
    end generate jet_etm_bx_0_bx_0_cosh_cos_l2;
end generate jet_etm_bx_0_bx_0_cosh_cos_l1;

dut: entity work.calo_esums_correlation_condition_v2
     generic map(
        
        dphi_cut => dphi_cut,
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
	DETA_DPHI_PRECISION => JET_ETM_DPHI_PRECISION,

        mass_upper_limit => mass_upper_limit,
        mass_lower_limit => mass_lower_limit,

        MASS_PRECISION => MASS_PRECISION,
	pt1_width => PT1_VECTOR_WIDTH,
	pt2_width => PT2_VECTOR_WIDTH,
	MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
	cosh_cos_width => COSH_COS_VECTOR_WIDTH,	
        pt_sq_threshold => pt_sq_threshold, 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        PT_PRECISION => JET_ETM_PT_PRECISION, 
        PT_SQ_SIN_COS_PRECISION => JET_ETM_SIN_COS_PRECISION

    )
    port map(
        lhc_clk => lhc_clk,
        calo_data_i => jet_bx_0,
        esums_data_i => etm_bx_0,
        diff_phi => diff_jet_etm_bx_0_bx_0_phi_vector,
        pt1 => jet_pt_vector_bx_0,
        pt2 => etm_pt_vector_bx_0,
	cos_dphi => jet_etm_bx_0_bx_0_cos_dphi_vector,
        cos_phi_1_integer => jet_cos_phi_bx_0, 
        cos_phi_2_integer => etm_cos_phi_bx_0, 
        sin_phi_1_integer => jet_sin_phi_bx_0, 
        sin_phi_2_integer => etm_sin_phi_bx_0,
	condition_o => condition_o
    );

end rtl;

