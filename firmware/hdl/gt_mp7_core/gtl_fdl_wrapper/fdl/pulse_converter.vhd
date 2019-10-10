
-- Desription:
-- "Pulse converter": a pulse with "undefined" length (e.g.: from a PCIe pulse register bit) is converted to a pulse
-- of a width of 25ns (lhc_clk period)

library ieee;
use ieee.std_logic_1164.all;

entity pulse_converter is
    port( 
        pulse_in         : in     std_logic;
        lhc_clk          : in     std_logic;
        pulse_25ns_out   : out    std_logic
    );
end pulse_converter;

architecture rtl of pulse_converter is
    signal request_ff : std_logic := '0';
    signal pulse_25ns : std_logic := '0';
    signal d_in : std_logic;
begin

    req_ff_p: process (pulse_in, pulse_25ns)
    begin
        if pulse_25ns = '1' then
            request_ff <= '0'; -- clear with positive edge of pulse_25ns
        elsif pulse_in'event and pulse_in = '1' then
            request_ff <= '1'; -- set with positive edge of pulse_in
        end if;
    end process req_ff_p;

    d_in <= not pulse_25ns and request_ff; -- to get a 25 ns pulse (one period of lhc_clk)

    pulse_25ns_out_p: process (lhc_clk, d_in)
    begin
        if lhc_clk'event and lhc_clk = '1' then
            pulse_25ns <= d_in;
        end if;
    end process pulse_25ns_out_p;

    pulse_25ns_out <= pulse_25ns;

end architecture rtl;

