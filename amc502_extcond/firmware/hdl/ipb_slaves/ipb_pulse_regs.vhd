library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

entity ipb_pulse_regs is
port
(
    ipb_clk             : in    std_logic;
    ipb_reset           : in    std_logic;
    ipb_mosi_i          : in    ipb_wbus;
    ipb_miso_o          : out ipb_rbus;
    ------------------
    lhc_clk             : in std_logic;
    ------------------
    pulse_o             : out   std_logic_vector
);

end ipb_pulse_regs;

architecture rtl of ipb_pulse_regs is

    signal reg: std_logic_vector(31 downto 0) := X"00000000";

    signal ack: std_logic;

    attribute keep: boolean;
    attribute keep of ack: signal is true;

    signal temp0: std_logic_vector(31 downto 0) := X"00000000";
    signal temp1: std_logic_vector(31 downto 0) := X"00000000";
    signal pulse: std_logic_vector(31 downto 0) := X"00000000";

begin

    --=============================--
    process(ipb_reset, lhc_clk)
    --=============================--
    begin
    if ipb_reset = '1' then
        temp0 <= (others => '0');
        temp1 <= (others => '0');
        pulse <= (others => '0');
    elsif rising_edge(lhc_clk) then
        temp0 <= reg;
        temp1 <= temp0;
        pulse <= temp0 and not temp1;
    end if;
    end process;

    --=============================--
    process(ipb_reset, ipb_clk)
    --=============================--
    begin
    if ipb_reset = '1' then
        ack      <= '0';
    elsif temp1 /= x"00000000" then
        reg <= (others => '0');
    elsif rising_edge(ipb_clk) then
        --reg <= reg_pulse;
        if ipb_mosi_i.ipb_strobe='1' and ipb_mosi_i.ipb_write='1' then
            reg <= ipb_mosi_i.ipb_wdata;
        end if;
        -- ack
        ack <= ipb_mosi_i.ipb_strobe and not ack;

    end if;
    end process;

    pulse_o <= pulse;

    ipb_miso_o.ipb_ack <= ack;
    ipb_miso_o.ipb_err <= '0';

end rtl;