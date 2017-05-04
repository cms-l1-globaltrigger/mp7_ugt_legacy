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
---Description:Lane Mapping Process, Developer HEPHY
-- $HeadURL: $
-- $Date:  $
-- $Author: Florian $
-- Modification : HEPHY, the deisgn has a bug and it does not working correctly at hardware, I do not have a time to take care on it. I exchanged it to one from coregenerator, which coudl be found in frame.vhd
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

entity simspymem is
	generic
	(
		USE_SW_OUTPUT_REGISTER : boolean := true;
		USE_SW_INPUT_REGISTER : boolean := true
	);
	port
	(
        ipbus_clk   : in    std_logic;
        ipbus_rst   : in    std_logic;
        ipbus_in    : in    ipb_wbus;
        ipbus_out   : out   ipb_rbus;
        ------------
		lhc_clk    : in std_logic;
-- 		lhc_rst    : in std_logic;
		lhc_data_o : out lhc_data_t;
		lhc_data_i : in lhc_data_t;
		bx_nr      : in std_logic_vector(11 downto 0);
		spy        : in std_logic
	);
begin
	assert ipbus_in.ipb_addr'length >= (log2c(BUNCHES_PER_ORBIT)+log2c(LHC_DATA_WIDTH/ipbus_in.ipb_wdata'length))
		report "address space too small for simspy memory!"
		severity failure;
	assert LHC_DATA_WIDTH mod (ipbus_in.ipb_wdata'length) = 0
		report "LHC_DATA_WIDTH is no multiple of software data width --> This is not supported"
		severity failure;
end;

architecture arch of simspymem is

-- 	constant SW_DATA_WIDTH : integer := ipbus_in.ipb_wdata'length;
	constant SW_DATA_WIDTH : integer := 32;
-- changed, because memory wr/rd not ok
-- 	constant READ_LATENCY : integer := 2; -- read latency of the internal ram
	constant READ_LATENCY : integer := 0; -- read latency of the internal ram

	constant MEMORY_BLOCKS : integer := LHC_DATA_WIDTH/SW_DATA_WIDTH;

	signal lhc_data_slv_o : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
	signal lhc_data_slv_i : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);

	type data_out_array_t is array(0 to MEMORY_BLOCKS-1) of std_logic_vector(SW_DATA_WIDTH-1 downto 0);

	signal data_out_array : data_out_array_t;
	signal mem_sel : std_logic_vector(MEMORY_BLOCKS-1 downto 0);
	signal mem_sel_reg : std_logic_vector(MEMORY_BLOCKS-1 downto 0);


	signal wr_internal : std_logic;
	signal addr_internal : std_logic_vector(log2c(BUNCHES_PER_ORBIT)+log2c(MEMORY_BLOCKS)-1 downto 0) := (others=>'0');

	signal bx_addr : std_logic_vector(bx_nr'length-1 downto 0);

	signal dl_in_rd_ack : std_logic;


	signal rd_ack_internal   : std_logic;
	signal sw_data_out_internal : std_logic_vector((ipbus_out.ipb_rdata'length)-1 downto 0);

	signal sw_in_internal : std_logic_vector((ipbus_in.ipb_wdata'length)-1 downto 0);

-- 	signal ack : std_logic;

begin



	wr_internal <= ipbus_in.ipb_write;
	addr_internal <= ipbus_in.ipb_addr(addr_internal'length-1 downto 0);	 -- use only the required bits

	gen_true_dp_mems : for i in 0 to MEMORY_BLOCKS-1 generate
		signal mem_wr : std_logic;
	begin

        mem_wr <= mem_sel(i) and wr_internal and ipbus_in.ipb_strobe;

		tdp_mem : entity work.ram_2c2w2r
			generic map
			(
				SIZE => BUNCHES_PER_ORBIT,
-- 				DATA_WIDTH => PCIE_DATA_WIDTH,
				DATA_WIDTH => SW_DATA_WIDTH,

-- 				USE_OUTPUT_REGISTER => true
				USE_OUTPUT_REGISTER => false
			)
			port map
			(
				--LHC clk
				a_clk     => lhc_clk,
				a_en   	  => '1',
				a_wr      => spy,
				a_rd      => '1',
				a_addr    => bx_addr,
				a_rd_data => lhc_data_slv_o( (i+1)*SW_DATA_WIDTH-1 downto i*SW_DATA_WIDTH ),
				a_wr_data => lhc_data_slv_i( (i+1)*SW_DATA_WIDTH-1 downto i*SW_DATA_WIDTH ),

				-- IPBus clk
				b_clk     => ipbus_clk,
				b_en      => ipbus_in.ipb_strobe,
				b_wr      => mem_wr,
				b_rd      => '1',
				b_addr    => addr_internal(addr_internal'length-1 downto log2c(MEMORY_BLOCKS)),
				b_rd_data => data_out_array(i),
				b_wr_data => sw_in_internal
			);
	end generate;

	lhc_data_o <= std_logic_vector_to_lhc_data_t(lhc_data_slv_o);
	lhc_data_slv_i <= lhc_data_t_to_std_logic_vector(lhc_data_i);

	mem_sel_gen : process (addr_internal)
		variable addr : std_logic_vector(log2c(MEMORY_BLOCKS)-1 downto 0);
	begin
		addr := addr_internal(log2c(MEMORY_BLOCKS)-1 downto 0);
		mem_sel <= (others=>'0');
		for i in 0 to MEMORY_BLOCKS-1 loop
			if unsigned(addr) = i then
				mem_sel(i) <= '1';
			end if;
		end loop;
	end process;

	sw_data_out_mux : process (data_out_array, mem_sel_reg)
		variable temp : data_out_array_t;
		variable temp_out : std_logic_vector(sw_data_out_internal'length-1 downto 0);
	begin

		-- and
		for i in 0 to MEMORY_BLOCKS-1 loop
			temp(i) := data_out_array(i) and (temp(i)'range=>mem_sel_reg(i));
		end loop;

		-- or
		temp_out := (others=>'0');
		for i in 0 to MEMORY_BLOCKS-1 loop
			temp_out := temp_out or temp(i);
		end loop;

		sw_data_out_internal <= temp_out;
	end process;

	gen_bx_addr : process (bx_nr, spy)
		variable temp : std_logic_vector(bx_nr'length downto 0); -- one bit more
	begin
		temp := std_logic_vector(unsigned('0' & bx_nr) + READ_LATENCY);

		if spy = '1' then
			bx_addr <= bx_nr; --no write latency
		else -- compensate the read latency of the sim memory
			if  unsigned(temp) > BUNCHES_PER_ORBIT-(READ_LATENCY-1) then
				temp := std_logic_vector(unsigned(temp) - BUNCHES_PER_ORBIT);
				bx_addr <= temp(bx_addr'range);
			else
				bx_addr <= temp(bx_addr'range);
			end if;
		end if;
	end process;

-- Generation of "error" and "ack" for IPBus
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
			sig_i => mem_sel,
			sig_o => mem_sel_reg
		);

	--! generate an additional output register
	GEN_SW_OUTPUT_REGISTER : if USE_SW_OUTPUT_REGISTER = true generate
	begin
		sw_out_reg : process (ipbus_clk, ipbus_rst)
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

	GEN_NO_SW_OUTPUT_REGISTER : if USE_SW_OUTPUT_REGISTER = false generate
		ipbus_out.ipb_rdata <= sw_data_out_internal;
		ipbus_out.ipb_ack <= rd_ack_internal;
	end generate;

	GEN_SW_INPUT_REGISTER : if USE_SW_INPUT_REGISTER = true generate
		sw_in_reg : process (ipbus_clk, ipbus_rst)
		begin
			if ipbus_rst = '1' then
				sw_in_internal <= (others=>'0');
			elsif rising_edge(ipbus_clk) then
				sw_in_internal <= ipbus_in.ipb_wdata;
			end if;
		end process;
	end generate;

	GEN_NO_SW_INPUT_REGISTER : if USE_SW_INPUT_REGISTER = false generate
		sw_in_internal <= ipbus_in.ipb_wdata;
	end generate;

end architecture;



