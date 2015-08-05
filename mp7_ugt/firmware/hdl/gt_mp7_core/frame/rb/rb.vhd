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
---Description:Lane Mapping Process, Developer Babak, Markus
-- $HeadURL: $
-- $Date:  $
-- $Author: ?$
-- Modification : Babak
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.gt_mp7_core_pkg.all;
use work.math_pkg.all;
use work.rb_pkg.all;

entity rb is
--     generic(
--         addr_width : natural := 12
--     );
	port 
	(
		sys_clk           : in std_logic;
		lhc_clk           : in std_logic;
		sys_rst           : in std_logic;
		lhc_rst           : in std_logic;

		-- data interface for IPBus
		data_acc_in  : in ipb_wbus;
		data_acc_out : out ipb_rbus;

		-- data interface for fpga access
		sw_regs_in  : out sw_regs_in_t; -- sw registers written via software(uhal) and read by the fpga(Ipbus:frame_fabric)
		sw_regs_out : in sw_regs_out_t  -- sw registers read via software(uhal) and written by the fpga(Ipbus:frame_fabric)
	); 
end;

architecture arch of rb is
	constant rb_addr_width : natural := 12;

-- CTRL registers
	constant OFFSET_DSMUX : std_logic_vector(rb_addr_width-1 downto 0) := X"04C";
	constant OFFSET_L1ASIM_CONFIG : std_logic_vector(rb_addr_width-1 downto 0) := X"140";
	constant OFFSET_L1ASIM_ORBIT_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := X"144";
	constant OFFSET_L1ASIM_ORBIT_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := X"148";
	constant OFFSET_L1ASIM_PATTERN_A0 : std_logic_vector(rb_addr_width-1 downto 0) := X"14C";
	constant OFFSET_L1ASIM_PATTERN_A1 : std_logic_vector(rb_addr_width-1 downto 0) := X"150";
	constant OFFSET_L1ASIM_PATTERN_A2 : std_logic_vector(rb_addr_width-1 downto 0) := X"154";
	constant OFFSET_L1ASIM_PATTERN_A3 : std_logic_vector(rb_addr_width-1 downto 0) := X"158";
	constant OFFSET_L1ASIM_PATTERN_A4 : std_logic_vector(rb_addr_width-1 downto 0) := X"15C";
	constant OFFSET_L1ASIM_PATTERN_B0 : std_logic_vector(rb_addr_width-1 downto 0) := X"160";
	constant OFFSET_L1ASIM_PATTERN_B1 : std_logic_vector(rb_addr_width-1 downto 0) := X"164";
	constant OFFSET_L1ASIM_PATTERN_B2 : std_logic_vector(rb_addr_width-1 downto 0) := X"168";
	constant OFFSET_L1ASIM_PATTERN_B3 : std_logic_vector(rb_addr_width-1 downto 0) := X"16C";
	constant OFFSET_L1ASIM_PATTERN_B4 : std_logic_vector(rb_addr_width-1 downto 0) := X"170";
	constant OFFSET_SPYTRIGGER_ORBIT_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := X"300";
	constant OFFSET_SPYTRIGGER_ORBIT_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := X"304";
	constant OFFSET_SPYTRIGGER_CONTROL : std_logic_vector(rb_addr_width-1 downto 0) := X"308";
	constant OFFSET_SW_RESET_RESET_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := X"05C";
	constant OFFSET_DM_DELAY_MUONS : std_logic_vector(rb_addr_width-1 downto 0) := X"014";
	constant OFFSET_DM_DELAY_EG : std_logic_vector(rb_addr_width-1 downto 0) := X"018";
	constant OFFSET_DM_DELAY_TAU : std_logic_vector(rb_addr_width-1 downto 0) := X"01c";
	constant OFFSET_DM_DELAY_JET : std_logic_vector(rb_addr_width-1 downto 0) := X"020";
	constant OFFSET_DM_DELAY_ETT : std_logic_vector(rb_addr_width-1 downto 0) := X"024";
	constant OFFSET_DM_DELAY_HT : std_logic_vector(rb_addr_width-1 downto 0) := X"028";
	constant OFFSET_DM_DELAY_ETM : std_logic_vector(rb_addr_width-1 downto 0) := X"02c";
	constant OFFSET_DM_DELAY_HTM : std_logic_vector(rb_addr_width-1 downto 0) := X"030";
	constant OFFSET_DM_DELAY_EXT_CON : std_logic_vector(rb_addr_width-1 downto 0) := X"034";
	constant OFFSET_DM_DELAY_BCRES : std_logic_vector(rb_addr_width-1 downto 0) := X"038";
	constant OFFSET_DM_DELAY_BCRES_FDL : std_logic_vector(rb_addr_width-1 downto 0) := X"03c";
	constant OFFSET_TCM_CMDIGNBCRES : std_logic_vector(rb_addr_width-1 downto 0) := X"100";
	constant OFFSET_TCM_ERR_DET_RESET_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := X"128";
	constant OFFSET_TCM_BGOS : std_logic_vector(rb_addr_width-1 downto 0) := X"138";
	constant OFFSET_TCM_BGOS_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := X"13C";
	constant OFFSET_TCM_TEST_REG : std_logic_vector(rb_addr_width-1 downto 0) := X"174";
	constant OFFSET_TCM_LIMINOSITY_SEG_PERIOD_MSK : std_logic_vector(rb_addr_width-1 downto 0) := X"108";
	constant OFFSET_ROP_VERSION : std_logic_vector(rb_addr_width-1 downto 0) := X"200";
	constant OFFSET_ROP_BOARDID : std_logic_vector(rb_addr_width-1 downto 0) := X"204";
	constant OFFSET_ROP_TOTAL_BX_IN_EVENT_DECISION : std_logic_vector(rb_addr_width-1 downto 0) := X"208";
	constant OFFSET_ROP_TOTAL_BX_IN_EVENT_EXT_COND : std_logic_vector(rb_addr_width-1 downto 0) := X"20C";
	constant OFFSET_ROP_TOTAL_BX_IN_EVENT_GMT : std_logic_vector(rb_addr_width-1 downto 0) := X"210";
	constant OFFSET_ROP_TOTAL_BX_IN_EVENT_GCT : std_logic_vector(rb_addr_width-1 downto 0) := X"214";
	constant OFFSET_ROP_PRESCALE_FACTOR_SET_INDEX : std_logic_vector(rb_addr_width-1 downto 0) := X"218";
	constant OFFSET_ROP_LHC_DATA_DELAY : std_logic_vector(rb_addr_width-1 downto 0) := X"21C";
	constant OFFSET_ROP_TCM_DELAY : std_logic_vector(rb_addr_width-1 downto 0) := X"220";
	constant OFFSET_ROP_ALGO_DELAY : std_logic_vector(rb_addr_width-1 downto 0) := X"224";
	constant OFFSET_ROP_BUSY_RESET_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := X"22C";
	constant OFFSET_ROP_PAYLOAD : std_logic_vector(rb_addr_width-1 downto 0) := X"230";



