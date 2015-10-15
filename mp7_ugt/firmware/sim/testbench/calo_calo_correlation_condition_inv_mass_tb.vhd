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
-- $HeadURL$
-- $Date$
-- $Author$
-- $Revision$
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.gtl_pkg.all;

entity calo_calo_correlation_condition_inv_mass_TB is
end calo_calo_correlation_condition_inv_mass_TB;

architecture rtl of calo_calo_correlation_condition_inv_mass_TB is

    constant LHC_CLK_PERIOD  : time :=  24 ns;

    signal lhc_clk : std_logic;
    
    constant TAU_ETA_SCALE_NON_LINEAR : boolean := false;

    
    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := false;
    constant inv_mass_cut : boolean := true;
    
    constant nr_calo1_objects: positive := 2;
    constant et_ge_mode_calo1: boolean := true;
    constant obj_type_calo1: natural := EG_TYPE;
    constant et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0010";
    constant eta_full_range_calo1: boolean := true;
    constant eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_calo1: boolean := true;
    constant eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_calo1: boolean := true;
    constant phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_calo1: boolean := true;
    constant phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant iso_lut_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";

    constant nr_calo2_objects: positive := 2;
    constant et_ge_mode_calo2: boolean := true;
    constant obj_type_calo2: natural := EG_TYPE;
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
    constant iso_lut_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";
    
    constant diff_eta_upper_limit: real := 0.0;
    constant diff_eta_lower_limit: real := 0.0;
--        
    constant diff_phi_upper_limit: real := 0.0;
    constant diff_phi_lower_limit: real := 0.0;
--        
    constant dr_upper_limit : dr_squared_range_real := 0.0;
    constant dr_lower_limit : dr_squared_range_real := 0.0;
        
    constant inv_mass_upper_limit : real := 13200.5;
    constant inv_mass_lower_limit : real := 13100.5;
        
-- ************************************************************************************************

    signal eg_bx_0: calo_objects_array(0 to nr_calo1_objects-1) := (X"00000000", X"00000000");
    signal eg_bx_0_ff: calo_objects_array(0 to nr_calo1_objects-1);
    signal default_diff_eta_integer_value : diff_2dim_integer_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => 0));      
    signal default_diff_phi_integer_value : diff_2dim_integer_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => 0));      

    signal condition_o: std_logic;
    signal cosh_deta_debug: diff_2dim_integer_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => 0));
    signal cos_dphi_debug: diff_2dim_integer_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => 0));
   
--*********************************Main Body of Code**********************************
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
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
        wait for LHC_CLK_PERIOD; 
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        wait for LHC_CLK_PERIOD; 
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        wait for LHC_CLK_PERIOD; 
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        wait for LHC_CLK_PERIOD; 
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
        wait for LHC_CLK_PERIOD; 
        eg_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
data_in_ff_p: process(lhc_clk, eg_bx_0)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           eg_bx_0_ff <= eg_bx_0;
        end if;
end process;

dut: entity work.calo_calo_correlation_condition
     generic map(
        deta_cut => deta_cut,
        dphi_cut => dphi_cut,
        dr_cut => dr_cut,
        inv_mass_cut => inv_mass_cut,
        
        nr_calo1_objects => nr_calo1_objects,
        et_ge_mode_calo1 => true,
        obj_type_calo1 => obj_type_calo1,
        et_threshold_calo1 => et_threshold_calo1,
        eta_full_range_calo1 => eta_full_range_calo1,
        eta_w1_upper_limit_calo1 => eta_w1_upper_limit_calo1,
        eta_w1_lower_limit_calo1 => eta_w1_lower_limit_calo1,
        eta_w2_ignore_calo1 => eta_w2_ignore_calo1,
        eta_w2_upper_limit_calo1 => eta_w2_upper_limit_calo1,
        eta_w2_lower_limit_calo1 => eta_w2_lower_limit_calo1,
        phi_full_range_calo1 => phi_full_range_calo1,
        phi_w1_upper_limit_calo1 => phi_w1_upper_limit_calo1,
        phi_w1_lower_limit_calo1 => phi_w1_lower_limit_calo1,
        phi_w2_ignore_calo1 => phi_w2_ignore_calo1,
        phi_w2_upper_limit_calo1 => phi_w2_upper_limit_calo1,
        phi_w2_lower_limit_calo1 => phi_w2_lower_limit_calo1,
	iso_lut_calo1 => iso_lut_calo1,
--
        nr_calo2_objects => nr_calo2_objects,
        et_ge_mode_calo2 => true,
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
--
        diff_eta_upper_limit => diff_eta_upper_limit,
        diff_eta_lower_limit => diff_eta_lower_limit,
--        
        diff_phi_upper_limit => diff_phi_upper_limit,
        diff_phi_lower_limit => diff_phi_lower_limit,
--        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit,
--        
        inv_mass_upper_limit => inv_mass_upper_limit,
        inv_mass_lower_limit => inv_mass_lower_limit
    )
    port map(
        lhc_clk => lhc_clk,
        calo1_data_i => eg_bx_0_ff,
        calo2_data_i => eg_bx_0_ff,
        diff_eta => default_diff_eta_integer_value,
        diff_phi => default_diff_phi_integer_value,
	condition_o => condition_o
-- 	cosh_deta_debug => cosh_deta_debug,
-- 	cos_dphi_debug => cos_dphi_debug
    );

end rtl;

