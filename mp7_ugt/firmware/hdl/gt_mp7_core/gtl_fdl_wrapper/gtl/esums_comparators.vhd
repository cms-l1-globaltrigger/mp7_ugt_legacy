
-- Desription:
-- Comparators fro esums

-- Version history:
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
        phi_full_range : boolean;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore : boolean;
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
   );
    port(
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        comp_o : out std_logic
    );
end esums_comparators;

architecture rtl of esums_comparators is

    constant ZERO : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');

    signal et_ett : std_logic_vector(D_S_I_ETT.et_high-D_S_I_ETT.et_low downto 0);

    signal et_etm : std_logic_vector(D_S_I_ETM.et_high-D_S_I_ETM.et_low downto 0);
    signal phi_etm : std_logic_vector(D_S_I_ETM.phi_high-D_S_I_ETM.phi_low downto 0);

    signal et_htt : std_logic_vector(D_S_I_HTT.et_high-D_S_I_HTT.et_low downto 0);

    signal et_htm : std_logic_vector(D_S_I_HTM.et_high-D_S_I_HTM.et_low downto 0);
    signal phi_htm : std_logic_vector(D_S_I_HTM.phi_high-D_S_I_HTM.phi_low downto 0);

-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
    signal et_ettem : std_logic_vector(D_S_I_ETTEM.et_high-D_S_I_ETTEM.et_low downto 0);

    signal et_etmhf : std_logic_vector(D_S_I_ETMHF.et_high-D_S_I_ETMHF.et_low downto 0);
    signal phi_etmhf : std_logic_vector(D_S_I_ETMHF.phi_high-D_S_I_ETMHF.phi_low downto 0);

-- HB 2018-08-09: inserted new esums quantities (Asymmetry and HTMHF).
    signal et_htmhf : std_logic_vector(D_S_I_HTMHF.et_high-D_S_I_HTMHF.et_low downto 0);
    signal phi_htmhf : std_logic_vector(D_S_I_HTMHF.phi_high-D_S_I_HTMHF.phi_low downto 0);

    signal et_asymet : std_logic_vector(D_S_I_ASYMET.high-D_S_I_ASYMET.low downto 0);
    signal et_asymht : std_logic_vector(D_S_I_ASYMHT.high-D_S_I_ASYMHT.low downto 0);
    signal et_asymethf : std_logic_vector(D_S_I_ASYMETHF.high-D_S_I_ASYMETHF.low downto 0);
    signal et_asymhthf : std_logic_vector(D_S_I_ASYMHTHF.high-D_S_I_ASYMHTHF.low downto 0);

    signal et_comp : std_logic;
    signal phi_comp : std_logic := '0';

    signal no_esums : std_logic;

begin

-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
    no_esums <= '1' when data_i = ZERO else '0';
    
    ett_sel: if obj_type=ETT_TYPE generate
        et_ett  <= data_i(D_S_I_ETT.et_high downto D_S_I_ETT.et_low);
    
