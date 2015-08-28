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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/esums_comparators.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:

-- Version history:
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
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        comp_o : out std_logic
    );
end esums_comparators;

architecture rtl of esums_comparators is

    constant ZERO : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');

    signal et_ett : std_logic_vector(D_S_I_ETT.et_high-D_S_I_ETT.et_low downto 0);

    signal et_etm : std_logic_vector(D_S_I_ETM.et_high-D_S_I_ETM.et_low downto 0);
    signal phi_etm : std_logic_vector(D_S_I_ETM.phi_high-D_S_I_ETM.phi_low downto 0);

    signal et_htt : std_logic_vector(D_S_I_HTT.et_high-D_S_I_HTT.et_low downto 0);

    signal et_htm : std_logic_vector(D_S_I_HTM.et_high-D_S_I_HTM.et_low downto 0);
    signal phi_htm : std_logic_vector(D_S_I_HTM.phi_high-D_S_I_HTM.phi_low downto 0);

    signal et_comp : std_logic;
    signal phi_comp : std_logic := '0';

    signal no_esums : std_logic;

begin
-- HB 2015-04-27: used integer for obj_type
-- ett_obj_type=0
-- htt_obj_type=1
-- etm_obj_type=2
-- htm_obj_type=3
    
-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
    no_esums <= '1' when data_i = ZERO else '0';
    
    ett_sel: if obj_type=0 generate
        et_ett  <= data_i(D_S_I_ETT.et_high downto D_S_I_ETT.et_low);
    
-- Comparator for energy (et)
-- et_ett = (others => '1') => overflow
        et_comp <= '1' when (et_ett >= et_threshold) and et_ge_mode else            
                   '1' when (et_ett = et_threshold) and not et_ge_mode else '0';            
    
        comp_o <= et_comp;   

    end generate ett_sel;
    
    htt_sel: if obj_type=1 generate
	et_htt  <= data_i(D_S_I_HTT.et_high downto D_S_I_HTT.et_low);
    
        et_comp <= '1' when (et_htt >= et_threshold) and et_ge_mode else            
                   '1' when (et_htt = et_threshold) and not et_ge_mode  else '0';            
    
        comp_o <= et_comp;   

    end generate htt_sel;
    
    etm_sel: if obj_type=2 generate
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
	
	comp_o <= et_comp and phi_comp;   

    end generate etm_sel;

    htm_sel: if obj_type=3 generate
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
        
end architecture rtl;
