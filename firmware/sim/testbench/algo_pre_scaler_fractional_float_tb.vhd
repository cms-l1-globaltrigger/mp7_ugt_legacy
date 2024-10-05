
-- Description:
-- Testbench for prescalers (FDL) with fractional prescale values given in float

-- Version history:
-- HB 2022-09-08: cleaned up
-- HB 2019-10-03: cleaned up code
-- HB 2019-05-31: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;    -- for uniform & trunc functions
use ieee.std_logic_arith.all;

use work.fdl_pkg.all;

entity algo_pre_scaler_fractional_TB is
end algo_pre_scaler_fractional_TB;

architecture beh of algo_pre_scaler_fractional_TB is

    constant SIM : boolean := true;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;
    signal request_update_factor_pulse, update_factor_pulse, start : std_logic := '0';
    signal algo : std_logic := '0';
    signal prescale_factor_algo_1 : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
    signal prescale_factor_algo_2 : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
    signal algo_1_cnt_sim : natural;
    signal algo_2_cnt_sim : natural;
    signal prescaled_algo_1_cnt_sim : natural;
    signal prescaled_algo_2_cnt_sim : natural;
    signal prescaled_algo_1_o : std_logic;
    signal prescaled_algo_2_o : std_logic;

    constant PRESCALE_FACTOR_VALUE_ALGO_1_1 : real := 0.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_1 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_1_1 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_1_VEC_1 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_1, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_1_2 : real := 2.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_2 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_1_2 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_1_VEC_2 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_2, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_1_3 : real := 3.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_3 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_1_3 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_1_VEC_3 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_3, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_1_4 : real := 1.30;
    constant PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_4 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_1_4 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_1_VEC_4 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_1_INTEGER_4, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_2_1 : real := 0.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_1 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_2_1 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_2_VEC_1 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_1, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_2_2 : real := 4.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_2 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_2_2 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_2_VEC_2 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_2, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_2_3 : real := 6.00;
    constant PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_3 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_2_3 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_2_VEC_3 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_3, PRESCALE_FACTOR_WIDTH);

    constant PRESCALE_FACTOR_VALUE_ALGO_2_4 : real := 3.90;
    constant PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_4 : integer := integer(PRESCALE_FACTOR_VALUE_ALGO_2_4 * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_VALUE_ALGO_2_VEC_4 : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_VALUE_ALGO_2_INTEGER_4, PRESCALE_FACTOR_WIDTH);

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

    -- Algo
    process
        variable seed1: positive;    -- seed values for random generator
        variable seed2: positive;    -- seed values for random generator
        variable x : real;       -- random real-number value, range 0 - 1.0
        variable interval: integer;            -- noise interval
    begin
	    loop
            uniform(seed1, seed2, x);
            interval := integer(floor(x * 100.0));

            wait for LHC_CLK_PERIOD;
            algo <= '1';
            wait for LHC_CLK_PERIOD;
            algo <= '0';
            wait for interval*LHC_CLK_PERIOD;
        end loop;
    end process;

    process
    begin
        wait for 10*LHC_CLK_PERIOD;
            start <= '1';
        wait for LHC_CLK_PERIOD;
            start <= '0';
        wait for LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_1;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_1;
        wait for 40*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 87*LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_2;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_2;
        wait for 36*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 111*LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_1;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_1;
        wait for 20*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 56*LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_3;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_3;
        wait for 27*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 79*LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_2;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_2;
        wait for 38*LHC_CLK_PERIOD;
            request_update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            request_update_factor_pulse <= '0';
        wait for 30*LHC_CLK_PERIOD;
            update_factor_pulse <= '1';
        wait for LHC_CLK_PERIOD;
            update_factor_pulse <= '0';
        wait for 79*LHC_CLK_PERIOD;
            prescale_factor_algo_1 <= PRESCALE_FACTOR_VALUE_ALGO_1_VEC_4;
            prescale_factor_algo_2 <= PRESCALE_FACTOR_VALUE_ALGO_2_VEC_4;
        wait for 38*LHC_CLK_PERIOD;
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

    dut_1: entity work.algo_pre_scaler
        generic map(PRESCALE_FACTOR_WIDTH, PRESCALE_FACTOR_INIT_VALUE_VEC, SIM)
        port map(
            clk => lhc_clk,
            algo_i => algo,
            start => start,
            request_update_factor_pulse => request_update_factor_pulse,
            update_factor_pulse => update_factor_pulse,
            prescale_factor => prescale_factor_algo_1,
            prescaled_algo_o => prescaled_algo_1_o,
            prescaled_algo_cnt_sim => prescaled_algo_1_cnt_sim,
            algo_cnt_sim => algo_1_cnt_sim
        );

    dut_2: entity work.algo_pre_scaler
        generic map(PRESCALE_FACTOR_WIDTH, PRESCALE_FACTOR_INIT_VALUE_VEC, SIM)
        port map(
            clk => lhc_clk,
            algo_i => algo,
            start => start,
            request_update_factor_pulse => request_update_factor_pulse,
            update_factor_pulse => update_factor_pulse,
            prescale_factor => prescale_factor_algo_2,
            prescaled_algo_o => prescaled_algo_2_o,
            prescaled_algo_cnt_sim => prescaled_algo_2_cnt_sim,
            algo_cnt_sim => algo_2_cnt_sim
        );    

    check_shadow_i: entity work.check_shadow
        port map(
            clk => lhc_clk,
            prescaled_algo_1 => prescaled_algo_1_o,
            prescaled_algo_2 => prescaled_algo_2_o,
            shadow => open
        );

end beh;

