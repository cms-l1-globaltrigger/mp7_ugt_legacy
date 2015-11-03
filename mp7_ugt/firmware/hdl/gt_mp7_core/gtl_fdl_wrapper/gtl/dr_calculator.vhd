--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
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
-- Calculation of Delta-R and comparison with limits 

-- Version history:
-- HB 2015-08-24: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity dr_calculator is
    generic (
-- HB 2015-09-21: TM proposed two thresholds for DR
	dr_upper_limit: dr_squared_range_real := 15.0; -- threshold for ΔR (see formula below) in real values
	dr_lower_limit: dr_squared_range_real := 10.0; -- threshold for ΔR (see formula below) in real values
	dr_limits_precision: positive := 3 -- 3 => max. number, higher numbers exceed 32 bit integer values !!!
    );
    port(
        diff_eta : in integer;
        diff_phi : in integer;
        dr_comp : out std_logic;
        sim_diff_eta_value_out : out integer;
        sim_diff_phi_value_out : out integer;
        sim_diff_eta_sq_out : out integer;
        sim_diff_phi_sq_out : out integer;
        sim_dr_squ_out : out integer;
        sim_dr_comp : out std_logic
    );
end dr_calculator;

architecture rtl of dr_calculator is
    signal dr_upper_limit_int : integer;
    signal dr_lower_limit_int : integer;
begin

dr_upper_limit_int <= integer((dr_upper_limit**2)*real(10**(dr_limits_precision*2)));
dr_lower_limit_int <= integer((dr_lower_limit**2)*real(10**(dr_limits_precision*2)));

    delta_r_p: process(diff_eta, diff_phi)
        variable dr_squared, diff_eta_value, diff_phi_value : integer;
        variable result : std_logic;
    begin

-- HB 2015-08-10: "ERROR: ... Nonconstant REAL value  is not supported for synthesis"

-- HB 2015-08-11: calculation of ΔR**2:
-- ΔR**2 = (eta1-eta2)**2+(phi1-phi2)**2

	diff_eta_value := diff_eta;
        diff_phi_value := diff_phi;
        dr_squared := diff_eta_value*diff_eta_value+diff_phi_value*diff_phi_value;
           
-- HB 2015-08-11: comparison of DR**2 with limits
        if (dr_squared >= dr_lower_limit_int and dr_squared <= dr_upper_limit_int) then
            result := '1';
        else
            result := '0';
        end if;

        dr_comp <= result;
        
-- for simulation
        sim_diff_eta_value_out <= diff_eta_value;
        sim_diff_phi_value_out <= diff_phi_value;
        sim_diff_eta_sq_out <= diff_eta_value*diff_eta_value;
        sim_diff_phi_sq_out <= diff_phi_value*diff_phi_value;
        sim_dr_squ_out <= dr_squared;
	sim_dr_comp <= result;
	
    end process delta_r_p;

end architecture rtl;
