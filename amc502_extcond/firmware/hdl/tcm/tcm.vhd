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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/customized_amc502/trunk/src/mp7_null_algo/firmware/hdl/tcm/tcm.vhd $
-- $Date: 2014-07-15 12:31:21 +0200 (Tue, 15 Jul 2014) $
-- $Author: rahbaran $
-- $Revision: 3050 $

-- HB 2014-07-08: done lhc_rst = RST_ACT in processes

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.gt_mp7_core_pkg.all;

entity tcm is
	port
	(
		lhc_clk           : in std_logic;
		lhc_rst           : in std_logic;
		bgos              : in bgos_t;
		l1a_sync          : in std_logic;
		bcres_d           : in std_logic;
		bcres_d_FDL       : in std_logic;
		sw_reg_in         : in ipb_reg_v(15 downto 0);
		sw_reg_out        : out ipb_reg_v(15 downto 0);
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
-- HB 2014-06-11: changed
-- 		bx_nr_chk          : std_logic_vector(PCIE_DATA_WIDTH-1 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
-- 		bx_nr_max          : std_logic_vector(PCIE_DATA_WIDTH-1 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
		bx_nr_chk          : std_logic_vector(31 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
		bx_nr_max          : std_logic_vector(31 downto 0); -- the highest value bx_nr ever reached is stored into a sw register for debug purposes
		err_det_reset_old  : std_logic; -- if the sw-in-reg err_det_reset toggles, err_det is reset to zero

		bgos_event_old     : std_logic; -- if any bit in sw-in-reg bgos toggles, the corresponding bgos command is issued for one cycle
	end record;

	constant LHC_REG_T_RESET  : lhc_reg_t := ('0', (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others => '0'), (others =>'0'), '0', '0', '0', (others => '0'), (others => '0'), '0', '0');

	signal l, lin  : lhc_reg_t;

	signal bgos_int : bgos_t; -- merges real bgos signal and simulation signal

begin
	-- LHC clock domain
	ctrl_lhc : process(lhc_rst, l, bgos, l1a_sync, bcres_d, sw_reg_in, bcres_d_FDL, bgos_int)
		variable v : lhc_reg_t;
	begin
		v := l;

		-- bcres_nr counter
		-- start, when we observe the first bcres_d
		v.start_lumisection := '0'; -- lumisection is high only for one clock period
		if (l.started_bx = '0' and bcres_d = '1') or sw_reg_in(0)(0) = '1'
		then
			v.started_bx := '1';
			v.bx_nr := bx_nr_t(to_unsigned(1, BX_NR_WIDTH));
		end if;
		if l.started_bx = '1'
		then
			if to_integer(unsigned(l.bx_nr)) = BC_TOP
			then
				v.bx_nr := (others => '0');
				v.orbit_nr := orbit_nr_t(unsigned(l.orbit_nr) + to_unsigned(1, ORBIT_NR_WIDTH));
				-- luminosity segment counter
				if unsigned(l.orbit_nr_periodic) >= (unsigned(sw_reg_in(4)) - 1)
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
		if l.started_bx = '1' and unsigned(l.orbit_nr) > 3 and sw_reg_in(0)(0) = '0' and
			((l.bx_nr = (l.bx_nr'range => '0') and bcres_d = '0') or
			(l.bx_nr /= (l.bx_nr'range => '0') and bcres_d = '1')) -- the bx_nr has to be zero when bcres_d is asserted, otherwise --> error
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
		if (l.started_bx_FDL = '0' and bcres_d_FDL = '1') or sw_reg_in(0)(0) = '1'
		then
			v.started_bx_FDL := '1';
			v.bx_nr_d_FDL := bx_nr_t(to_unsigned(1, BX_NR_WIDTH));
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

		-- simulate bgos
		if sw_reg_in(3)(0) /= l.bgos_event_old then
			bgos_int <= sw_reg_in(2)(3 downto 0);
			v.bgos_event_old := sw_reg_in(3)(0);
		else
			bgos_int <= bgos;
		end if;

		-- handle BGos messages
		case bgos_int is
			when BGOS_RESYNC =>
				if to_integer(unsigned(l.bx_nr)) /= BC_TOP
				then
					v.err_det := '1';
					v.started_bx := '0'; -- resync
					v.started_bx_FDL := '0';
				end if;
				v.orbit_nr_periodic := (others => '0');
			when BGOS_ORBIT_COUNTER_RESET =>
				v.orbit_nr := (others => '0');
				v.orbit_nr_periodic := (others => '0');
			when BGOS_START_RUN =>
				v.trigger_nr := (others => '0');
			when BGOS_EVENT_COUNTER_RESET =>
				v.event_nr := (others => '0');
			when others =>
				null;
		end case;

		-- reset
-- HB 2014-07-08: done lhc_rst = RST_ACT in processes
-- 		if lhc_rst = '0' then
		if lhc_rst = RST_ACT then
			v.bgos_event_old := sw_reg_in(3)(0); -- a reset should not trigger bgos
		end if;

		-- if the sw in reg err_det_reset toggles, err_det is reset to zero
		if sw_reg_in(1)(0) /= l.err_det_reset_old then
			v.err_det := '0';
			v.err_det_reset_old := sw_reg_in(1)(0);
		end if;

		-- write out software registers
		sw_reg_out(0)(11 downto 0)       <= l.bx_nr;
        sw_reg_out(1)                    <= l.event_nr;
        sw_reg_out(2)                    <= l.trigger_nr(31 downto 0);
        sw_reg_out(3)(15 downto 0)       <= l.trigger_nr(47 downto 32);
        sw_reg_out(4)                    <= l.orbit_nr(31 downto 0);
        sw_reg_out(5)(15 downto 0)       <= l.orbit_nr(47 downto 32);
        sw_reg_out(6)                    <= l.bx_nr_chk;
        sw_reg_out(7)                    <= l.bx_nr_max;
        sw_reg_out(8)(0)                 <= l.err_det;
		sw_reg_out(9)(11 downto 0)       <= l.bx_nr_d_fdl;
		sw_reg_out(10)                   <= l.luminosity_seg_nr;

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

	sync_lhc : process(lhc_clk, lhc_rst)
	begin
-- 		if lhc_rst = '0' then
		if lhc_rst = RST_ACT then
			l <= LHC_REG_T_RESET;
		elsif rising_edge(lhc_clk) then
			l <= lin;
		end if;
	end process;

end architecture;
