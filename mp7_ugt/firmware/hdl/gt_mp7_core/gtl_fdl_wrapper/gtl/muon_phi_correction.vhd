-- Desription:
-- Muon phi correction (instead of uGMT): phi values are measured at station 2, not at vertex, therefore correction is needed (for inv. mass conditions with muons). 
-- Correction is done for all muon conditions.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;
use work.muon_phi_correction_pkg.all;

entity muon_phi_correction is
    port(
        pt : in std_logic_vector(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0);
        phi : in std_logic_vector(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0);
        charge : in std_logic_vector(D_S_I_MUON.charge_high-D_S_I_MUON.charge_low downto 0);
        phi_o : out std_logic_vector(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0);
        phi_temp_o : out integer
    );
end muon_phi_correction;

architecture rtl of muon_phi_correction is

    signal phi_value : natural;
    signal phi_correction : natural;
    
begin

    phi_correction <= PHI_CORRECTION_LUT(CONV_INTEGER(pt));
    
    phi_value <= (CONV_INTEGER(phi));

    phi_correction_p: process(phi_value, phi_correction, charge)
        variable phi_temp : integer;
        variable phi_internal : natural;
    begin
-- HB 2016-08-17: MJ checks, whether valid pos. muon means adding phi_correction or subtracting
        if charge = "10" then -- valid pos. muon
            phi_temp := phi_value + phi_correction;
	    if phi_temp > 576 then
		phi_internal := phi_temp - 576;
	    else
		phi_internal := phi_temp;
	    end if;
        elsif charge = "11" then -- valid neg. muon
            phi_temp := phi_value - phi_correction;
	    if phi_temp < 0 then
		phi_internal := 576 - abs(phi_temp);
	    else
		phi_internal := phi_temp;
	    end if;
        else -- HB 2016-08-17: charge = not valid
	    phi_internal := phi_value;
        end if;       

        phi_o <= CONV_STD_LOGIC_VECTOR(phi_internal, 10);
	phi_temp_o <= phi_temp;
	
    end process phi_correction_p;
    
end architecture rtl;
