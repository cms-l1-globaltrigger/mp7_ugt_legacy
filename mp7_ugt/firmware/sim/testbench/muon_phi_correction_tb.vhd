library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.gtl_pkg.all;

entity muon_phi_correction_TB is
end muon_phi_correction_TB;

architecture rtl of muon_phi_correction_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal pt: std_logic_vector(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0) := (others => '0');
    signal phi: std_logic_vector(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0) := (others => '0');
    signal charge: std_logic_vector(D_S_I_MUON.charge_high-D_S_I_MUON.charge_low downto 0) := "10";
    
--*********************************Main Body of Code**********************************
begin
    
    process
    begin
        pt <= "0"&X"27";
        phi <= "00"&X"0A";
--         phi_correction <= 12;
	wait for LHC_CLK_PERIOD; 
        pt <= "0"&X"B6";
        phi <= "10"&X"39";
--         phi_correction <= 3;
	wait for LHC_CLK_PERIOD; 
        pt <= "1"&X"C2";
        phi <= "10"&X"39";
--         phi_correction <= 1;
	wait for LHC_CLK_PERIOD; 
        pt <= "0"&X"39";
        phi <= "10"&X"39";
--         phi_correction <= 8;
	wait for LHC_CLK_PERIOD; 
        charge <= "11";
        pt <= "0"&X"39";
        phi <= "10"&X"39";
--         phi_correction <= 8;
	wait for LHC_CLK_PERIOD; 
        charge <= "11";
        pt <= "0"&X"2A";
        phi <= "00"&X"0A";
--         phi_correction <= 11;
	wait for LHC_CLK_PERIOD; 
        charge <= "00";
        pt <= "0"&X"2A";
        phi <= "00"&X"0A";
--         phi_correction <= 11;
	wait for LHC_CLK_PERIOD; 
        charge <= "01";
        pt <= "0"&X"2A";
        phi <= "00"&X"0A";
--         phi_correction <= 11;
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
    
    dut: entity work.muon_phi_correction
	port map(pt, phi, charge, open, open);
    
end;