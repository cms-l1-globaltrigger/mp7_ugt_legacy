-- Calculation of Delta-R and comparison with limits 

-- Version history:
-- HB 2017-02-06: inserted "attribute use_dsp48" for "dr_squared" (calculation of dr_squared is done by DSPs, reduces used number of LUTs)
-- HB 2015-11-26: changed to calculation with std_logic_vector
-- HB 2015-08-24: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity dr_calculator_v2 is
    generic (
-- HB 2015-09-21: TM proposed two thresholds for DR
	upper_limit: dr_squared_range_real := 15.0; -- threshold for ΔR**2 (see formula below) in real values
	lower_limit: dr_squared_range_real := 10.0; -- threshold for ΔR**2 (see formula below) in real values
	DETA_DPHI_VECTOR_WIDTH: positive := 14;
-- 	DR_PRECISION : positive := 1;
	DETA_DPHI_PRECISION: positive := 3
    );
    port(
        diff_eta : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
        diff_phi : in std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
        dr_comp : out std_logic;
        upper_limit_vector_sim : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
        lower_limit_vector_sim : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
        dr_squared_sim : out std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0)        
    );
end dr_calculator_v2;

architecture rtl of dr_calculator_v2 is
    signal diff_eta_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
    signal diff_phi_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
    signal dr_squared : std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
    signal upper_limit_vector : std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);
    signal lower_limit_vector : std_logic_vector(DETA_DPHI_VECTOR_WIDTH*2-1 downto 0);

-- HB 2017-02-06: inserted "attribute use_dsp48" for "dr_squared" (calculation of dr_squared is done by DSPs, reduces used number of LUTs)
    attribute use_dsp48 : string;
    attribute use_dsp48 of diff_eta_squared : signal is "yes";
    attribute use_dsp48 of diff_phi_squared : signal is "yes";
    attribute use_dsp48 of dr_squared : signal is "yes";

begin

-- HB 2015-11-26: converting limits to std_logic_vector for comparison.
-- HB 2016-04-08: bug fixed with DETA_DPHI_PRECISION*2.
    upper_limit_vector <= conv_std_logic_vector(integer(upper_limit*real(10**(DETA_DPHI_PRECISION*2))),DETA_DPHI_VECTOR_WIDTH*2);
    lower_limit_vector <= conv_std_logic_vector(integer(lower_limit*real(10**(DETA_DPHI_PRECISION*2))),DETA_DPHI_VECTOR_WIDTH*2);

-- HB 2015-11-26: calculation of ΔR**2 with formular ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2
    diff_eta_squared <= diff_eta*diff_eta;
    diff_phi_squared <= diff_phi*diff_phi;
    dr_squared <= diff_eta_squared+diff_phi_squared;

-- HB 2015-11-26: comparison
    dr_comp <= '1' when (dr_squared >= lower_limit_vector and dr_squared <= upper_limit_vector) else '0';
    
-- HB 2016-04-08: inserted outputs for waveform simulation.
    upper_limit_vector_sim <= upper_limit_vector;
    lower_limit_vector_sim <= lower_limit_vector;
    dr_squared_sim <= dr_squared;
    
end architecture rtl;
