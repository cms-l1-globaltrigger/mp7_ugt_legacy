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
---Description:RTL RAM design for ROP. It could be used for any design. It should be adjusted for changing the technology
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY$
-- $Revision: 0.1 $
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;

entity ram_2c1w1r is
	generic
	(
		DATA_WIDTH : integer := 32;
		SIZE : integer := 256;
		USE_OUTPUT_REGISTER : boolean := false
	);
	port
	(
		wr_clk  : in  std_logic;
		rd_clk  : in  std_logic;

		wr_en   : in  std_logic;
		wr      : in  std_logic;
		rd      : in  std_logic;

		wr_addr : in  std_logic_vector(log2c(SIZE)-1 downto 0);
		rd_addr : in  std_logic_vector(log2c(SIZE)-1 downto 0);

		rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
		wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0)

	);
end entity;

architecture arch of ram_2c1w1r is

	type ram_t is array (SIZE-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);

	-- If using Dual Port, 2 Clocks, 2 Read/Write Ports use the following definition for <ram_name>
	shared variable ram : ram_t := (others=>(others=>'0'));

	signal rd_data_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
begin

	process (wr_clk)
	begin
		 if (wr_clk'event and wr_clk = '1') then
		    if (wr_en = '1') then
		       if (wr = '1') then
		          ram(conv_integer(wr_addr)) := wr_data;
		       end if;
		    end if;
		 end if;
	end process;

	process (rd_clk)
	begin
		 if (rd_clk'event and rd_clk = '1') then
		    if (rd = '1') then
		       rd_data_temp <= ram(conv_integer(rd_addr));
		    end if;
		 end if;
	end process;

	gen_output_register : if USE_OUTPUT_REGISTER = true generate
		process (rd_clk)
		begin
			if (rd_clk'event and rd_clk = '1') then
				rd_data <= rd_data_temp;
			end if;
		end process;
	end generate;

	gen_NO_output_register : if USE_OUTPUT_REGISTER = false generate
		rd_data <= rd_data_temp;
	end generate;
end architecture;







