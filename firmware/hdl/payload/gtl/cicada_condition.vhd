
-- Description:
-- Comparator for CICADA (anomaly detection - 16 bits)

-- Version history:
-- HB 2023-12-13: updated names.
-- HB 2023-12-06: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity cicada_condition is
    generic	(
        ge_mode: boolean := true;
        cscore : std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0')
    );
    port(
        lhc_clk: in std_logic;
        cicada_i : in std_logic_vector(CICADA_BITS-1 downto 0) := (others => '0');
        c_comp_o : out std_logic
    );
end cicada_condition;

architecture rtl of cicada_condition is

    signal c_comp : std_logic := '0';
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    ad_p: process(cicada_i)
    begin
        if ge_mode then
            if cicada_i >= cscore(CICADA_BITS-1 downto 0) then
                c_comp <= '1';
            else
                c_comp <= '0';                
            end if;
        else
            if cicada_i = cscore(CICADA_BITS-1 downto 0)then
                c_comp <= '1';
            else
                c_comp <= '0';                
            end if;
        end if;
    end process;

    comp_v(0) <= c_comp;
    
    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => CICADA_COND_STAGES
        )
        port map(
            lhc_clk, comp_v, comp_v_o
        );

    c_comp_o <= comp_v_o(0);

end architecture rtl;
