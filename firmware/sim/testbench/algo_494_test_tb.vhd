
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity algo_494_test_TB is
end algo_494_test_TB;

architecture rtl of algo_494_test_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;

    signal mu_0 : muon_objects_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
    signal mu_m1 : muon_objects_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
    signal mu_bx_0_phi_integer: integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
    signal mu_bx_m1_phi_integer: integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
    signal mu_mu_bx_0_bx_0_dphi_integer: dim2_max_phi_range_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => 0));
    signal mu_mu_bx_0_bx_0_dphi: deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal mu_mu_bx_m1_bx_0_dphi_integer: dim2_max_phi_range_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => 0));
    signal mu_mu_bx_m1_bx_0_dphi: deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));

begin

    -- Clock
    lhc_clk_p: process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;
00689e0ba5e0292f 000d3d4fcae03183 0049d89b5760215b

    stimuli_p: process
    begin
        wait for 2*LHC_CLK_PERIOD;
        -- TestVector_v1_2_1_eta_window_corr_mushowers.txt - bx=207
        mu_m1 <= (X"c4a57adbf1e02cdb", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        mu_0 <= (X"008d13fbf1e045be", X"8090c45ff6e025dc", X"0009a4ebcfe02964", X"00aaa63f97a00d18", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        mu_m1 <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        mu_0 <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        -- TestVector_v1_2_1_eta_window_corr_mushowers.txt - bx=3159
        mu_m1 <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        mu_0 <= (X"008cb3cb036031c2", X"4083dadbe56030a7", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        mu_m1 <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        mu_0 <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        -- TestVector_v1_2_1_eta_window_corr_mushowers.txt - bx=3437
        mu_m1 <= (X"00689e0ba5e0292f", X"000d3d4fcae03183", X"0049d89b5760215b", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        mu_0 <= (X"4083b2afea60243a", X"00102d7bcae02a2d", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
    calc_mu_bx_m1_i: entity work.obj_parameter
        generic map(
            nr_obj => NR_MU_OBJECTS,
            type_obj => MU_TYPE
        )
        port map(
            muon => mu_m1,
            phi_integer => mu_bx_m1_phi_integer
        );
    --
    calc_mu_bx_0_i: entity work.obj_parameter
        generic map(
            nr_obj => NR_MU_OBJECTS,
            type_obj => MU_TYPE
        )
        port map(
            muon => mu_0,
            phi_integer => mu_bx_0_phi_integer
        );
    --
    calc_dphi_integer_i: entity work.deta_dphi_calculations
        generic map(
            phi_half_range => MUON_PHI_HALF_RANGE_BINS,
            phi_h_r_half_range => MUON_PHI_HALF_RES_HALF_RANGE_BINS,
            nr_obj1 => NR_MU_OBJECTS,
            type_obj1 => MU_TYPE,
            nr_obj2 => NR_MU_OBJECTS,
            type_obj2 => MU_TYPE
        )
        port map(
            phi_integer_obj1 => mu_bx_m1_phi_integer,
            phi_integer_obj2 => mu_bx_0_phi_integer,
            dphi_integer => mu_mu_bx_m1_bx_0_dphi_integer
        );
    --
    calc_cut_dphi_i: entity work.correlation_cuts_calculation
        generic map(
            nr_obj1 => NR_MU_OBJECTS,
            type_obj1 => MU_TYPE,
            nr_obj2 => NR_MU_OBJECTS,
            type_obj2 => MU_TYPE,
            dphi_cut => true
        )
        port map(
            dphi_integer => mu_mu_bx_m1_bx_0_dphi_integer,
            dphi => mu_mu_bx_m1_bx_0_dphi
        );

    dut: entity work.correlation_conditions
        generic map(
    -- slices for muon
            slice_low_obj1 => 0,
            slice_high_obj1 => 7,
            slice_low_obj2 => 0,
            slice_high_obj2 => 7,
    -- obj cuts
            pt_threshold_obj1 => X"0007",
            nr_eta_windows_obj1 => 1,
            eta_w1_upper_limit_obj1 => X"006E",
            eta_w1_lower_limit_obj1 => X"0192",
            nr_phi_windows_obj1 => 1,
            phi_w1_upper_limit_obj1 => X"00EF",
            phi_w1_lower_limit_obj1 => X"0030",
            qual_lut_obj1 => X"F000",
            pt_threshold_obj2 => X"0007",
            nr_eta_windows_obj2 => 1,
            eta_w1_upper_limit_obj2 => X"006E",
            eta_w1_lower_limit_obj2 => X"0192",
            nr_phi_windows_obj2 => 1,
            phi_w1_upper_limit_obj2 => X"020F",
            phi_w1_lower_limit_obj2 => X"0150",
            qual_lut_obj2 => X"F000",
    -- correlation cuts
            dphi_cut => true,
            dphi_upper_limit_vector => X"00000C46",
            dphi_lower_limit_vector => X"00000A3A",
    -- number of objects and type
            nr_obj1 => NR_MU_OBJECTS,
            type_obj1 => MU_TYPE,
            nr_obj2 => NR_MU_OBJECTS,
            type_obj2 => MU_TYPE,
    -- selector same/different bunch crossings
            same_bx => false
        )
        port map(
            lhc_clk,
            muon_obj1 => mu_m1,
            muon_obj2 => mu_0,
            dphi => mu_mu_bx_m1_bx_0_dphi,
            condition_o => open
        );
        
end rtl;
