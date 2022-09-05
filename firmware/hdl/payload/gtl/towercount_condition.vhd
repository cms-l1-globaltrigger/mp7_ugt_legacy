
-- Desription: TOWERCOUNT (ECAL sum) conditions

-- HB 2022-09-05: cleaned up.
-- HB 2016-10-11: first design.

library ieee;
use ieee.std_logic_1164.all;

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

    signal temp1, comp_o : std_logic;

begin

    comp_o <= '0' when data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) = ZERO(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) else
              '1' when (data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) >= count_threshold(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0)) and et_ge_mode else
              '1' when (data_i(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0) = count_threshold(TOWERCOUNT_COUNT_HIGH-TOWERCOUNT_COUNT_LOW-1 downto 0)) and not et_ge_mode else
              '0';

-- Pipeline stages for condition output - 2 stages.
    condition_o_pipeline: process(clk, comp_o)
    begin
        if (clk'event and clk = '1') then
            temp1 <= comp_o;
            condition_o <= temp1;
        end if;
    end process;

end architecture rtl;
