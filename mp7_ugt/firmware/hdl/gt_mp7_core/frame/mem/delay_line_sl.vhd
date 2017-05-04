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
-- $Author: HEPHY $
-- Modification :
--    1) modification for different reset, lhc reset as well as IPbus reset is active high, and the reset is active low.
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.gt_mp7_core_pkg.all;

use work.math_pkg.all;

entity delay_line_sl is
	generic
	(
		DELAY : integer := 0;
		SPY_IN: boolean := false
	);
	port
	(
		clk   : in  std_logic;
		rst   : in  std_logic; --with rst   => rop_rst in spymem3
		sig_i : in  std_logic;
		sig_o : out std_logic
	);
end entity;

architecture arch of delay_line_sl is
begin

	NO_DELAY : if DELAY = 0 generate
		sig_o <= sig_i;
	end generate;

  FOR_SPY_IN_i: if SPY_IN = true generate
  -- for SYP_i   rst   => rop_rst
  begin

  	DELAY_1 : if DELAY = 1 generate
		signal reg : std_logic;
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT_ROP then
				reg <= '0';
			elsif rising_edge(clk) then
				reg <= sig_i;
			end if;
		end process;
		sig_o  <= reg;
	end generate;

	DELAY_GR_1 : if DELAY > 1 generate
		signal delay_line : std_logic_vector(DELAY-1 downto 0);
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT_ROP then
				delay_line <= (others=>'0');
			elsif rising_edge(clk) then
				delay_line <= delay_line(DELAY-2 downto 0) & sig_i;
			end if;
		end process;

		sig_o  <= delay_line(DELAY-1);
	end generate;


  end generate  FOR_SPY_IN_i;

  FOR_SPY_ACK_i: if SPY_IN = false generate
  -- for SPY_ACK  rst   => lhc_rst,

  begin
     	DELAY_1 : if DELAY = 1 generate
		signal reg : std_logic;
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT then
				reg <= '0';
			elsif rising_edge(clk) then
				reg <= sig_i;
			end if;
		end process;
		sig_o  <= reg;
	end generate;

	DELAY_GR_1 : if DELAY > 1 generate
		signal delay_line : std_logic_vector(DELAY-1 downto 0);
	begin
		gen_DELAY : process(clk, rst)
		begin
			if rst = RST_ACT then
				delay_line <= (others=>'0');
			elsif rising_edge(clk) then
				delay_line <= delay_line(DELAY-2 downto 0) & sig_i;
			end if;
		end process;

		sig_o  <= delay_line(DELAY-1);
	end generate;
  end generate  FOR_SPY_ACK_i;


end architecture;





