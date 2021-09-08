
-- Description:
-- Testbench for simulation of rom_lut_muon_inv_dr_sq_all

-- Version history:
-- HB 2021-09-06: first design

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

entity rom_lut_muon_inv_dr_sq_all_tb is
end rom_lut_muon_inv_dr_sq_all_tb;

architecture beh of rom_lut_muon_inv_dr_sq_all_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal muon_deta_bin : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal muon_dphi_bin : STD_LOGIC_VECTOR(9 DOWNTO 0);


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
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <=  "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '1' & X"C2";
        muon_dphi_bin <= "01" & X"20";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"10";
        muon_dphi_bin <= "01" & X"20";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"ff";
        muon_dphi_bin <= "01" & X"20";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '1' & X"00";
        muon_dphi_bin <= "01" & X"20";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"10";
        muon_dphi_bin <= "00" & X"06";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"02";
        muon_dphi_bin <= "00" & X"06";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"04";
        muon_dphi_bin <= "00" & X"06";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"56";
        muon_dphi_bin <= "00" & X"80";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"80";
        muon_dphi_bin <= "00" & X"56";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '1' & X"80";
        muon_dphi_bin <= "00" & X"80";
        wait for LHC_CLK_PERIOD;
        muon_deta_bin <= '0' & X"00";
        muon_dphi_bin <= "00" & X"00";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------


dut : entity work.rom_lut_muon_inv_dr_sq_all
    port map (
        clk => lhc_clk,
-- reduced bin width (8 bits) for muon deta [226] and muon dphi [144] (half resolution)
        deta => muon_deta_bin(8 DOWNTO 1),
        dphi => muon_dphi_bin(8 DOWNTO 1),
        dout => open
    );

end beh;

