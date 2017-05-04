--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL:  $
-- $Date:  $
-- $Author: HEPHY $
-- $Revision: 0.1  $
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity crc16d32 is
   generic
   (
      RST_ACTIVE : std_logic := '0'
   );
   port
   (
      clk      : in  std_logic;
      rst      : in  std_logic;

      soc        : in  std_logic;
      data       : in  std_logic_vector(31 downto 0);
      data_valid : in  std_logic;
      eoc        : in  std_logic;
      crc        : out std_logic_vector(15 downto 0);

      crc_valid  : out std_logic
   );
end crc16d32;

architecture behavioral of crc16d32 is

   constant crc_const : std_logic_vector(15 downto 0) := (others => '0');

   signal crc_r : std_logic_vector(15 downto 0);
   signal crc_c : std_logic_vector(15 downto 0);
   signal crc_i : std_logic_vector(15 downto 0);

begin

   crc_i <= crc_const when soc = '1' else crc_r;

   crc_c(0)  <= data(0) xor data(1) xor data(15) xor data(30) xor crc_i(14) xor data(2) xor data(16) xor crc_i(0) xor data(31) xor crc_i(15) xor data(3) xor data(17) xor crc_i(1) xor data(4) xor data(18) xor crc_i(2) xor data(5) xor data(19) xor crc_i(3) xor data(6) xor data(20) xor crc_i(4) xor data(7) xor data(21) xor crc_i(5) xor data(8) xor data(22) xor crc_i(6) xor data(9) xor data(23) xor crc_i(7) xor data(10) xor data(24) xor crc_i(8) xor data(11) xor data(25) xor crc_i(9) xor data(12) xor data(26) xor crc_i(10) xor data(13) xor data(27) xor crc_i(11);
   crc_c(1)  <= data(1) xor data(2) xor data(16) xor crc_i(0) xor data(31) xor crc_i(15) xor data(3) xor data(17) xor crc_i(1) xor data(4) xor data(18) xor crc_i(2) xor data(5) xor data(19) xor crc_i(3) xor data(6) xor data(20) xor crc_i(4) xor data(7) xor data(21) xor crc_i(5) xor data(8) xor data(22) xor crc_i(6) xor data(9) xor data(23) xor crc_i(7) xor data(10) xor data(24) xor crc_i(8) xor data(11) xor data(25) xor crc_i(9) xor data(12) xor data(26) xor crc_i(10) xor data(13) xor data(27) xor crc_i(11) xor data(14) xor data(28) xor crc_i(12);
   crc_c(2)  <= data(0) xor data(14) xor data(28) xor crc_i(12) xor data(29) xor crc_i(13) xor data(1) xor data(30) xor crc_i(14) xor data(16) xor crc_i(0) xor data(31) xor crc_i(15);
   crc_c(3)  <= data(1) xor data(15) xor data(29) xor crc_i(13) xor data(30) xor crc_i(14) xor data(2) xor data(31) xor crc_i(15) xor data(17) xor crc_i(1);
   crc_c(4)  <= data(2) xor data(16) xor data(30) xor crc_i(14) xor crc_i(0) xor data(31) xor crc_i(15) xor data(3) xor data(18) xor crc_i(2);
   crc_c(5)  <= data(3) xor data(17) xor data(31) xor crc_i(15) xor crc_i(1) xor data(4) xor data(19) xor crc_i(3);
   crc_c(6)  <= data(4) xor data(18) xor crc_i(2) xor data(5) xor data(20) xor crc_i(4);
   crc_c(7)  <= data(5) xor data(19) xor crc_i(3) xor data(6) xor data(21) xor crc_i(5);
   crc_c(8)  <= data(6) xor data(20) xor crc_i(4) xor data(7) xor data(22) xor crc_i(6);
   crc_c(9)  <= data(7) xor data(21) xor crc_i(5) xor data(8) xor data(23) xor crc_i(7);
   crc_c(10) <= data(8) xor data(22) xor crc_i(6) xor data(9) xor data(24) xor crc_i(8);
   crc_c(11) <= data(9) xor data(23) xor crc_i(7) xor data(10) xor data(25) xor crc_i(9);
   crc_c(12) <= data(10) xor data(24) xor crc_i(8) xor data(11) xor data(26) xor crc_i(10);
   crc_c(13) <= data(11) xor data(25) xor crc_i(9) xor data(12) xor data(27) xor crc_i(11);
   crc_c(14) <= data(12) xor data(26) xor crc_i(10) xor data(13) xor data(28) xor crc_i(12);
   crc_c(15) <= data(0) xor data(14) xor data(29) xor crc_i(13) xor data(1) xor data(15) xor data(30) xor crc_i(14) xor data(2) xor data(16) xor crc_i(0) xor data(31) xor crc_i(15) xor data(3) xor data(17) xor crc_i(1) xor data(4) xor data(18) xor crc_i(2) xor data(5) xor data(19) xor crc_i(3) xor data(6) xor data(20) xor crc_i(4) xor data(7) xor data(21) xor crc_i(5) xor data(8) xor data(22) xor crc_i(6) xor data(9) xor data(23) xor crc_i(7) xor data(10) xor data(24) xor crc_i(8) xor data(11) xor data(25) xor crc_i(9) xor data(12) xor data(26) xor crc_i(10);

   crc_gen_p : process(clk,rst)
   begin

      if rst = RST_ACTIVE then
         crc_r <= crc_const;
      elsif rising_edge(clk) then
         if data_valid = '1' then
            crc_r <= crc_c;
         end if;
      end if;

   end process;


   crc_valid_p : process(clk,rst)
   begin

      if rst = RST_ACTIVE then
         crc_valid <= '0';
      elsif rising_edge(clk) then
         if (data_valid and eoc) = '1' then
            crc_valid <= '1';
         else
            crc_valid <= '0';
         end if;
      end if;

   end process;

   crc <= crc_r;

end behavioral;