-- Comparator for energy (et)
        et_comp <= '1' when (et_ett >= et_threshold) and et_ge_mode else            
                   '1' when (et_ett = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate ett_sel;
    
    htt_sel: if obj_type=HTT_TYPE generate
        et_htt  <= data_i(D_S_I_HTT.et_high downto D_S_I_HTT.et_low);
    
        et_comp <= '1' when (et_htt >= et_threshold) and et_ge_mode else            
                   '1' when (et_htt = et_threshold) and not et_ge_mode  else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate htt_sel;
    
    etm_sel: if obj_type=ETM_TYPE generate
        et_etm  <= data_i(D_S_I_ETM.et_high downto D_S_I_ETM.et_low);
        phi_etm <= data_i(D_S_I_ETM.phi_high downto D_S_I_ETM.phi_low);
    
        et_comp <= '1' when (et_etm >= et_threshold) and et_ge_mode else            
                   '1' when (et_etm = et_threshold) and not et_ge_mode else '0';            
    
-- Phi windows comparator (same module as used in calo_conditions_v2)
        phi_windows_comp_i: entity work.phi_windows_comp
            generic map(
                phi_full_range => phi_full_range,
                phi_w1_upper_limit => phi_w1_upper_limit,
                phi_w1_lower_limit => phi_w1_lower_limit,
                phi_w2_ignore => phi_w2_ignore,
                phi_w2_upper_limit => phi_w2_upper_limit,
                phi_w2_lower_limit => phi_w2_lower_limit
            )
            port map(
                phi => phi_etm,
                phi_comp_o => phi_comp
            );

        comp_o <= et_comp and phi_comp and not no_esums;   

    end generate etm_sel;

    htm_sel: if obj_type=HTM_TYPE generate
        et_htm  <= data_i(D_S_I_HTM.et_high downto D_S_I_HTM.et_low);
        phi_htm <= data_i(D_S_I_HTM.phi_high downto D_S_I_HTM.phi_low);
        
        et_comp <= '1' when (et_htm >= et_threshold) and et_ge_mode else            
                   '1' when (et_htm = et_threshold) and not et_ge_mode else '0';            
        
        phi_windows_comp_i: entity work.phi_windows_comp
            generic map(
                phi_full_range => phi_full_range,
                phi_w1_upper_limit => phi_w1_upper_limit,
                phi_w1_lower_limit => phi_w1_lower_limit,
                phi_w2_ignore => phi_w2_ignore,
                phi_w2_upper_limit => phi_w2_upper_limit,
                phi_w2_lower_limit => phi_w2_lower_limit
            )
            port map(
                phi => phi_htm,
                phi_comp_o => phi_comp
            );

        comp_o <= et_comp and phi_comp and not no_esums;   

    end generate htm_sel;

    ettem_sel: if obj_type=ETTEM_TYPE generate
        et_ettem  <= data_i(D_S_I_ETTEM.et_high downto D_S_I_ETTEM.et_low);

        et_comp <= '1' when (et_ettem >= et_threshold) and et_ge_mode else            
                   '1' when (et_ettem = et_threshold) and not et_ge_mode else '0';            

        comp_o <= et_comp;   

    end generate ettem_sel;

    etmhf_sel: if obj_type=ETMHF_TYPE generate
        et_etmhf  <= data_i(D_S_I_ETMHF.et_high downto D_S_I_ETMHF.et_low);
        phi_etmhf <= data_i(D_S_I_ETMHF.phi_high downto D_S_I_ETMHF.phi_low);

        et_comp <= '1' when (et_etmhf >= et_threshold) and et_ge_mode else            
                   '1' when (et_etmhf = et_threshold) and not et_ge_mode else '0';            
    
-- Phi windows comparator (same module as used in calo_conditions_v2)
        phi_windows_comp_i: entity work.phi_windows_comp
            generic map(
                phi_full_range => phi_full_range,
                phi_w1_upper_limit => phi_w1_upper_limit,
                phi_w1_lower_limit => phi_w1_lower_limit,
                phi_w2_ignore => phi_w2_ignore,
                phi_w2_upper_limit => phi_w2_upper_limit,
                phi_w2_lower_limit => phi_w2_lower_limit
            )
            port map(
                phi => phi_etmhf,
                phi_comp_o => phi_comp
            );

    comp_o <= et_comp and phi_comp and not no_esums;   

    end generate etmhf_sel;

    htmhf_sel: if obj_type=HTMHF_TYPE generate
        et_htmhf  <= data_i(D_S_I_HTMHF.et_high downto D_S_I_HTMHF.et_low);
        phi_htmhf <= data_i(D_S_I_HTMHF.phi_high downto D_S_I_HTMHF.phi_low);

        et_comp <= '1' when (et_htmhf >= et_threshold) and et_ge_mode else            
                   '1' when (et_htmhf = et_threshold) and not et_ge_mode else '0';            
    
-- Phi windows comparator (same module as used in calo_conditions_v2)
        phi_windows_comp_i: entity work.phi_windows_comp
            generic map(
                phi_full_range => phi_full_range,
                phi_w1_upper_limit => phi_w1_upper_limit,
                phi_w1_lower_limit => phi_w1_lower_limit,
                phi_w2_ignore => phi_w2_ignore,
                phi_w2_upper_limit => phi_w2_upper_limit,
                phi_w2_lower_limit => phi_w2_lower_limit
            )
            port map(
                phi => phi_htmhf,
                phi_comp_o => phi_comp
            );

    comp_o <= et_comp and phi_comp and not no_esums;   

    end generate htmhf_sel;

    asymet_sel: if obj_type=ASYMET_TYPE generate
        et_asymet  <= data_i(D_S_I_ASYMET.high downto D_S_I_ASYMET.low);
    
        et_comp <= '1' when (et_asymet >= et_threshold) and et_ge_mode else            
                   '1' when (et_asymet = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate asymet_sel;

    asymht_sel: if obj_type=ASYMHT_TYPE generate
        et_asymht  <= data_i(D_S_I_ASYMHT.high downto D_S_I_ASYMHT.low);
    
        et_comp <= '1' when (et_asymht >= et_threshold) and et_ge_mode else            
                   '1' when (et_asymht = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate asymht_sel;

    asymethf_sel: if obj_type=ASYMETHF_TYPE generate
        et_asymethf  <= data_i(D_S_I_ASYMETHF.high downto D_S_I_ASYMETHF.low);
    
        et_comp <= '1' when (et_asymethf >= et_threshold) and et_ge_mode else            
                   '1' when (et_asymethf = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate asymethf_sel;

    asymhthf_sel: if obj_type=ASYMHTHF_TYPE generate
        et_asymhthf  <= data_i(D_S_I_ASYMHTHF.high downto D_S_I_ASYMHTHF.low);
    
        et_comp <= '1' when (et_asymhthf >= et_threshold) and et_ge_mode else            
                   '1' when (et_asymhthf = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp and not no_esums;   

    end generate asymhthf_sel;

end architecture rtl;