-- BR 2015-05-10: changed status register addresses
	constant OFFSET_SPYTRIGGER_STATUS : std_logic_vector(rb_addr_width-1 downto 0) := X"000";
	constant OFFSET_DM_STATUS : std_logic_vector(rb_addr_width-1 downto 0) := X"001";
	constant OFFSET_TCM_STATUS_BX_NR : std_logic_vector(rb_addr_width-1 downto 0) := X"002";
	constant OFFSET_TCM_STATUS_EVENT_NR : std_logic_vector(rb_addr_width-1 downto 0) := X"003";
	constant OFFSET_TCM_STATUS_TRIGGER_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := X"004";
	constant OFFSET_TCM_STATUS_TRIGGER_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := X"005";
	constant OFFSET_TCM_STATUS_ORBIT_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := X"006";
	constant OFFSET_TCM_STATUS_ORBIT_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := X"007";
	constant OFFSET_TCM_STATUS_BX_NR_CHK : std_logic_vector(rb_addr_width-1 downto 0) := X"008";
	constant OFFSET_TCM_STATUS_BX_NR_MAX : std_logic_vector(rb_addr_width-1 downto 0) := X"009";
	constant OFFSET_TCM_STATUS_ERR_DET : std_logic_vector(rb_addr_width-1 downto 0) := X"00A";
	constant OFFSET_TCM_STATUS_BX_NR_D_FDL : std_logic_vector(rb_addr_width-1 downto 0) := X"00B";
	constant OFFSET_TCM_LIMINOSITY_SEG_NR : std_logic_vector(rb_addr_width-1 downto 0) := X"00C";
	constant OFFSET_ROP_STATUS : std_logic_vector(rb_addr_width-1 downto 0) := X"00D";

