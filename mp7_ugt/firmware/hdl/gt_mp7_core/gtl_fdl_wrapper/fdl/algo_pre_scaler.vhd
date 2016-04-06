--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_pre_scaler.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:
-- Prescalers for algorithms in FDL

-- HB 2016-04-04: inhibit algo with factor=0 in "prescaled_algo_p" process.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity algo_pre_scaler is
   generic( 
      COUNTER_WIDTH : integer := 24;
      PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0) := X"00000001"
   );
   port( 
      clk              : in     std_logic;
      sres_counter     : in     std_logic;
      algo_i           : in     std_logic;
      request_update_factor_pulse   : in     std_logic;
      update_factor_pulse    : in     std_logic;
      prescale_factor  : in     std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0); -- why counter_width ???
      prescaled_algo_o : out    std_logic
   );
end algo_pre_scaler;

architecture rtl of algo_pre_scaler is
   constant ZERO : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');

   signal prescale_factor_int : std_logic_vector(COUNTER_WIDTH-1 downto 0) := PRESCALE_FACTOR_INIT(COUNTER_WIDTH-1 downto 0);
   signal counter : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   signal limit : std_logic := '0';
   signal request_ff : std_logic := '0';
begin

prescale_factor_update_i: entity work.update_process
    generic map(
        WIDTH => COUNTER_WIDTH,
        INIT_VALUE => PRESCALE_FACTOR_INIT
    )
    port map( 
        clk => clk,
        request_update_pulse => request_update_factor_pulse,
        update_pulse => update_factor_pulse,
        data_i => prescale_factor(COUNTER_WIDTH-1 downto 0),
        data_o => prescale_factor_int
    );

   counter_p: process (clk, sres_counter, algo_i, limit)
   begin
      if clk'event and clk = '1' then
         if (limit = '1' and algo_i = '1') or (sres_counter = '1') or (update_factor_pulse = '1') then
            counter <= (others => '0');
         elsif (limit = '0' and algo_i = '1') then
            counter <= counter + 1;
         end if;
      end if;
   end process counter_p;

   compare_p: process (counter, prescale_factor_int)
   begin
      if (counter+1 = prescale_factor_int) then
         limit <= '1';
      else
         limit <= '0';
      end if;
   end process compare_p;

--    prescaled_algo_p: process (algo_i, limit)
--    begin
--       if limit = '1' and algo_i = '1' then
--          prescaled_algo_o <= '1';
--       else
--          prescaled_algo_o <= '0';
--       end if;
--    end process prescaled_algo_p;   

-- HB 04-09-2013: process with clk needed to get prescaled_algo_o with clk period width, otherwise
-- "glitches" on prescaled_algo_o occur.
-- This gives an additional latency of one bx in FDL.
--      if clk'event and clk = '1' then

-- HB 09-09-2013: process with clk needed to get prescaled_algo_o with clk period width, otherwise
-- "glitches" on prescaled_algo_o occur.
-- Using negative edge of lhc_clk gives no latency.
-- Check whether timing is ok for clk-nclk-clk !!!

-- HB 2016-04-04: bug fix for factor=0. Inhibit algo with factor=0 in "prescaled_algo_p" process.

   prescaled_algo_p: process (clk, algo_i, limit, prescale_factor_int)
   begin
      if clk'event and clk = '0' then 
        if prescale_factor_int = ZERO then
            prescaled_algo_o <= '0';
        elsif limit = '1' and algo_i = '1' then
            prescaled_algo_o <= '1';
        else
            prescaled_algo_o <= '0';
        end if;
      end if;
   end process prescaled_algo_p;   

end architecture rtl;

