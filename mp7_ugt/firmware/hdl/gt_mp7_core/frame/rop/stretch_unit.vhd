-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: Read-out Process, complex design, Specification and architecture design/implementation::Babak, output logic scripts, babak 
--              students
--            : ROP moudule produce read-out recorrd for sending their to DAQ block in MP7 from there to 
--              AMC13..
--              Please do not change any part of the design without to cousultate Babak, because the main part of design
--              will automated produced and you have to know, what do you do.  
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/rop/stretch_unit.vhd $
-- $Date: 2015-03-03 19:25:25 +0100 (Tue, 03 Mar 2015) $
-- $Author: rahbaran $
-- $Revision: 3803 $
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity stretch_unit is
   generic
   (
      MAX_BX_IN_EVENT : integer := 7;
      
      RST_ACT : std_logic := '0'
   );
   port 
   (
      clk : in  std_logic;
      rst : in  std_logic;
      
      flag_i : in  std_logic;
      sig_o  : out  std_logic
   );
end stretch_unit;

architecture behavioral of stretch_unit is

   signal cnt, cnt_nxt : integer range 0 to MAX_BX_IN_EVENT := MAX_BX_IN_EVENT-1;
   
   signal sig_o_int : std_logic := '0';
   signal cnt_eq    : std_logic := '0';

begin

   process(cnt,flag_i)
      variable sig_o_v : std_logic;
      variable cnt_max : std_logic;
   begin
   
      cnt_nxt <= cnt;
      
      if cnt = MAX_BX_IN_EVENT-1 then
         cnt_max := '1';
      else
         cnt_max := '0';
      end if;
      
      sig_o_v := flag_i or not cnt_max;
      
      if sig_o_v = '1' then
         if flag_i = '1' then
            cnt_nxt <= 0;
         else 
            cnt_nxt <= cnt+1;
         end if;
      end if;
      
      sig_o <= sig_o_v;
   
   end process;

   sync: process(clk,rst)
   begin
   
      if rst = RST_ACT then
         cnt <= MAX_BX_IN_EVENT-1;
      elsif rising_edge(clk) then
         cnt <= cnt_nxt;
      end if;
   
   end process;
   

end behavioral;

