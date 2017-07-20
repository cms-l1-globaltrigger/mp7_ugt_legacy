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

use work.gtl_pkg.all;

entity fdl_module_TB is
end fdl_module_TB;

architecture rtl of fdl_module_TB is

    constant SIM_MODE : boolean := true; -- if SIM_MODE = true, "algo_bx_mask" by default = 1.

    constant LHC_CLK_PERIOD  : time :=  25 ns;
    constant IPBUS_CLK_PERIOD  : time :=  8 ns;

    constant PRESCALER_COUNTER_WIDTH : integer := 24;
    type prescale_factor_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0); -- same width as PCIe data
    constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); -- written by TME
    constant PRESCALE_FACTOR_SET_INDEX_WIDTH : positive := 8;
    constant PRESCALE_FACTOR_SET_INDEX_REG_INIT : ipb_regs_array(0 to 1) := (others => X"00000000");
    constant CNTRL_REG_INIT : ipb_regs_array(0 to 1) := (others => X"00000000");
-- Input flip-flops for algorithms of fdl_module.vhd - used for tests of fdl_module.vhd only
    constant ALGO_INPUTS_FF: boolean := true;
-- HB 2014-02-28: changed vector length of init values for finor- and veto-maks, because of min. 32 bits for register
    constant MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ( others => X"00000001"); --Finor and veto masks registers (bit 0 = finor, bit 1 = veto)

    signal lhc_clk : std_logic;
    signal ipb_clk : std_logic;

    signal begin_lumi_section : std_logic := '0';

    signal ipb_in : ipb_wbus := IPB_WBUS_NULL;
    signal ipb_out : ipb_rbus;

    signal algo_in : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_bx_mask_sim : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '1');

--*********************************Main Body of Code**********************************
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

    ipbus_access_p: process
    begin
        wait for 207 ns;
        ipb_in <= (X"90010201", X"00000003", '1' ,'1'); -- prescale factor for algo(1) set to 3
        wait for IPBUS_CLK_PERIOD;
        ipb_in  <=  IPB_WBUS_NULL;
        wait for IPBUS_CLK_PERIOD;
        ipb_in <= (X"90091900", X"00000001", '1' ,'1'); -- request_update_factor_pulse
        wait for IPBUS_CLK_PERIOD;
        ipb_in  <=  IPB_WBUS_NULL;
        wait for IPBUS_CLK_PERIOD;
        wait for 900 ns;
        ipb_in <= (X"90010401", X"00000000", '1' ,'1'); -- finormask =0 for algo(1)
        wait for IPBUS_CLK_PERIOD;
        ipb_in  <=  IPB_WBUS_NULL;
        wait for IPBUS_CLK_PERIOD;
        wait for 577 ns;
        ipb_in <= (X"90010001", X"00000000", '1' ,'1'); -- rate-counter for algo(1)
        wait for IPBUS_CLK_PERIOD;
        ipb_in  <=  IPB_WBUS_NULL;
        wait for IPBUS_CLK_PERIOD;
        wait; 
    end process;

    begin_lumi_section_p: process
    begin
        wait for 507 ns;
        begin_lumi_section  <=  '1';
        wait for LHC_CLK_PERIOD;
        begin_lumi_section  <=  '0';
        wait for LHC_CLK_PERIOD;
--         wait; 
    end process;

    stimuli_p: process
    begin
        wait for 107 ns;
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for 200 ns;
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for 50 ns;
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "01"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "11"; 
        algo_bx_mask_sim <= "10"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "10"; 
        algo_bx_mask_sim <= "11"; 
        wait for LHC_CLK_PERIOD; 
        algo_in <= "00"; 
        wait for LHC_CLK_PERIOD; 
        wait; 
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.fdl_module
    generic map(
        SIM_MODE => SIM_MODE,
        PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT,
        MASKS_INIT => MASKS_INIT,
	PRESCALE_FACTOR_SET_INDEX_WIDTH => PRESCALE_FACTOR_SET_INDEX_WIDTH,
	PRESCALE_FACTOR_SET_INDEX_REG_INIT => PRESCALE_FACTOR_SET_INDEX_REG_INIT,
	CNTRL_REG_INIT => CNTRL_REG_INIT,
	ALGO_INPUTS_FF => ALGO_INPUTS_FF
	)
    port map( 
        ipb_clk         => ipb_clk,
        ipb_rst         => '0',
        ipb_in          => ipb_in,
        ipb_out         => open,
        lhc_clk         => lhc_clk,
        lhc_rst         => '0',
        bcres           => '0',
-- HB 2015-09-17: added "ec0", "resync" and "oc0" from "ctrs"
        ec0             => '0',
        resync          => '0',
        oc0             => '0',
        lhc_gap         => '0',
        begin_lumi_section => begin_lumi_section,
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
	local_finor_with_veto_o  => open,
        algo_bx_mask_sim => algo_bx_mask_sim
    );
  
end rtl;

