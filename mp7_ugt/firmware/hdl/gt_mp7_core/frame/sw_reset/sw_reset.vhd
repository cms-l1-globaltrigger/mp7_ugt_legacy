-------------------------------------------------------------------------------
-- Synthesizer : ISE 13.2
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description: Software Reset, Students
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/sw_reset/sw_reset.vhd $
-- $Date: 2014-07-02 14:05:41 +0200 (Wed, 02 Jul 2014) $
-- $Author: bergauer $
-- $Revision: 3006 $

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.math_pkg.all;
use work.rb_pkg.all;

entity sw_reset is
	port 
	(
		lhc_clk    : in std_logic;

		-- data interface for fpga access
		sw_reg_in  : in sw_reg_sw_reset_in_t; -- sw registers written via pci and read by the fpga

		-- the synchronized lhc reset
		sw_reset   : out std_logic
	); 
end;

architecture arch of sw_reset is
	signal reset_event_old     : std_logic := '0';
begin
	sync : process(lhc_clk)
	begin
		if rising_edge(lhc_clk) then
			reset_event_old <= sw_reg_in.reset_event;
		end if;
	end process;

	sw_reset <= '0' when reset_event_old /= sw_reg_in.reset_event else '1';
	
end architecture;



