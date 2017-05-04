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
---Description:SPYMEM 2 for algos.
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
-- Modification : HEPHY, the deisgn has a bug and it does not working correctly at hardware. The problem is fixed, but it is decided to use coregenerator version
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

entity spymem2_algos is
	generic
	(
		GTL_FDL_LATENCY : integer := 0;
		USE_SW_OUTPUT_REGISTER : boolean := true
	);
	port
	(
        ipbus_clk   : in    std_logic;
        ipbus_rst   : in    std_logic;
        ipbus_in    : in    ipb_wbus;
        ipbus_out   : out   ipb_rbus;
        ------------
		lhc_clk    : in std_logic;
		lhc_rst    : in std_logic;

		bx_nr      : in bx_nr_t;
		spy_i      : in std_logic;
		algos_i    : in std_logic_vector(MAX_NR_ALGOS-1 downto 0)
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
	assert(ipbus_in.ipb_addr'length > (log2c(MAX_NR_ALGOS/ipbus_in.ipb_wdata'length)+log2c(BUNCHES_PER_ORBIT)) )
		report "address space too small for spy II (algos)!"
		severity error;
end;

architecture arch of spymem2_algos is

	constant SW_DATA_WIDTH : integer := 32;
	constant MEMORY_BLOCKS : integer := MAX_NR_ALGOS/SW_DATA_WIDTH;
-- 	constant READ_LATENCY : integer := 2; -- read latency of the internal ram
	constant READ_LATENCY : integer := 0; -- read latency of the internal ram


	signal bx_addr : std_logic_vector(log2c(BUNCHES_PER_ORBIT)-1 downto 0);
	signal bx_addr_nxt : std_logic_vector(log2c(BUNCHES_PER_ORBIT)-1 downto 0);
	signal spy_we  : std_logic;

	type data_out_array_t is array(0 to MEMORY_BLOCKS-1) of std_logic_vector(SW_DATA_WIDTH-1 downto 0);
	signal data_out_array : data_out_array_t ;

	signal dl_in_rd_ack : std_logic;
	signal addr_internal : std_logic_vector(log2c(BUNCHES_PER_ORBIT)+log2c(MEMORY_BLOCKS)-1 downto 0);
	signal mem_sel : std_logic_vector(log2c(MEMORY_BLOCKS)-1 downto 0);

	signal rd_ack_internal   : std_logic;
	signal sw_data_out_internal : std_logic_vector((ipbus_out.ipb_rdata'length)-1 downto 0);

-- 	signal ack : std_logic;

begin

--	addr_internal <= sw_i.addr(addr_internal'length-1 downto 0);
    addr_internal <= ipbus_in.ipb_addr(addr_internal'length-1 downto 0);

	sync_lhc_clk : process (lhc_clk, lhc_rst)
	begin
		if lhc_rst = RST_ACT then
			bx_addr <= (others=>'0');
		elsif rising_edge(lhc_clk) then
			bx_addr <= bx_addr_nxt;
		end if;
	end process;

	dprams : for i in 0 to MEMORY_BLOCKS-1 generate
	begin
		ram32 : entity work.ram_2c1w1r
			generic map
			(
				DATA_WIDTH => SW_DATA_WIDTH,
--  what's that ???
				SIZE       => 2**log2c(BUNCHES_PER_ORBIT),
				USE_OUTPUT_REGISTER => true
			)
			port map
			(
				wr_clk  => lhc_clk,
				wr_en   => '1',
				wr      => spy_we,
				wr_addr => bx_addr,
				wr_data => algos_i(SW_DATA_WIDTH*(i+1)-1 downto SW_DATA_WIDTH*i),

				rd_clk  => ipbus_clk,
				rd      => '1',
				rd_addr => addr_internal(addr_internal'length-1 downto log2c(MEMORY_BLOCKS)),
				rd_data => data_out_array(i)
			);
	end generate;

	gen_bx_addr : process (bx_nr, spy_we, bx_addr)
	begin
		bx_addr_nxt <= (others=>'0');
		if spy_we = '1' then
			bx_addr_nxt <= std_logic_vector(unsigned(bx_addr) + 1);
		end if;
		-- just for safty, this is needed if two spy triggers come back to back
		-- should never happen ...
		if unsigned(bx_addr) = BUNCHES_PER_ORBIT-1 then
			bx_addr_nxt <= (others=>'0');
		end if;
	end process;

	dl_spy : entity work.delay_line_sl
		generic map
		(
			DELAY => GTL_FDL_LATENCY
		)
		port map
		(
			clk => lhc_clk,
			rst => lhc_rst,
			sig_i => spy_i,
			sig_o => spy_we
		);

-- Generation of "error" for IPBus
    ipbus_out.ipb_err <= '0';


    dl_in_rd_ack <= ipbus_in.ipb_strobe;

	dl_rd_ack : entity work.delay_line_sl
		generic map
		(
			DELAY => READ_LATENCY
		)
		port map
		(
            clk => ipbus_clk,
            rst => ipbus_rst,
			sig_i => dl_in_rd_ack,
			sig_o => rd_ack_internal
		);

	dl_mem_sel : entity work.delay_line_slv
		generic map
		(
			DELAY => READ_LATENCY,
			WIDTH => mem_sel'length
		)
		port map
		(
            clk => ipbus_clk,
            rst => ipbus_rst,
			sig_i => addr_internal(log2c(MEMORY_BLOCKS)-1 downto 0),
			sig_o => mem_sel
		);

	data_out_mux : process (mem_sel, data_out_array)
	begin

		sw_data_out_internal <= data_out_array(0);

		for i in 0 to MEMORY_BLOCKS-1 loop
			if unsigned(mem_sel) = i then
				sw_data_out_internal <= data_out_array(i);
			end if;
		end loop;

	end process;

	--! generate an additional output register
	GEN_SW_OUTPUT_REGISTER : if USE_SW_OUTPUT_REGISTER = true generate
	begin
		sync_ipbus_clk : process (ipbus_clk, ipbus_rst)
		begin
-- 			if ipbus_rst = '0' then
            if ipbus_rst = '1' then
                ipbus_out.ipb_rdata <= (others=>'0');
                ipbus_out.ipb_ack <= '0';
            elsif rising_edge(ipbus_clk) then
                ipbus_out.ipb_rdata <= sw_data_out_internal;
                ipbus_out.ipb_ack <= rd_ack_internal;
            end if;
		end process;

	end generate;

	DONT_GEN_SW_OUTPUT_REGISTER : if USE_SW_OUTPUT_REGISTER = false generate
        ipbus_out.ipb_rdata <= sw_data_out_internal;
        ipbus_out.ipb_ack <= rd_ack_internal;
	end generate;


end architecture;








