
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

entity cicada_ad_hi_condition_TB is
end cicada_ad_hi_condition_TB;

architecture rtl of cicada_ad_hi_condition_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;

    signal cicada_ad_dec : std_logic_vector(7 downto 0) := X"00";
    signal cicada_ad_int : std_logic_vector(7 downto 0) := X"00";

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
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"04";
        wait for LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"00";
        wait for 2*LHC_CLK_PERIOD;
        cicada_ad_dec <= X"05";
        cicada_ad_int <= X"03";
        wait for LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"00";
        wait for 2*LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"03";
        wait for LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"00";
        wait for 2*LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"02";
        wait for LHC_CLK_PERIOD;
        cicada_ad_dec <= X"00";
        cicada_ad_int <= X"00";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------


    dut: entity work.cicada_ad_hi_condition
        generic map(
            ad_requ => true,
            ad_dec_thr => X"0005",
            ad_int_thr => X"0003"
        )
        port map(
            lhc_clk => lhc_clk,
            ad_dec_i => cicada_ad_dec,
            ad_int_i => cicada_ad_int,
            ad_comp_o => open
        );
end rtl;
