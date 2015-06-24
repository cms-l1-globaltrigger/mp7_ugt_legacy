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
---Description:Memory, Specification : Babak, Devopler: Babak, Flo
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/frame/mem/delay_line_slv.vhd $
-- $Date: 2014-07-02 14:05:41 +0200 (Wed, 02 Jul 2014) $
-- $Author: bergauer $
-- $Revision: 3006 $

-- -- HB 2014-05-07: changed code (from gt_amc514) for use with IPBus in MP7

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





