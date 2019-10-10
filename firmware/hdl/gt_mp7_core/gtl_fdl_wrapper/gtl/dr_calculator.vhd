
-- Description:
-- Calculation of Delta-R and comparison with limits 

-- Version history:
-- HB 2019-05-03: changed name from  dr_calculator_v3 to dr_calculator.
-- HB 2017-09-21: based on "dr_calculator_v2.vhd" but added upper_limit_vector and lower_limit_vector to generic. Changed attribute "use_dsp48" to "use_dsp"
-- HB 2017-02-06: inserted "attribute use_dsp" for "dr_squared" (calculation of dr_squared is done by DSPs, reduces used number of LUTs)
-- HB 2015-11-26: changed to calculation with std_logic_vector
-- HB 2015-08-24: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity dr_calculator is
    generic (
-- HB 2015-09-21: TM proposed two thresholds for DR
        upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0)
    );
    port(
        diff_eta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        diff_phi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        dr_comp : out std_logic;
        dr_squared_sim : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)
    );
end dr_calculator;

architecture rtl of dr_calculator is
    signal diff_eta_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal diff_phi_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);
    signal dr_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0);

-- HB 2017-09-21: used "attribute use_dsp" instead of "use_dsp48" for "dr_squared" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of diff_eta_squared : signal is "yes";
    attribute use_dsp of diff_phi_squared : signal is "yes";
    attribute use_dsp of dr_squared : signal is "yes";

begin

-- HB 2015-11-26: calculation of ΔR**2 with formular ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2
    diff_eta_squared <= diff_eta*diff_eta;
    diff_phi_squared <= diff_phi*diff_phi;
    dr_squared <= diff_eta_squared+diff_phi_squared;

-- HB 2015-11-26: comparison
    dr_comp <= '1' when (dr_squared >= lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0) and dr_squared <= upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)) else '0';

-- HB 2016-04-08: inserted outputs for waveform simulation.
    dr_squared_sim <= dr_squared;

end architecture rtl;
