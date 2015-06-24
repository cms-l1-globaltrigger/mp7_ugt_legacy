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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/tau_comparators.vhd $
-- $Date: 2015-05-21 12:47:20 +0200 (Thu, 21 May 2015) $
-- $Author: wittmann $
-- $Revision: 3965 $
--------------------------------------------------------------------------------

-- Desription:
-- Comparators for energy, pseudorapidity and azimuth angle of tau objects

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

use work.gtl_lib.all;
use work.gtl_pkg.all;

entity tau_comparators is
    generic	(
        d_s_i: d_s_i_tau_record;
        et_ge_mode : boolean;
        et_threshold : std_logic_vector;
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector
    );
    port(
        data_i	  : in std_logic_vector;
        comp_o    : out std_logic
    );
end tau_comparators;

architecture rtl of tau_comparators is
    signal et : std_logic_vector(d_s_i.et_high-d_s_i.et_low downto 0);
    signal eta : std_logic_vector(d_s_i.eta_high-d_s_i.eta_low downto 0);
    signal phi : std_logic_vector(d_s_i.phi_high-d_s_i.phi_low downto 0);
    signal et_comp : std_logic;
    signal eta_comp : std_logic;
    signal phi_comp : std_logic;
begin

    et  <= data_i(d_s_i.et_high downto d_s_i.et_low);

-- Comparator for energy (et)
    et_comp <= '1' when et >= et_threshold and et_ge_mode else            
               '1' when et = et_threshold and not et_ge_mode else '0'; 
           
-- HB 2015-04-23: implemented eta_windows_comp for better modularity
    eta_windows_comp_i: eta_windows_comp
        generic map(
            eta_full_range => eta_full_range,
            eta_w1_upper_limit => eta_w1_upper_limit,
            eta_w1_lower_limit => eta_w1_lower_limit,
            eta_w2_ignore => eta_w2_ignore,
            eta_w2_upper_limit => eta_w2_upper_limit,
            eta_w2_lower_limit => eta_w2_lower_limit
        )
        port map(
            eta => data_i(d_s_i.eta_high downto d_s_i.eta_low),
            eta_comp_o => eta_comp
        );
        
-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    phi_windows_comp_i: phi_windows_comp
        generic map(
            phi_full_range => phi_full_range,
            phi_w1_upper_limit => phi_w1_upper_limit,
            phi_w1_lower_limit => phi_w1_lower_limit,
            phi_w2_ignore => phi_w2_ignore,
            phi_w2_upper_limit => phi_w2_upper_limit,
            phi_w2_lower_limit => phi_w2_lower_limit
        )
        port map(
	    phi => data_i(d_s_i.phi_high downto d_s_i.phi_low),
	    phi_comp_o => phi_comp
	);
    
    comp_o <= et_comp and eta_comp and phi_comp;

end architecture rtl;
