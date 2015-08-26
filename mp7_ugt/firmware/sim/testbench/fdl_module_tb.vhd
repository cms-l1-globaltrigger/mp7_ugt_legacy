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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/testbench/demux_lane_data_tb.vhd $
-- $Date: 2015-04-30 10:46:28 +0200 (Don, 30 Apr 2015) $
-- $Author: bergauer $
-- $Revision: 3878 $
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

use work.ipbus.all;
use work.ipbus_trans_decl.all;
use work.mp7_data_types.all;

use work.gt_mp7_core_pkg.all;

-- use work.fdl_pkg.all;
-- use work.gtl_pkg.all;

entity fdl_module_TB is
end fdl_module_TB;

architecture rtl of fdl_module_TB is

    constant SIM_MODE : boolean := true; -- if SIM_MODE = true, "algo_bx_mask" by default = 1.

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    constant NR_ALGOS : positive := 16;

    constant PRESCALER_COUNTER_WIDTH : integer := 24;
    type prescale_factor_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0); -- same width as PCIe data
    constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); -- written by TME

-- HB 2014-02-28: changed vector length of init values for finor- and veto-maks, because of min. 32 bits for register
    constant MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); --Finor and veto masks registers (bit 0 = finor, bit 1 = veto)

    signal lhc_clk : std_logic;

    signal algo_in : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_bx_mask_sim : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '1');

--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
--         wait for 1207 ns; -- setup time for PLL for 80 MHz
--         algo_in <= X"0000"; 
--         wait for 3*LHC_CLK_PERIOD; 
--         algo_in <= X"0001"; 
--         wait for LHC_CLK_PERIOD; 
--         algo_in <= X"0000"; 
--         wait for LHC_CLK_PERIOD; 
--         algo_in <= X"0003"; 
--         wait for LHC_CLK_PERIOD; 
--         algo_in <= X"0000"; 
--         wait for LHC_CLK_PERIOD; 
--         algo_in <= X"0056"; 
--         wait for LHC_CLK_PERIOD; 
--         algo_in <= X"0000"; 
--         wait for LHC_CLK_PERIOD; 
--         wait; 
        wait for 1207 ns; -- setup time for PLL for 80 MHz
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0001"; 
        algo_bx_mask_sim <= X"FFFF"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0003"; 
        algo_bx_mask_sim <= X"FFFE"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0056"; 
        algo_bx_mask_sim <= X"FFFF"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= X"0000"; 
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.fdl_module
    generic map(
        SIM_MODE => SIM_MODE,
        PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT,
        MASKS_INIT => MASKS_INIT
    )
    port map( 
        ipb_clk         => '0',
        ipb_rst         => '0',
        ipb_in          => IPB_WBUS_NULL,
        ipb_out         => open,
-- ========================================================
--         clk160          => '0',
        lhc_clk         => lhc_clk,
        lhc_rst         => '0',
        bcres           => '0',
        lhc_gap         => '0',
        begin_lumi_section => '0',
        bx_nr           => (others => '0'),
        algo_i          => algo_in,
        fdl_status      => open,
        prescale_factor_set_index_rop => open,
        algo_before_prescaler_rop => open,
        algo_after_prescaler_rop  => open,
        algo_after_finor_mask_rop => open,
        local_finor_rop => open,
        local_veto_rop  => open,
        finor_2_mezz_lemo  => open,
        veto_2_mezz_lemo  => open,
	finor_with_veto_2_mezz_lemo  => open,
	local_finor_with_veto_o  => open,
        algo_bx_mask_sim => algo_bx_mask_sim
    );
  
end rtl;

