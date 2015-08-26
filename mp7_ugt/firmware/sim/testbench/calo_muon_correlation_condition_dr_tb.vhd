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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/testbench/calo_muon_correlation_condition_dr_tb.vhd $
-- $Date: 2015-08-25 11:26:14 +0200 (Die, 25 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4175 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.gtl_pkg.all;
-- use work.eta_scale_luts_pkg.all;

entity calo_muon_correlation_condition_dr_TB is
end calo_muon_correlation_condition_dr_TB;

architecture rtl of calo_muon_correlation_condition_dr_TB is

    constant LHC_CLK_PERIOD  : time :=  24 ns;

    signal lhc_clk : std_logic;
    
    constant TAU_ETA_SCALE_NON_LINEAR : boolean := false;
    constant deta_cut : boolean := false;
    constant dphi_cut : boolean := false;
    constant dr_cut : boolean := true;
    
    constant obj_type_calo : natural := TAU_TYPE;
--     constant nr_calo_objects := NR_TAU_OBJECTS;
    constant nr_calo_objects : natural  := 2;
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
    constant iso_lut_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := X"000F";

--     constant nr_muon_objects : natural := NR_MUON_OBJECTS;
    constant nr_muon_objects : natural  := 2;
    constant pt_threshold_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0020";
    constant eta_full_range_muon : boolean := true;
    constant eta_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_ignore_muon : boolean := true;
    constant eta_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant eta_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_full_range_muon : boolean := true;
    constant phi_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore_muon : boolean := true;
    constant phi_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant requested_charge_muon: string(1 to 3) := "ign";
    constant qual_lut_muon: std_logic_vector(15 downto 0) := X"FFFF";
    constant iso_lut_muon: std_logic_vector(3 downto 0) := "1111";

    constant diff_eta_upper_limit: real := 0.0;
    constant diff_eta_lower_limit: real := 0.0;
--        
    constant diff_phi_upper_limit: real := 0.0;
    constant diff_phi_lower_limit: real := 0.0;
--        
--     constant dr_upper_limit : dr_squared_range_real := 31.0;
--     constant dr_lower_limit : dr_squared_range_real := 27.0;
--     constant dr_upper_limit : dr_squared_range_real := 5.6;
--     constant dr_lower_limit : dr_squared_range_real := 5.2;
    constant dr_upper_limit : dr_squared_range_real := 4.6;
    constant dr_lower_limit : dr_squared_range_real := 4.5;
        
-- ************************************************************************************************

    signal tau_bx_0: calo_objects_array(0 to nr_calo_objects-1) := (X"00000000", X"00000000");
    signal tau_bx_0_ff: calo_objects_array(0 to nr_calo_objects-1);
    signal tau_eta_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal tau_phi_bx_0: diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal muon_bx_0: muon_objects_array(0 to nr_muon_objects-1) := (X"0000000000000000", X"0000000000000000");
    signal muon_bx_0_ff: muon_objects_array(0 to nr_muon_objects-1);
    signal muon_phi_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal muon_eta_bx_0: diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal diff_tau_muon_eta_bins_bx_0: diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal diff_tau_muon_phi_bins_bx_0: diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1) := (others => (others => 0));
    signal tau_eta_tau_muon_bx_0 : diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal tau_phi_tau_muon_bx_0 : diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
    signal muon_eta_tau_muon_bx_0 : diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
    signal muon_phi_tau_muon_bx_0 : diff_inputs_array(0 to nr_muon_objects-1) := (others => (others => '0'));
 
    signal tau_eta_value_bx_0 : diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal tau_phi_value_bx_0 : diff_integer_inputs_array(0 to nr_calo_objects-1) := (others => 0);
    signal muon_eta_value_bx_0 : diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal muon_phi_value_bx_0 : diff_integer_inputs_array(0 to nr_muon_objects-1) := (others => 0);
    signal diff_tau_muon_eta_integer_value_bx_0_bx_0 : diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1);      
    signal diff_tau_muon_phi_integer_value_bx_0_bx_0 : diff_2dim_integer_array(0 to nr_calo_objects-1, 0 to nr_muon_objects-1);      

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
--         wait for 5 * LHC_CLK_PERIOD; 
--         wait for 7 ns; 
--         tau_bx_0 <= (X"00000030", X"01110011");
--         muon_bx_0 <= (X"0000000000008000", X"0000000000008001");
--         wait for LHC_CLK_PERIOD; 
--         tau_bx_0 <= (X"00000030", X"00000030");
--         muon_bx_0 <= (X"0000000000008000", X"0000000000008000");
--         wait for LHC_CLK_PERIOD; 
-- --         tau_bx_0 <= (X"00000000", X"01211020");
--         tau_bx_0 <= (X"00000030", X"01111020");
--         muon_bx_0 <= (X"0000000000008000", X"0000000080008001");
--         wait for LHC_CLK_PERIOD; 
--         tau_bx_0 <= (X"00000030", X"00000030");
--         muon_bx_0 <= (X"0000000000008000", X"0000000000008000");
--         wait for LHC_CLK_PERIOD; 
--         wait; 

        wait for 5 * LHC_CLK_PERIOD; 
        wait for 7 ns; 
