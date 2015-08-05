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
--------------------------------------------------------------------------------
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;

use work.math_pkg.all;


entity dynamic_delay_line is
	generic
	(
		WIDTH : integer := 8;
		MAX_DELAY : integer range 1 to 7:= 3;
		STATIC_DELAY : integer := 0
	);
	port
	(
		clk   : in  std_logic;
		rst   : in  std_logic;
		delay : in  std_logic_vector(log2c(MAX_DELAY) downto 0);
		sig_i : in  std_logic_vector(WIDTH-1 downto 0);
		sig_o : out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;


architecture arch of dynamic_delay_line is
	signal sig_after_static_delay : std_logic_vector(WIDTH-1 downto 0);
	
	type delay_line_t is array(integer range <>) of std_logic_vector(WIDTH-1 downto 0);
	signal dyndl : delay_line_t(0 to MAX_DELAY-1);
begin

	NO_DELAY : if STATIC_DELAY = 0 generate
		sig_after_static_delay <= sig_i;
	end generate;
	
	DELAY_1 : if STATIC_DELAY = 1 generate
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
		sig_after_static_delay  <= reg;
	end generate;
	

	DELAY_GR_1 : if STATIC_DELAY > 1 generate
		signal delay_line : delay_line_t(0 to STATIC_DELAY-1);
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
	
		sig_after_static_delay  <= delay_line(STATIC_DELAY-1);
	end generate;


	--generate dynamic delay line
	

	
	process(clk, rst)
	begin
		if rst = RST_ACT then
			dyndl <= (others=>(others=>'0'));
		elsif rising_edge(clk) then
			dyndl(0) <= sig_after_static_delay;
			for i in 1 to dyndl'length-1 loop	
				dyndl(i) <= dyndl(i-1);
			end loop;	
		end if;
	end process;
	
	
	output_mux : process (dyndl, sig_after_static_delay)
		variable mux_input : delay_line_t(0 to MAX_DELAY);
	begin
		mux_input(0) := sig_after_static_delay;
		mux_input(1 to MAX_DELAY) := dyndl;
		sig_o <= mux_input(to_integer(unsigned(delay)));
	end process;
	
	

end architecture;





