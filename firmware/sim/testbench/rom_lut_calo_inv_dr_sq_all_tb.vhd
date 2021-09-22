
-- Description:
-- Testbench for simulation of rom_lut_calo_inv_dr_sq_all

-- Version history:
-- HB 2021-09-08: first design

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

entity rom_lut_calo_inv_dr_sq_all_tb is
end rom_lut_calo_inv_dr_sq_all_tb;

architecture beh of rom_lut_calo_inv_dr_sq_all_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal calo_deta_bin : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal calo_dphi_bin : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal calo_deta_bin_sync : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal calo_dphi_bin_sync : STD_LOGIC_VECTOR(7 DOWNTO 0);


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
        calo_deta_bin <= (others => '0');
        calo_dphi_bin <= (others => '0');
        wait for LHC_CLK_PERIOD;
        for i in 0 to 230 loop
            calo_deta_bin <= CONV_STD_LOGIC_VECTOR(i, 8);
            for i in 0 to 72 loop
                calo_dphi_bin <= CONV_STD_LOGIC_VECTOR(i, 8);
            wait for LHC_CLK_PERIOD;
            end loop;
        end loop;
        wait;
 
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <=  X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"C2";
--         calo_dphi_bin <= X"48";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"7F";
--         calo_dphi_bin <= X"48";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"10";
--         calo_dphi_bin <= X"20";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"ff";
--         calo_dphi_bin <= X"20";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"20";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"10";
--         calo_dphi_bin <= X"06";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"02";
--         calo_dphi_bin <= X"06";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"04";
--         calo_dphi_bin <= X"06";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"56";
--         calo_dphi_bin <= X"48";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"80";
--         calo_dphi_bin <= X"56";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"80";
--         calo_dphi_bin <= X"80";
--         wait for LHC_CLK_PERIOD;
--         calo_deta_bin <= X"00";
--         calo_dphi_bin <= X"00";
--         wait;
    end process;

 ------------------- Instantiate  modules  -----------------


sync_p: process(lhc_clk, calo_deta_bin, calo_dphi_bin)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        calo_deta_bin_sync <= calo_deta_bin;
        calo_dphi_bin_sync <= calo_dphi_bin;
    end if;
end process;

dut : entity work.rom_lut_calo_inv_dr_sq_all
    port map (
        clk => lhc_clk,
        deta => calo_deta_bin_sync,
        dphi => calo_dphi_bin_sync,
        dout => open
    );

end beh;

