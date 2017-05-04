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
-- $Author:HEPHY  $
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mp7_data_types.all;

entity mux is
    port
    (   clk    : in std_logic;
        res    : in std_logic;
        bcres  : in std_logic; -- bcres 40 MHz
        -- 6 inputs for 40MHz -> 240MHz
        in0    : in lword;
        in1    : in lword;
        in2    : in lword;
        in3    : in lword;
        in4    : in lword;
        in5    : in lword;
        -- output
        mux_out   : out lword
    );
end mux;

architecture arch of mux is
    signal s_out    : lword;
    signal frame_cntr  : std_logic_vector (2 downto 0); --counter for frame mux: 0 to 5

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

    s_out   <=  in0 when frame_cntr = "000" else
                in1 when frame_cntr = "001" else
                in2 when frame_cntr = "010" else
                in3 when frame_cntr = "011" else
                in4 when frame_cntr = "100" else
                in5 when frame_cntr = "101" else
                ((others => '0'), '0', '0', '0');

    sync : process(clk)
    begin
        if rising_edge(clk) then
            mux_out <= s_out;
        end if;
    end process;

end architecture;



