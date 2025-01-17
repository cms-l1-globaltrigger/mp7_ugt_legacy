
-- Description:
-- Minimum bias UPC conditions

-- Version history:
-- HB 2025-01-13: new design for minimum bias UPC objects.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity min_bias_upc_conditions is
    generic(
        et_ge_mode : boolean := true;
        obj_type : natural := MBT0P_UPC_TYPE;
        count_threshold: std_logic_vector(MAX_MBHF_TEMPLATES_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        condition_o : out std_logic
    );
end min_bias_upc_conditions;

architecture rtl of min_bias_upc_conditions is

    signal comp_o : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    mbt0p_sel: if obj_type=4 generate
        comp_o <= '1' when (data_i(MBT0P_UPC_HIGH downto MBT0P_UPC_LOW) >= count_threshold(MBT0P_UPC_HIGH downto MBT0P_UPC_LOW)) and et_ge_mode else
                  '0';
    end generate mbt0hfp_sel;
    
    mbt0m_sel: if obj_type=5 generate
        comp_o <= '1' when (data_i(MBT0M_UPC_HIGH downto MBT0M_UPC_LOW) >= count_threshold(MBT0M_UPC_HIGH downto MBT0M_UPC_LOW)) and et_ge_mode else
                  '0';
    end generate mbt0hfp_sel;
    
    mbt1p_sel: if obj_type=6 generate
        comp_o <= '1' when (data_i(MBT1P_UPC_HIGH downto MBT1P_UPC_LOW) >= count_threshold(MBT1P_UPC_HIGH downto MBT1P_UPC_LOW)) and et_ge_mode else
                  '0';
    end generate mbt0hfp_sel;
    
    mbt1m_sel: if obj_type=7 generate
        comp_o <= '1' when (data_i(MBT1M_UPC_HIGH downto MBT1M_UPC_LOW) >= count_threshold(MBT1M_UPC_HIGH downto MBT1M_UPC_LOW)) and et_ge_mode else
                  '0';
    end generate mbt0hfp_sel;

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
