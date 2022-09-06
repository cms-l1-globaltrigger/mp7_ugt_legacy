
-- Desription:
-- Comparators fro esums

-- Version history:
-- HB 2022-09-06: cleaned up.
-- HB 2021-05-18: changed slice parameter.
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New logic.
-- HB 2020-01-30: removed "no_esums"
-- HB 2018-08-09: updated for "htmhf" and "Asymmetry"
-- HB 2015-06-29: updated for "ettem" and "etmhf"
-- HB 2015-12-09: removed clk - not needed
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity esums_comparators is
    generic	(
        et_ge_mode : boolean;
        obj_type : natural := ETT_TYPE; -- ett=0, htt=1, etm=2, htm=3
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        nr_phi_windows : natural;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
   );
    port(
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        comp_o : out std_logic
    );
end esums_comparators;

architecture rtl of esums_comparators is

    signal et_data : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal phi_data : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');

    signal et_comp : std_logic;
    signal phi_comp : std_logic := '0';

begin

    ett_sel: if obj_type=ETT_TYPE generate
        et_data(ETT_ET_HIGH-ETT_ET_LOW downto 0) <= data_i(ETT_ET_HIGH downto ETT_ET_LOW);
        comp_o <= et_comp;
    end generate ett_sel;

    htt_sel: if obj_type=HTT_TYPE generate
        et_data(HTT_ET_HIGH-HTT_ET_LOW downto 0) <= data_i(HTT_ET_HIGH downto HTT_ET_LOW);
        comp_o <= et_comp;
    end generate htt_sel;

    ettem_sel: if obj_type=ETTEM_TYPE generate
        et_data(ETTEM_ET_HIGH-ETTEM_ET_LOW downto 0) <= data_i(ETTEM_ET_HIGH downto ETTEM_ET_LOW);
        comp_o <= et_comp;
    end generate ettem_sel;

    etm_sel: if obj_type=ETM_TYPE generate
        et_data(ETM_ET_HIGH-ETM_ET_LOW downto 0) <= data_i(ETM_ET_HIGH downto ETM_ET_LOW);
        phi_data(ETM_PHI_HIGH-ETM_PHI_LOW downto 0) <= data_i(ETM_PHI_HIGH downto ETM_PHI_LOW);
        comp_o <= et_comp and phi_comp;
    end generate etm_sel;

    htm_sel: if obj_type=HTM_TYPE generate
        et_data(HTM_ET_HIGH-HTM_ET_LOW downto 0) <= data_i(HTM_ET_HIGH downto HTM_ET_LOW);
        phi_data(HTM_PHI_HIGH-HTM_PHI_LOW downto 0) <= data_i(HTM_PHI_HIGH downto HTM_PHI_LOW);
        comp_o <= et_comp and phi_comp;
    end generate htm_sel;

    etmhf_sel: if obj_type=ETMHF_TYPE generate
        et_data(ETMHF_ET_HIGH-ETMHF_ET_LOW downto 0) <= data_i(ETMHF_ET_HIGH downto ETMHF_ET_LOW);
        phi_data(ETMHF_PHI_HIGH-ETMHF_PHI_LOW downto 0) <= data_i(ETMHF_PHI_HIGH downto ETMHF_PHI_LOW);
        comp_o <= et_comp and phi_comp;
    end generate etmhf_sel;

    htmhf_sel: if obj_type=HTMHF_TYPE generate
        et_data(HTMHF_ET_HIGH-HTMHF_ET_LOW downto 0) <= data_i(HTMHF_ET_HIGH downto HTMHF_ET_LOW);
        phi_data(HTMHF_PHI_HIGH-HTMHF_PHI_LOW downto 0) <= data_i(HTMHF_PHI_HIGH downto HTMHF_PHI_LOW);
        comp_o <= et_comp and phi_comp;
    end generate htmhf_sel;

    asymet_sel: if obj_type=ASYMET_TYPE generate
        et_data(ASYMET_HIGH-ASYMET_LOW downto 0) <= data_i(ASYMET_HIGH downto ASYMET_LOW);
        comp_o <= et_comp;
    end generate asymet_sel;

    asymht_sel: if obj_type=ASYMHT_TYPE generate
        et_data(ASYMHT_HIGH-ASYMHT_LOW downto 0) <= data_i(ASYMHT_HIGH downto ASYMHT_LOW);
        comp_o <= et_comp;
    end generate asymht_sel;

    asymethf_sel: if obj_type=ASYMETHF_TYPE generate
        et_data(ASYMETHF_HIGH-ASYMETHF_LOW downto 0) <= data_i(ASYMETHF_HIGH downto ASYMETHF_LOW);
        comp_o <= et_comp;
    end generate asymethf_sel;

    asymhthf_sel: if obj_type=ASYMHTHF_TYPE generate
        et_data(ASYMHTHF_HIGH-ASYMHTHF_LOW downto 0) <= data_i(ASYMHTHF_HIGH downto ASYMHTHF_LOW);
        comp_o <= et_comp;
    end generate asymhthf_sel;

-- Comparator for energy (et)
    et_comp <= '1' when (et_data >= et_threshold) and et_ge_mode else
               '1' when (et_data = et_threshold) and not et_ge_mode else '0';

    phi_windows_sel: if obj_type=ETM_TYPE or obj_type=HTM_TYPE or obj_type=ETMHF_TYPE or obj_type=HTMHF_TYPE generate
-- Phi windows comparator
        phi_windows_comp_i: entity work.phi_windows_comp
            generic map(
                nr_phi_windows => nr_phi_windows,
                phi_w1_upper_limit => phi_w1_upper_limit,
                phi_w1_lower_limit => phi_w1_lower_limit,
                phi_w2_upper_limit => phi_w2_upper_limit,
                phi_w2_lower_limit => phi_w2_lower_limit
            )
            port map(
                phi => phi_data,
                phi_comp_o => phi_comp
            );

    end generate phi_windows_sel;
end architecture rtl;
