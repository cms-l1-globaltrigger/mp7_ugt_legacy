
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
-- $Date: 2015-12-14 14:49:29 +0100 (Mon, 14 Dec 2015) $
-- $Author: hbergaue $
-- $Revision: 41145 $
--------------------------------------------------------------------------------

-- Desription:
-- A Delta-R for two different object types which removes (set to 0) objects of second object type by multiplexer. Afterwards invariant mass calculation for second object type.
-- In the current latency budget, this condition works only with bx_p2 data (using 2 bx for Delta-R calculation).

-- Version history:
-- HB 2016-07-08: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity overlap_remover_condition is
     generic(

        nr_calo1_delta_r_objects: positive;
        et_ge_mode_calo1_delta_r: boolean;
        obj_type_calo1_delta_r: natural := TAU_TYPE;
        et_threshold_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo1_delta_r: boolean;
        eta_w1_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo1_delta_r: boolean;
        eta_w2_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1_delta_r: boolean;
        phi_w1_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1_delta_r: boolean;
        phi_w2_upper_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo1_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

	nr_calo2_delta_r_objects: positive;
        et_ge_mode_calo2_delta_r: boolean;
        obj_type_calo2_delta_r: natural := JET_TYPE;
        et_threshold_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo2_delta_r: boolean;
        eta_w1_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo2_delta_r: boolean;
        eta_w2_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2_delta_r: boolean;
        phi_w1_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2_delta_r: boolean;
        phi_w2_upper_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo2_delta_r: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

        et_ge_mode_calo_inv_mass_1: boolean;
        et_threshold_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo_inv_mass_1: boolean;
        eta_w1_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo_inv_mass_1: boolean;
        eta_w2_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo_inv_mass_1: boolean;
        phi_w1_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo_inv_mass_1: boolean;
        phi_w2_upper_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo_inv_mass_1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

        et_ge_mode_calo_inv_mass_2: boolean;
        et_threshold_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo_inv_mass_2: boolean;
        eta_w1_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo_inv_mass_2: boolean;
        eta_w2_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo_inv_mass_2: boolean;
        phi_w1_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo_inv_mass_2: boolean;
        phi_w2_upper_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo_inv_mass_2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;

	DETA_DPHI_VECTOR_WIDTH: positive ;
	DETA_DPHI_PRECISION: positive;

        inv_mass_upper_limit: real;
        inv_mass_lower_limit: real;
        
        INV_MASS_PRECISION: positive;
	pt_width: positive; 
	INV_MASS_COSH_COS_PRECISION : positive;
	cosh_cos_width: positive	
    );
    port(
        lhc_clk: in std_logic;
        calo1_delta_r: in calo_objects_array;
        calo2_delta_r: in calo_objects_array;
        calo_inv_mass: in calo_objects_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        pt : in diff_inputs_array;
	cosh_deta : in calo_cosh_cos_vector_array;
        cos_dphi : in calo_cosh_cos_vector_array;
        condition_o: out std_logic
    );
end overlap_remover_condition; 

architecture rtl of overlap_remover_condition is

    type removed_objects_mask_array is array (natural range <>) of std_logic;
    signal removed_objects_mask, removed_objects_mask_pipe : removed_objects_mask_array(0 to nr_calo2_delta_r_objects-1);

    constant ZERO_PT : std_logic_vector(MAX_DIFF_BITS-1 downto 0):= (others => '0');
    signal removed_overlaps_pt : diff_inputs_array(0 to nr_calo2_delta_r_objects-1);
    
