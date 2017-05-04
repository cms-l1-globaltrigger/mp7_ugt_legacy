--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL:  $
-- $Date:  $
-- $Author:  $
-- $Revision: 0.1  $
------------------------------------------------------------------------------------------------------------------------------------
-- HEPHY: 04.05.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package.

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;

entity l1asim is
	port
	(
		lhc_clk    : in std_logic;
		lhc_rst    : in std_logic;

		bx_nr      : in bx_nr_t;
		orbit_nr   : in orbit_nr_t;

		sw_reg_i   : in sw_reg_l1asim_in_t;

		l1a_real_i : in std_logic;
		l1a_o      : out std_logic
	);
end;

architecture arch of l1asim is

	signal sim_temp : std_logic;
	signal l1a_sim : std_logic;
	signal last_fire_once_event : std_logic;
	signal fire_once : std_logic;

begin

	sync_lhc : process(lhc_clk, lhc_rst)
	begin
	--comments
		if lhc_rst = RST_ACT then
			last_fire_once_event <= '0';
		elsif rising_edge(lhc_clk) then
			last_fire_once_event <= sw_reg_i.fire_once_event;
		end if;
	end process;

	fire_once_event_detector : process (sw_reg_i, last_fire_once_event)
	begin
		fire_once <= '0';
		if sw_reg_i.fire_once_event /= last_fire_once_event then
			fire_once <= '1';
		end if;
	end process;


	process (sw_reg_i, orbit_nr, bx_nr)
		variable pattern_a_match : std_logic;
		variable pattern_b_match : std_logic;
	begin

		sim_temp <= '0';

		pattern_a_match := '0';
		for i in 0 to sw_reg_i.pattern_a'length-1 loop
			if sw_reg_i.pattern_a(i) = bx_nr then
				pattern_a_match := '1';
			end if;
		end loop;

		pattern_b_match := '0';
		for i in 0 to sw_reg_i.pattern_b'length-1 loop
			if sw_reg_i.pattern_b(i) = bx_nr then
				pattern_b_match := '1';
			end if;
		end loop;

		case sw_reg_i.cntrl is
			when L1A_SIM_CNTRL_PATTERN_AT_ORBIT =>
				if orbit_nr = sw_reg_i.orbit_nr then
					sim_temp <= pattern_a_match;
				end if;
			when L1A_SIM_CNTRL_ALTERNATING =>
				if orbit_nr(0) = '0' then -- --> even
					sim_temp <= pattern_a_match;
				else -- orbit_nr = '1' --> odd
					sim_temp <= pattern_b_match;
				end if;
			when others =>
				sim_temp <= '0';
		end case;

	end process;


	l1a_sim <= fire_once or sim_temp;

	l1a_o <= l1a_real_i when sw_reg_i.enable_l1a_sim = '0' else l1a_sim;

end;
