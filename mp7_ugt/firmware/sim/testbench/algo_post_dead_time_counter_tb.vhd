--------------------------------------------------------------------------------
-- Simulator   : Modelsim 10.1
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Simulation
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/testbench/esums_conditions_tb.vhd $
-- $Date: 2015-05-20 11:40:51 +0200 (Mit, 20 Mai 2015) $
-- $Author: bergauer $
-- $Revision: 3958 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;

entity algo_post_dead_time_counter_TB is
end algo_post_dead_time_counter_TB;

architecture rtl of algo_post_dead_time_counter_TB is

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;
    constant IPBUS_CLK_PERIOD  : time :=  8 ns;
    constant MAX_DELAY : integer := 32;
    
    signal lhc_clk : std_logic;
    signal ipb_clk : std_logic;

    signal lhc_res : std_logic := '0';
    signal sres_counter : std_logic := '0';
    signal begin_lumi_section, begin_lumi_section_s : std_logic := '0';
    signal l1a, l1a_s : std_logic := '0';
    signal delay : std_logic_vector(log2c(MAX_DELAY)-1 downto 0) := "00101";
    signal algo, algo_s : std_logic := '0';

begin
    
    -- Clock
    lhc_clk_p: process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    ipbus_clk_p: process
    begin
        ipb_clk  <=  '1';
        wait for IPBUS_CLK_PERIOD/2;
        ipb_clk  <=  '0';
        wait for IPBUS_CLK_PERIOD/2;
    end process;

    l1a_p: process
    begin
        wait for 150 ns;
        l1a  <=  '1';
        wait for LHC_CLK_PERIOD;
        l1a  <=  '0';
        wait for LHC_CLK_PERIOD;
    end process;

    begin_lumi_section_p: process
    begin
        wait for 300 ns;
        begin_lumi_section  <=  '1';
        wait for LHC_CLK_PERIOD;
        begin_lumi_section  <=  '0';
        wait for LHC_CLK_PERIOD;
    end process;

    stimuli_p: process
    begin
        wait for 50 ns;
        algo <= '1'; 
        wait for LHC_CLK_PERIOD; 
        algo <= '0'; 
        wait for 175 ns;
        algo <= '1'; 
        wait for LHC_CLK_PERIOD; 
        algo <= '0'; 
        wait for 175 ns;
        algo <= '1'; 
        wait for LHC_CLK_PERIOD; 
        algo <= '0'; 
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------

   synchr_p: process (lhc_clk, l1a, begin_lumi_section, algo)
   begin
      if lhc_clk'event and lhc_clk = '1' then
	  l1a_s <= l1a;
	  begin_lumi_section_s <= begin_lumi_section;
	  algo_s <= algo;
      end if;
   end process synchr_p;

dut: entity work.algo_post_dead_time_counter
    generic map(32, MAX_DELAY)
    port map(ipb_clk, lhc_clk, lhc_res, sres_counter, begin_lumi_section_s, l1a_s, delay, algo_s, open);

end rtl;
