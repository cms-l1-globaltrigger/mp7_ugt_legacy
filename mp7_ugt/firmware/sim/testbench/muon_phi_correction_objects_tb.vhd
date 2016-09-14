library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.gtl_pkg.all;

entity muon_phi_correction_objects_TB is
end muon_phi_correction_objects_TB;

architecture rtl of muon_phi_correction_objects_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal data_i: muon_objects_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
    signal data_o: muon_objects_array(0 to NR_MUON_OBJECTS-1);
    
--*********************************Main Body of Code**********************************
begin
    
    process
    begin
        data_i(0)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= "10";
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"27";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "00"&X"0A";
--         phi_correction <= 12;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"B6";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "10"&X"39";
--         phi_correction <= 3;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "1"&X"C2";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "10"&X"39";
--         phi_correction <= 1;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"39";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "10"&X"39";
--         phi_correction <= 8;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= "11";
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"39";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "10"&X"39";
--         phi_correction <= 8;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= "11";
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"2A";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "00"&X"0A";
--         phi_correction <= 11;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= "00";
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"2A";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "00"&X"0A";
--         phi_correction <= 11;
	wait for LHC_CLK_PERIOD; 
        data_i(0)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= "01";
        data_i(0)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= "0"&X"2A";
        data_i(0)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low) <= "00"&X"0A";
--         phi_correction <= 11;
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
    
    dut: entity work.muon_phi_correction_objects
	port map(data_i, data_o);
    
end;