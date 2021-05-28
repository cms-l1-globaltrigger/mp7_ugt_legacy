
-- Description:
-- Prescalers for algorithms in FDL with fractional prescale values
-- bits 31:24 => fractional value (precision 2), bits 23:0 => integer digits
-- (for backward compatibility)

-- Version-history:
-- HB 2019-06-12: moved LUTs to algo_pre_scaler_fractional_pkg, using PRESCALER_MODE_SEQ_LEN for LUT selection, using fractional prescale values for all 3 LUTs with precision 2
-- HB 2019-06-03: changed mode_b_sel default value
-- HB 2019-05-31: updated for fractional prescale values (with precision 2)
-- HB 2016-04-04: inhibit algo with factor=0 in "prescaled_algo_p" process.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.algo_pre_scaler_fractional_pkg.all;

entity algo_pre_scaler is
   generic( 
      COUNTER_WIDTH : integer := 24;
      PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0) := X"00000001"; -- represents floting point notation of PRESCALE_FACTOR (=1.0)
      FRACTION_WIDTH : integer := 8;
      SIM : boolean := false
   );
   port( 
      clk : in std_logic;
      sres_counter : in std_logic;
      algo_i : in std_logic;
      request_update_factor_pulse : in std_logic;
      update_factor_pulse : in std_logic;
      prescale_factor : in std_logic_vector (FRACTION_WIDTH+COUNTER_WIDTH-1 DOWNTO 0); -- why counter_width ???
      prescaled_algo_o : out std_logic;
      -- output for simulation
      index_sim : out integer := 0;
      prescaled_algo_cnt_sim : out natural := 0;
      algo_cnt_sim : out natural := 0  
   );
end algo_pre_scaler;

architecture rtl of algo_pre_scaler is

   constant ZERO : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   
   signal prescale_factor_int : std_logic_vector(FRACTION_WIDTH+COUNTER_WIDTH-1 downto 0) := PRESCALE_FACTOR_INIT(FRACTION_WIDTH+COUNTER_WIDTH-1 downto 0);
   signal counter : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   signal fraction : std_logic_vector(FRACTION_WIDTH-1 downto 0) := (others => '0');
   signal factor : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   signal limit : std_logic := '0';
   signal mode_seq : std_logic_vector(0 to PRESCALER_MODE_SEQ_LEN-1);
   signal mode_len : natural;
   signal mode_b_sel : std_logic := '1'; -- to get first algo occurrence correct in simulation

begin

    assert (PRESCALER_MODE_SEQ_LEN = 1 or PRESCALER_MODE_SEQ_LEN = 10 or PRESCALER_MODE_SEQ_LEN = 20 or PRESCALER_MODE_SEQ_LEN = 100) report 
        "Wrong value for PRESCALER_MODE_SEQ_LEN = " & integer'image(PRESCALER_MODE_SEQ_LEN) 
    severity failure;        

    prescale_factor_update_i: entity work.update_process
    generic map(
        WIDTH => FRACTION_WIDTH+COUNTER_WIDTH,
        INIT_VALUE => PRESCALE_FACTOR_INIT
    )
    port map( 
        clk => clk,
        request_update_pulse => request_update_factor_pulse,
        update_pulse => update_factor_pulse,
        data_i => prescale_factor(FRACTION_WIDTH+COUNTER_WIDTH-1 downto 0),
        data_o => prescale_factor_int(FRACTION_WIDTH+COUNTER_WIDTH-1 downto 0)
    );
    
    fraction <= prescale_factor_int(FRACTION_WIDTH+COUNTER_WIDTH-1 downto COUNTER_WIDTH);
    factor <= prescale_factor_int(COUNTER_WIDTH-1 downto 0);
    
-- HB 2019-06-12: using fractional prescale values for all 3 LUTs with precision 2
    sel_fraction_i: if PRESCALER_MODE_SEQ_LEN /= 1 generate
