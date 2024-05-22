
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;

use work.gtl_pkg.all;

entity calo_comb_multi_condition_TB is
end calo_comb_multi_condition_TB;

architecture rtl of calo_comb_multi_condition_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;

    signal jet_data : calo_objects_array(0 to 11) := (others => X"00000000");

begin

    -- Clock
    lhc_clk_p: process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;


    stimuli_p: process
    begin
        wait for 2*LHC_CLK_PERIOD;
        jet_data <= (X"00000015", X"00000015", X"00000015", X"00000015", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD;
        jet_data <= (X"00000015", X"00000015", X"00000015", X"00000015", X"00000015", X"00000014", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD;
        jet_data <= (X"0000001b", X"0000001a", X"00000019", X"00000018", X"00000017", X"00000016", X"00000014", X"00000014", X"00000014", X"00000000", X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD;
        jet_data <= (X"00000015", X"00000015", X"00000015", X"00000015", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
    dut: entity work.calo_comb_multi_condition
        generic map(
            obj_nr => 5,
            pt_width => JET_ET_BITS,
            pt_threshold => X"0015"
        )
        port map(
            clk => lhc_clk,
            data_i => jet_data,
            condition_o => open
        );
end rtl;
