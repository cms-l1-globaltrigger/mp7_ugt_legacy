
-- Desription:
-- Condition module for esums object types (ett, etm, htt, htm, etmhf, htmhf) conditions.

-- Version history:
-- HB 2022-09-23: used "delay_pipeline" for condition output.
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New order in generic.
-- HB 2020-11-27: added default parameters. Changed order in generic.
-- HB 2020-01-31: redesign output pipeline
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;

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

    signal comp_o : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

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

-- Pipeline stages for condition output
    comp_v(0) <= comp_o;

    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => ESUMS_COND_STAGES
        )
        port map(
            clk, comp_v, comp_v_o
        );

    condition_o <= comp_v_o(0);

end architecture rtl;
