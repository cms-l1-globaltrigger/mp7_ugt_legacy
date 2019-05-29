
-- Description:

-- Version history:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity algo_pre_scaler_fractional_TB is
end algo_pre_scaler_fractional_TB;

architecture rtl of algo_pre_scaler_fractional_TB is

    constant COUNTER_WIDTH : natural := 24;
    constant FRACTION_WIDTH : natural := 4;
    constant PRESCALE_FACTOR_INIT : std_logic_vector(31 downto 0) := X"00000010";
    
    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
    signal sres_counter, request_update_factor_pulse, update_factor_pulse : std_logic := '0';
    signal algo : std_logic := '1';
    signal prescale_factor : std_logic_vector(COUNTER_WIDTH+FRACTION_WIDTH-1 downto 0) := (others => '0');

--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
	wait for LHC_CLK_PERIOD; 
        sres_counter <= '1';
	wait for LHC_CLK_PERIOD; 
        sres_counter <= '0';
        prescale_factor <= X"00000A5";
	wait for 5*LHC_CLK_PERIOD;
	request_update_factor_pulse <= '1';
	wait for LHC_CLK_PERIOD;
	request_update_factor_pulse <= '0';
	wait for 5*LHC_CLK_PERIOD;
	update_factor_pulse <= '1';
	wait for LHC_CLK_PERIOD;	
	update_factor_pulse <= '0';
-- 	wait for 10*LHC_CLK_PERIOD;	
-- 	algo <= '1';
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.algo_pre_scaler
    generic map(COUNTER_WIDTH, FRACTION_WIDTH, PRESCALE_FACTOR_INIT)
    port map(
      lhc_clk,
      sres_counter,
      algo,
      request_update_factor_pulse,
      update_factor_pulse,
      prescale_factor,
      open,
      open
    );

end rtl;

