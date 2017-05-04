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
---Description: Read-out Process, complex design, Specification and architecture design/implementation.
--             ROP moudule produce read-out recorrd for sending their to DAQ block in MP7 from there to
--              AMC13..
--              Please do not change any part of the design without to cousultate HEPHY, because the main part of design
--              will automated produced and you have to know, what do you do.
-- $Date: 2015-06-15 $
-- $Author: HEPHY $
-- Warning:  Reset logic should be re-designed. The current version is working but reset design should be changed in all sub-modules
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;

entity rop_sw_reg_synchronizer is
   port
   (
      lhc_clk : in  std_logic;
      lhc_rst : in  std_logic;

      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      sw_regs_lhc : in  sw_reg_rop_in_t;
      sw_regs_daq : out sw_reg_rop_in_t
   );
end rop_sw_reg_synchronizer;

architecture behavioral of rop_sw_reg_synchronizer is

   signal flag_lhc  : std_logic;
   signal flag_busy : std_logic;
   signal flag_daq  : std_logic;

   signal sw_regs_int : sw_reg_rop_in_t;

begin

   flag_lhc <= not flag_busy;

   flag_sync: entity work.flag_synchronizer
   generic map
   (
      RST_ACTIVE_LHC => RST_ACT,
      RST_ACTIVE_ROP => RST_ACT_ROP
   )
   port map
   (
      wr_clk => lhc_clk,
      wr_rst => lhc_rst,

      rd_clk => daq_clk,
      rd_rst => daq_rst,

      flagi  => flag_lhc,
      busy   => flag_busy,

      flago  => flag_daq
   );

   lhc_sync: process(lhc_clk,lhc_rst)
   begin

       if lhc_rst = RST_ACT then

         sw_regs_int <= SW_REG_ROP_IN_RESET;
      elsif rising_edge(lhc_clk) then
         if flag_lhc = '1' then
            sw_regs_int <= sw_regs_lhc;
         end if;
      end if;

   end process;

   daq_sync: process(daq_clk,daq_rst)
   begin

      if daq_rst = RST_ACT_ROP then
         sw_regs_daq <= SW_REG_ROP_IN_RESET;
      elsif rising_edge(daq_clk) then
         if flag_daq = '1' then
            sw_regs_daq <= sw_regs_int;
         end if;
      end if;

   end process;

end behavioral;

