-- Desription:
-- Muon phi correction for all muon objects. 
-- Correction is done for all muon conditions.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_phi_correction_objects is
    port(
        data_i : in muon_objects_array;
        data_o : out muon_objects_array
    );
end muon_phi_correction_objects;

architecture rtl of muon_phi_correction_objects is

begin

    obj_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        muon_phi_correction_i: entity work.muon_phi_correction
	    port map(data_i(i)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low), 
		data_i(i)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low), 
		data_i(i)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low), 
		data_o(i)(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low));
	    
	data_o(i)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low) <= data_i(i)(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low);
	data_o(i)(D_S_I_MUON.qual_high downto D_S_I_MUON.qual_low) <= data_i(i)(D_S_I_MUON.qual_high downto D_S_I_MUON.qual_low);
	data_o(i)(D_S_I_MUON.eta_high downto D_S_I_MUON.eta_low) <= data_i(i)(D_S_I_MUON.eta_high downto D_S_I_MUON.eta_low);
	data_o(i)(D_S_I_MUON.iso_high downto D_S_I_MUON.iso_low) <= data_i(i)(D_S_I_MUON.iso_high downto D_S_I_MUON.iso_low);
	data_o(i)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low) <= data_i(i)(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low);
	data_o(i)(MAX_MUON_BITS-1 downto D_S_I_MUON.charge_high+1) <= data_i(i)(MAX_MUON_BITS-1 downto D_S_I_MUON.charge_high+1);
	
    end generate obj_l;

end architecture rtl;
