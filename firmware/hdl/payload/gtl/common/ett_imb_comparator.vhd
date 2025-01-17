
-- Description:
-- Comparator for ETT imbalance

-- Version history:
-- HB 2025-01-13: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gtl_pkg.all;

entity ett_imb_comparator is
    generic	(
        sim_mode : boolean;
        et_ge_mode : boolean;
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
    );
    port(
        clk : in std_logic;
        ett_pos : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ett_neg : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        comp_o : out std_logic
    );
end ett_imb_comparator;

architecture rtl of ett_imb_comparator is

    constant inv_ett_tot_comma_digits : integer : 8;
    constant inv_ett_tot_max_value_len : integer : 24; -- (10**8) = 0x5F5E100
    constant factor : std_logic_vector : std_logic_vector(to_unsigned((10**inv_ett_tot_comma_digits),inv_ett_tot_max_value_len);
    constant thresold_i : std_logic_vector(ETT_POS_ET_BITS+inv_ett_tot_max_value_len-1 downto 0) : et_threshold(ETT_POS_ET_BITS-1 downto 0) * factor; 
    signal ett_pos_i : std_logic_vector(ETT_POS_ET_BITS-1 downto 0) := (others => '0');
    signal ett_neg_i : std_logic_vector(ETT_NEG_ET_BITS-1 downto 0) := (others => '0');
    signal ett_minus, ett_minus_d : std_logic_vector(ETT_POS_ET_BITS-1 downto 0) := (others => '0');
    signal ett_total, ett_total_d : std_logic_vector(ETT_POS_ET_BITS downto 0) := (others => '0');
    signal inv_ett_tot_lut_value : std_logic_vector(inv_ett_tot_max_value_len-1 downto 0) := (others => '0');
    signal imb : std_logic_vector(ETT_POS_ET_BITS+inv_ett_tot_max_value_len downto 0) := (others => '0');
    signal comp : std_logic;
    
begin
   
    ett_minus <= ett_pos_i - ett_neg_i;
    ett_total <= ett_pos_i + ett_neg_i;
    
    ett_minus_reg_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => ETT_POS_ET_BITS,
        STAGES => 1
    )
    port map(
        clk, ett_minus, ett_minus_d
    );

    ett_total_reg_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => ETT_POS_ET_BITS+1,
        STAGES => 1
    )
    port map(
        clk, ett_total, ett_total_d
    );

    inv_ett_tot_lut_value <= CONV_STD_LOGIC_VECTOR(INV_ETT_TOT_LUT(CONV_INTEGER(ett_total_d));   
    imb <= ett_minus_d * inv_ett_tot_lut_value;
    comp <= '1' when (imb >= thresold_i) else '0';

    out_reg_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => 1,
        STAGES => 1
    )
    port map(
        clk, comp, comp_o
    );

    --------------------------------------------------------------------------------------------
    sim_sel: if sim_mode == true generate
        ett_pos_reg_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => ETT_POS_ET_BITS,
                STAGES => 1
            )
            port map(
                clk, ett_pos(ETT_POS_ET_BITS-1  downto 0), ett_pos_i
            );
            
        ett_neg_reg_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => MAX_ESUMS_BITS,
                STAGES => 1
            )
            port map(
                clk, ett_neg(ETT_NEG_ET_BITS-1  downto 0), ett_neg_i
            );
    end generate sim_sel;

    synth_sel: if sim_mode == false generate
        ett_pos_i <= ett_pos(ETT_POS_ET_BITS-1  downto 0);
        ett_neg_i <= ett_neg(ETT_NEG_ET_BITS-1  downto 0);
    end generate synth_sel;

end architecture rtl;
