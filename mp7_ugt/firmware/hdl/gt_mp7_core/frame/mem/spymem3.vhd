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
---Description:SPYMEM3
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
-- Modification : HEPHY, the bug in the state machine is fixed, generally the memory is working. Please use the validation concept workflow version 0.1 to validate the correct behavior of
-- the Design
--
-- $Revision: 0.1 $
--------------------------------------------------------------------------------


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.ipbus.all;
use work.math_pkg.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;

--use work.rb_pkg.all;

entity spymem3 is
	generic
	(
	SIZE_IN_BYTES : integer    := 4096;
	INPUT_DATA_WIDTH : integer := 16
	);
	port
	(
		ipbus_clk   : in    std_logic;
		ipbus_rst   : in    std_logic;
		ipbus_in    : in    ipb_wbus;
		ipbus_out   : out   ipb_rbus;

		lhc_clk          : in std_logic;
		lhc_rst          : in std_logic;
		spy_i            : in std_logic;
		spy_ack_o        : out std_logic;

		rop_clk          : in std_logic;
		rop_rst          : in std_logic;
		rop_data_i       : in std_logic_vector(INPUT_DATA_WIDTH-1 downto 0);
		rop_en_i         : in std_logic;
		rop_packet_end_i : in std_logic
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
	assert(INPUT_DATA_WIDTH = 16 or INPUT_DATA_WIDTH = 32 or INPUT_DATA_WIDTH = 64)
		report "Input data width NOT supported!"
		severity error;
end;


architecture arch of spymem3 is

	constant SW_DATA_WIDTH : integer := ipbus_in.ipb_wdata'length;
	constant SW_ADDR_WIDTH : integer := log2c(SIZE_IN_BYTES/(SW_DATA_WIDTH/8));

	constant INPUT_ADDR_WIDTH : integer := log2c(SIZE_IN_BYTES/(INPUT_DATA_WIDTH/8));

	constant READ_LATENCY : integer := 2; -- read latency of the internal ram

	type spy3_state_t is (IDLE, WAIT_NEW_PACKET, WAIT_REMAINING_PACKET, RECORD_PACKET, COMPLETE);

	signal state : spy3_state_t;
	signal state_nxt : spy3_state_t;

	signal rec : std_logic;
	signal rec_addr : std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0);
	signal rec_addr_nxt : std_logic_vector(INPUT_ADDR_WIDTH-1 downto 0);

	constant SYNC_STAGES : integer := 2;

	signal spy_i_sync : std_logic;
	signal spy_ack_internal : std_logic;

-- 	signal rd_ack_internal   : std_logic;
	signal dl_in_rd_ack : std_logic;

-- 	signal ack : std_logic;

begin

	sync_rop_clk : process (rop_clk, rop_rst)
	begin
		if rop_rst = RST_ACT_ROP then
			state <= IDLE;
			rec_addr <= (others=>'0');
		elsif rising_edge(rop_clk) then
			state <= state_nxt;
			rec_addr <= rec_addr_nxt;
		end if;
	end process;


	spy_i_syncronizer : entity work.delay_line_sl
		generic map
		(
			DELAY	=> SYNC_STAGES,
			SPY_IN	=> true
		)
		port map
		(
			clk   => rop_clk,
			rst   => rop_rst,
			sig_i => spy_i,
			sig_o => spy_i_sync
		);


	spy_ack_o_syncronizer : entity work.delay_line_sl
		generic map
		(
			DELAY	=> SYNC_STAGES,
			SPY_IN	=> false
		)
		port map
		(
			clk   => lhc_clk,
			rst   => lhc_rst,
			sig_i => spy_ack_internal,
			sig_o => spy_ack_o
		);


    ipbus_out.ipb_err <= '0';

    dl_in_rd_ack <= ipbus_in.ipb_strobe;

	dl_rd_ack : entity work.delay_line_sl
		generic map
		(
			DELAY	=> READ_LATENCY,
			SPY_IN	=> false
		)
		port map
		(
			clk	=> ipbus_clk,
			rst	=> ipbus_rst,
			sig_i	=> dl_in_rd_ack,
			sig_o	=> ipbus_out.ipb_ack
		);

	next_state : process(state, rec_addr, spy_i_sync, rop_en_i, rop_packet_end_i, spy_ack_internal)
	begin
