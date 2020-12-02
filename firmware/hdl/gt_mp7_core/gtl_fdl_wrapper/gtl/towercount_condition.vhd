
-- Desription: TOWERCOUNT (ECAL sum) conditions

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

begin

   comp_o <= '0' when data_i(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0) = ZERO(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0) else
	     '1' when (data_i(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0) >= count_threshold(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0)) and et_ge_mode else            
             '1' when (data_i(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0) = count_threshold(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low-1 downto 0)) and not et_ge_mode else
             '0';            
    
-- Pipeline stages for condition output.
    condition_o_pipeline: process(clk, comp_o)
	variable pipeline_temp : std_logic_vector(0 to conditions_pipeline_stages+1) := (others => '0');
    begin
        pipeline_temp(conditions_pipeline_stages+1) := comp_o;
        if (conditions_pipeline_stages > 0) then 
            if (clk'event and (clk = '1') ) then
                pipeline_temp(0 to conditions_pipeline_stages) := pipeline_temp(1 to conditions_pipeline_stages+1);
            end if;
        end if;
        condition_o <= pipeline_temp(1); -- used pipeline_temp(1) instead of pipeline_temp(0), to prevent warnings in compilation
    end process;

end architecture rtl;