-- Selection of LUT
        sel_lut_p: process (fraction)
            variable fraction_10, fraction_20 : natural;
        begin
            if PRESCALER_MODE_SEQ_LEN = 10 then
                fraction_10 := conv_integer(fraction) / 10;
                mode_seq <= MODE_SEQ_LUT_10(conv_integer(fraction_10)).mode;
                mode_len <= MODE_SEQ_LUT_10(conv_integer(fraction_10)).length;
            elsif PRESCALER_MODE_SEQ_LEN = 20 then
                fraction_20 := conv_integer(fraction) / 5;
                mode_seq <= MODE_SEQ_LUT_20(conv_integer(fraction_20)).mode;
                mode_len <= MODE_SEQ_LUT_20(conv_integer(fraction_20)).length;
            elsif PRESCALER_MODE_SEQ_LEN = 100 then
                mode_seq <= MODE_SEQ_LUT_100(conv_integer(fraction)).mode;
                mode_len <= MODE_SEQ_LUT_100(conv_integer(fraction)).length;
            end if;
        end process sel_lut_p;
        
-- Switching between mode A and B depending on mode sequences and mode length
       mode_sel_b_p: process (clk, sres_counter, update_factor_pulse, mode_seq, mode_len, algo_i, limit)
            variable index : integer := 0;
        begin
            if clk'event and clk = '1' then
                if sres_counter = '1' or update_factor_pulse = '1' then
                    index := 0;
                elsif (mode_len = index and limit = '1' and algo_i = '1') then
                    index := 0;
                    mode_b_sel <= mode_seq(index);
                    index := index + 1;
                elsif (mode_len >= index and limit = '1' and algo_i = '1') then
                    mode_b_sel <= mode_seq(index);
                    index := index + 1;
                end if;
                if SIM then
                    index_sim <= index - 1;
                end if;
            end if;
        end process mode_sel_b_p;
        
-- Comparing counter and factor depending on mode
        compare_p: process (clk, counter, factor)
        begin
            if clk'event and clk = '0' then 
                if (mode_b_sel = '1' and counter+1 = factor) then
                    limit <= '1';
                elsif (mode_b_sel = '0' and counter+1 = factor+1) then
                    limit <= '1';
                else
                    limit <= '0';
                end if;
            end if;
        end process compare_p;
    end generate sel_fraction_i;
    
    sel_integer_i: if PRESCALER_MODE_SEQ_LEN = 1 generate
-- Comparing counter and factor (if only integer prescale values are taken)
        compare_p: process (counter, factor)
        begin
            if (counter+1 = factor) then
                limit <= '1';
            else
                limit <= '0';
            end if;
        end process compare_p;
    end generate sel_integer_i;
    
-- Counting algos
    counter_p: process (clk, sres_counter, update_factor_pulse, algo_i, limit)
    begin
        if clk'event and clk = '1' then
            if (limit = '1' and algo_i = '1') or (sres_counter = '1') or (update_factor_pulse = '1') then
                counter <= (others => '0');
            elsif (limit = '0' and algo_i = '1') then
                counter <= counter + 1;
            end if;
        end if;
    end process counter_p;
    
-- Generating prescaled algos (prescale factor value = 0 => no prescaled algos)
    prescaled_algo_p: process (clk, algo_i, limit)
        variable algo_cnt : natural := 0;
    begin
        if clk'event and clk = '0' then 
            if factor = ZERO then
                prescaled_algo_o <= '0';
            elsif limit = '1' and algo_i = '1' then
                prescaled_algo_o <= '1';
            else
                prescaled_algo_o <= '0';
            end if;
        end if;
    end process prescaled_algo_p; 
    
-- Generating signals for simulation
    prescaled_algo_cnt_i: if SIM generate
        prescaled_algo_cnt_p: process (clk, algo_i, limit, sres_counter, update_factor_pulse)
            variable algo_cnt : natural := 0;
            variable prescaled_algo_cnt : natural := 0;
        begin
            if clk'event and clk = '0' then
                if sres_counter = '1' or update_factor_pulse = '1' then
                    prescaled_algo_cnt := 0;
                    algo_cnt := 0;
                elsif limit = '0' and algo_i = '1' then
                    algo_cnt := algo_cnt + 1;
                elsif limit = '1' and algo_i = '1' then
                    algo_cnt := algo_cnt + 1;
                    prescaled_algo_cnt := prescaled_algo_cnt + 1;
                end if;
                algo_cnt_sim <= algo_cnt;
                prescaled_algo_cnt_sim <= prescaled_algo_cnt;
            end if;
        end process prescaled_algo_cnt_p; 
    end generate prescaled_algo_cnt_i;
    
end architecture rtl;

