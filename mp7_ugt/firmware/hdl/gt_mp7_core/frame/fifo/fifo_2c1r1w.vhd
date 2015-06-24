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
---Description:FIFO Design, Specification and implementation : Florain, Babak
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/firmware/hdl/gt_mp7_core/frame/fifo/fifo_2c1r1w.vhd $
-- $Date: 2015-05-13 12:29:43 +0200 (Wed, 13 May 2015) $
-- $Author: wittmann $
-- $Revision: 3937 $

--! \file

----------------------------------------------------------------------------------
--                                LIBRARIES                                     --
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gt_mp7_core_pkg.all;
use work.math_pkg.all;

----------------------------------------------------------------------------------
--                                 ENTITY                                       --
----------------------------------------------------------------------------------
--! A generic dual clocked FIFO
----------------------------------------------------------------------------------
entity fifo_2c1r1w is
	generic
	(
		MIN_DEPTH  : integer := 8;
		DATA_WIDTH : integer := 8
	);
	port
	(
		wr_clk    : in  std_logic;
		wr_res_n  : in  std_logic;

		rd_clk    : in  std_logic;
		rd_res_n  : in  std_logic;

		data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		rd1       : in  std_logic;

		data_in2  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		wr2       : in  std_logic;

		empty     : out std_logic;
		full      : out std_logic
	);
end entity;


architecture beh of fifo_2c1r1w is

	constant SYNC_STAGES : integer := 2;
	constant BUFFER_WIDTH : integer := log2c(MIN_DEPTH);
	type sync_stages_type is array(SYNC_STAGES -1  downto 0) of std_logic_vector(BUFFER_WIDTH downto 0);

	signal rd_addr, rd_addr_next : std_logic_vector(BUFFER_WIDTH downto 0);
	signal wr_addr, wr_addr_next : std_logic_vector(BUFFER_WIDTH downto 0);

	signal wr_ram : std_logic;
	signal rd_ram : std_logic;

	signal empty_next : std_logic;
	signal sig_empty: std_logic;

	signal sig_full : std_logic;
	signal full_next : std_logic;

	-- gray encoded signals
	signal wr_addr_gray : std_logic_vector(BUFFER_WIDTH downto 0);
	signal wr_addr_gray_next : std_logic_vector(BUFFER_WIDTH downto 0);

	signal rd_addr_gray : std_logic_vector(BUFFER_WIDTH downto 0);
	signal rd_addr_gray_next : std_logic_vector(BUFFER_WIDTH downto 0);

	signal wr_addr_gray_sync_stages : sync_stages_type;
	signal wr_addr_gray_sync : std_logic_vector(BUFFER_WIDTH downto 0) ;

	signal rd_addr_gray_sync_stages : sync_stages_type;
	signal rd_addr_gray_sync : std_logic_vector(BUFFER_WIDTH downto 0) ;


