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
---Description: Delay Manager
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/customized_amc502/trunk/src/mp7_null_algo/firmware/hdl/delay_element.vhd $
-- $Date: 2015-05-05 17:37:57 +0200 (Tue, 05 May 2015) $
-- $Author: wittmann $
-- $Revision: 3906 $
--------------------------------------------------------------------------------
 --JW 17.02.2015 - modified rd address calculation because delay was always 1bx too much
 --JW 16.02.2015 - changed rd + wr addresses to natural
 --JW 16.02.2015 - changed logic for address calculation, because an bug was found:
 --  instead of r.xxx, r_nxt.xxx was used
 --JW 11.02.2015 - changed logic for address calculation, because an bug was found:
 --  if the MAX_DELAY is smaller than the whole instanciated ram, we have to take care,
 --  that the read pointer does not jump to an unused position when the write pointer is set back to 0
--BR: 04.02.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package.

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.math_pkg.all;
use work.user_package.all;

entity delay_element is
	generic
	(
		MAX_DELAY : integer := 31
	);
	port
	(
		lhc_clk : in std_logic;
		lhc_rst : in std_logic;

		data_i : in std_logic;
		data_o : out std_logic;

		valid_i : in std_logic;
		valid_o : out std_logic;

		delay : in std_logic_vector(log2c(MAX_DELAY)-1 downto 0)
	);
end;

architecture arch of delay_element is

	subtype ram_entry_t is std_logic;
	type RAM_TYPE is array (0 to (2**(log2c(MAX_DELAY)))-1) of ram_entry_t;

	type dm_state_t is record
	        rd_addr   : natural range 0 to (2 * MAX_DELAY);
        	wr_addr   : natural range 0 to (2 * MAX_DELAY);
		valid_cnt : std_logic_vector(log2c(MAX_DELAY)-1 downto 0);
		cur_delay : std_logic_vector(log2c(MAX_DELAY)-1 downto 0);
		data_i    : ram_entry_t;
		valid     : std_logic;
	end record;

	constant DM_RESET_STATE : dm_state_t := (0,0,(others=>'0'),(others=>'0'), '0', '0');

	signal r     : dm_state_t;
	signal r_nxt : dm_state_t;


  signal ram : RAM_TYPE := (others=>'0');
	--signal ram_data_in  : ram_entry_t;
	signal ram_data_out : ram_entry_t;

-- 	signal rd_addr : std_logic_vector(log2c(MAX_DELAY)-1 downto 0);
	signal rd_addr :natural range 0 to (2 * MAX_DELAY);
	signal int_valid : std_logic;

begin

	sync : process (lhc_clk, lhc_rst)
	begin
	--BR: 04.02.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package.
		if lhc_rst = RST_ACT then
			r <= DM_RESET_STATE;
		elsif rising_edge(lhc_clk) then
			r <= r_nxt;
		end if;
	end process;

	fifo : process (valid_i, r, delay, data_i)
		variable s : dm_state_t;
    begin

        r_nxt <= r;
        r_nxt.valid <= valid_i;
        r_nxt.data_i <= data_i;
        r_nxt.cur_delay <= delay;

        int_valid <= '0';

        -- advance write pointer
        if r.wr_addr >= (MAX_DELAY - 1)  then
            r_nxt.wr_addr    <= 0;
        else
            r_nxt.wr_addr    <= r.wr_addr + 1;
        end if;


        --calculate read address for the next cycle

        --JW 11.02.2015 - changed logic for address calculation, because an bug was found:
        --  if the MAX_DELAY is smaller than the whole instanciated ram, we have to take care,
        --  that the read pointer does not jump to an unused position when the write pointer is set back to 0

	if ((r.wr_addr - to_integer(unsigned(r.cur_delay)) + 1) < 0) then
        -- special formula for the case mentionned above:
            rd_addr <=  MAX_DELAY - to_integer(unsigned(r.cur_delay)) + r.wr_addr + 1;
        else
            -- read address calculation under normal circumstances:
            rd_addr <=  r.wr_addr - to_integer(unsigned(r.cur_delay)) + 1;
        end if;

        if (r.valid_cnt < r.cur_delay) then
            r_nxt.valid_cnt <= std_logic_vector(unsigned(r.valid_cnt) + 1);
            int_valid    <= '0';
        else
            int_valid    <= '1';
        end if;


        --check if there is a new delay in the sw register
        if unsigned(delay) /= unsigned(r.cur_delay) then
            r_nxt.valid_cnt <= (others=>'0');
        end if;

        if valid_i = '0' then
            r_nxt.valid_cnt <= (others=>'0');
        end if;

	end process;

	-------------------------------------------------------
	-- Internal RAM
	-------------------------------------------------------
	--ram_data_in <= data_i;
 	ram_access : process(lhc_clk)
  	begin

	if rising_edge(lhc_clk) then
      		ram_data_out <= ram(rd_addr);
      		--if WrEn = '1' then
       		ram(r.wr_addr) <= data_i;
      		--end if;
     	end if;
  	end process;

	output : process (r.cur_delay, data_i, r.data_i, ram_data_out, valid_i, r.valid, int_valid)
	begin
		if unsigned(r.cur_delay) = 0 then
			data_o <= data_i;
			valid_o <= valid_i;
		elsif unsigned(r.cur_delay) = 1 then
			data_o <= r.data_i;
			valid_o <= r.valid;
		else
			data_o <= ram_data_out;
			valid_o <= int_valid;
		end if;
	end process;

end architecture;