-- 		state_nxt <= state; --this is a bug, which occurs a problem with ipbus data out.
 		rec_addr_nxt <= rec_addr;
 		rec <= '0';
 		spy_ack_internal <= '0';

		case state is
			when IDLE =>
				rec_addr_nxt <= (others=>'0');
				if spy_i_sync = '1' then
					if rop_en_i = '1' and rop_packet_end_i = '0' then -- there is currently a packet being sent --> wait for it to finish
						state_nxt <= WAIT_REMAINING_PACKET;
					else
						state_nxt <= WAIT_NEW_PACKET;
					end if;
				end if;

			when WAIT_REMAINING_PACKET =>
				if rop_packet_end_i = '1' then -- last packet was sent completely --> wait for new packet (to record)
					state_nxt <= WAIT_NEW_PACKET;
				end if;

			when WAIT_NEW_PACKET =>
				if rop_en_i = '1' then
					rec_addr_nxt <= std_logic_vector(unsigned(rec_addr) + 1);
					rec <= '1';
					state_nxt <= RECORD_PACKET;
				end if;

			when RECORD_PACKET =>
				if rop_en_i = '1' then
					rec_addr_nxt <= std_logic_vector(unsigned(rec_addr) + 1);
					rec <= '1';
				end if;

				if rop_packet_end_i = '1' then
					state_nxt <= COMPLETE;
				end if;

			when COMPLETE =>
				spy_ack_internal <= '1';
				if spy_i_sync = '0' then
					state_nxt <= IDLE;
				end if;

			when others =>
			  state_nxt <= IDLE;
		end case;
	end process;

	INPUT_DATA_WIDTH_16 : if INPUT_DATA_WIDTH = 16 generate
		asym_ram_16_32 : entity work.ram_asym_2c2w2r
			generic map
			(
				WIDTHA      => 16,
				SIZEA       => 2**INPUT_ADDR_WIDTH,
				ADDRWIDTHA  => INPUT_ADDR_WIDTH,
				WIDTHB      => 32,
				SIZEB       => 2**SW_ADDR_WIDTH,
				ADDRWIDTHB  => SW_ADDR_WIDTH
			)
			port map
			(
				a_clk     => rop_clk,
				a_en      => '1',
				a_we      => rec,
				a_addr    => rec_addr,
				a_wr_data => rop_data_i,
				a_rd_data => open,

				b_clk   => ipbus_clk,
				b_en    => '1',
				b_we    => '0',
				b_addr  => ipbus_in.ipb_addr(SW_ADDR_WIDTH-1 downto 0),
				b_wr_data => (others=>'0'),
				b_rd_data => ipbus_out.ipb_rdata
			);
	end generate;


	INPUT_DATA_WIDTH_32 : if INPUT_DATA_WIDTH = 32 generate
		ram32 : entity work.ram_2c1w1r
			generic map
			(
				DATA_WIDTH => 32,
				SIZE       => 2**SW_ADDR_WIDTH,
				USE_OUTPUT_REGISTER => true
			)
			port map
			(
				wr_clk  => rop_clk,
				wr_en   => '1',
				wr      => rec,
				wr_addr => rec_addr,
				wr_data => rop_data_i,

				rd_clk  => ipbus_clk,
				rd      => '1',
				rd_addr => ipbus_in.ipb_addr(SW_ADDR_WIDTH-1 downto 0),
				rd_data => ipbus_out.ipb_rdata
			);
	end generate;

	INPUT_DATA_WIDTH_64 : if INPUT_DATA_WIDTH = 64 generate
		--signal mem_sel : std_logic;
		signal mem_sel_delay_line : std_logic_vector(READ_LATENCY-1 downto 0);
		type data_out_t is array(0 to 1) of std_logic_vector(31 downto 0);
		signal data_out : data_out_t;
	begin
		ram32_1 : entity work.ram_2c1w1r
			generic map
			(
				DATA_WIDTH => 32,
				SIZE       => 2**(SW_ADDR_WIDTH-1),
				USE_OUTPUT_REGISTER => true
			)
			port map
			(
				wr_clk  => rop_clk,
				wr_en   => '1',
				wr      => rec,
				wr_addr => rec_addr,
				wr_data => rop_data_i(31 downto 0),

				rd_clk  => ipbus_clk,
				rd      => '1',
				rd_addr => ipbus_in.ipb_addr(SW_ADDR_WIDTH-1 downto 1),
				rd_data => data_out(0)
			);

		ram32_2 : entity work.ram_2c1w1r
			generic map
			(
				DATA_WIDTH => 32,
				SIZE       => 2**(SW_ADDR_WIDTH-1),
				USE_OUTPUT_REGISTER => true
			)
			port map
			(
				wr_clk  => rop_clk,
				wr_en   => '1',
				wr      => rec,
				wr_addr => rec_addr,
				wr_data => rop_data_i(63 downto 32),

				rd_clk  => ipbus_clk,
				rd      => '1',
				rd_addr => ipbus_in.ipb_addr(SW_ADDR_WIDTH-1 downto 1),
				rd_data => data_out(1)
			);


			mem_sel : process (ipbus_clk, ipbus_rst)
			begin
				if ipbus_rst = '1' then
					mem_sel_delay_line <= (others=>'0');
				elsif rising_edge(ipbus_clk) then
					mem_sel_delay_line <= mem_sel_delay_line(READ_LATENCY-2  downto 0) & ipbus_in.ipb_addr(0);
				end if;
			end process;

			ipbus_out.ipb_rdata <= data_out(0) when mem_sel_delay_line(READ_LATENCY-1) = '0' else data_out(1);

	end generate;



end architecture;








