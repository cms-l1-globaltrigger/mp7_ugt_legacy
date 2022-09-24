
-- Description:
-- Minimum bias Hf conditions

-- Version history:
-- HB 2022-09-23: used "delay_pipeline" for condition output.
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

    signal comp_o : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    mbt0hfp_sel: if obj_type=0 generate
        comp_o <= '1' when (data_i(MBT0HFP_COUNT_HIGH downto MBT0HFP_COUNT_LOW) >= count_threshold) and et_ge_mode else
                  '1' when (data_i(MBT0HFP_COUNT_HIGH downto MBT0HFP_COUNT_LOW) = count_threshold) and not et_ge_mode else
                  '0';
    end generate mbt0hfp_sel;

    mbt0hfm_sel: if obj_type=1 generate
        comp_o <= '1' when (data_i(MBT0HFM_COUNT_HIGH downto MBT0HFM_COUNT_LOW) >= count_threshold) and et_ge_mode else
                  '1' when (data_i(MBT0HFM_COUNT_HIGH downto MBT0HFM_COUNT_LOW) = count_threshold) and not et_ge_mode else
                  '0';
    end generate mbt0hfm_sel;

    mbt1hfp_sel: if obj_type=2 generate
        comp_o <= '1' when (data_i(MBT1HFP_COUNT_HIGH downto MBT1HFP_COUNT_LOW) >= count_threshold) and et_ge_mode else
                  '1' when (data_i(MBT1HFP_COUNT_HIGH downto MBT1HFP_COUNT_LOW) = count_threshold) and not et_ge_mode else
                  '0';
    end generate mbt1hfp_sel;

    mbt1hfm_sel: if obj_type=3 generate
        comp_o <= '1' when (data_i(MBT1HFM_COUNT_HIGH downto MBT1HFM_COUNT_LOW) >= count_threshold) and et_ge_mode else
                  '1' when (data_i(MBT1HFM_COUNT_HIGH downto MBT1HFM_COUNT_LOW) = count_threshold) and not et_ge_mode else
                  '0';
    end generate mbt1hfm_sel;

-- Pipeline stages for condition output
    comp_v(0) <= comp_o;

    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => MB_COND_STAGES
        )
        port map(
            clk, comp_v, comp_v_o
        );

    condition_o <= comp_v_o(0);

end architecture rtl;
