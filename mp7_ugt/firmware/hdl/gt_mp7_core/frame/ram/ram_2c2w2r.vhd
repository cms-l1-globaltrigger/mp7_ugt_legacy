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
-- $Author:  HEPHY$
-- $Revision: 0.1 $
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;

entity ram_2c2w2r is
	generic
	(
		DATA_WIDTH : integer := 32;
		SIZE : integer := 4096;
		--ADDR_WIDTH : integer := 8
		USE_OUTPUT_REGISTER : boolean := true
	);
	port
	(
		a_clk     : in  std_logic;
		a_en      : in  std_logic;
		a_wr      : in  std_logic;
		a_rd      : in  std_logic;
		a_addr    : in  std_logic_vector(log2c(SIZE)-1 downto 0);
		a_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
		a_wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);

		b_clk     : in  std_logic;
		b_en      : in  std_logic;
		b_wr      : in  std_logic;
		b_rd      : in  std_logic;
		b_addr    : in  std_logic_vector(log2c(SIZE)-1 downto 0);
		b_rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
		b_wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;

architecture arch of ram_2c2w2r is

	type ram_t is array (SIZE-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);

	-- If using Dual Port, 2 Clocks, 2 Read/Write Ports use the following definition for ram
	shared variable ram : ram_t := (others=>(others=>'0'));

	signal a_rd_data_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal b_rd_data_temp : std_logic_vector(DATA_WIDTH-1 downto 0);

begin


	process (a_clk)
	begin
		 if (a_clk'event and a_clk = '1') then
		    if (a_en = '1') then
		       if (a_wr = '1') then
		          ram(conv_integer(a_addr)) := a_wr_data;
		       end if;
		       a_rd_data_temp <= ram(conv_integer(a_addr));
		    end if;
		 end if;
	end process;

	process (b_clk)
	begin
		 if (b_clk'event and b_clk = '1') then
		    if (b_en = '1') then
		       if (b_wr = '1') then
		          ram(conv_integer(b_addr)) := b_wr_data;
		       end if;
		       b_rd_data_temp <= ram(conv_integer(b_addr));
		    end if;
		 end if;
	end process;

	gen_output_register : if USE_OUTPUT_REGISTER = true generate
		process (b_clk)
		begin
			if (b_clk'event and b_clk = '1') then
				b_rd_data <= b_rd_data_temp;
			end if;
		end process;

		process (a_clk)
		begin
			if (a_clk'event and a_clk = '1') then
				a_rd_data <= a_rd_data_temp;
			end if;
		end process;
	end generate;

	gen_NO_output_register : if USE_OUTPUT_REGISTER = false generate
		a_rd_data <= a_rd_data_temp;
		b_rd_data <= b_rd_data_temp;
	end generate;

end architecture;




