
-- Description:
-- Comparator for ETT imbalance

-- Version history:
-- HB 2025-01-13: first design.

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.CONV_INTEGER;

use work.gtl_pkg.all;
use work.gtl_luts_pkg.all;

entity ett_imb_comparator is
    generic	(
        sim_mode : boolean;
        et_ge_mode : boolean;
        et_threshold: real
    );
    port(
        clk : in std_logic;
        ett_pos : in std_logic_vector(ETT_POS_ET_BITS-1 downto 0);
        ett_neg : in std_logic_vector(ETT_NEG_ET_BITS-1 downto 0);
        comp_o : out std_logic
    );
end ett_imb_comparator;

architecture rtl of ett_imb_comparator is

    constant inv_ett_tot_comma_digits : integer := 8;
    constant factor : real := 100000000.0;
    constant inv_ett_tot_max_value_len : integer := 28; -- (10**8) = 0x5F5E100
    signal thresold_i : std_logic_vector(ETT_POS_ET_BITS+inv_ett_tot_max_value_len-1 downto 0) := (others => '0'); 
    signal ett_pos_i : std_logic_vector(ETT_POS_ET_BITS-1 downto 0) := (others => '0');
    signal ett_neg_i : std_logic_vector(ETT_NEG_ET_BITS-1 downto 0) := (others => '0');
    signal ett_minus, ett_minus_d : std_logic_vector(ETT_POS_ET_BITS-1 downto 0) := (others => '0');
    signal ett_total, ett_total_d : std_logic_vector(ETT_POS_ET_BITS-1 downto 0) := (others => '0');
    signal inv_ett_tot_lut_value : std_logic_vector(inv_ett_tot_max_value_len-1 downto 0) := (others => '0');
    signal imb : std_logic_vector(ETT_POS_ET_BITS+inv_ett_tot_max_value_len-1 downto 0) := (others => '0');
    signal comp, comp_d : std_logic_vector(0 downto 0);
    
begin
   
    thresold_i <= CONV_STD_LOGIC_VECTOR(integer(et_threshold * factor),inv_ett_tot_max_value_len+ETT_POS_ET_BITS); 
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
        DATA_WIDTH => ETT_POS_ET_BITS,
        STAGES => 1
    )
    port map(
        clk, ett_total, ett_total_d
    );

    inv_ett_tot_lut_value <= CONV_STD_LOGIC_VECTOR(INV_ETT_TOT_LUT(CONV_INTEGER(ett_total_d)),inv_ett_tot_max_value_len);   
    imb <= ett_minus_d * inv_ett_tot_lut_value;
    comp(0) <= '1' when (imb >= thresold_i) else '0';

    out_reg_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => 1,
        STAGES => 1
    )
    port map(
        clk, comp, comp_d
    );

    comp_o <= comp_d(0);

    --------------------------------------------------------------------------------------------
    sim_sel: if sim_mode = true generate
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
                DATA_WIDTH => ETT_NEG_ET_BITS,
                STAGES => 1
            )
            port map(
                clk, ett_neg(ETT_NEG_ET_BITS-1  downto 0), ett_neg_i
            );
    end generate sim_sel;

    synth_sel: if sim_mode = false generate
        ett_pos_i <= ett_pos(ETT_POS_ET_BITS-1  downto 0);
        ett_neg_i <= ett_neg(ETT_NEG_ET_BITS-1  downto 0);
    end generate synth_sel;

end architecture rtl;
