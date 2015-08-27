library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.all;

entity ipb_dpmem_4096_32 is
    port
    (
        ipbus_clk   : in 	STD_LOGIC;
        reset		: in 	STD_LOGIC;
        ipbus_in	: in 	ipb_wbus;
        ipbus_out	: out   ipb_rbus;
        ------------
        clk_b       : in  STD_LOGIC;
        enb         : in  STD_LOGIC;
        web         : in  STD_LOGIC;
        addrb       : in  std_logic_vector(11 downto 0);
        dinb        : in  std_logic_vector(31 downto 0);
        doutb       : out std_logic_vector(31 downto 0)
    );

end ipb_dpmem_4096_32;

architecture rtl of ipb_dpmem_4096_32 is

-- 	signal sel: integer range 0 to 4095; --

	signal ack: std_logic;
	signal wea_i: std_logic_vector(0 downto 0);
	signal web_i: std_logic_vector(0 downto 0);

	attribute keep: boolean;
	attribute keep of ack: signal is true;
-- 	attribute keep of sel: signal is true; --

begin

--     sel <= to_integer(unsigned(ipbus_in.ipb_addr(11 downto 0))); --

    wea_i(0) <= ipbus_in.ipb_write;
    web_i(0) <= web;

    dp_mem_4096x32_i: entity work.dp_mem_4096x32
        port map(
            clka => ipbus_clk,
            ena => ipbus_in.ipb_strobe,
            wea => wea_i,
            addra => ipbus_in.ipb_addr(11 downto 0),
            dina => ipbus_in.ipb_wdata,
            douta => ipbus_out.ipb_rdata,
            clkb => clk_b,
            enb => enb,
            web => web_i,
            addrb => addrb,
            dinb => dinb,
            doutb => doutb
        );

	process(reset, ipbus_clk) --sel)
		variable ack_ctrl : std_logic_vector(1 downto 0);
	begin
	if reset='1' then
		ack <= '0';
		ack_ctrl := "00";
	elsif rising_edge(ipbus_clk) then
-- 	    if ((sel <= 4096) and (sel >= 0)) then	--
		if ipbus_in.ipb_strobe='1' and ipbus_in.ipb_write='1' then
		    ack <= ipbus_in.ipb_strobe;
		else
		    case ack_ctrl is
			    when "00" => ack <= '0';
                    if ipbus_in.ipb_strobe='1' then
					    ack <= '1'; ack_ctrl := "01";
                    end if;
			    when "01" => ack <= '0'; ack_ctrl := "10";
			    when "10" => ack <= '0'; ack_ctrl := "11";
			    when "11" => ack <= '0'; ack_ctrl := "00";
			    when others =>
		    end case;
		end if;
-- 	    else	--
-- 	      ack <= '0';	--
-- 	    end if;	--
	end if;
	end process;

	ipbus_out.ipb_ack <= ack;
	ipbus_out.ipb_err <= '0';

end rtl;
