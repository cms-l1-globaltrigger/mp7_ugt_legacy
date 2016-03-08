-- ext_cond sync
--
-- Synchronizes input with clk, if wanted.
--
-- Johannes Wittmann, April 2015

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity data_sync is
    generic
    (
        DATA_WIDTH            : integer := 64;
        USE_REGISTERED_OUTPUT : boolean := false
    );
    port(
        clk: in std_logic; -- sync clk
        rst: in std_logic;
        data_in: in  std_logic_vector(DATA_WIDTH-1 downto 0); -- inputs
        data_out: out  std_logic_vector(DATA_WIDTH-1 downto 0) -- outputs
    );

end data_sync;

architecture rtl of data_sync is

constant RST_ACT: std_logic := '1';

begin

    GEN_ADDITIONAL_OUTPUT_REGISTER : if USE_REGISTERED_OUTPUT = true generate
        sync_clk : process (clk, rst)
        begin
            if rst = RST_ACT then
                data_out <= (others => '0');
            elsif rising_edge(clk) then
                data_out <= data_in;
            end if;
        end process;
    end generate;

    DONT_GEN_ADDITIONAL_OUTPUT_REGISTER : if USE_REGISTERED_OUTPUT = false generate
        data_out <= data_in;
    end generate;


end architecture;