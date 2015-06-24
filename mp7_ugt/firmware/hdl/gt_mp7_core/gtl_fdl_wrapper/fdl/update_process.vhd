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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/fdl/update_process.vhd $
-- $Date: 2015-06-16 11:48:44 +0200 (Tue, 16 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4043 $
--------------------------------------------------------------------------------

-- Desription:
-- Update process for prescalers for algorithms in FDL

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity update_process is
   generic( 
      WIDTH : integer := 24;
      INIT_VALUE : std_logic_vector(31 DOWNTO 0) := X"00000001"
   );
   port( 
      clk              : in std_logic;
      request_update_pulse : in std_logic;
      update_pulse : in std_logic;
      data_i           : in std_logic_vector(WIDTH-1 downto 0);
      data_o           : out std_logic_vector(WIDTH-1 downto 0)
   );
end update_process;

architecture rtl of update_process is
   signal request_ff : std_logic := '0';
   signal data_int : std_logic_vector(WIDTH-1 downto 0) := INIT_VALUE(WIDTH-1 downto 0);
begin

   request_ff_p: process (clk, request_update_pulse, update_pulse)
   begin
      if clk'event and clk = '1' then
         if request_update_pulse = '1' then
            request_ff <= '1'; -- set if update is requested
         elsif update_pulse = '1' then
            request_ff <= '0'; -- clear with "update" pulse (e.g.: begin of lumi-section)
         end if;
      end if;
   end process request_ff_p;

   update_factor_p: process (clk, request_ff, update_pulse, data_i)
   begin
      if clk'event and clk = '1' and request_ff = '1' and update_pulse = '1' then
         data_int <= data_i; -- load data_i to data_int, if requested and "update" pulse (e.g.: begin of lumi-section)
      end if;
   end process update_factor_p;

    data_o <= data_int;

end architecture rtl;

