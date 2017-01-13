
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
-- A Delta-R for two different calo object types is calculated. If DR is within thresholds for a certain combination of objects,
-- the result of the calculation for DETA, DHI or mass is ignored for this combination of objects.
-- In the current latency budget, this condition works with bx_p2 data for DR (because calculation of DR needs 2 bx) and bx_0 data for DETA, DHI or mass.

-- Version history:
-- HB 2017-01-10: updated mass_cuts instantiation
-- HB 2016-12-20: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity calo_calo_overlap_remover_condition is
     generic(

        deta_cut: boolean := true;
        dphi_cut: boolean := true;
        mass_cut: boolean := false;
	mass_type : natural := 0;

        nr_calo1_objects: positive;
        et_ge_mode_calo1: boolean;
        obj_type_calo1: natural := JET_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo1: boolean;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo1: boolean;
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1: boolean;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1: boolean;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

	nr_calo2_objects: positive;
        et_ge_mode_calo2: boolean;
        obj_type_calo2: natural := TAU_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo2: boolean;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo2: boolean;
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2: boolean;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2: boolean;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
	iso_lut_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;

	DETA_DPHI_VECTOR_WIDTH: positive ;
	DETA_DPHI_PRECISION: positive;

	diff_eta_upper_limit: diff_eta_range_real;
        diff_eta_lower_limit: diff_eta_range_real;

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

	mass_upper_limit: real;
        mass_lower_limit: real;
        
        MASS_PRECISION: positive;
	pt1_width: positive; 
	pt2_width: positive; 
	MASS_COSH_COS_PRECISION : positive;
	cosh_cos_width: positive;
	
	pt_sq_threshold: real; -- for pt**2
	sin_cos_width: positive; -- for pt**2 calculation
	PT_PRECISION : positive;
	PT_SQ_SIN_COS_PRECISION : positive

    );
    port(
        lhc_clk: in std_logic;
        calo1_delta_r: in calo_objects_array;
        calo2_delta_r: in calo_objects_array;
        calo1_correlation: in calo_objects_array;
        calo2_correlation: in calo_objects_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
	cosh_deta : in calo_cosh_cos_vector_array;
        cos_dphi : in calo_cosh_cos_vector_array;
        cos_phi_1 : in calo_sin_cos_vector_array;
        cos_phi_2 : in calo_sin_cos_vector_array;
        sin_phi_1 : in calo_sin_cos_vector_array;
        sin_phi_2 : in calo_sin_cos_vector_array;
        condition_o: out std_logic
    );
end calo_calo_overlap_remover_condition; 

architecture rtl of calo_calo_overlap_remover_condition is

    type removed_objects_mask_array is array (natural range <>, natural range <>) of std_logic;
    signal removed_objects_mask, removed_objects_mask_pipe : removed_objects_mask_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1);

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

--     type inv_mass_object_vs_template_array is array (0 to nr_calo_inv_mass_objects-1, 1 to 2) of std_logic;
    type calo1_delta_r_object_vs_template_array is array (0 to nr_calo1_objects-1, 1 to 1) of std_logic;
    type calo2_delta_r_object_vs_template_array is array (0 to nr_calo2_objects-1, 1 to 1) of std_logic;
    type diff_comp_array is array (0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) of std_logic;
    type calo1_object_vs_template_array is array (0 to nr_calo1_objects-1, 1 to 1) of std_logic;
    type calo2_object_vs_template_array is array (0 to nr_calo2_objects-1, 1 to 1) of std_logic;

    signal diff_eta_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_eta_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    
    signal diff_phi_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    
    signal calo1_delta_r_obj_vs_templ : calo1_delta_r_object_vs_template_array;
    signal calo1_delta_r_obj_vs_templ_pipe : calo1_delta_r_object_vs_template_array;
    signal calo2_delta_r_obj_vs_templ : calo2_delta_r_object_vs_template_array;
    signal calo2_delta_r_obj_vs_templ_pipe : calo2_delta_r_object_vs_template_array;
    signal calo1_obj_vs_templ : calo1_object_vs_template_array;
    signal calo1_obj_vs_templ_pipe : calo1_object_vs_template_array;
    signal calo2_obj_vs_templ : calo2_object_vs_template_array;
    signal calo2_obj_vs_templ_pipe : calo2_object_vs_template_array;
    signal diff_eta_comp : diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal dr_comp : diff_comp_array := (others => (others => '0'));
    signal dr_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal mass_comp : diff_comp_array := (others => (others => '0'));
    signal mass_comp_temp : diff_comp_array := (others => (others => '0'));
    signal mass_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal condition_and_or : std_logic;

begin

-- HB 2016-12-15: failure if object types are the same
    assert (obj_type_calo1 /= obj_type_calo2) report 
	"obj_type_calo1 same as obj_type_calo2" severity failure;

