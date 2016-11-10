--------------------------------------------------------------------------------
-- Simulator   : Modelsim 10.1
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Simulation
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL$
-- $Date$
-- $Author$
-- $Revision$
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity invariant_mass_TB is
end invariant_mass_TB;

architecture rtl of invariant_mass_TB is

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal lhc_clk : std_logic;

    signal data1, data2 : std_logic_vector(31 downto 0) := X"00000000";
    signal calo1, calo2 : std_logic_vector(31 downto 0) := X"00000000";
    signal pt1, pt2 : std_logic_vector(12 downto 0) := '0'&X"000";
    signal cosh_deta : std_logic_vector(27 downto 0) := (others => '0');
    signal cos_dphi : std_logic_vector(27 downto 0) := (others => '0');
        
--*********************************Main Body of Code**********************************
begin
    
    process
    begin
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"000";
        pt2 <= '0'&X"000";
        cosh_deta <= X"0000000";
        cos_dphi <= X"0000000";
        calo1 <= X"00000040";
        calo2 <= X"01117E30";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"9F6";
        pt2 <= '0'&X"9F6";
        cosh_deta <= X"1f512de";
        cos_dphi <= X"FFFFC18";
        calo1 <= X"01112011";
        calo2 <= X"00000030";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"000";
        pt2 <= '0'&X"000";
        cosh_deta <= X"0000000";
        cos_dphi <= X"0000000";
        calo1 <= X"00000030";
        calo2 <= X"00000000";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"9F6";
        pt2 <= '0'&X"9F6";
	cosh_deta <= X"1f512de";
        cos_dphi <= X"00003E8";
        calo1 <= X"00000000";
        calo2 <= X"00000000";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"000";
        pt2 <= '0'&X"000";
        cosh_deta <= X"0000000";
        cos_dphi <= X"0000000";
        calo1 <= X"00000000";
        calo2 <= X"00000000";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"9F6";
        pt2 <= '0'&X"9F6";
        cosh_deta <= X"00003EB";
        cos_dphi <= X"00003E8";
        calo1 <= X"00000000";
        calo2 <= X"00000000";
	wait for LHC_CLK_PERIOD; 
        pt1 <= '0'&X"000";
        pt2 <= '0'&X"000";
        cosh_deta <= X"0000000";
        cos_dphi <= X"0000000";
        calo1 <= X"00000000";
        calo2 <= X"00000000";
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

-- cosh_deta <= CALO_CALO_COSH_DETA_LUT(CONV_INTEGER(calo1(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low)),CONV_INTEGER(calo2(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low)));
-- cos_dphi <= CALO_CALO_COS_DPHI_LUT(CONV_INTEGER(calo1(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)),CONV_INTEGER(calo2(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));

dut: entity work.invariant_mass
    generic map(196.222, 195.0, EG_PT_VECTOR_WIDTH, EG_PT_VECTOR_WIDTH, EG_EG_COSH_COS_VECTOR_WIDTH, EG_EG_INV_MASS_PRECISION, EG_EG_COSH_COS_PRECISION) -- M**2/2
    port map(pt1(EG_PT_VECTOR_WIDTH-1 downto 0), pt2(EG_PT_VECTOR_WIDTH-1 downto 0), cosh_deta(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0), cos_dphi(EG_EG_COSH_COS_VECTOR_WIDTH-1 downto 0), open, open);

end rtl;

