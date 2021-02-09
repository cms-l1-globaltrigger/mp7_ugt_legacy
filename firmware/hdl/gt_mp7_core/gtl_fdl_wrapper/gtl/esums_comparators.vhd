
-- Desription:
-- Comparators fro esums

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New logic.
-- HB 2020-01-30: removed "no_esums"
-- HB 2018-08-09: updated for "htmhf" and "Asymmetry"
-- HB 2015-06-29: updated for "ettem" and "etmhf"
-- HB 2015-12-09: removed clk - not needed
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

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
        et_data(D_S_I_ETT.et_high-D_S_I_ETT.et_low downto 0) <= data_i(D_S_I_ETT.et_high downto D_S_I_ETT.et_low);
        comp_o <= et_comp;   
    end generate ett_sel;
    
    htt_sel: if obj_type=HTT_TYPE generate
        et_data(D_S_I_HTT.et_high-D_S_I_HTT.et_low downto 0) <= data_i(D_S_I_HTT.et_high downto D_S_I_HTT.et_low);
        comp_o <= et_comp;   
    end generate htt_sel;
    
    ettem_sel: if obj_type=ETTEM_TYPE generate
        et_data(D_S_I_ETTEM.et_high-D_S_I_ETTEM.et_low downto 0) <= data_i(D_S_I_ETTEM.et_high downto D_S_I_ETTEM.et_low);
        comp_o <= et_comp;   
    end generate ettem_sel;
    
    etm_sel: if obj_type=ETM_TYPE generate
        et_data(D_S_I_ETM.et_high-D_S_I_ETM.et_low downto 0) <= data_i(D_S_I_ETM.et_high downto D_S_I_ETM.et_low);
        phi_data(D_S_I_ETM.phi_high-D_S_I_ETM.phi_low downto 0) <= data_i(D_S_I_ETM.phi_high downto D_S_I_ETM.phi_low);
        comp_o <= et_comp and phi_comp;   
    end generate etm_sel;
    
    htm_sel: if obj_type=HTM_TYPE generate
        et_data(D_S_I_HTM.et_high-D_S_I_HTM.et_low downto 0) <= data_i(D_S_I_HTM.et_high downto D_S_I_HTM.et_low);
        phi_data(D_S_I_HTM.phi_high-D_S_I_HTM.phi_low downto 0) <= data_i(D_S_I_HTM.phi_high downto D_S_I_HTM.phi_low);
        comp_o <= et_comp and phi_comp;   
    end generate htm_sel;
    
    etmhf_sel: if obj_type=ETMHF_TYPE generate
        et_data(D_S_I_ETMHF.et_high-D_S_I_ETMHF.et_low downto 0) <= data_i(D_S_I_ETMHF.et_high downto D_S_I_ETMHF.et_low);
        phi_data(D_S_I_ETMHF.phi_high-D_S_I_ETMHF.phi_low downto 0) <= data_i(D_S_I_ETMHF.phi_high downto D_S_I_ETMHF.phi_low);
        comp_o <= et_comp and phi_comp;   
    end generate etmhf_sel;
    
    htmhf_sel: if obj_type=HTMHF_TYPE generate
        et_data(D_S_I_HTMHF.et_high-D_S_I_HTMHF.et_low downto 0) <= data_i(D_S_I_HTMHF.et_high downto D_S_I_HTMHF.et_low);
        phi_data(D_S_I_HTMHF.phi_high-D_S_I_HTMHF.phi_low downto 0) <= data_i(D_S_I_HTMHF.phi_high downto D_S_I_HTMHF.phi_low);
        comp_o <= et_comp and phi_comp;   
    end generate htmhf_sel;
    
    asymet_sel: if obj_type=ASYMET_TYPE generate
        et_data(D_S_I_ASYMET.high-D_S_I_ASYMET.low-1 downto 0) <= data_i(D_S_I_ASYMET.high downto D_S_I_ASYMET.low);
        comp_o <= et_comp;   
    end generate asymet_sel;

    asymht_sel: if obj_type=ASYMHT_TYPE generate
        et_data(D_S_I_ASYMHT.high-D_S_I_ASYMHT.low-1 downto 0) <= data_i(D_S_I_ASYMHT.high downto D_S_I_ASYMHT.low);
        comp_o <= et_comp;   
    end generate asymht_sel;

    asymethf_sel: if obj_type=ASYMETHF_TYPE generate
        et_data(D_S_I_ASYMETHF.high-D_S_I_ASYMETHF.low-1 downto 0) <= data_i(D_S_I_ASYMETHF.high downto D_S_I_ASYMETHF.low);
        comp_o <= et_comp;   
    end generate asymethf_sel;

    asymhthf_sel: if obj_type=ASYMHTHF_TYPE generate
        et_data(D_S_I_ASYMHTHF.high-D_S_I_ASYMHTHF.low-1 downto 0) <= data_i(D_S_I_ASYMHTHF.high downto D_S_I_ASYMHTHF.low);
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
