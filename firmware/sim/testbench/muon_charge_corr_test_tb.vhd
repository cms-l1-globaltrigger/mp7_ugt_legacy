
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

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal muon : muon_objects_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));

    signal ls_charcorr_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal os_charcorr_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal ls_charcorr_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal os_charcorr_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal ls_charcorr_quad: std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
    signal os_charcorr_quad : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
    signal charge_comp_double_o : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '1'));
    signal charge_comp_triple_o : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '1')));

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
        "os", false, true, true   
    )
    port map(
        lhc_clk,
        ls_charcorr_double, 
        os_charcorr_double,
        ls_charcorr_triple, 
        os_charcorr_triple, 
        charge_comp_double_o,
        charge_comp_triple_o
    );

end beh;
