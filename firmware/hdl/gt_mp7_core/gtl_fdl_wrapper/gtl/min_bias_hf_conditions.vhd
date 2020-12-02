
-- Description: minimum bias Hf conditions

-- HB 2020-01-31: redesign output pipeline
-- HB 2020-01-30: removed data_i compare with "ZERO".
-- HB 2016-04-26: updated minimum bias Hf types to same notation as in grammar.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity min_bias_hf_conditions is
    generic(
        et_ge_mode : boolean := true;
        obj_type : natural := MBT0HFP_TYPE;
        count_threshold: std_logic_vector(MAX_MBHF_TEMPLATES_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        condition_o : out std_logic
    );
end min_bias_hf_conditions;

architecture rtl of min_bias_hf_conditions is

--     constant ZERO : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
-- fixed pipeline structure, 2 stages total
--     constant conditions_pipeline_stages: natural := 2; -- pipeline stages for output signal of esums_conditions.vhd (0 => no flip-flop) 

    signal temp1, temp2 : std_logic;
    signal comp_o : std_logic;

begin

    mbt0hfp_sel: if obj_type=0 generate
        comp_o <= '1' when (data_i(D_S_I_MBT0HFP_V2.count_high downto D_S_I_MBT0HFP_V2.count_low) >= count_threshold) and et_ge_mode else            
                  '1' when (data_i(D_S_I_MBT0HFP_V2.count_high downto D_S_I_MBT0HFP_V2.count_low) = count_threshold) and not et_ge_mode else
                  '0';            
    end generate mbt0hfp_sel;
    
    mbt0hfm_sel: if obj_type=1 generate
        comp_o <= '1' when (data_i(D_S_I_MBT0HFM_V2.count_high downto D_S_I_MBT0HFM_V2.count_low) >= count_threshold) and et_ge_mode else            
                  '1' when (data_i(D_S_I_MBT0HFM_V2.count_high downto D_S_I_MBT0HFM_V2.count_low) = count_threshold) and not et_ge_mode else
                  '0';            
    end generate mbt0hfm_sel;
    
    mbt1hfp_sel: if obj_type=2 generate
        comp_o <= '1' when (data_i(D_S_I_MBT1HFP_V2.count_high downto D_S_I_MBT1HFP_V2.count_low) >= count_threshold) and et_ge_mode else            
                  '1' when (data_i(D_S_I_MBT1HFP_V2.count_high downto D_S_I_MBT1HFP_V2.count_low) = count_threshold) and not et_ge_mode else
                  '0';            
    end generate mbt1hfp_sel;
    
    mbt1hfm_sel: if obj_type=3 generate
        comp_o <= '1' when (data_i(D_S_I_MBT1HFM_V2.count_high downto D_S_I_MBT1HFM_V2.count_low) >= count_threshold) and et_ge_mode else            
                  '1' when (data_i(D_S_I_MBT1HFM_V2.count_high downto D_S_I_MBT1HFM_V2.count_low) = count_threshold) and not et_ge_mode else
                  '0';            
    end generate mbt1hfm_sel;
    
-- This code did not work correctly (no minbias conditions in implementation) with Vivado versions 2018.3 and higher !!!
-- -- Pipeline stages for condition output.
--     condition_o_pipeline: process(clk, comp_o)
--         variable pipeline_temp : std_logic_vector(0 to conditions_pipeline_stages+1) := (others => '0');
--     begin
--         pipeline_temp(conditions_pipeline_stages+1) := comp_o;
--         if (conditions_pipeline_stages > 0) then 
--             if (clk'event and (clk = '1') ) then
--                 pipeline_temp(0 to conditions_pipeline_stages) := pipeline_temp(1 to conditions_pipeline_stages+1);
--             end if;
--         end if;
--         condition_o <= pipeline_temp(1); -- used pipeline_temp(1) instead of pipeline_temp(0), to prevent warnings in compilation
--     end process;

-- Pipeline stages for condition output - 2 stages.
    condition_o_pipeline: process(clk, comp_o)
    begin
        if (clk'event and clk = '1') then
            temp1 <= comp_o;
            condition_o <= temp1;
        end if;
    end process;

end architecture rtl;