-- HB 2016-12-20: wrong mass type
    assert (mass_type < MASS_TYPE_MAX_VALUE+1) report 
	"mass type out of range (0 to " & integer'image(MASS_TYPE_MAX_VALUE) & ") - mass_type = " & integer'image(mass_type) severity failure;

   -- *** section: Delta-R - begin ***************************************************************************************
    
    -- Conversion of limits to std_logic_vector.
    diff_eta_upper_limit_int <= conv_std_logic_vector(integer(diff_eta_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_eta_lower_limit_int <= conv_std_logic_vector(integer(diff_eta_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);

    -- Comparison with limits.
    -- HB 2015-09-17: permutations for Delta-R.
    dr_l_1: for i in 0 to nr_calo1_objects-1 generate 
	dr_l_2: for j in 0 to nr_calo2_objects-1 generate
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

    calo1_delta_r_obj_l: for i in 0 to nr_calo1_objects-1 generate
	calo1_delta_r_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo1, obj_type_calo1,
		et_threshold_calo1,
		eta_full_range_calo1,
		eta_w1_upper_limit_calo1,
		eta_w1_lower_limit_calo1,
		eta_w2_ignore_calo1,
		eta_w2_upper_limit_calo1,
		eta_w2_lower_limit_calo1,
		phi_full_range_calo1,
		phi_w1_upper_limit_calo1,
		phi_w1_lower_limit_calo1,
		phi_w2_ignore_calo1,
		phi_w2_upper_limit_calo1,
		phi_w2_lower_limit_calo1,
		iso_lut_calo1
	    )
	    port map(calo1_delta_r(i), calo1_delta_r_obj_vs_templ(i,1));
    end generate calo1_delta_r_obj_l;

    calo2_delta_r_obj_l: for i in 0 to nr_calo2_objects-1 generate
	calo2_delta_r_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo2, obj_type_calo2,
		et_threshold_calo2,
		eta_full_range_calo2,
		eta_w1_upper_limit_calo2,
		eta_w1_lower_limit_calo2,
		eta_w2_ignore_calo2,
		eta_w2_upper_limit_calo2,
		eta_w2_lower_limit_calo2,
		phi_full_range_calo2,
		phi_w1_upper_limit_calo2,
		phi_w1_lower_limit_calo2,
		phi_w2_ignore_calo2,
		phi_w2_upper_limit_calo2,
		phi_w2_lower_limit_calo2,
		iso_lut_calo2
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
	variable removed_objects_mask_or : removed_objects_mask_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => '0'));
	type dr_obj_templ_array is array (natural range <>, natural range <>) of std_logic;
	variable dr_obj_templ : dr_obj_templ_array(0 to nr_calo1_objects-1, 0 to nr_calo2_objects-1) := (others => (others => '0'));
    begin
	dr_obj_templ := (others => (others => '0'));
	removed_objects_mask_or := (others => (others => '0'));
	for i in 0 to nr_calo1_objects-1 loop 
	    for j in 0 to nr_calo2_objects-1 loop
		dr_obj_templ(i,j) := calo1_delta_r_obj_vs_templ_pipe(i,1) and calo2_delta_r_obj_vs_templ_pipe(j,1) and dr_comp_pipe(i,j);
		removed_objects_mask_or(i,j) := removed_objects_mask_or(i,j) or dr_obj_templ(i,j);
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

    -- *** section: Delta-R - end ***************************************************************************************
    
    -- *** section: Correlations - begin ***************************************************************************************
    delta_l_1: for i in 0 to nr_calo1_objects-1 generate 
	delta_l_2: for j in 0 to nr_calo2_objects-1 generate
	    deta_diff_i: if deta_cut = true generate
		diff_eta_comp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit_int and diff_eta(i,j) <= diff_eta_upper_limit_int and removed_objects_mask_pipe(i,j) = '0' else '0';
	    end generate deta_diff_i;
	    dphi_diff_i: if dphi_cut = true generate
		diff_phi_comp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit_int and diff_phi(i,j) <= diff_phi_upper_limit_int and removed_objects_mask_pipe(i,j) = '0' else '0';
	    end generate dphi_diff_i;
	    mass_i: if mass_cut = true generate
		mass_calculator_i: entity work.mass_cuts
		    generic map(
			mass_type => mass_type,
			mass_upper_limit => mass_upper_limit,
			mass_lower_limit => mass_lower_limit,
			pt1_width => pt1_width, 
			pt2_width => pt2_width, 
			cosh_cos_width => cosh_cos_width,
			MASS_PRECISION => MASS_PRECISION,
			MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
			pt_sq_threshold => pt_sq_threshold,
			sin_cos_width => sin_cos_width,
			PT_PRECISION => PT_PRECISION,
			PT_SQ_SIN_COS_PRECISION => PT_SQ_SIN_COS_PRECISION
		    )
		    port map(
			pt1 => pt1(i)(pt1_width-1 downto 0),
			pt2 => pt2(j)(pt2_width-1 downto 0),
			cosh_deta => cosh_deta(i,j),
			cos_dphi => cos_dphi(i,j),
			cos_phi_1 => cos_phi_1(i),
			cos_phi_2 => cos_phi_2(j),
			sin_phi_1 => sin_phi_1(i),
			sin_phi_2 => sin_phi_2(j),
			mass_comp => mass_comp_temp(i,j)
		    );
		mass_comp(i,j) <= mass_comp_temp(i,j) and not removed_objects_mask_pipe(i,j);
	    end generate mass_i;
	end generate delta_l_2;
    end generate delta_l_1;
    
    -- Pipeline stage for diff_eta_comp, diff_phi_comp, dr_comp and mass_comp
    diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp, mass_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                if deta_cut = true and dphi_cut = false and mass_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                elsif deta_cut = false and dphi_cut = true and mass_cut = false then
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = true and dphi_cut = true and mass_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = false and dphi_cut = false and mass_cut = true then
                    mass_comp_pipe <= mass_comp;
                end if;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    if deta_cut = true and dphi_cut = false and mass_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                    elsif deta_cut = false and dphi_cut = true and mass_cut = false then
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = true and dphi_cut = true and mass_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = false and dphi_cut = false and mass_cut = true then
                        mass_comp_pipe <= mass_comp;
                    end if;
                end if;
            end if;
    end process;

    -- Instance of comparators for calorimeter objects.
    calo1_obj_l: for i in 0 to nr_calo1_objects-1 generate
	calo1_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo1, obj_type_calo1,
		et_threshold_calo1,
		eta_full_range_calo1,
		eta_w1_upper_limit_calo1,
		eta_w1_lower_limit_calo1,
		eta_w2_ignore_calo1,
		eta_w2_upper_limit_calo1,
		eta_w2_lower_limit_calo1,
		phi_full_range_calo1,
		phi_w1_upper_limit_calo1,
		phi_w1_lower_limit_calo1,
		phi_w2_ignore_calo1,
		phi_w2_upper_limit_calo1,
		phi_w2_lower_limit_calo1,
	      iso_lut_calo1
	  )
	  port map(calo1_correlation(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    calo2_obj_l: for i in 0 to nr_calo2_objects-1 generate
	calo2_comp_i: entity work.calo_comparators_v2
	    generic map(et_ge_mode_calo2, obj_type_calo2,
                et_threshold_calo2,
                eta_full_range_calo2,
                eta_w1_upper_limit_calo2,
                eta_w1_lower_limit_calo2,
                eta_w2_ignore_calo2,
                eta_w2_upper_limit_calo2,
                eta_w2_lower_limit_calo2,
                phi_full_range_calo2,
                phi_w1_upper_limit_calo2,
                phi_w1_lower_limit_calo2,
                phi_w2_ignore_calo2,
                phi_w2_upper_limit_calo2,
                phi_w2_lower_limit_calo2,
                iso_lut_calo2
	    )
	    port map(calo2_correlation(i), calo2_obj_vs_templ(i,1));
    end generate calo2_obj_l;

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ)
	begin
	if obj_vs_templ_pipeline_stage = false then 
	    calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
	    calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
	else
	    if (lhc_clk'event and lhc_clk = '1') then
		calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
		calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
	    end if;
	end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    -- HB 2015-0917: permutations are different for same and different object types. For same object type, only differences of different object indices are compared.

    matrix_deta_dphi_mass_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, mass_comp_pipe)
	variable index : integer := 0;
	variable obj_vs_templ_vec : std_logic_vector((nr_calo1_objects*nr_calo2_objects) downto 1) := (others => '0');
	variable condition_and_or_tmp : std_logic := '0';
    begin
	index := 0;
	obj_vs_templ_vec := (others => '0');
	condition_and_or_tmp := '0';
	for i in 0 to nr_calo1_objects-1 loop 
	    for j in 0 to nr_calo2_objects-1 loop
		if deta_cut = true and dphi_cut = false and mass_cut = false then
		    index := index + 1;
		    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j);
		elsif deta_cut = false and dphi_cut = true and mass_cut = false then
		    index := index + 1;
		    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and diff_phi_comp_pipe(i,j);
		elsif deta_cut = false and dphi_cut = false and mass_cut = true then
		    index := index + 1;
		    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and mass_comp_pipe(i,j);
		elsif deta_cut = true and dphi_cut = true and mass_cut = false then
		    index := index + 1;
		    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j);
		end if;
	    end loop;
	end loop;
	for i in 1 to index loop 
	    -- ORs for matrix
	    condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	end loop;
	condition_and_or <= condition_and_or_tmp;
    end process matrix_deta_dphi_mass_p;

    -- *** section: Correlations - end ***************************************************************************************
        
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
    
    
    
    
    
    
    
    
    
    