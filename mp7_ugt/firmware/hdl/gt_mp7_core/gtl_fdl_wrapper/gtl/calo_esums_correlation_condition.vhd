
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
-- $HeadURL: https://svn.cern.ch/reps/cactus/trunk/cactusupgrades/projects/ugt/mp7_ugt/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_calo_correlation_condition.vhd $
-- $Date: 2015-11-27 08:56:38 +0100 (Fri, 27 Nov 2015) $
-- $Author: hbergaue $
-- $Revision: 40905 $
--------------------------------------------------------------------------------

-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and esums (etm and htm).

-- Version history:
-- HB 2015-12-09: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_esums_correlation_condition is
     generic(

        nr_calo_objects: positive;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := EG_TYPE;
        et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo: boolean;
        eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo: boolean;
        eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo: boolean;
        phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo: boolean;
        phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);
	
	et_ge_mode_esums: boolean;
	obj_type_esums: natural := ETM_TYPE; -- etm=2, htm=3
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_full_range_esums: boolean;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_esums: boolean;
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

	DETA_DPHI_VECTOR_WIDTH: positive;
	DETA_DPHI_PRECISION: positive
	
    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        esums_data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        diff_phi: in deta_dphi_vector_array;
        condition_o: out std_logic
    );
end calo_esums_correlation_condition; 

architecture rtl of calo_esums_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type object_vs_template_array is array (0 to nr_calo_objects-1, 1 to 1) of std_logic;
    type diff_comp_array is array (0 to nr_calo_objects-1, 0 to 0) of std_logic;

    signal diff_phi_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    
    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal esums_comp_o, esums_comp_o_pipe : std_logic;
    signal condition_and_or : std_logic;
    
begin

    -- *** section: CUTs - begin ***************************************************************************************
    -- Conversion of limits to std_logic_vector.
    diff_phi_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);

    -- Comparison with limits.
    delta_l: for i in 0 to nr_calo_objects-1 generate 
	diff_phi_comp(i,0) <= '1' when diff_phi(i,0) >= diff_phi_lower_limit_int and diff_phi(i,0) <= diff_phi_upper_limit_int else '0';
    end generate delta_l;
    
    -- Pipeline stage for diff_phi_comp
    diff_pipeline_p: process(lhc_clk, diff_phi_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then 
	    diff_phi_comp_pipe <= diff_phi_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
		diff_phi_comp_pipe <= diff_phi_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    obj_templ1_l: for i in 0 to nr_calo_objects-1 generate
	obj_templ1_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo, obj_type_calo,
                et_threshold_calo,
                eta_full_range_calo,
                eta_w1_upper_limit_calo,
                eta_w1_lower_limit_calo,
                eta_w2_ignore_calo,
                eta_w2_upper_limit_calo,
                eta_w2_lower_limit_calo,
                phi_full_range_calo,
                phi_w1_upper_limit_calo,
                phi_w1_lower_limit_calo,
                phi_w2_ignore_calo,
                phi_w2_upper_limit_calo,
                phi_w2_lower_limit_calo,
                iso_lut_calo
            )
            port map(calo_data_i(i), obj_vs_templ(i,1));
    end generate obj_templ1_l;

    esums_comparators_i: entity work.esums_comparators
	generic map(
	    et_ge_mode => et_ge_mode_esums,
	    obj_type => obj_type_esums,
	    et_threshold => et_threshold_esums,
            phi_full_range => phi_full_range_esums,
            phi_w1_upper_limit => phi_w1_upper_limit_esums,
            phi_w1_lower_limit => phi_w1_lower_limit_esums,
            phi_w2_ignore => phi_w2_ignore_esums,
            phi_w2_upper_limit => phi_w2_upper_limit_esums,
            phi_w2_lower_limit => phi_w2_lower_limit_esums	
	)
	port map(
	    data_i => esums_data_i,
	    comp_o => esums_comp_o
	);
    
    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_vs_templ)
    begin
	if obj_vs_templ_pipeline_stage = false then 
	    obj_vs_templ_pipe <= obj_vs_templ;
	    esums_comp_o_pipe <= esums_comp_o;
	else
	    if (lhc_clk'event and lhc_clk = '1') then
		obj_vs_templ_pipe <= obj_vs_templ;
		esums_comp_o_pipe <= esums_comp_o;
	    end if;
	end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_deta_dphi_dr_p: process(obj_vs_templ_pipe, esums_comp_o_pipe, diff_phi_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(nr_calo_objects downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_calo_objects-1 loop 
	    index := index + 1;
	    obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and esums_comp_o and diff_phi_comp_pipe(i,0);
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_deta_dphi_dr_p;

    -- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
    begin
        if conditions_pipeline_stage = false then 
            condition_o <= condition_and_or;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                condition_o <= condition_and_or;
            end if;
        end if;
    end process;
    
end architecture rtl;
    
    
    
    
    
    
    
    
    
    