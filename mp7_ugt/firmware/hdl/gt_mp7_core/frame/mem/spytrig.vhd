
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;

use work.math_pkg.all;

entity spytrig is
	port
	(
		lhc_clk    : in  std_logic;
		lhc_rst    : in  std_logic;
		orbit_nr   : in  orbit_nr_t;
		bx_nr      : in bx_nr_t;
		sw_reg_i   : in  sw_reg_spytrigger_in_t;
		sw_reg_o   : out sw_reg_spytrigger_out_t;

		spy1_o     : out std_logic;
		spy2_o     : out std_logic;
		spy3_o     : out std_logic;
		spy3_ack_i : in  std_logic;

		simmem_in_use_i : in std_logic
	);
end;


architecture arch of spytrig is

	constant RESET_TIMEOUT : integer := 31;
	-- give the values time to travel through the synchronizer in the register bank
	signal rst_timeout_cnt     : std_logic_vector(log2c(RESET_TIMEOUT)-1 downto 0);
	signal rst_timeout_cnt_nxt : std_logic_vector(log2c(RESET_TIMEOUT)-1 downto 0);
	signal rst_timeout_flag    : std_logic;

	type event_flags_t is
	record
		spy12_once        : std_logic;
		spy12_next        : std_logic;
		spy3              : std_logic;
		clear_spy12_ready : std_logic;
		clear_spy3_ready  : std_logic;
		clear_spy12_error : std_logic;
	end record;

	constant EVENT_FLAGS_NULL : event_flags_t := ('0','0','0','0','0', '0');
	signal last_flags : event_flags_t;

	type spy3_fsm_state_t is (IDLE, WAIT_ACK);
	signal spy3_fsm_state : spy3_fsm_state_t;
	signal spy3_fsm_state_nxt : spy3_fsm_state_t;

	type spy12_fsm_state_t is (IDLE, SPY, SPY_COMPLETE, SPY_NEXT, SPY_ONCE, SPY_ONCE_ERROR);
	signal spy12_fsm_state : spy12_fsm_state_t;
	signal spy12_fsm_state_nxt : spy12_fsm_state_t;


	signal set_spy12_ready_flag : std_logic;
	signal set_spy3_ready_flag  : std_logic;
	signal set_spy12_error_flag : std_logic;

	signal spy12_ready_flag     : std_logic;
	signal spy12_ready_flag_nxt : std_logic;
	signal spy3_ready_flag      : std_logic;
	signal spy3_ready_flag_nxt  : std_logic;
	signal spy12_error_flag     : std_logic;
	signal spy12_error_flag_nxt : std_logic;


	signal spy_once_orbit_nr     : orbit_nr_t;
	signal spy_once_orbit_nr_nxt : orbit_nr_t;
