-- Version-history:
-- HB 2023-09-08: changed type (lword_array) of port in_mux.

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mp7_data_types.all;

use work.gtl_pkg.all;

entity mux is
    port
    (   clk     : in std_logic;
        res     : in std_logic;
        bcres   : in std_logic; -- bcres 40 MHz
        in_mux  : in lword_array;
        mux_out : out lword
    );
end mux;

architecture arch of mux is
    signal s_out : lword;
    signal frame_cntr : std_logic_vector (2 downto 0); --counter for frame mux: 0 to 5

begin

    -- frame counter
    frame_counter: process (clk, res, bcres, frame_cntr)
    begin
        if (res = '1' or bcres = '1') then
           frame_cntr <= "000";      -- async. res
        elsif (clk'event and clk = '1') then
            if (frame_cntr = "101") then
                frame_cntr <= "000";   -- sync BCReset
            else
                frame_cntr <= frame_cntr + '1';
            end if;
        end if;
    end process frame_counter;

    s_out   <=  in_mux(0) when frame_cntr = "000" else
                in_mux(1) when frame_cntr = "001" else
                in_mux(2) when frame_cntr = "010" else
                in_mux(3) when frame_cntr = "011" else
                in_mux(4) when frame_cntr = "100" else
                in_mux(5) when frame_cntr = "101" else
                ((others => '0'), '0', '0', '0');

    sync : process(clk)
    begin
        if rising_edge(clk) then
            mux_out <= s_out;
        end if;
    end process;

end architecture;
