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
---Description: TCM
-- $HeadURL: $
-- $Date: $
-- $Author: ?
-- $Revision: 3796 $

-- HB 2016-04-25: Resync not used anymore. Resetting v.orbit_nr_periodic with resync was a bug.
-- HB 2016-04-22: OC0 resets orbit number and lumi-section number to 1.
-- HB 2016-03-17: inserted reset of lumi-section number with OC0
-- HB 2016-03-10: used signals (of BGos) for reset OC, reset EC, start and resync
-- JW 2015-11-04: included mp7_ttc_decl and used constant TTC_BC0_BX
-- BR 2015-05-08: done lhc_rst = RST_ACT in processes

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;
use work.mp7_ttc_decl.all;

entity tcm is
	port
	(
		lhc_clk           : in std_logic;
		lhc_rst           : in std_logic;
		ec0		  : in std_logic;
		oc0		  : in std_logic;
		resync		  : in std_logic;
		start		  : in std_logic;
		stop		  : in std_logic;
		l1a_sync          : in std_logic;
		bcres_d           : in std_logic;
		bcres_d_FDL       : in std_logic;
		sw_reg_in         : in sw_reg_tcm_in_t;
		sw_reg_out        : out sw_reg_tcm_out_t;
		bx_nr             : out bx_nr_t;
		bx_nr_d_fdl       : out bx_nr_t;
		event_nr          : out event_nr_t;
		trigger_nr        : out trigger_nr_t;
		orbit_nr          : out orbit_nr_t;
		luminosity_seg_nr : out luminosity_seg_nr_t;
		start_lumisection : out std_logic
	);
end;

