
-- Desription:
-- Rate counter for algorithms in FDL
-- Output synchronized with sys_clk, to prevent wrong counter values when reading via PCIe.
-- This design only works with LHC clock (40 MHz) and PCIe system clock (125 MHz)

-- HB 2016-06-28: removed clock domain change for counter_o.
-- HB 2015-09-17: inserted "clear counter value in the "output" register for reading by IPBus" with sres_counter = '1'.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity algo_rate_counter is
   generic(
      COUNTER_WIDTH : integer := 32
   );
   port(
      sys_clk          : in     std_logic;
      lhc_clk          : in     std_logic;
      sres_counter     : in     std_logic;
      store_cnt_value  : in     std_logic;
      algo_i           : in     std_logic;
      counter_o        : out    std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0) := (others => '0') -- init value (for simulation)
   );
end algo_rate_counter;

architecture rtl of algo_rate_counter is
    constant counter_end : std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0) := (others => '1'); -- counter stops at this value
    signal counter : std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0) := (others => '0');
    signal counter_int: std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0) := (others => '0');
    signal limit : std_logic := '0';
begin
   counter_p: process (lhc_clk, sres_counter, store_cnt_value, algo_i, limit, counter)
   begin
      if lhc_clk'event and lhc_clk = '1' then
        if sres_counter = '1' or store_cnt_value = '1' then
            if (limit = '0' and algo_i = '1') then
                counter <= std_logic_vector(to_unsigned(1, counter'length)); -- this (re)sets the counter value to 1 if there occurs a trigger just in the 'store_cnt_value' clk cycle
            else
                counter <= (others => '0'); -- clear counter with synchr. reset and store_cnt_value (which is begin of lumi section)
            end if;
         elsif limit = '1' then
            counter <= counter_end;
         elsif (limit = '0' and algo_i = '1') then
            counter <= counter + 1;
         end if;
      end if;
   end process counter_p;

   compare_p: process (counter)
   begin
      if (counter = counter_end) then
         limit <= '1';
      else
         limit <= '0';
      end if;
   end process compare_p;

   store_int_p: process (lhc_clk, counter, store_cnt_value)
   begin
      if lhc_clk'event and lhc_clk = '1' then
         if store_cnt_value = '1' then
            counter_int <= counter; -- "store" counter value internally for read access with store_cnt_value (which is begin of lumi section)
         end if;
      end if;
   end process store_int_p;
   
   counter_o <= counter_int;

end architecture rtl;

