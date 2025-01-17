
-- Description:

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
--library std;                  -- for Printing
--use std.textio.all;

--use work.math_pkg.all;

entity ett_imb_comparator_TB is
end ett_imb_comparator_TB;

architecture rtl of ett_imb_comparator_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;

    signal ett_pos : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := others => '0';
    signal ett_neg : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := others => '0';

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
        ett_pos <= X"000F";
        ett_neg <= X"000E";
        wait for LHC_CLK_PERIOD;
        ett_pos <= X"0004";
        ett_neg <= X"0002";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
    dut: entity work.ett_imb_comparator
        generic map(
            sim_mode => true,
            et_ge_mode => true,
            et_threshold => X"0008"
        )
        port map(
            clk => lhc_clk,
            ett_pos => ett_pos,
            ett_neg => ett_neg,
            comp_o => open
        );
        
end rtl;
