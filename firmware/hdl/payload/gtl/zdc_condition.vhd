
-- Description: ZDC condition

-- HB 2022-09-23: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity zdc_condition is
    generic	(
        et_ge_mode : boolean := true;
        threshold: std_logic_vector(MAX_ZDC_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_ZDC_BITS-1 downto 0);
        condition_o : out std_logic
    );
end zdc_condition;

architecture rtl of zdc_condition is

    signal comp : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    comp <= '1' when (data_i(ZDC_BIT_HIGH-ZDC_BIT_LOW-1 downto 0) >= threshold(ZDC_BIT_HIGH-ZDC_BIT_LOW-1 downto 0)) and et_ge_mode else
            '1' when (data_i(ZDC_BIT_HIGH-ZDC_BIT_LOW-1 downto 0) = threshold(ZDC_BIT_HIGH-ZDC_BIT_LOW-1 downto 0)) and not et_ge_mode else
            '0';

    comp_v(0) <= comp;

    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => ZDC_STAGES
        )
        port map(
            clk, comp_v, comp_v_o
        );

    condition_o <= comp_v_o(0);

end architecture rtl;
