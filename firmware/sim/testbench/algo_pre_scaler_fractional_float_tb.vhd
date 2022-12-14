
-- Description:
-- Testbench for prescalers (FDL) with fractional prescale values given in float

-- Version history:
-- HB 2022-09-08: cleaned up
-- HB 2019-10-03: cleaned up code
-- HB 2019-05-31: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.fdl_pkg.all;

entity algo_pre_scaler_fractional_TB is
end algo_pre_scaler_fractional_TB;

architecture beh of algo_pre_scaler_fractional_TB is

    constant SIM : boolean := true;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
    signal request_update_factor_pulse, update_factor_pulse, start : std_logic := '0';
    signal algo : std_logic := '1';
    signal algo_o : std_logic;
    signal prescale_factor : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
    signal algo_cnt_sim : natural;
    signal prescaled_algo_cnt_sim : natural;

    constant PRESCALE_FACTOR_VALUE_1 : real := 0.00;
    constant PRESCALE_FACTOR_VALUE_INTEGER_1 : integer := integer(PRESCALE_FACTOR_VALUE_1 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_VEC_1 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_INTEGER_1, PRESCALE_FACTOR_WIDTH);
    constant PRESCALE_FACTOR_VALUE_2 : real := 4.00;
    constant PRESCALE_FACTOR_VALUE_INTEGER_2 : integer := integer(PRESCALE_FACTOR_VALUE_2 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_VEC_2 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_INTEGER_2, PRESCALE_FACTOR_WIDTH);
    constant PRESCALE_FACTOR_VALUE_3 : real := 6.00;
    constant PRESCALE_FACTOR_VALUE_INTEGER_3 : integer := integer(PRESCALE_FACTOR_VALUE_3 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_VEC_3 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_INTEGER_3, PRESCALE_FACTOR_WIDTH);
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
        wait for 10*LHC_CLK_PERIOD;
            start <= '1';
        wait for LHC_CLK_PERIOD;
            start <= '0';
        wait for LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_1;
        wait for 40*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 87*LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_2;
        wait for 36*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 111*LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_1;
        wait for 20*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 56*LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_3;
        wait for 27*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 79*LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_2;
        wait for 38*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 150*LHC_CLK_PERIOD;
            prescale_factor <= PRESCALE_FACTOR_VALUE_VEC_1;
        wait for 40*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
       wait;
    end process;

 ------------------- Instantiate  modules  -----------------

    dut: entity work.algo_pre_scaler
        generic map(PRESCALE_FACTOR_WIDTH, PRESCALE_FACTOR_INIT_VALUE_VEC, SIM)
        port map(
            clk => lhc_clk,
            algo_i => algo,
            start => start,
            request_update_factor_pulse => request_update_factor_pulse,
            update_factor_pulse => update_factor_pulse,
            prescale_factor => prescale_factor,
            prescaled_algo_o => open,
            prescaled_algo_cnt_sim => prescaled_algo_cnt_sim,
            algo_cnt_sim => algo_cnt_sim
        );

end beh;

