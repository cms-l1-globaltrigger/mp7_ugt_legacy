-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.2
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: Dual Clock synchronizer
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/synchronizer/dualclock_synchronizer.vhd $
-- $Date: 2014-07-02 14:05:41 +0200 (Wed, 02 Jul 2014) $
-- $Author: bergauer $
-- $Revision: 3006 $

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dualclock_synchronizer is
   generic
   (
      DATA_WIDTH : integer := 8;
      RST_ACTIVE : std_logic := '0'
   );
   port 
   (
      wr_clk   : in  std_logic;
      wr_rst   : in  std_logic;
      rd_clk   : in  std_logic;
      rd_rst   : in  std_logic;
      
      din      : in  std_logic_vector (DATA_WIDTH-1 downto 0);
      din_set  : in  std_logic;
      din_busy : out std_logic;
      
      dout     : out std_logic_vector (DATA_WIDTH-1 downto 0);
      dout_ch  : out std_logic
   );
end dualclock_synchronizer;

architecture behavioral of dualclock_synchronizer is
   
   signal busy_int : std_logic := '0';
   
   signal in_reg     : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
   signal in_reg_en  : std_logic := '0';
   
   signal out_reg_en : std_logic := '0';

begin

   flag_sync: entity work.flag_synchronizer
   generic map
   (
      RST_ACTIVE => RST_ACTIVE
   )
   port map
   (
      wr_clk => wr_clk,
      wr_rst => wr_rst,
      rd_clk => rd_clk,
      rd_rst => rd_rst,
      
      flagi  => din_set,
      busy   => busy_int,
      
      flago  => out_reg_en
   );
   
   in_reg_en <= din_set and not busy_int;
   din_busy  <= busy_int;
   
   process(wr_clk,wr_rst)
   begin
   
      if wr_rst = RST_ACTIVE then
         in_reg <= (others => '0');
      elsif rising_edge(wr_clk) and in_reg_en = '1' then
         in_reg <= din;
      end if;

   end process;
   
   process(rd_clk,rd_rst)
   begin
   
      if rd_rst = RST_ACTIVE then
         dout <= (others => '0');
         dout_ch <= '0';
      elsif rising_edge(rd_clk) then
         dout_ch <= out_reg_en;
         if out_reg_en = '1' then
            dout <= in_reg;
         end if;
      end if;

   end process;   
      
end behavioral;

