library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.gt_mp7_core_pkg.ALL;

entity ipb_write_regs is
    generic(
        init_value : ipb_regs_array;
        addr_width : natural;
        regs_beg_index : natural;
        regs_end_index : natural
    );
    port
    (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        ipbus_in : in ipb_wbus;
        ipbus_out : out  ipb_rbus;
        ------------
        regs_o : out ipb_regs_array(regs_beg_index to regs_end_index)
    );
	
end ipb_write_regs;

architecture rtl of ipb_write_regs is

    signal regs: ipb_regs_array(regs_beg_index to regs_end_index) := init_value;

	signal sel: integer range 0 to 2**addr_width-1;
	signal ack: std_logic := '0';

-- HB 14-08-2013:
-- used for what ???
	attribute keep: boolean;
	attribute keep of ack: signal is true;
	attribute keep of sel: signal is true;

begin

    sel <= to_integer(unsigned(ipbus_in.ipb_addr(addr_width-1 downto 0))) when addr_width>0 else 0;
    
    regs_o_inst: for i in regs_beg_index to regs_end_index generate
        regs_o(i) <= regs(i);
    end generate;

	process(reset, clk, sel)
		variable ack_ctrl : std_logic_vector(1 downto 0) := "00";
	begin
	if reset='1' then
        for i in regs_beg_index to regs_end_index loop
            regs(i) <= init_value(i);	
        end loop;
		ack <= '0';
		ack_ctrl := "00";
	elsif rising_edge(clk) then
		if ipbus_in.ipb_strobe='1' and ipbus_in.ipb_write='1' then
            for i in regs_beg_index to regs_end_index loop
                if i = sel then
                    regs(i) <= ipbus_in.ipb_wdata; 
                end if;
            end loop;
		end if;
		-- read out ------
		ipbus_out.ipb_rdata <= regs(sel);		
		-- ack control ---
		if ((sel <= regs_end_index) and (sel >= regs_beg_index)) then
		
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
		else
            ack <= '0';
		end if;
	end if;
	end process;
	
	ipbus_out.ipb_ack <= ack;
	ipbus_out.ipb_err <= '0';

end rtl;
