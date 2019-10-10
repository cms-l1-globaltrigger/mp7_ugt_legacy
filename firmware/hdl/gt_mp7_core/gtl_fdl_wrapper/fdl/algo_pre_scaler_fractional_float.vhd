
-- Description:
-- Prescalers for algorithms in FDL with fractional prescale values in float notation

-- Version-history:
-- HB 2019-10-04: new file name for fractional prescale values in float notation.
-- HB 2019-10-03: removed generic parameter PRESCALER_INCR [used as globaly, directly taken from fdl_pkg.vhd].
-- HB 2019-09-27: new generic parameter PRESCALER_INCR.
-- HB 2019-09-25: first design, based on proposal of A. Bocci (email: M. Jeitler, 25.9.2019, "Fwd: Fractional prescales")

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fdl_pkg.ALL;

entity algo_pre_scaler is
   generic( 
      PRESCALE_FACTOR_WIDTH : integer;
      PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0);
      SIM : boolean := false
   );
   port( 
      clk : in std_logic;
      sres_counter : in std_logic;
      algo_i : in std_logic;
      request_update_factor_pulse : in std_logic;
      update_factor_pulse : in std_logic;
      prescale_factor : in std_logic_vector (PRESCALE_FACTOR_WIDTH-1 DOWNTO 0); -- why counter_width ???
      prescaled_algo_o : out std_logic;
      -- output for simulation
      index_sim : out integer := 0;
      prescaled_algo_cnt_sim : out natural := 0;
      algo_cnt_sim : out natural := 0  
   );
end algo_pre_scaler;

architecture rtl of algo_pre_scaler is

   constant ZERO : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
   constant INCR : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := PRESCALER_INCR(PRESCALE_FACTOR_WIDTH-1 downto 0);
   
   signal prescale_factor_int : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := PRESCALE_FACTOR_INIT(PRESCALE_FACTOR_WIDTH-1 downto 0);
   signal counter : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
   signal factor : std_logic_vector(PRESCALE_FACTOR_WIDTH-1 downto 0) := (others => '0');
   signal limit : std_logic := '0';

begin

    prescale_factor_update_i: entity work.update_process
    generic map(
        WIDTH => PRESCALE_FACTOR_WIDTH,
        INIT_VALUE => PRESCALE_FACTOR_INIT
    )
    port map( 
        clk => clk,
        request_update_pulse => request_update_factor_pulse,
        update_pulse => update_factor_pulse,
        data_i => prescale_factor(PRESCALE_FACTOR_WIDTH-1 downto 0),
        data_o => prescale_factor_int(PRESCALE_FACTOR_WIDTH-1 downto 0)
    );
    
    factor <= prescale_factor_int(PRESCALE_FACTOR_WIDTH-1 downto 0);
    
-- Comparing counter and factor
    compare_p: process (counter, factor)
    begin
        if (counter+INCR >= factor) then
            limit <= '1';            
        else
            limit <= '0';
        end if;
    end process compare_p;

-- Counting algos
    counter_p: process (clk, sres_counter, update_factor_pulse, algo_i, limit)
    begin
        if clk'event and clk = '1' then
            if (sres_counter = '1') or (update_factor_pulse = '1') then
                counter <= (others => '0');
            elsif (limit = '1' and algo_i = '1') then
                counter <= counter+INCR-factor;
            elsif (limit = '0' and algo_i = '1') then
                counter <= counter+INCR;
            end if;
        end if;
    end process counter_p;
    
-- Generating prescaled algos (prescale factor value = 0 => no prescaled algos)
    prescaled_algo_p: process (clk, algo_i, limit, factor)
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

