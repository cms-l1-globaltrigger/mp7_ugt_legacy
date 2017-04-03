
-- Description:

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity calo_collection_builder_TB is
end calo_collection_builder_TB;

architecture rtl of calo_collection_builder_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    constant sel_bit_inv : boolean := false;
    signal tau_data : calo_objects_array(0 to NR_TAU_OBJECTS-1) := (others => X"00000000");
    signal collection_out : calo_objects_array(0 to NR_TAU_OBJECTS-1);

begin
    
    process
    begin
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"00978199", X"0200E0FD",X"00978099", X"0200E080", others => X"00000000");
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"009781FD", X"0000E1CE",X"009780FD", X"0000E0CE", others => X"00000000");
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"0006D080", X"0000E070",X"0206D060", X"0200E050", others => X"00000000");
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"0006D077", X"0200E076",X"0206D070", X"0200E060", others => X"00000000");
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"0006D077", X"0200E076",X"0006D070", X"0200E060", others => X"00000000");
	wait for LHC_CLK_PERIOD; 
        tau_data <= (X"00000000", X"00000000",X"00000000", X"00000000", others => X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

-- HB 2017-03-27: building a new collection of taus with isolation-bit. 
--                If sel_bit_inv=false the new collection contains only "isolated taus",
--                otherwise (sel_bit_inv=true) the new collection contains only "non-isolated taus".

dut: entity work.calo_collection_builder
    generic map(NR_TAU_OBJECTS, TAU_ISO_LOW, sel_bit_inv)
    port map(tau_data, collection_out);

end rtl;