-- 	signal stat_reg: ipb_reg_v(2 ** (rb_addr_width-1) - 1 downto 0);
	signal stat_reg: ipb_reg_v(13 downto 0);
	signal ctrl_reg: ipb_reg_v(2 ** (rb_addr_width-1) - 1 downto 0);
-- 	signal stat_reg: ipb_reg_v(2 ** rb_addr_width - 1 downto 0);
-- 	signal ctrl_reg: ipb_reg_v(2 ** rb_addr_width - 1 downto 0);


begin

-- ipbus_syncreg_v
--
-- Generic control / status register bank
--
-- Provides N_CTRL control registers (32b each), rw
-- Provides N_STAT status registers (32b each), ro
--
-- Bottom part of read address space is control, top is status
--
-- Both control and status are moved across clock domains with full handshaking
-- This may be overkill for some applications
--
-- Dave Newbold, June 2013

	rb_i: entity work.ipbus_syncreg_v
		generic map(
---- BR 2015-05-04: bug fixed region for status register 
-- 			N_CTRL => 2 ** rb_addr_width,
-- 			N_STAT => 2 ** rb_addr_width
			N_CTRL => 2 ** (rb_addr_width-1),
-- BR 2015-05-04:: changed status register addresses
-- 			N_STAT => 2 ** (rb_addr_width-1)
			N_STAT => 14
		)
		port map(
			clk => sys_clk,
			rst => sys_rst,
			ipb_in => data_acc_in,
			ipb_out => data_acc_out,
			slv_clk => lhc_clk, 
---- BR 2015-05-04:: bug fixed region for status register 
-- 			d => stat_reg(2 ** rb_addr_width - 1 downto 0),
-- 			q => ctrl_reg(2 ** rb_addr_width - 1 downto 0)
			d => stat_reg(13 downto 0),
			q => ctrl_reg(2 ** (rb_addr_width-1) - 1 downto 0)
		);

-- CTRL registers
-- dsmux
	sw_regs_in.dsmux.muon_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(0);
	sw_regs_in.dsmux.eg_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(1);
	sw_regs_in.dsmux.tau_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(2);
	sw_regs_in.dsmux.jet_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(3);
	sw_regs_in.dsmux.ett_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(4);
	sw_regs_in.dsmux.ht_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(5);
	sw_regs_in.dsmux.etm_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(6);
	sw_regs_in.dsmux.htm_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(7);
	sw_regs_in.dsmux.ext_con_src <= ctrl_reg(to_integer(unsigned(OFFSET_DSMUX)))(8);

-- l1asim
	sw_regs_in.l1asim.enable_l1a_sim <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_CONFIG)))(0);
-- **********************
-- BR 2015-05-04:: event register implementation - has to be checked in HW !!!
-- 	l1asim_fire_once_event_int <= not l1asim_fire_once_event_int when ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_CONFIG)))(1) = '1' else l1asim_fire_once_event_int;
-- 	sw_regs_in.l1asim.fire_once_event <= l1asim_fire_once_event_int;