begin

	sync : process(lhc_clk, lhc_rst)
	begin
		if lhc_rst = RST_ACT then
			last_flags <= EVENT_FLAGS_NULL;
			rst_timeout_cnt <= (others=>'0');
			spy3_fsm_state <= IDLE;
			spy12_fsm_state <= IDLE;
			spy12_ready_flag <= '0';
			spy3_ready_flag <= '0';
			spy12_error_flag <= '0';
		elsif rising_edge(lhc_clk) then
			rst_timeout_cnt <= rst_timeout_cnt_nxt;
			--record event flags to detect toggled bits
			last_flags.spy12_once        <= sw_reg_i.spy12_once_event;
			last_flags.spy12_next        <= sw_reg_i.spy12_next_event;
			last_flags.spy3              <= sw_reg_i.spy3_event;
			last_flags.clear_spy12_ready <= sw_reg_i.clear_spy12_ready_event;
			last_flags.clear_spy3_ready  <= sw_reg_i.clear_spy3_ready_event;
			last_flags.clear_spy12_error <= sw_reg_i.clear_spy12_error_event;
			-- state machines
			spy3_fsm_state <= spy3_fsm_state_nxt;
			spy12_fsm_state <= spy12_fsm_state_nxt;
			-- ready flags
			spy12_ready_flag  <= spy12_ready_flag_nxt;
			spy3_ready_flag   <= spy3_ready_flag_nxt;
			spy12_error_flag  <= spy12_error_flag_nxt;
			spy_once_orbit_nr <= spy_once_orbit_nr_nxt;
		end if;
	end process;

	sw_reg_o.trig_spy12_ready <= spy12_ready_flag;
	sw_reg_o.trig_spy3_ready <= spy3_ready_flag;
	sw_reg_o.trig_spy12_error <= spy12_error_flag;

	rst_cnt : process(rst_timeout_cnt)
	begin
		rst_timeout_cnt_nxt <= rst_timeout_cnt;
		rst_timeout_flag <= '0';
		if unsigned(rst_timeout_cnt) = RESET_TIMEOUT then
			rst_timeout_flag <= '1';
		else
			rst_timeout_cnt_nxt <= std_logic_vector(unsigned(rst_timeout_cnt) + 1);
		end if;
	end process;


	spy3_fsm : process(spy3_fsm_state, last_flags, rst_timeout_flag, spy3_ack_i, sw_reg_i)
	begin
		spy3_fsm_state_nxt <= spy3_fsm_state;
		spy3_o <= '0';
		sw_reg_o.trig_spy3_busy <= '0';
		set_spy3_ready_flag <= '0';

		case spy3_fsm_state is
			when IDLE =>
				if rst_timeout_flag = '1' then
					if sw_reg_i.spy3_event /= last_flags.spy3 then
							spy3_fsm_state_nxt <= WAIT_ACK;
					end if;
				end if;
			when WAIT_ACK =>
				spy3_o <= '1';
				sw_reg_o.trig_spy3_busy <= '1';
				if spy3_ack_i = '1' then
					spy3_fsm_state_nxt <= IDLE;
					set_spy3_ready_flag <= '1';
				end if;
			--when others => -- case statement is complete
				--null;
		end case;
	end process;


	spy12_fsm : process(spy12_fsm_state, spy_once_orbit_nr, rst_timeout_flag, sw_reg_i, bx_nr, simmem_in_use_i, last_flags, orbit_nr)
	begin
		spy12_fsm_state_nxt <= spy12_fsm_state;
		spy1_o <= '0';
		spy2_o <= '0';
		sw_reg_o.trig_spy12_busy <= '1';
		spy_once_orbit_nr_nxt <= spy_once_orbit_nr;

		set_spy12_error_flag <= '0';
		set_spy12_ready_flag <= '0';

		case spy12_fsm_state is
			when IDLE =>
				sw_reg_o.trig_spy12_busy <= '0';
				if rst_timeout_flag = '1' then
					if sw_reg_i.spy12_once_event /= last_flags.spy12_once then
							spy12_fsm_state_nxt <= SPY_ONCE;
							spy_once_orbit_nr_nxt <= sw_reg_i.orbit_nr;
					elsif sw_reg_i.spy12_next_event /= last_flags.spy12_next then
							spy12_fsm_state_nxt <= SPY_NEXT;
					end if;
				end if;

			when SPY_NEXT =>
				if unsigned(bx_nr) = BUNCHES_PER_ORBIT-1 then
					spy12_fsm_state_nxt <= SPY;
				end if;

			when SPY_ONCE =>
				if (unsigned(spy_once_orbit_nr) - 1) < unsigned(orbit_nr) then
					spy12_fsm_state_nxt <= SPY_ONCE_ERROR;
				end if;

				if (unsigned(spy_once_orbit_nr) - 1) = unsigned(orbit_nr) and
					unsigned(bx_nr) = BUNCHES_PER_ORBIT-1 then
					spy12_fsm_state_nxt <= SPY;
				end if;

			when SPY =>
				spy1_o <= '1' and not simmem_in_use_i;
				spy2_o <= '1';

				if unsigned(bx_nr) = BUNCHES_PER_ORBIT-1 then
					spy12_fsm_state_nxt <= SPY_COMPLETE;
				end if;

			when SPY_COMPLETE =>
				spy12_fsm_state_nxt <= IDLE;
				set_spy12_ready_flag <= '1';

			when SPY_ONCE_ERROR =>
				set_spy12_error_flag <= '1';
				spy12_fsm_state_nxt <= IDLE;

			--when others => -- case statement is complete
				--null;
		end case;

	end process;


	-- ready/error flags logic
	spy_ready_flags : process(set_spy12_ready_flag, set_spy3_ready_flag, spy12_ready_flag, spy3_ready_flag, last_flags, sw_reg_i, spy12_error_flag, set_spy12_error_flag)
	begin

		spy12_ready_flag_nxt <= spy12_ready_flag;
		spy3_ready_flag_nxt  <= spy3_ready_flag;
		spy12_error_flag_nxt <= spy12_error_flag;

		if set_spy12_ready_flag = '1' then
			spy12_ready_flag_nxt <= '1';
		elsif sw_reg_i.clear_spy12_ready_event /= last_flags.clear_spy12_ready then -- clear ready flag
			spy12_ready_flag_nxt <= '0';
		end if;

		if set_spy3_ready_flag = '1' then
			spy3_ready_flag_nxt <= '1';
		elsif sw_reg_i.clear_spy3_ready_event /= last_flags.clear_spy3_ready then -- clear ready flag
			spy3_ready_flag_nxt <= '0';
		end if;

		if set_spy12_error_flag = '1' then
			spy12_error_flag_nxt <= '1';
		elsif sw_reg_i.clear_spy12_error_event /= last_flags.clear_spy12_error then -- clear ready flag
			spy12_ready_flag_nxt <= '0';
		end if;
	end process;


end architecture;

