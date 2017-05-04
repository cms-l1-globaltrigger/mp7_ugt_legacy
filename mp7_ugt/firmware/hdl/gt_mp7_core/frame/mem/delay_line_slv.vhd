-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description:delay line concept for adjusting the delay for different part
-- $HeadURL: $
-- $Date:  $
-- $Author: HEPHY $
-- $Revision: 0.1 $
--------------------------------------------------------------------------------


library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;

use work.math_pkg.all;

entity delay_line_slv is
	generic
	(
		DELAY : integer := 0;
		WIDTH : integer := 8
	);
	port
	(
		clk   : in  std_logic;
		rst   : in  std_logic;
		sig_i : in  std_logic_vector(WIDTH-1 downto 0);
		sig_o : out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;

architecture arch of delay_line_slv is
begin

	NO_DELAY : if DELAY = 0 generate
		sig_o <= sig_i;
	end generate;

	DELAY_1 : if DELAY = 1 generate
		signal reg : std_logic_vector(WIDTH-1 downto 0);
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT then
				reg <= (others=>'0');
			elsif rising_edge(clk) then
				reg <= sig_i;
			end if;
		end process;
		sig_o  <= reg;
	end generate;

	DELAY_GR_1 : if DELAY > 1 generate
		type delay_line_t is array(0 to DELAY-1) of std_logic_vector(WIDTH-1 downto 0);
		signal delay_line : delay_line_t;
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT then
				delay_line <= (others=>(others=>'0'));
			elsif rising_edge(clk) then
				delay_line(0) <= sig_i;
				for i in 1 to delay_line'length-1 loop
					delay_line(i) <= delay_line(i-1);
				end loop;
			end if;
		end process;

		sig_o  <= delay_line(DELAY-1);
	end generate;

end architecture;