-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type inv_mass_object_vs_template_array is array (0 to nr_calo2_delta_r_objects-1, 1 to 2) of std_logic;
    type calo1_delta_r_object_vs_template_array is array (0 to nr_calo1_delta_r_objects-1, 1 to 1) of std_logic;
    type calo2_delta_r_object_vs_template_array is array (0 to nr_calo2_delta_r_objects-1, 1 to 1) of std_logic;
    type dr_diff_comp_array is array (0 to nr_calo1_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) of std_logic;
    type inv_mass_diff_comp_array is array (0 to nr_calo2_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) of std_logic;

    signal inv_mass_obj_vs_templ : inv_mass_object_vs_template_array;
    signal inv_mass_obj_vs_templ_pipe : inv_mass_object_vs_template_array;
    signal calo1_delta_r_obj_vs_templ : calo1_delta_r_object_vs_template_array;
    signal calo1_delta_r_obj_vs_templ_pipe : calo1_delta_r_object_vs_template_array;
    signal calo2_delta_r_obj_vs_templ : calo2_delta_r_object_vs_template_array;
    signal calo2_delta_r_obj_vs_templ_pipe : calo2_delta_r_object_vs_template_array;
    signal diff_eta_comp : dr_diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : dr_diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp : dr_diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : dr_diff_comp_array := (others => (others => '0'));
    signal dr_comp : dr_diff_comp_array;
    signal dr_comp_pipe : dr_diff_comp_array := (others => (others => '0'));
    signal inv_mass_comp : inv_mass_diff_comp_array := (others => (others => '0'));
    signal inv_mass_comp_pipe : inv_mass_diff_comp_array := (others => (others => '0'));

    signal condition_and_or : std_logic;
    