--BR 2015-05-04:: changed event register (not working) to "in-register"
	sw_regs_in.l1asim.fire_once_event <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_CONFIG)))(1);
-- **********************
	sw_regs_in.l1asim.cntrl <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_CONFIG)))(3 downto 2);
	sw_regs_in.l1asim.orbit_nr(31 downto 0) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_ORBIT_NR_L)))(31 downto 0);
	sw_regs_in.l1asim.orbit_nr(ORBIT_NR_WIDTH-1 downto 32) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_ORBIT_NR_L)))(ORBIT_NR_WIDTH-1-32 downto 0);
	sw_regs_in.l1asim.pattern_a(0) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_A0)))(11 downto 0);
	sw_regs_in.l1asim.pattern_a(1) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_A1)))(11 downto 0);
	sw_regs_in.l1asim.pattern_a(2) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_A2)))(11 downto 0);
	sw_regs_in.l1asim.pattern_a(3) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_A3)))(11 downto 0);
	sw_regs_in.l1asim.pattern_a(4) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_A4)))(11 downto 0);
	sw_regs_in.l1asim.pattern_b(0) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_B0)))(11 downto 0);
	sw_regs_in.l1asim.pattern_b(1) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_B1)))(11 downto 0);
	sw_regs_in.l1asim.pattern_b(2) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_B2)))(11 downto 0);
	sw_regs_in.l1asim.pattern_b(3) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_B3)))(11 downto 0);
	sw_regs_in.l1asim.pattern_b(4) <= ctrl_reg(to_integer(unsigned(OFFSET_L1ASIM_PATTERN_B4)))(11 downto 0);

-- spytrigger
	sw_regs_in.spytrigger.orbit_nr(31 downto 0) <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_ORBIT_NR_L)))(31 downto 0);
	sw_regs_in.spytrigger.orbit_nr(ORBIT_NR_WIDTH-1 downto 32) <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_ORBIT_NR_H)))(ORBIT_NR_WIDTH-1-32 downto 0);

-- **********************
-- spytrigger event registers
-- 	spytrigger_spy12_once_event_int <= not spytrigger_spy12_once_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(0) = '1' else spytrigger_spy12_once_event_int;
-- 	sw_regs_in.spytrigger.spy12_once_event <= spytrigger_spy12_once_event_int;
-- 	spytrigger_spy12_next_event_int <= not spytrigger_spy12_next_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(1) = '1' else spytrigger_spy12_next_event_int;
-- 	sw_regs_in.spytrigger.spy12_next_event <= spytrigger_spy12_next_event_int;
-- 	spytrigger_spy3_event_int <= not spytrigger_spy3_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(2) = '1' else spytrigger_spy3_event_int;
-- 	sw_regs_in.spytrigger.spy3_event <= spytrigger_spy3_event_int;
-- 	spytrigger_clear_spy12_ready_event_int <= not spytrigger_clear_spy12_ready_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(3) = '1' else spytrigger_clear_spy12_ready_event_int;
-- 	sw_regs_in.spytrigger.clear_spy12_ready_event <= spytrigger_clear_spy12_ready_event_int;
-- 	spytrigger_clear_spy3_ready_event_int <= not spytrigger_clear_spy3_ready_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(4) = '1' else spytrigger_clear_spy3_ready_event_int;
-- 	sw_regs_in.spytrigger.clear_spy3_ready_event <= spytrigger_clear_spy3_ready_event_int;
-- 	spytrigger_clear_spy12_error_event_int <= not spytrigger_clear_spy12_error_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(5) = '1' else spytrigger_clear_spy12_error_event_int;
-- 	sw_regs_in.spytrigger.clear_spy12_error_event <= spytrigger_clear_spy12_error_event_int;