--         tau_bx_0 <= (X"00000030", X"01110011");
--                     spare  iso   phi   eta       et
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"90"&('0'&X"11")));
--         muon_bx_0 <= (X"0000000000008000", X"0000000000008001");
--                        spare    ch  iso       eta    qual      et          phi
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
--         muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
--         muon_bx_0 <= (X"0000000000008000", X"0000000000008001");
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"88"&X"98"&('0'&X"20")));
--         muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
--         muon_bx_0 <= (X"0000000000008000", X"0000000080008001");
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('1'&X"00")&X"0"&('0'&X"20")&("00"&X"01")));
        wait for LHC_CLK_PERIOD; 
        tau_bx_0 <= (("00000"&"00"&X"00"&X"00"&('0'&X"30")), ("00000"&"00"&X"00"&X"00"&('0'&X"30")));
        muon_bx_0 <= ((X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")), (X"0000000"&"00"&"00"&('0'&X"00")&X"0"&('0'&X"20")&("00"&X"00")));
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------
data_in_ff_p: process(lhc_clk, tau_bx_0, muon_bx_0)
    begin
        if (lhc_clk'event and lhc_clk = '1') then
           tau_bx_0_ff <= tau_bx_0;
           muon_bx_0_ff <= muon_bx_0;
        end if;
end process;

tau_data_bx_0_l: for i in 0 to nr_calo_objects-1 generate
    tau_eta_value_bx_0(i) <= tau_eta_lut(CONV_INTEGER(tau_bx_0_ff(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
--     assert tau_eta_value_bx_0(i) /= 0 report "tau_eta_value_bx_0(i) is 0" severity error;
    tau_phi_value_bx_0(i) <= tau_phi_lut(CONV_INTEGER(tau_bx_0_ff(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
end generate;

muon_data_bx_0_l: for i in 0 to nr_muon_objects-1 generate
    muon_eta_value_bx_0(i) <= muon_eta_lut(CONV_INTEGER(muon_bx_0_ff(i)(d_s_i_muon.eta_high downto d_s_i_muon.eta_low)));
    muon_phi_value_bx_0(i) <= muon_phi_lut(CONV_INTEGER(muon_bx_0_ff(i)(d_s_i_muon.phi_high downto d_s_i_muon.phi_low)));
end generate;

-- Instantiations of differences calculation for calo muon correlation conditions - used for DETA, DPHI and DR
diff_tau_muon_eta_bx_0_bx0_i: entity work.sub_eta_integer_obj_vs_obj
    generic map(nr_calo_objects, nr_muon_objects)
    port map(tau_eta_value_bx_0, muon_eta_value_bx_0, diff_tau_muon_eta_integer_value_bx_0_bx_0);      

diff_tau_muon_phi_bx_0_bx0_i: entity work.sub_phi_integer_obj_vs_obj
    generic map(nr_calo_objects, nr_muon_objects, PHI_HALF_RANGE_INTEGER)
    port map(tau_phi_value_bx_0, muon_phi_value_bx_0, diff_tau_muon_phi_integer_value_bx_0_bx_0);      

dut: entity work.calo_muon_correlation_condition
     generic map(
        deta_cut => deta_cut,
        dphi_cut => dphi_cut,
        dr_cut => dr_cut,
        nr_calo_objects => nr_calo_objects,
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
        nr_muon_objects => nr_muon_objects,
        pt_ge_mode_muon => true,
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
        diff_eta_upper_limit => diff_eta_upper_limit,
        diff_eta_lower_limit => diff_eta_lower_limit,
--        
        diff_phi_upper_limit => diff_phi_upper_limit,
        diff_phi_lower_limit => diff_phi_lower_limit,
--        
        dr_upper_limit => dr_upper_limit,
        dr_lower_limit => dr_lower_limit
    )
    port map(
        clk => lhc_clk,
        calo_data_i => tau_bx_0_ff,
        muon_data_i => muon_bx_0_ff,
        diff_eta => diff_tau_muon_eta_integer_value_bx_0_bx_0,
        diff_phi => diff_tau_muon_phi_integer_value_bx_0_bx_0,
	condition_o => open
    );

end rtl;

