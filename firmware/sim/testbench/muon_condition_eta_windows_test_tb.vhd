
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

entity muon_condition_eta_windows_test_TB is
end muon_condition_eta_windows_test_TB;

architecture rtl of muon_condition_eta_windows_test_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;

    signal muon_data : muon_objects_array(0 to 7) := (others => X"0000000000000000");

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
        muon_data <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon_data <= (X"01d02e9fb86085f9", X"018efe6bb1e035fb", X"0106f06f46e030be", X"0006e18b3c802904", X"00101d7bc3802a2b", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD;
        muon_data <= (X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
 dut: entity work.comb_conditions
    generic map(
-- no slice requirements
-- object cuts
        pt_thresholds_obj1 => (X"0001", X"0001", X"0000", X"0000"),
        nr_eta_windows_obj1 => (3, 3, 0, 0),
--        eta_w1_upper_limits_obj1 => (X"01B7", X"01B7", X"0000", X"0000"),
--        eta_w1_lower_limits_obj1 => (X"0049", X"0049", X"0000", X"0000"),
        eta_w1_upper_limits_obj1 => (X"0049", X"0049", X"0000", X"0000"),
        eta_w1_lower_limits_obj1 => (X"01B7", X"01B7", X"0000", X"0000"),
        eta_w2_upper_limits_obj1 => (X"0147", X"0147", X"0000", X"0000"),
        eta_w2_lower_limits_obj1 => (X"018E", X"018E", X"0000", X"0000"),
        eta_w3_upper_limits_obj1 => (X"00B8", X"00B8", X"0000", X"0000"),
        eta_w3_lower_limits_obj1 => (X"0073", X"0073", X"0000", X"0000"),
        qual_luts_obj1 => (X"F000", X"F000", X"FFFF", X"FFFF"),
        upt_cuts_obj1 => (true, true, false, false),
        upt_upper_limits_obj1 => (X"00FF", X"00FF", X"0000", X"0000"),
        upt_lower_limits_obj1 => (X"0007", X"0007", X"0000", X"0000"),
-- number of objects and type
        nr_obj1 => NR_MU_OBJECTS,
        type_obj1 => MU_TYPE,
        nr_templates => 2
    )
    port map(
        lhc_clk,
        obj1_muon => muon_data,
        condition_o => open
    );

end rtl;

