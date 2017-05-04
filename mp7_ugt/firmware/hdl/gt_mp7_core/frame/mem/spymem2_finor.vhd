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
---Description:SPYMEM 2 FINOR
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

entity spymem2_finor is
	generic
	(
		GTL_FDL_LATENCY : integer := 2
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

		bx_nr      : in std_logic_vector(11 downto 0);
		spy_i      : in std_logic;
		finor_i    : in std_logic
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
end;


architecture arch of spymem2_finor is

	constant SW_DATA_WIDTH    : integer := 32;
	constant INPUT_ADDR_WIDTH : integer := log2c(BUNCHES_PER_ORBIT);
	constant SW_ADDR_WIDTH    : integer := log2c(BUNCHES_PER_ORBIT/SW_DATA_WIDTH);

	signal bx_addr     : std_logic_vector(log2c(BUNCHES_PER_ORBIT)-1 downto 0);
	signal bx_addr_nxt : std_logic_vector(log2c(BUNCHES_PER_ORBIT)-1 downto 0);
	signal spy_we      : std_logic;
	signal finor_i_slv : std_logic_vector (0 downto 0);

-- 	constant READ_LATENCY : integer := 2; -- read latency of the internal ram
	constant READ_LATENCY : integer := 0; -- read latency of the internal ram

	signal dl_in_rd_ack : std_logic;


begin

	sync_lhc_clk : process (lhc_clk, lhc_rst)
	begin
		if lhc_rst = RST_ACT then
			bx_addr <= (others=>'0');
		elsif rising_edge(lhc_clk) then
			bx_addr <= bx_addr_nxt;
		end if;
	end process;

	finor_i_slv(0) <= finor_i;

	ram : entity work.ram_asym_2c2w2r
		generic map
		(
		  WIDTHA      => 1,
		  SIZEA       => 2**INPUT_ADDR_WIDTH,
		  ADDRWIDTHA  => INPUT_ADDR_WIDTH,
		  WIDTHB      => 32,
		  SIZEB       => 2**SW_ADDR_WIDTH,
		  ADDRWIDTHB  => SW_ADDR_WIDTH
		)
		port map
		(
		  a_clk     => lhc_clk,
		  a_en      => '1',
		  a_we      => spy_we,
		  a_addr    => bx_addr,
		  a_wr_data => finor_i_slv,
		  a_rd_data => open,

		  b_clk     => ipbus_clk,
		  b_en      => '1',
		  b_we      => '0',
		  b_addr    => ipbus_in.ipb_addr(SW_ADDR_WIDTH-1 downto 0),
		  b_wr_data => (others=>'0'),
		  b_rd_data => ipbus_out.ipb_rdata
		);

    ipbus_out.ipb_err <= '0';


--
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

-- 	dl_in_rd_ack <= sw_i.rd_req and sw_i.sel;
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
			sig_o => ipbus_out.ipb_ack
		);

end architecture;



