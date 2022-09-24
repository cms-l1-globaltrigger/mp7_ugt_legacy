
-- Desription:
-- TOWERCOUNT (ECAL sum) conditions

-- Version history:
-- HB 2022-09-23: used "delay_pipeline" for condition output.
-- HB 2016-10-11: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity towercount_condition is
    generic	(
        et_ge_mode : boolean := true;
        count_threshold: std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        condition_o : out std_logic
    );
end towercount_condition;

architecture rtl of towercount_condition is

    constant ZERO : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0) := (others => '0');
-- fixed pipeline structure, 2 stages total
    constant conditions_pipeline_stages: natural := 2; -- pipeline stages for output signal of esums_conditions.vhd (0 => no flip-flop)

    signal comp_o : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

   comp_o <= '0' when data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) = ZERO(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) else
             '1' when (data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) >= count_threshold(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0)) and et_ge_mode else
             '1' when (data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) = count_threshold(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0)) and not et_ge_mode else
             '0';

-- Pipeline stages for condition output
    comp_v(0) <= comp_o;

    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => TC_COND_STAGES
        )
        port map(
            clk, comp_v, comp_v_o
        );

    condition_o <= comp_v_o(0);

end architecture rtl;
