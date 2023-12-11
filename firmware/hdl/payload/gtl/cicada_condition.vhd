
-- Description:
-- Comparator for cicada Anomaly Detection (16 bits)

-- Version history:
-- HB 2023-12-06: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity cicada_condition is
    generic	(
        ge_mode: boolean := true;
        ad_thr : std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0')
    );
    port(
        lhc_clk: in std_logic;
        ad_i : in std_logic_vector(AD_BITS-1 downto 0) := (others => '0');
        ad_comp_o : out std_logic
    );
end cicada_condition;

architecture rtl of cicada_ad_hi_condition is

    signal ad_comp : std_logic := '0';
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    ad_p: process(ad_int_i, ad_dec_i)
    begin
        if ge_mode then
            if ad_i >= ad_thr(AD_BITS-1 downto 0) then
                ad_comp <= '1';
            else
                ad_comp <= '0';                
            end if;
        else
            if ad_i = ad_thr(AD_BITS-1 downto 0)then
                ad_comp <= '1';
            else
                ad_comp <= '0';                
            end if;
        end if;
    end process;

    comp_v <= ad_comp;
    
    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => CICADA_COND_STAGES
        )
        port map(
            lhc_clk, comp_v, comp_v_o
        );

    ad_comp_o <= comp_v_o(0);

end architecture rtl;