-- BR 2015-05-04:: changed event register (not working) to "in-register"
	sw_regs_in.spytrigger.spy12_once_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(0);
	sw_regs_in.spytrigger.spy12_next_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(1);
	sw_regs_in.spytrigger.spy3_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(2);
	sw_regs_in.spytrigger.clear_spy12_ready_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(3);
	sw_regs_in.spytrigger.clear_spy3_ready_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(4);
	sw_regs_in.spytrigger.clear_spy12_error_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(5);
-- **********************

-- sw_reset
-- 	sw_reset_reset_event_int <= not sw_reset_reset_event_int when ctrl_reg(to_integer(unsigned(OFFSET_SW_RESET_RESET_EVENT)))(0) = '1' else sw_reset_reset_event_int;
-- 	sw_regs_in.sw_reset.reset_event <= sw_reset_reset_event_int;

-- BR 2015-05-04: changed event register (not working) to "in-register"
	sw_regs_in.sw_reset.reset_event <= ctrl_reg(to_integer(unsigned(OFFSET_SW_RESET_RESET_EVENT)))(0);

-- dm
	sw_regs_in.dm.delay_muons <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_MUONS)))(11 downto 0);
	sw_regs_in.dm.delay_eg <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_EG)))(11 downto 0);
	sw_regs_in.dm.delay_tau <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_TAU)))(11 downto 0);
	sw_regs_in.dm.delay_jet <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_JET)))(11 downto 0);
	sw_regs_in.dm.delay_ett <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_ETT)))(11 downto 0);
	sw_regs_in.dm.delay_ht <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_HT)))(11 downto 0);
	sw_regs_in.dm.delay_etm <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_ETM)))(11 downto 0);
	sw_regs_in.dm.delay_htm <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_HTM)))(11 downto 0);
	sw_regs_in.dm.delay_ext_con <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_EXT_CON)))(11 downto 0);
	sw_regs_in.dm.delay_bcres <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_BCRES)))(11 downto 0);
	sw_regs_in.dm.delay_bcres_fdl <= ctrl_reg(to_integer(unsigned(OFFSET_DM_DELAY_BCRES_FDL)))(11 downto 0);

-- tcm
	sw_regs_in.tcm.cmd_ignbcres <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_CMDIGNBCRES)))(0);
-- **********************
-- tcm event registers
-- 	tcm_err_det_reset_event_int <= not tcm_err_det_reset_event_int when ctrl_reg(to_integer(unsigned(OFFSET_TCM_ERR_DET_RESET_EVENT)))(0) = '1' else tcm_err_det_reset_event_int;
-- 	sw_regs_in.tcm.err_det_reset_event <= tcm_bgos_event_int;
-- 	tcm_bgos_event_int <= not tcm_bgos_event_int when ctrl_reg(to_integer(unsigned(OFFSET_TCM_BGOS_EVENT)))(0) = '1' else tcm_bgos_event_int;
-- 	sw_regs_in.tcm.bgos_event <= tcm_bgos_event_int;

-- BR 2015-05-04: changed event register (not working) to "in-register"
	sw_regs_in.tcm.err_det_reset_event <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_ERR_DET_RESET_EVENT)))(0);
	sw_regs_in.tcm.bgos_event <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_BGOS_EVENT)))(0);
-- **********************
	sw_regs_in.tcm.luminosity_seg_period_msk <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_LIMINOSITY_SEG_PERIOD_MSK)))(31 downto 0);
	sw_regs_in.tcm.bgos <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_BGOS)))(3 downto 0);
	sw_regs_in.tcm.test_reg <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_TEST_REG)))(31 downto 0);

