-- Description:
-- Delay pipelines.

-- Version history:
-- HB 2019-06-28: Updated comments.
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity delay_pipeline is
    generic(
        DATA_WIDTH : positive;
        STAGES : natural
    );
    port(
        clk : in std_logic;
        in_data: in std_logic_vector(DATA_WIDTH-1 downto 0);
        out_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end delay_pipeline;

architecture rtl of delay_pipeline is

begin

    pipe_p: process(clk, in_data)
        type pipe_array is array (0 to STAGES+1) of std_logic_vector(DATA_WIDTH-1 downto 0);
        variable in_tmp : pipe_array := (others => (others => '0'));
        begin
            in_tmp(STAGES+1) := in_data;
            if (STAGES > 0) then
                if (clk'event and (clk = '1') ) then
                    in_tmp(0 to STAGES) := in_tmp(1 to STAGES+1);
                end if;
            else
                in_tmp(1) := in_data; -- no register
            end if;
            out_data <= in_tmp(1); -- used in_tmp(1) instead of in_tmp(0), to prevent warnings in compilation
    end process;

end architecture rtl;
