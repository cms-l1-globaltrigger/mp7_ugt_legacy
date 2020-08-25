
-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

entity test_rom_lut_calo_inv_dr_sq_all_tb is
end test_rom_lut_calo_inv_dr_sq_all_tb;

architecture beh of test_rom_lut_calo_inv_dr_sq_all_tb is

    constant CLK_PERIOD : time :=  10 ns;
    
    constant calo_deta_bins : positive := 230;
    constant calo_dphi_bins : positive := 144;

    signal clk_p : std_logic;
    signal clk_n : std_logic;
    
    signal deta, deta_i : std_logic_vector(7 downto 0) := X"00";
    signal dphi, dphi_i : std_logic_vector(7 downto 0) := X"00";
    signal inv_dr_sq : std_logic_vector(25 downto 0);
    
--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        clk_p  <=  '1';
        clk_n  <=  '0';
        wait for CLK_PERIOD/2;
        clk_p  <=  '0';
        clk_n  <=  '1';
        wait for CLK_PERIOD/2;
    end process;

    process
    begin
        wait for 3ns; 
        deta <= X"00";
        dphi <= X"00";
        for i in 0 to calo_deta_bins-1 loop
            for j in 0 to calo_dphi_bins-1 loop
                wait for CLK_PERIOD; 
                deta <= CONV_STD_LOGIC_VECTOR(i,8);
                dphi <= CONV_STD_LOGIC_VECTOR(j,8);
            end loop;
        end loop;
        wait for CLK_PERIOD; 
        deta <= X"00";
        dphi <= X"00";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

    lut_addr_p: process(clk_p, deta, dphi)
    begin
        if (clk_p'event and clk_p = '1') then
            deta_i <= deta;
            dphi_i <= dphi;
        end if;
    end process;
    
    dut: entity work.test_rom_lut_calo_inv_dr_sq_all
        port map(clk_p, clk_n, deta_i, dphi_i, inv_dr_sq);

end beh;

