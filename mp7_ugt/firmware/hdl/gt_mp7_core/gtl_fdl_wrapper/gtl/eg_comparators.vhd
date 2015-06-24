--------------------------------------------------------------------------------
-- Synthesizer : ISE 13.2
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/eg_comparators.vhd $
-- $Date: 2015-05-21 12:47:20 +0200 (Thu, 21 May 2015) $
-- $Author: wittmann $
-- $Revision: 3965 $
--------------------------------------------------------------------------------

-- Desription:
-- Comparators for energy, pseudorapidity and azimuth angle of eg objects

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

use work.gtl_lib.all;
use work.gtl_pkg.all;

entity eg_comparators is
    generic	(
        d_s_i: d_s_i_eg_record;
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
        data_i    : in std_logic_vector;
        comp_o    : out std_logic
    );
end eg_comparators;

architecture rtl of eg_comparators is
    signal et : std_logic_vector(d_s_i.et_high-d_s_i.et_low downto 0);
    signal eta : std_logic_vector(d_s_i.eta_high-d_s_i.eta_low downto 0);
    signal phi : std_logic_vector(d_s_i.phi_high-d_s_i.phi_low downto 0);
    signal et_comp : std_logic;
    signal eta_comp : std_logic;
--     signal eta_comp_w1 : std_logic;
--     signal eta_comp_w2 : std_logic;
    signal phi_comp : std_logic;
--     signal phi_comp_w1 : std_logic;
--     signal phi_comp_w2 : std_logic;
begin

    et  <= data_i(d_s_i.et_high downto d_s_i.et_low);
--    eta <= data_i(d_s_i.eta_high downto d_s_i.eta_low);
--    phi <= data_i(d_s_i.phi_high downto d_s_i.phi_low);

-- Comparator for energy (et)
    et_comp <= '1' when et >= et_threshold and et_ge_mode else            
               '1' when et = et_threshold and not et_ge_mode else '0'; 
           
-- Comparator for pseudorapidity (eta)
-- Eta scale is defined with Two's Complement notation values for HW index.
-- Therefore a comparison with "signed" is implemented, which needs ieee.std_logic_signed.all library.
-- The comparators for et and phi work unsigned, so a module for Eta comparators is instantiated,
-- in which ieee.std_logic_signed.all library is used.

--     eta_full_range_i: if eta_full_range = true generate
--         eta_comp <= '1';
--     end generate eta_full_range_i;
-- 
--     not_eta_full_range_i: if eta_full_range = false generate
--         eta_w1_comp_i: eta_comp_signed
--             generic map(
--                 eta_upper_limit => eta_w1_upper_limit(d_s_i.eta_high-d_s_i.eta_low downto 0),
--                 eta_lower_limit => eta_w1_lower_limit(d_s_i.eta_high-d_s_i.eta_low downto 0)
--             )    
--         port map( 
--                 eta => eta(d_s_i.eta_high downto d_s_i.eta_low),
--                 eta_comp => eta_comp_w1
--         );
-- 
--         not_eta_w2_ignore_i: if eta_w2_ignore = false generate
--             eta_w2_comp_i: eta_comp_signed
--                 generic map(
--                     eta_upper_limit => eta_w2_upper_limit(d_s_i.eta_high-d_s_i.eta_low downto 0),
--                     eta_lower_limit => eta_w2_lower_limit(d_s_i.eta_high-d_s_i.eta_low downto 0)
--                 )    
--                 port map( 
--                     eta => eta(d_s_i.eta_high downto d_s_i.eta_low),
--                     eta_comp => eta_comp_w2
--                 );
--         end generate not_eta_w2_ignore_i;
-- 
--         eta_w2_ignore_i: if eta_w2_ignore = true generate
--             eta_comp_w2 <= '0';
--         end generate eta_w2_ignore_i;
-- 
--         eta_comp <= eta_comp_w1 or eta_comp_w2;
-- 
--     end generate not_eta_full_range_i;
    
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
        
-- Comparator for azimuth angle (phi)
-- Two "windows"-comparartors used.
-- Changed logic: if upper_limit = lower_limit than phi must be equal upper_limit (= lower_limit).
--     phi_full_range_i: if phi_full_range = true generate
--         phi_comp <= '1';
--     end generate phi_full_range_i;
-- 
--     not_phi_full_range_i: if phi_full_range = false generate
--         phi_comp_w1 <= '1' when phi_w1_upper_limit < phi_w1_lower_limit and (phi <= phi_w1_upper_limit or phi >= phi_w1_lower_limit) else
--                        '1' when phi_w1_upper_limit >= phi_w1_lower_limit and (phi <= phi_w1_upper_limit and phi >= phi_w1_lower_limit) else
--                        '0';
-- 
--         not_phi_w2_ignore_i: if phi_w2_ignore = false generate
--             phi_comp_w2 <= '1' when phi_w2_upper_limit < phi_w2_lower_limit and (phi <= phi_w2_upper_limit or phi >= phi_w2_lower_limit) else
--                            '1' when phi_w2_upper_limit >= phi_w2_lower_limit and (phi <= phi_w2_upper_limit and phi >= phi_w2_lower_limit) else
--                            '0';
--         end generate not_phi_w2_ignore_i;
-- 
--         phi_w2_ignore_i: if phi_w2_ignore = true generate
--             phi_comp_w2 <= '0';
--         end generate phi_w2_ignore_i;
-- 
--         phi_comp <= phi_comp_w1 or phi_comp_w2;
-- 
--     end generate not_phi_full_range_i;

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
