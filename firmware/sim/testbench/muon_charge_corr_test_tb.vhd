
-- Description:
-- Testbench for simulation of mass div DR

-- Version history:
-- HB 2020-08-25: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity muon_charge_corr_test_tb is
end muon_charge_corr_test_tb;

architecture beh of muon_charge_corr_test_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD : time :=  25 ns;
    constant slice_low_obj1 : natural := 0;
    constant slice_high_obj1 : natural := NR_MU_OBJECTS-1;
    constant slice_low_obj2 : natural := 0;
    constant slice_high_obj2 : natural := NR_MU_OBJECTS-1;
    constant slice_low_obj3 : natural := 0;
    constant slice_high_obj3 : natural := NR_MU_OBJECTS-1;
    constant type_obj1 : natural := MU_TYPE;
    
    signal muon : muon_objects_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));

    signal ls_charcorr_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal os_charcorr_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal ls_charcorr_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal os_charcorr_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal ls_charcorr_quad: std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
    signal os_charcorr_quad : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
    signal charge_comp_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
    signal charge_comp_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
    signal obj1_vs_templ : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '1'));
    signal obj2_vs_templ : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '1'));
    signal obj3_vs_templ : std_logic_2dim_array(slice_low_obj3 to slice_high_obj3, 1 to 1) := (others => (others => '1'));
    signal mass_3_obj_comp : std_logic_3dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2, slice_low_obj3 to slice_high_obj3) := (others => (others => (others => '1')));
    signal condition_and_or : std_logic;

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
        wait for 5 ns;
        muon <= (X"000b280f58e01d3d", X"000fd00f4a601dc6", X"000fa80f4a601dc1", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"0004400fc9205470", X"0003a80bcfe028a5", X"0003b00bcae0289e", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", others => X"0000000000000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

muon_charge_correlations_i: entity work.muon_charge_correlations
    port map(
        muon,
        muon,
        ls_charcorr_double, 
        os_charcorr_double,
        ls_charcorr_triple, 
        os_charcorr_triple, 
        ls_charcorr_quad,
        os_charcorr_quad
    );

charge_correlation_comp_i: entity work.charge_correlation_comp
    generic map(
        0, NR_MU_OBJECTS-1, 0, NR_MU_OBJECTS-1, 0, NR_MU_OBJECTS-1,
        "os", true, true, true   
    )
    port map(
        lhc_clk,
        ls_charcorr_double, 
        os_charcorr_double,
        ls_charcorr_triple, 
        os_charcorr_triple, 
        charge_comp_double,
        charge_comp_triple
    );

matrix_corr_cond_i: entity work.matrix_corr_cond
    generic map(
        obj_2plus1 => false,
        mass_3_obj => true,
        slice_high_obj1 => NR_MU_OBJECTS-1,
        slice_high_obj2 => NR_MU_OBJECTS-1,
        slice_high_obj3 => NR_MU_OBJECTS-1,
        type_obj1 => MU_TYPE,
        type_obj2 => MU_TYPE,
        same_bx => true
    )
    port map(
        obj1_vs_templ => obj1_vs_templ,
        obj2_vs_templ => obj2_vs_templ,
        obj3_vs_templ => obj3_vs_templ,
        mass_3_obj_comp => mass_3_obj_comp,
        charge_comp_triple => charge_comp_triple,
        condition_and_or => open
    );

end beh;
