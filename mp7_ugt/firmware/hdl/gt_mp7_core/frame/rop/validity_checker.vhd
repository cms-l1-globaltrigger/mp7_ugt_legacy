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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/rop/validity_checker.vhd $
-- $Date: 2015-03-03 19:25:25 +0100 (Tue, 03 Mar 2015) $
-- $Author: rahbaran $
-- $Revision: 3803 $

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity validity_checker is
   generic
   (
      MAX_BX_IN_EVENT : integer := 7;
      
      RST_ACT : std_logic := '0'
   );
   port 
   (
      clk : in  std_logic;
      rst : in  std_logic;
      
      valid_i : in  std_logic;
      valid_o : out std_logic
   );
end validity_checker;

architecture behavioral of validity_checker is

   signal cnt, cnt_nxt : integer range 0 to MAX_BX_IN_EVENT-1 := 0;

begin

   counter_p: process(cnt,valid_i)
      variable cnt_en  : std_logic;
      variable cnt_max : std_logic;
   begin
     
      cnt_nxt <= cnt;
      
      if cnt = MAX_BX_IN_EVENT-2 then
         cnt_max := '1';
      else
         cnt_max := '0';
      end if;
      
      cnt_en := (valid_i and not cnt_max) or not valid_i;
      
      if cnt_en = '1' then
         if valid_i = '1' then
            cnt_nxt <= cnt+1;
         else
            cnt_nxt <= 0;
         end if;
      end if;
      
      valid_o <= cnt_max and valid_i;   
   
   end process;
   
   sync: process(clk,rst)
   begin
   
      if rst = RST_ACT then
         cnt <= 0;
      elsif rising_edge(clk) then
         cnt <= cnt_nxt;
      end if;
   
   end process;


end behavioral;