begin

    -- *** section: Delta-R - begin ***************************************************************************************
    
    -- Comparison with limits.
    -- HB 2015-09-17: permutations for Delta-R.
   dr_l_1: for i in 0 to nr_calo1_delta_r_objects-1 generate 
	dr_l_2: for j in 0 to nr_calo2_delta_r_objects-1 generate
	    dr_calculator_i: entity work.dr_calculator
	    generic map(
		upper_limit => dr_upper_limit,
		lower_limit => dr_lower_limit,
		DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH,
		DETA_DPHI_PRECISION => DETA_DPHI_PRECISION
	    )
	    port map(
		diff_eta => diff_eta(i,j),
		diff_phi => diff_phi(i,j),
		dr_comp => dr_comp(i,j)
	    );
	end generate dr_l_2;
    end generate dr_l_1;
    
    -- Pipeline stage for dr_comp
    dr_pipeline_p: process(lhc_clk, dr_comp)
        begin
	  if (lhc_clk'event and lhc_clk = '1') then
	      dr_comp_pipe <= dr_comp;
	  end if;
    end process;

-- HB 2016-07-08: different object types for Delta-R.

    calo1_delta_r_obj_l: for i in 0 to nr_calo1_delta_r_objects-1 generate
	calo1_delta_r_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo1_delta_r, obj_type_calo1_delta_r,
		et_threshold_calo1_delta_r,
		eta_full_range_calo1_delta_r,
		eta_w1_upper_limit_calo1_delta_r,
		eta_w1_lower_limit_calo1_delta_r,
		eta_w2_ignore_calo1_delta_r,
		eta_w2_upper_limit_calo1_delta_r,
		eta_w2_lower_limit_calo1_delta_r,
		phi_full_range_calo1_delta_r,
		phi_w1_upper_limit_calo1_delta_r,
		phi_w1_lower_limit_calo1_delta_r,
		phi_w2_ignore_calo1_delta_r,
		phi_w2_upper_limit_calo1_delta_r,
		phi_w2_lower_limit_calo1_delta_r,
		iso_lut_calo1_delta_r
	    )
	    port map(calo1_delta_r(i), calo1_delta_r_obj_vs_templ(i,1));
    end generate calo1_delta_r_obj_l;

    calo2_delta_r_obj_l: for i in 0 to nr_calo2_delta_r_objects-1 generate
	calo2_delta_r_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo2_delta_r, obj_type_calo2_delta_r,
		et_threshold_calo2_delta_r,
		eta_full_range_calo2_delta_r,
		eta_w1_upper_limit_calo2_delta_r,
		eta_w1_lower_limit_calo2_delta_r,
		eta_w2_ignore_calo2_delta_r,
		eta_w2_upper_limit_calo2_delta_r,
		eta_w2_lower_limit_calo2_delta_r,
		phi_full_range_calo2_delta_r,
		phi_w1_upper_limit_calo2_delta_r,
		phi_w1_lower_limit_calo2_delta_r,
		phi_w2_ignore_calo2_delta_r,
		phi_w2_upper_limit_calo2_delta_r,
		phi_w2_lower_limit_calo2_delta_r,
		iso_lut_calo2_delta_r
	    )
	    port map(calo2_delta_r(i), calo2_delta_r_obj_vs_templ(i,1));
    end generate calo2_delta_r_obj_l;

	-- Pipeline stage for obj_vs_templ
    dr_obj_vs_templ_pipeline_p: process(lhc_clk, calo1_delta_r_obj_vs_templ, calo2_delta_r_obj_vs_templ)
	begin
	    if (lhc_clk'event and lhc_clk = '1') then
		calo1_delta_r_obj_vs_templ_pipe <= calo1_delta_r_obj_vs_templ;
		calo2_delta_r_obj_vs_templ_pipe <= calo2_delta_r_obj_vs_templ;
	    end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    remove_overlaps_p: process(calo1_delta_r_obj_vs_templ_pipe, calo2_delta_r_obj_vs_templ_pipe, dr_comp_pipe)
	variable removed_objects_mask_or : removed_objects_mask_array(0 to nr_calo2_delta_r_objects-1) := (others => '0');
	type dr_obj_templ_array is array (natural range <>, natural range <>) of std_logic;
	variable dr_obj_templ : dr_obj_templ_array(0 to nr_calo1_delta_r_objects-1, 0 to nr_calo2_delta_r_objects-1) := (others => (others => '0'));
    begin
	dr_obj_templ := (others => (others => '0'));
	removed_objects_mask_or := (others => '0');
	for i in 0 to nr_calo1_delta_r_objects-1 loop 
	    for j in 0 to nr_calo2_delta_r_objects-1 loop
		dr_obj_templ(i,j) := calo1_delta_r_obj_vs_templ_pipe(i,1) and calo2_delta_r_obj_vs_templ_pipe(j,1) and dr_comp_pipe(i,j);
	    end loop;
	end loop;
	for i in 0 to nr_calo1_delta_r_objects-1 loop 
	    for j in 0 to nr_calo2_delta_r_objects-1 loop
		removed_objects_mask_or(j) := removed_objects_mask_or(j) or dr_obj_templ(i,j);
	    end loop;
	end loop;
	removed_objects_mask <= removed_objects_mask_or;
    end process remove_overlaps_p;
    
    removed_objects_mask_pipeline_p: process(lhc_clk, removed_objects_mask)
	begin
	    if (lhc_clk'event and lhc_clk = '1') then
		removed_objects_mask_pipe <= removed_objects_mask;
	    end if;
    end process;

    removed_overlaps_pt_l: for i in 0 to nr_calo2_delta_r_objects-1 generate
	removed_overlaps_pt(i) <= pt(i) when removed_objects_mask_pipe(i) = '0' else ZERO_PT;
    end generate removed_overlaps_pt_l;


    -- *** section: Delta-R - end ***************************************************************************************
    
    -- *** section: Invariant mass - begin ***************************************************************************************
    inv_mass_l_1: for i in 0 to nr_calo2_delta_r_objects-1 generate 
	inv_mass_l_2: for j in 0 to nr_calo2_delta_r_objects-1 generate
	    delta_if: if j/=i generate
		inv_mass_calculator_i: entity work.invariant_mass
		    generic map(
			upper_limit => inv_mass_upper_limit,
			lower_limit => inv_mass_lower_limit,
			pt1_width => pt_width, 
			pt2_width => pt_width, 
			cosh_cos_width => cosh_cos_width,
			INV_MASS_PRECISION => INV_MASS_PRECISION,
			INV_MASS_COSH_COS_PRECISION => INV_MASS_COSH_COS_PRECISION
		    )
		    port map(
			pt1 => removed_overlaps_pt(i)(pt_width-1 downto 0),
			pt2 => removed_overlaps_pt(j)(pt_width-1 downto 0),
			cosh_deta => cosh_deta(i,j),
			cos_dphi => cos_dphi(i,j),
			inv_mass_comp => inv_mass_comp(i,j)
		);
	    end generate delta_if;
	end generate inv_mass_l_2;
    end generate inv_mass_l_1;
    
    -- Pipeline stage for dr_comp
    inv_mass_pipeline_p: process(lhc_clk, inv_mass_comp)
        begin
	  if (lhc_clk'event and lhc_clk = '1') then
	      inv_mass_comp_pipe <= inv_mass_comp;
	  end if;
    end process;

	-- Instance of comparators for calorimeter objects.
    inv_mass_obj_templ1_l: for i in 0 to nr_calo2_delta_r_objects-1 generate
	inv_mass_obj_templ1_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo_inv_mass_1, obj_type_calo2_delta_r,
		et_threshold_calo_inv_mass_1,
		eta_full_range_calo_inv_mass_1,
		eta_w1_upper_limit_calo_inv_mass_1,
		eta_w1_lower_limit_calo_inv_mass_1,
		eta_w2_ignore_calo_inv_mass_1,
		eta_w2_upper_limit_calo_inv_mass_1,
		eta_w2_lower_limit_calo_inv_mass_1,
		phi_full_range_calo_inv_mass_1,
		phi_w1_upper_limit_calo_inv_mass_1,
		phi_w1_lower_limit_calo_inv_mass_1,
		phi_w2_ignore_calo_inv_mass_1,
		phi_w2_upper_limit_calo_inv_mass_1,
		phi_w2_lower_limit_calo_inv_mass_1,
		iso_lut_calo_inv_mass_1
	    )
	    port map(calo_inv_mass(i), inv_mass_obj_vs_templ(i,1));
    end generate inv_mass_obj_templ1_l;

    inv_mass_obj_templ2_l: for i in 0 to nr_calo2_delta_r_objects-1 generate
	inv_mass_obj_templ2_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo_inv_mass_2, obj_type_calo2_delta_r,
		et_threshold_calo_inv_mass_2,
		eta_full_range_calo_inv_mass_2,
		eta_w1_upper_limit_calo_inv_mass_2,
		eta_w1_lower_limit_calo_inv_mass_2,
		eta_w2_ignore_calo_inv_mass_2,
		eta_w2_upper_limit_calo_inv_mass_2,
		eta_w2_lower_limit_calo_inv_mass_2,
		phi_full_range_calo_inv_mass_2,
		phi_w1_upper_limit_calo_inv_mass_2,
		phi_w1_lower_limit_calo_inv_mass_2,
		phi_w2_ignore_calo_inv_mass_2,
		phi_w2_upper_limit_calo_inv_mass_2,
		phi_w2_lower_limit_calo_inv_mass_2,
		iso_lut_calo_inv_mass_2
	    )
	    port map(calo_inv_mass(i), inv_mass_obj_vs_templ(i,2));
    end generate inv_mass_obj_templ2_l;

	-- Pipeline stage for obj_vs_templ
    inv_mass_obj_vs_templ_pipeline_p: process(lhc_clk, inv_mass_obj_vs_templ)
	begin
	    if (lhc_clk'event and lhc_clk = '1') then
		inv_mass_obj_vs_templ_pipe <= inv_mass_obj_vs_templ;
	    end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_inv_mass_p: process(inv_mass_obj_vs_templ_pipe, inv_mass_comp_pipe)
	variable index : integer := 0;
	variable obj_vs_templ_vec : std_logic_vector((nr_calo2_delta_r_objects*nr_calo2_delta_r_objects) downto 1) := (others => '0');
	variable condition_and_or_tmp : std_logic := '0';
    begin
	index := 0;
	obj_vs_templ_vec := (others => '0');
	condition_and_or_tmp := '0';
	for i in 0 to nr_calo2_delta_r_objects-1 loop 
	    for j in 0 to nr_calo2_delta_r_objects-1 loop
		if j/=i then
		    index := index + 1;
		    obj_vs_templ_vec(index) := inv_mass_obj_vs_templ_pipe(i,1) and inv_mass_obj_vs_templ_pipe(j,2) and inv_mass_comp_pipe(i,j);
		end if;
	    end loop;
	end loop;
	for i in 1 to index loop 
	    -- ORs for matrix
	    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	end loop;
	condition_and_or <= condition_and_or_tmp;
    end process matrix_inv_mass_p;
    -- *** section: Invariant mass - end ***************************************************************************************
        
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
    
    
    
    
    
    
    
    
    
    