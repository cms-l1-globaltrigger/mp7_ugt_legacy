-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: ROP
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
-- Modification : I am not sure, if it is working correctly.
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flag_synchronizer is
   generic
   (
      RST_ACTIVE_LHC : std_logic := '1';
      RST_ACTIVE_ROP :std_logic  := '0'
   );
   port
   (
      wr_clk : in  std_logic;
      wr_rst : in  std_logic; -- with lhc_rst
      rd_clk : in  std_logic;
      rd_rst : in  std_logic; --with daq_rst

      flagi  : in  std_logic;
      busy   : out std_logic;

      flago  : out std_logic
   );
end flag_synchronizer;

architecture behavioral of flag_synchronizer is

   signal flag_toggle : std_logic := '0';
   signal busy_int    : std_logic := '0';

   signal toggle_synchronizer   : std_logic_vector(2 downto 0) := (others => '0');
   signal backward_synchronizer : std_logic_vector(1 downto 0) := (others => '0');

begin

   process(wr_clk,wr_rst)
   begin

      if wr_rst = RST_ACTIVE_LHC then
         flag_toggle <= '0';
         backward_synchronizer <= (others => '0');
      elsif rising_edge(wr_clk) then
         flag_toggle <= flag_toggle xor (flagi and not busy_int);
         backward_synchronizer(0) <= toggle_synchronizer(toggle_synchronizer'length-1);
         for i in 1 to backward_synchronizer'length-1 loop
            backward_synchronizer(i) <= backward_synchronizer(i-1);
         end loop;
      end if;

   end process;

   process(rd_clk,rd_rst)
   begin

      if rd_rst = RST_ACTIVE_ROP then
         toggle_synchronizer <= (others => '0');
      elsif rising_edge(rd_clk) then
         toggle_synchronizer(0) <= flag_toggle;
         for i in 1 to toggle_synchronizer'length-1 loop
            toggle_synchronizer(i) <= toggle_synchronizer(i-1);
         end loop;
      end if;

   end process;

   flago    <= toggle_synchronizer(toggle_synchronizer'length-1) xor
               toggle_synchronizer(toggle_synchronizer'length-2);
   busy_int <= flag_toggle xor backward_synchronizer(backward_synchronizer'length-1);
   busy     <= busy_int;

end behavioral;