architecture beh of tcm is

	type lhc_reg_t is record
		err_det            : std_logic;

		bx_nr              : bx_nr_t;
		bx_nr_d_fdl        : bx_nr_t;
		event_nr           : event_nr_t;
		trigger_nr         : trigger_nr_t;
		orbit_nr           : orbit_nr_t;
		luminosity_seg_nr  : luminosity_seg_nr_t;
		orbit_nr_periodic  : luminosity_seg_period_msk_t;
		start_lumisection  : std_logic;

		started_bx         : std_logic;
		started_bx_FDL     : std_logic;
		bx_nr_chk          : std_logic_vector(31 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
		bx_nr_max          : std_logic_vector(31 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
		err_det_reset_old  : std_logic; -- if the sw-in-reg err_det_reset toggles, err_det is reset to zero

-- HB 2016-03-10: removed unused SW BGos
-- 		bgos_event_old     : std_logic; -- if any bit in sw-in-reg bgos toggles, the corresponding bgos command is issued for one cycle
	end record;

-- 	constant LHC_REG_T_RESET  : lhc_reg_t := ('0', X"dd3", X"dd3", (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others =>'0'), '0', '0', '0', (others => '0'), (others => '0'), '0', '0');
-- HB 2016-03-10: removed unused SW BGos
	constant LHC_REG_T_RESET  : lhc_reg_t := ('0', X"dd3", X"dd3", (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others =>'0'), '0', '0', '0', (others => '0'), (others => '0'), '0');

	signal l, lin  : lhc_reg_t;

-- 	signal bgos_int : bgos_t; -- merges real bgos signal and simulation signal

-- HB 2016-04-22: value 0 for orbit_nr and luminosity_seg_nr.
	constant ZERO_ORBIT_NR : orbit_nr_t := (others => '0');
	constant ZERO_LUMI_NR : luminosity_seg_nr_t := (others => '0');

begin
	-- LHC clock domain
	ctrl_lhc: process(lhc_rst, l, ec0, oc0, resync, start, l1a_sync, bcres_d, sw_reg_in, bcres_d_FDL)
		variable v : lhc_reg_t;
	begin
		v := l;

		-- bcres_nr counter
		-- start, when we observe the first bcres_d
		v.start_lumisection := '0'; -- lumisection is high only for one clock period
		if (l.started_bx = '0' and bcres_d = '1') or sw_reg_in.cmd_ignbcres = '1'
		then
			v.started_bx := '1';
			--v.bx_nr := bx_nr_t(to_unsigned(1, BX_NR_WIDTH));
            v.bx_nr := bx_nr_t(to_unsigned(TTC_BC0_BX + 1, BX_NR_WIDTH)); -- JW 08.09.2015  Changed reset value of the bc cntr
		end if;
		if l.started_bx = '1'
		then
			if to_integer(unsigned(l.bx_nr)) = BC_TOP
			then
				v.bx_nr := (others => '0');
				v.orbit_nr := orbit_nr_t(unsigned(l.orbit_nr) + to_unsigned(1, ORBIT_NR_WIDTH));
				-- luminosity segment counter
 				if unsigned(l.orbit_nr_periodic) >= (unsigned(sw_reg_in.luminosity_seg_period_msk) - 1)
				then
					v.luminosity_seg_nr := luminosity_seg_nr_t(unsigned(l.luminosity_seg_nr) + to_unsigned(1, LUM_SEG_NR_WIDTH));
					v.start_lumisection := '1';
					v.orbit_nr_periodic := (others => '0');
				else
					v.orbit_nr_periodic := luminosity_seg_period_msk_t(unsigned(l.orbit_nr_periodic) + to_unsigned(1, LUM_SEG_PERIOD_MSK_WIDTH));
				end if;
			else
				v.bx_nr := bx_nr_t(unsigned(l.bx_nr) + to_unsigned(1, BX_NR_WIDTH));
			end if;
		end if;
		if l.started_bx = '1' and unsigned(l.orbit_nr) > 3 and sw_reg_in.cmd_ignbcres = '0' and
            ((l.bx_nr =  bx_nr_t(to_unsigned(TTC_BC0_BX, BX_NR_WIDTH)) and bcres_d = '0') or
            (l.bx_nr /=  bx_nr_t(to_unsigned(TTC_BC0_BX, BX_NR_WIDTH)) and bcres_d = '1')) -- the bx_nr has to be zero when bcres_d is asserted, otherwise --> error
-- 			((l.bx_nr = (l.bx_nr'range => '0') and bcres_d = '0') or
-- 			(l.bx_nr /= (l.bx_nr'range => '0') and bcres_d = '1')) -- the bx_nr has to be zero when bcres_d is asserted, otherwise --> error
		then
			v.err_det := '1'; -- set error detected sw register
			v.started_bx := '0'; -- resync automatically
			v.started_bx_FDL := '0'; -- note: only bx_nr is used to check synchronism, nevertheless both bx counters have to resync if synchronization is lost
		end if;

		-- the highest value bx_nr ever reached is stored into a sw register for debug purposes, should be BC_TOP
		if bcres_d = '1' then
			v.bx_nr_chk := std_logic_vector(to_unsigned(0, v.bx_nr_chk'length));
		else
			v.bx_nr_chk := std_logic_vector(unsigned(l.bx_nr_chk) + to_unsigned(1, l.bx_nr_chk'length));
		end if;
		if v.bx_nr_chk > l.bx_nr_max
		then
			v.bx_nr_max := v.bx_nr_chk;
		end if;

		-- bx_nr_d_FDL
		if (l.started_bx_FDL = '0' and bcres_d_FDL = '1') or sw_reg_in.cmd_ignbcres = '1'
		then
			v.started_bx_FDL := '1';
			--v.bx_nr_d_FDL := bx_nr_t(to_unsigned(1, BX_NR_WIDTH));
            v.bx_nr_d_FDL := bx_nr_t(to_unsigned(TTC_BC0_BX + 1, BX_NR_WIDTH)); -- JW 08.09.2015  Changed reset value of the bc cntr
		elsif l.started_bx_FDL = '1' then
			if to_integer(unsigned(l.bx_nr_d_FDL)) = BC_TOP
			then
				v.bx_nr_d_FDL := (others => '0');
			else
				v.bx_nr_d_FDL := bx_nr_t(unsigned(l.bx_nr_d_FDL) + to_unsigned(1, BX_NR_WIDTH));
			end if;
		end if;

		-- event counter
		if l1a_sync = '1'
		then
			v.event_nr := event_nr_t(unsigned(l.event_nr) + to_unsigned(1, EVENT_NR_WIDTH));
			v.trigger_nr := trigger_nr_t(unsigned(l.trigger_nr) + to_unsigned(1, TRIGGER_NR_WIDTH));
		end if;

-- HB 2016-03-10: removed "locally defined" BGos and SW simulated BGos
-- 		-- simulate bgos
-- 		if sw_reg_in.bgos_event /= l.bgos_event_old then
-- 			bgos_int <= sw_reg_in.bgos;
-- 			v.bgos_event_old := sw_reg_in.bgos_event;
-- 		else
-- 			bgos_int <= bgos;
-- 		end if;
--
		-- handle BGos messages
-- 		case bgos_int is
-- 			when BGOS_RESYNC =>
-- 				if to_integer(unsigned(l.bx_nr)) /= BC_TOP
-- 				then
-- 					v.err_det := '1';
-- 					v.started_bx := '0'; -- resync
-- 					v.started_bx_FDL := '0';
-- 				end if;
-- 				v.orbit_nr_periodic := (others => '0');
-- 			when BGOS_ORBIT_COUNTER_RESET =>
-- 				v.orbit_nr := (others => '0');
-- 				v.orbit_nr_periodic := (others => '0');
-- 			when BGOS_START_RUN =>
-- 				v.trigger_nr := (others => '0');
-- 			when BGOS_EVENT_COUNTER_RESET =>
-- 				v.event_nr := (others => '0');
-- 			when others =>
-- 				null;
-- 		end case;

-- HB 2016-03-10: used signals (of BGo) for reset OC, reset EC, start and resync (from mp7_ttc.vhd)
-- HB 2016-04-25: resync not used anymore. Resetting v.orbit_nr_periodic with resync was a bug.
-- 		if resync = '1' then
-- 			if to_integer(unsigned(l.bx_nr)) /= BC_TOP
-- 			then
-- 				v.err_det := '1';
-- 				v.started_bx := '0'; -- resync
-- 				v.started_bx_FDL := '0';
-- 			end if;
-- 			v.orbit_nr_periodic := (others => '0');
-- 		end if;
		if oc0 = '1' then
-- HB 2016-04-22: OC0 resets orbit number and lumi-section number to 1.
-- 			v.orbit_nr := (others => '0');
			v.orbit_nr := orbit_nr_t(to_unsigned(1, ORBIT_NR_WIDTH));
			v.orbit_nr_periodic := (others => '0');
-- HB 2016-03-17: inserted reset of lumi-section number with OC0
-- HB 2016-04-22: OC0 resets orbit number and lumi-section number to 1.
-- 			v.luminosity_seg_nr := (others => '0');
			v.luminosity_seg_nr := luminosity_seg_nr_t(to_unsigned(1, LUM_SEG_NR_WIDTH));
		end if;
		if start = '1' then
			v.trigger_nr := (others => '0');
		end if;
		if ec0 = '1' then
			v.event_nr := (others => '0');
		end if;

-- HB 2016-03-10: removed reset of unused SW BGos
		-- reset
-- 		if lhc_rst = '0' then
-- 		if lhc_rst = RST_ACT then
-- 			v.bgos_event_old := sw_reg_in.bgos_event; -- a reset should not trigger bgos
-- 		end if;

		-- if the sw in reg err_det_reset toggles, err_det is reset to zero
		if sw_reg_in.err_det_reset_event /= l.err_det_reset_old then
			v.err_det := '0';
			v.err_det_reset_old := sw_reg_in.err_det_reset_event;
		end if;

		-- write out software registers
		sw_reg_out.err_det           <= l.err_det;
		sw_reg_out.bx_nr             <= l.bx_nr;
		sw_reg_out.bx_nr_d_fdl       <= l.bx_nr_d_fdl;
		sw_reg_out.bx_nr_chk         <= l.bx_nr_chk;
		sw_reg_out.bx_nr_max         <= l.bx_nr_max;
		sw_reg_out.orbit_nr          <= l.orbit_nr;
		sw_reg_out.event_nr          <= l.event_nr;
		sw_reg_out.trigger_nr        <= l.trigger_nr;
		sw_reg_out.luminosity_seg_nr <= l.luminosity_seg_nr;

		-- next values for l, used in the sync_lhc process
		lin <= v;

		-- write outputs
		bx_nr             <= l.bx_nr;
		bx_nr_d_fdl       <= l.bx_nr_d_fdl;
		orbit_nr          <= l.orbit_nr;
		event_nr          <= l.event_nr;
		trigger_nr        <= l.trigger_nr;
		luminosity_seg_nr <= l.luminosity_seg_nr;
		start_lumisection <= l.start_lumisection;

	end process;

	sync_lhc: process(lhc_clk, lhc_rst)
	begin
-- 		if lhc_rst = '0' then
		if lhc_rst = RST_ACT then
			l <= LHC_REG_T_RESET;
		elsif rising_edge(lhc_clk) then
			l <= lin;
		end if;
	end process;

end architecture;
