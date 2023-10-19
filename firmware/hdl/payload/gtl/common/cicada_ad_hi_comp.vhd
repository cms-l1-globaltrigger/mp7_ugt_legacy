
-- Description:
-- Comparator for cicada Anomaly Detection and HI bits

-- Version history:
-- HB 2022-02-09: updated for 2 HI bits.
-- HB 2022-02-03: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity cicada_ad_hi_comp is
    generic	(
        hi_bits_requ : boolean := false;
        hi_bits_val : std_logic_vector(HI_BITS-1 downto 0) := (others => '0');
        ad_requ : boolean := false;
        ad_dec_thr : std_logic_vector(AD_DEC_BITS-1 downto 0) := (others => '0');
        ad_int_thr : std_logic_vector(AD_INT_BITS-1 downto 0) := (others => '0')
    );
    port(
        lhc_clk: in std_logic;
        hi_bits_i : in std_logic_vector(HI_BITS-1 downto 0) := (others => '0');
        ad_dec_i : in std_logic_vector(AD_DEC_BITS-1 downto 0) := (others => '0');
        ad_int_i : in std_logic_vector(AD_INT_BITS-1 downto 0) := (others => '0');
        hi_comp_o : out std_logic := '1';
        ad_comp_o : out std_logic := '1'
    );
end cicada_ad_hi_comp;

architecture rtl of cicada_ad_hi_comp is

    signal hi_comp, ad_comp : std_logic := '1';

begin

    hi_i: if hi_bits_requ generate
        hi_p: process(hi_bits_i)
        begin
            if hi_bits_i = hi_bits_val then
                hi_comp <= '1';
            else
                hi_comp <= '0';
            end if;
        end process;
    end generate hi_i;
    
    ad_i: if ad_requ generate
        ad_p: process(ad_int_i, ad_dec_i)
        begin
            if ad_int_i > ad_int_thr then
                ad_comp <= '1';
            elsif ad_int_i = ad_int_thr then
                if ad_dec_i >= ad_dec_thr then
                    ad_comp <= '1';
                else
                    ad_comp <= '0';
                end if;
            else
                ad_comp <= '0';
            end if;
        end process;
    end generate ad_i;
    
    pipeline_p: process(lhc_clk, hi_comp, ad_comp)
        begin
        if INTERMEDIATE_PIPELINE = false then
            hi_comp_o <= hi_comp;
            ad_comp_o <= ad_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                hi_comp_o <= hi_comp;
                ad_comp_o <= ad_comp;
            end if;
        end if;
    end process;    

end architecture rtl;