
-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

entity test_rom_lut_muon_inv_dr_sq_all_tb is
end test_rom_lut_muon_inv_dr_sq_all_tb;

architecture beh of test_rom_lut_muon_inv_dr_sq_all_tb is

    constant CLK_PERIOD : time :=  10 ns;
    
    constant muon_deta_bins : positive := 225; -- half of muon eta resolution (double of calos)
    constant muon_dphi_bins : positive := 144; -- quarter of muon phi resolution (same as calos)

    signal clk_p : std_logic;
    signal clk_n : std_logic;
    
    signal deta, deta_i : std_logic_vector(7 downto 0) := X"00";
    signal dphi, dphi_i : std_logic_vector(7 downto 0) := X"00";
    signal inv_dr_sq : std_logic_vector(27 downto 0);
    signal deta_r, dphi_r : real := 0.0;
    signal pi : real := 3.141592653589793;
    signal dr_sq_real : real;
    
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
        deta_r <= 0.0;
        dphi_r <= 0.0;
        deta <= X"00";
        dphi <= X"00";
        for i in 0 to muon_deta_bins-1 loop
            for j in 0 to muon_dphi_bins-1 loop
                wait for CLK_PERIOD;
                deta_r <= real(i);
                dphi_r <= real(j);
                deta <= CONV_STD_LOGIC_VECTOR(i,8);
                dphi <= CONV_STD_LOGIC_VECTOR(j,8);
            end loop;
        end loop;
        wait for CLK_PERIOD; 
        deta_r <= 0.0;
        dphi_r <= 0.0;
        deta <= X"00";
        dphi <= X"00";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
    lut_addr_p: process(clk_p, deta, dphi, deta_r, dphi_r)
    begin
        if (clk_p'event and clk_p = '1') then
            deta_i <= deta;
            dphi_i <= dphi;
            dr_sq_real <= ((deta_r*0.087/4)**2)+((dphi_r*2*pi/144)**2); -- 1/dr_sq_real not allowed !!!
        end if;
    end process;
    
    dut: entity work.test_rom_lut_muon_inv_dr_sq_all
        port map(clk_p, clk_n, deta_i, dphi_i, inv_dr_sq);

end beh;