begin

	memory_inst : entity work.ram_2c1w1r
		generic map
		(
			DATA_WIDTH => DATA_WIDTH,
			SIZE       => MIN_DEPTH
		)
		port map
		(
			wr_clk   => wr_clk,
			rd_clk   => rd_clk,

			wr_en => '1',
			wr    => wr_ram,
			rd    => rd_ram,

			wr_addr => wr_addr(wr_addr'length-2 downto 0),
			rd_addr => rd_addr(rd_addr'length-2 downto 0),

			rd_data => data_out1,
			wr_data => data_in2
		);

	--------------------------------------------------------------------
	--                    PROCESS : SYNC                              --
	--------------------------------------------------------------------
	sync_wr : process(wr_clk, wr_res_n)
	begin
		if wr_res_n = RST_ACT then
			wr_addr <= (others => '0');
         wr_addr_gray <= (others => '0');
			sig_full <= '0';
		elsif rising_edge(wr_clk) then
			wr_addr <= wr_addr_next;
			wr_addr_gray <= wr_addr_gray_next;
			sig_full <= full_next;
		end if;
	end process;


	sync_rd : process(rd_clk, rd_res_n)
	begin
		if rd_res_n = RST_ACT then
			rd_addr <= (others => '0');
         rd_addr_gray <= (others => '0');
			sig_empty <= '1';
		elsif rising_edge(rd_clk) then
			rd_addr <= rd_addr_next;
			rd_addr_gray <= rd_addr_gray_next;
			sig_empty <= empty_next;
		end if;
	end process;


  	empty <= sig_empty;
  	full <= sig_full;


  	--------------------------------------------------------------------
	--                PROCESS : SYNCHRONIZER                          --
	--------------------------------------------------------------------
	wr_addr_gray_sync <= wr_addr_gray_sync_stages(SYNC_STAGES - 1);
	synchronizer_rd : process(rd_clk, rd_res_n)
	begin
		if rd_res_n = RST_ACT then
			wr_addr_gray_sync_stages <= (others => (others => '0'));
		elsif rising_edge(rd_clk) then
			wr_addr_gray_sync_stages(0) <= wr_addr_gray;
			for i in 1 to SYNC_STAGES - 1 loop
				wr_addr_gray_sync_stages(i) <= wr_addr_gray_sync_stages(i - 1);
			end loop;
		end if;
	end process;


	rd_addr_gray_sync <= rd_addr_gray_sync_stages(SYNC_STAGES - 1);
	synchronizer_wr : process(wr_clk, wr_res_n)
	begin
		if wr_res_n = RST_ACT then
			rd_addr_gray_sync_stages <= (others => (others => '0'));
		elsif rising_edge(wr_clk) then
			rd_addr_gray_sync_stages(0) <= rd_addr_gray;
			for i in 1 to SYNC_STAGES - 1 loop
				rd_addr_gray_sync_stages(i) <= rd_addr_gray_sync_stages(i - 1);
			end loop;
		end if;
	end process;



	--------------------------------------------------------------------
	--                    PROCESS : EXEC                              --
	--------------------------------------------------------------------
	read_operation : process(rd1, rd_addr, sig_empty, wr_addr_gray_sync)
		variable rd_addr_buffer : std_logic_vector(BUFFER_WIDTH downto 0);
		variable rd_addr_gray_buffer : std_logic_vector(BUFFER_WIDTH downto 0);
	begin

		empty_next <= '0';
		rd_ram <= '0';

		if rd1 = '1' and sig_empty = '0'  then
			rd_ram <= '1'; -- only read, if fifo is not empty
			rd_addr_buffer := std_logic_vector(unsigned(rd_addr) + 1);
		else
			rd_addr_buffer := rd_addr;
		end if;

		-- gray encoding
		rd_addr_gray_buffer := rd_addr_buffer xor ('0' & rd_addr_buffer(rd_addr'length-1 downto 1));

		if wr_addr_gray_sync = rd_addr_gray_buffer then
				empty_next <= '1';
		end if;

		rd_addr_gray_next <= rd_addr_gray_buffer;
		rd_addr_next <= rd_addr_buffer;
	end process read_operation;


	write_operation : process(wr2, wr_addr, sig_full, rd_addr_gray_sync)
		variable wr_addr_buffer : std_logic_vector(BUFFER_WIDTH downto 0);
		variable wr_addr_gray_buffer : std_logic_vector(BUFFER_WIDTH downto 0);


		variable compare_buffer_gray : std_logic_vector(1 downto 0);
	begin

		full_next <= '0';
		wr_ram <= '0';

		if wr2 = '1' and sig_full = '0'  then
			wr_ram <= '1'; -- only read, if fifo is not empty
			wr_addr_buffer := std_logic_vector(unsigned(wr_addr) + 1);
		else
			wr_addr_buffer := wr_addr;
		end if;

		-- gray encoding
		wr_addr_gray_buffer := wr_addr_buffer xor ('0' & wr_addr_buffer(wr_addr_buffer'length-1 downto 1));

		-- if the MSB in binary encoding is toggeled, the 2 MSB in the gray-code represantation of this register have to be toggled
		compare_buffer_gray := not wr_addr_gray_buffer(BUFFER_WIDTH downto BUFFER_WIDTH-1);

		if rd_addr_gray_sync = (compare_buffer_gray & wr_addr_gray_buffer(BUFFER_WIDTH-2 downto 0)) then
				full_next <= '1';
		end if;

		wr_addr_gray_next <= wr_addr_gray_buffer;
		wr_addr_next <= wr_addr_buffer;
	end process write_operation;


end architecture;

