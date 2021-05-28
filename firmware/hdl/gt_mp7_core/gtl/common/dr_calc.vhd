
-- Description:
-- Calculation of Delta-R

-- Version history:
-- HB 2021-04-19: removed obsolete generic
-- HB 2021-04-08: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity dr_calc is
    port(
        deta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        dphi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        dr : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)
    );
end dr_calc;

architecture rtl of dr_calc is
    signal deta_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal dphi_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal dr_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of deta_squared : signal is "yes";
    attribute use_dsp of dphi_squared : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";

begin

    deta_squared <= deta*deta;
    dphi_squared <= dphi*dphi;
    dr_squared <= deta_squared+dphi_squared;

    dr <= dr_squared;

end architecture rtl;
