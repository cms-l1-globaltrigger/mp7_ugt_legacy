
-- Desription:
-- Condition module for esums object types (ett, etm, htt, htm, etmhf, htmhf) conditions.

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New order in generic.
-- HB 2020-11-27: added default parameters. Changed order in generic.
-- HB 2020-01-31: redesign output pipeline
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity esums_conditions is
    generic	(
        et_ge_mode: boolean := true;
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows: natural := 0;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        obj_type: natural := ETT_TYPE
   );
    port(
        clk: in std_logic;
        data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        condition_o: out std_logic
    );
end esums_conditions;

architecture rtl of esums_conditions is
-- fixed pipeline structure, 2 stages total
--     constant conditions_pipeline_stages: natural := 2; -- pipeline stages for output signal of esums_conditions.vhd (0 => no flip-flop) 

    signal temp1, temp2 : std_logic;
    signal comp_o : std_logic;

begin
    
    esums_comparators_i: entity work.esums_comparators
    generic map(
        et_ge_mode => et_ge_mode,
        obj_type => obj_type,
        et_threshold => et_threshold,
        nr_phi_windows => nr_phi_windows,
        phi_w1_upper_limit => phi_w1_upper_limit,
        phi_w1_lower_limit => phi_w1_lower_limit,
        phi_w2_upper_limit => phi_w2_upper_limit,
        phi_w2_lower_limit => phi_w2_lower_limit	
    )
    port map(
        data_i => data_i,
        comp_o => comp_o
    );
    
-- Pipeline stages for condition output - 2 stages.
    condition_o_pipeline: process(clk, comp_o)
    begin
        if (clk'event and clk = '1') then
            temp1 <= comp_o;
            condition_o <= temp1;
        end if;
    end process;

end architecture rtl;
