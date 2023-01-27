library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port(
        clk : in std_logic;
        inp : in std_logic;
        outp : out std_logic
    );
end reg;

architecture rtl of reg is

begin

p: process(clk, inp)
    begin
        if (clk'event and clk = '1') then
            outp <= inp;
        end if;
end process;

end architecture rtl;
