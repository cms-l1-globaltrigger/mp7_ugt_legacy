
-- Desription:
-- Comparators for pseudorapidity

-- Version history:
-- HB 2019-06-04: extended to "five eta cuts".

library ieee;
use ieee.std_logic_1164.all;

entity eta_windows_comp is
    generic	(
        nr_eta_windows : natural;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        eta_w3_upper_limit : std_logic_vector;
        eta_w3_lower_limit : std_logic_vector;
        eta_w4_upper_limit : std_logic_vector;
        eta_w4_lower_limit : std_logic_vector;
        eta_w5_upper_limit : std_logic_vector;
        eta_w5_lower_limit : std_logic_vector
    );
    port(
        eta : in std_logic_vector;
        eta_comp_o : out std_logic
    );
end eta_windows_comp;

architecture rtl of eta_windows_comp is
    signal eta_comp_w1 : std_logic := '0';
    signal eta_comp_w2 : std_logic := '0';
    signal eta_comp_w3 : std_logic := '0';
    signal eta_comp_w4 : std_logic := '0';
    signal eta_comp_w5 : std_logic := '0';
begin

-- HB 2017-12-19: nr_eta_windows has to be between 0 and 5 (0 means no eta window required, 1 to 5 are numbers of required windows)
    assert (nr_eta_windows >= 0 and nr_eta_windows <= 5) report 
        "wrong number of eta windows (has to be between 0 and 5) - nr_eta_windows=" & integer'image(nr_eta_windows)
    severity failure;

    no_eta_window_i: if nr_eta_windows = 0 generate
        eta_comp_o <= '1';
    end generate no_eta_window_i;

    eta_w1_sel_i: if nr_eta_windows >= 1 and nr_eta_windows <= 5 generate
        eta_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w1_upper_limit,
                eta_lower_limit => eta_w1_lower_limit
            )    
            port map( 
                eta => eta,
                eta_comp => eta_comp_w1
            );
        eta_comp_o <= eta_comp_w1 or eta_comp_w2 or eta_comp_w3 or eta_comp_w4 or eta_comp_w5;
    end generate eta_w1_sel_i;

    eta_w2_sel_i: if nr_eta_windows >= 2 and nr_eta_windows <= 5 generate
        eta_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w2_upper_limit,
                eta_lower_limit => eta_w2_lower_limit
            )    
            port map( 
                eta => eta,
                eta_comp => eta_comp_w2
            );
    end generate eta_w2_sel_i;

    eta_w3_sel_i: if nr_eta_windows >= 3 and nr_eta_windows <= 5 generate
        eta_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w3_upper_limit,
                eta_lower_limit => eta_w3_lower_limit
            )    
            port map( 
                eta => eta,
                eta_comp => eta_comp_w3
            );
    end generate eta_w3_sel_i;

    eta_w4_sel_i: if nr_eta_windows >= 4 and nr_eta_windows <= 5 generate
        eta_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w4_upper_limit,
                eta_lower_limit => eta_w4_lower_limit
            )    
            port map( 
                eta => eta,
                eta_comp => eta_comp_w4
            );
    end generate eta_w4_sel_i;

    eta_w5_sel_i: if nr_eta_windows = 5 generate
        eta_comp_i: entity work.eta_comp_signed
            generic map(
                eta_upper_limit => eta_w5_upper_limit,
                eta_lower_limit => eta_w5_lower_limit
            )    
            port map( 
                eta => eta,
                eta_comp => eta_comp_w5
            );
    end generate eta_w5_sel_i;

end architecture rtl;