-- rop
	sw_regs_in.rop.version <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_VERSION)))(31 downto 0);
	sw_regs_in.rop.BoardID <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_BOARDID)))(15 downto 0);
	sw_regs_in.rop.total_bx_in_event_decision <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_TOTAL_BX_IN_EVENT_DECISION)))(3 downto 0);
	sw_regs_in.rop.total_bx_in_event_ext_cond <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_TOTAL_BX_IN_EVENT_EXT_COND)))(3 downto 0);
	sw_regs_in.rop.total_bx_in_event_gmt <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_TOTAL_BX_IN_EVENT_GMT)))(3 downto 0);
	sw_regs_in.rop.total_bx_in_event_gct <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_TOTAL_BX_IN_EVENT_GCT)))(3 downto 0);
	sw_regs_in.rop.prescale_factor_set_index <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_PRESCALE_FACTOR_SET_INDEX)))(7 downto 0);
	sw_regs_in.rop.lhc_data_delay <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_LHC_DATA_DELAY)))(3 downto 0);
	sw_regs_in.rop.tcm_delay <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_TCM_DELAY)))(3 downto 0);
	sw_regs_in.rop.algo_delay <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_ALGO_DELAY)))(3 downto 0);
-- **********************
-- rop event registers
-- 	rop_busy_reset_event_int <= not rop_busy_reset_event_int when ctrl_reg(to_integer(unsigned(OFFSET_ROP_BUSY_RESET_EVENT)))(0) = '1' else rop_busy_reset_event_int;
-- 	sw_regs_in.rop.busy_reset_event <= tcm_bgos_event_int;

-- BR 2015-05-04:: changed event register (not working) to "in-register"
	sw_regs_in.rop.busy_reset_event <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_BUSY_RESET_EVENT)))(0);
-- **********************
	sw_regs_in.rop.Payload <= ctrl_reg(to_integer(unsigned(OFFSET_ROP_PAYLOAD)))(19 downto 0);

-- STAT registers
-- spytrigger
	stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(27) <= sw_regs_out.spytrigger.trig_spy12_error;
	stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(28) <= sw_regs_out.spytrigger.trig_spy3_ready;
	stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(29) <= sw_regs_out.spytrigger.trig_spy12_ready;
	stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(30) <= sw_regs_out.spytrigger.trig_spy3_busy;
	stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(31) <= sw_regs_out.spytrigger.trig_spy12_busy;

-- dm
	stat_reg(to_integer(unsigned(OFFSET_DM_STATUS)))(0) <= sw_regs_out.dm.valid;

-- tcm
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR)))(11 downto 0) <= sw_regs_out.tcm.bx_nr;
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_EVENT_NR)))(31 downto 0) <= sw_regs_out.tcm.event_nr;
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_TRIGGER_NR_L)))(31 downto 0) <= sw_regs_out.tcm.trigger_nr(31 downto 0);
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_TRIGGER_NR_H)))(TRIGGER_NR_WIDTH-1-32 downto 0) <= sw_regs_out.tcm.trigger_nr(TRIGGER_NR_WIDTH-1 downto 32);
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ORBIT_NR_L)))(31 downto 0) <= sw_regs_out.tcm.orbit_nr(31 downto 0);
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ORBIT_NR_H)))(ORBIT_NR_WIDTH-1-32 downto 0) <= sw_regs_out.tcm.orbit_nr(ORBIT_NR_WIDTH-1 downto 32);
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_CHK)))(31 downto 0) <= sw_regs_out.tcm.bx_nr_chk;
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_MAX)))(31 downto 0) <= sw_regs_out.tcm.bx_nr_max;
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ERR_DET)))(0) <= sw_regs_out.tcm.err_det;
	stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_D_FDL)))(11 downto 0) <= sw_regs_out.tcm.bx_nr_d_fdl;
	stat_reg(to_integer(unsigned(OFFSET_TCM_LIMINOSITY_SEG_NR)))(31 downto 0) <= sw_regs_out.tcm.luminosity_seg_nr;

-- rop
	stat_reg(to_integer(unsigned(OFFSET_ROP_STATUS)))(0) <= sw_regs_out.rop.busy;

end architecture;



