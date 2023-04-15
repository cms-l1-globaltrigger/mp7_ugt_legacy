
-- Description:
-- Comparators for muon index bits

-- Version history:
-- HB 2023-04-15: first design.

library ieee;
use ieee.std_logic_1164.all;

entity muon_index_windows_comp is
    generic	(
        nr_idx_windows : natural;
        idx_w1_upper_limit : std_logic_vector;
        idx_w1_lower_limit : std_logic_vector;
        idx_w2_upper_limit : std_logic_vector;
        idx_w2_lower_limit : std_logic_vector;
        idx_w3_upper_limit : std_logic_vector;
        idx_w3_lower_limit : std_logic_vector;
        idx_w4_upper_limit : std_logic_vector;
        idx_w4_lower_limit : std_logic_vector;
        idx_w5_upper_limit : std_logic_vector;
        idx_w5_lower_limit : std_logic_vector
    );
    port(
        idx : in std_logic_vector;
        idx_comp_o : out std_logic
    );
end muon_index_windows_comp;

architecture rtl of muon_index_windows_comp is
    signal idx_comp_w1 : std_logic := '0';
    signal idx_comp_w2 : std_logic := '0';
    signal idx_comp_w3 : std_logic := '0';
    signal idx_comp_w4 : std_logic := '0';
    signal idx_comp_w5 : std_logic := '0';
begin

-- HB 2017-12-19: nr_idx_windows has to be between 0 and 5 (0 means no idx window required, 1 to 5 are numbers of required windows)
    assert (nr_idx_windows >= 0 and nr_idx_windows <= 5) report
        "wrong number of idx windows (has to be between 0 and 5) - nr_idx_windows=" & integer'image(nr_idx_windows)
    severity failure;

    no_idx_window_i: if nr_idx_windows = 0 generate
        idx_comp_o <= '1';
    end generate no_idx_window_i;

    idx_w1_sel_i: if nr_idx_windows >= 1 and nr_idx_windows <= 5 generate
        idx_comp_i: entity work.muon_index_comp
            generic map(
                idx_upper_limit => idx_w1_upper_limit,
                idx_lower_limit => idx_w1_lower_limit
            )
            port map(
                idx => idx,
                idx_comp => idx_comp_w1
            );
        idx_comp_o <= idx_comp_w1 or idx_comp_w2 or idx_comp_w3 or idx_comp_w4 or idx_comp_w5;
    end generate idx_w1_sel_i;

    idx_w2_sel_i: if nr_idx_windows >= 2 and nr_idx_windows <= 5 generate
        idx_comp_i: entity work.muon_index_comp
            generic map(
                idx_upper_limit => idx_w2_upper_limit,
                idx_lower_limit => idx_w2_lower_limit
            )
            port map(
                idx => idx,
                idx_comp => idx_comp_w2
            );
    end generate idx_w2_sel_i;

    idx_w3_sel_i: if nr_idx_windows >= 3 and nr_idx_windows <= 5 generate
        idx_comp_i: entity work.muon_index_comp
            generic map(
                idx_upper_limit => idx_w3_upper_limit,
                idx_lower_limit => idx_w3_lower_limit
            )
            port map(
                idx => idx,
                idx_comp => idx_comp_w3
            );
    end generate idx_w3_sel_i;

    idx_w4_sel_i: if nr_idx_windows >= 4 and nr_idx_windows <= 5 generate
        idx_comp_i: entity work.muon_index_comp
            generic map(
                idx_upper_limit => idx_w4_upper_limit,
                idx_lower_limit => idx_w4_lower_limit
            )
            port map(
                idx => idx,
                idx_comp => idx_comp_w4
            );
    end generate idx_w4_sel_i;

    idx_w5_sel_i: if nr_idx_windows = 5 generate
        idx_comp_i: entity work.muon_index_comp
            generic map(
                idx_upper_limit => idx_w5_upper_limit,
                idx_lower_limit => idx_w5_lower_limit
            )
            port map(
                idx => idx,
                idx_comp => idx_comp_w5
            );
    end generate idx_w5_sel_i;

end architecture rtl;
