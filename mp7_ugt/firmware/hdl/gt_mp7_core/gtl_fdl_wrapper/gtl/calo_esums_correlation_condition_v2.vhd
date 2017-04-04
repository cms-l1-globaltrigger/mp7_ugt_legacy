
-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and esums (etm, etm_hf and htm).

-- Definition of mass_type for calo-esums:
-- 2 => transverse mass
-- 3 => transverse mass with pt cut

-- Version history:
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DPHI). Using integer for cos and sin phi inputs.
-- HB 2017-02-01: used "calo_object_low" and "calo_object_high" for object ranges.
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2016-12-20: first design of version 2 - implemented transverse mass

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_esums_correlation_condition_v2 is
     generic(

        dphi_cut: boolean := true;
        mass_cut: boolean := false;
	mass_type : natural := 2;

        calo_object_low: natural;
        calo_object_high: natural;
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
	obj_type_esums: natural := ETM_TYPE;
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
	DETA_DPHI_PRECISION: positive;

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
        calo_data_i: in calo_objects_array;
        esums_data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
        cos_dphi : in calo_cosh_cos_vector_array;
        cos_phi_1_integer : in calo_sin_cos_integer_array;
        cos_phi_2_integer : in calo_sin_cos_integer_array;
        sin_phi_1_integer : in calo_sin_cos_integer_array;
        sin_phi_2_integer : in calo_sin_cos_integer_array;
        condition_o: out std_logic
    );
end calo_esums_correlation_condition_v2;

architecture rtl of calo_esums_correlation_condition_v2 is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    type object_vs_template_array is array (calo_object_low to calo_object_high, 1 to 1) of std_logic;
    type diff_comp_array is array (calo_object_low to calo_object_high, 0 to 0) of std_logic;

    signal diff_phi_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);

    signal cosh_deta_zero_vector: calo_cosh_cos_vector_array(calo_object_low to calo_object_high, 0 to 0) := (others => (others => (others => '0')));

    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal mass_comp : diff_comp_array;
    signal mass_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal esums_comp_o, esums_comp_o_pipe : std_logic;
    signal condition_and_or : std_logic;

begin

-- HB 2016-12-20: only transverse mass could be calculated with esums
    assert (mass_cut and mass_type = 2) or (mass_cut and mass_type = 3) report 
	"mass selection not valid: mass_type = " & integer'image(mass_type) & ", which means one of invariant mass types (but, only transverse mass types are valid)" 
    severity failure;	

    -- *** section: CUTs - begin ***************************************************************************************
    -- Conversion of limits to std_logic_vector.
    diff_phi_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);

    -- Comparison with limits.
    delta_l: for i in calo_object_low to calo_object_high generate
	diff_phi_i: if dphi_cut = true generate
	    diff_phi_comp(i,0) <= '1' when diff_phi(i,0) >= diff_phi_lower_limit_int and diff_phi(i,0) <= diff_phi_upper_limit_int else '0';
	end generate diff_phi_i;
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
		    pt2 => pt2(0)(pt2_width-1 downto 0),
		    cosh_deta => cosh_deta_zero_vector(i,0),
		    cos_dphi => cos_dphi(i,0),
		    cos_phi_1_integer => cos_phi_1_integer(i),
		    cos_phi_2_integer => cos_phi_2_integer(0),
		    sin_phi_1_integer => sin_phi_1_integer(i),
		    sin_phi_2_integer => sin_phi_2_integer(0),
		    mass_comp => mass_comp(i,0)
		);
	end generate mass_i;
    end generate delta_l;

    -- Pipeline stage for diff_phi_comp
    diff_pipeline_p: process(lhc_clk, diff_phi_comp)
    begin
        if obj_vs_templ_pipeline_stage = false then
	    diff_phi_comp_pipe <= diff_phi_comp;
	    mass_comp_pipe <= mass_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
		diff_phi_comp_pipe <= diff_phi_comp;
		mass_comp_pipe <= mass_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    obj_templ1_l: for i in calo_object_low to calo_object_high generate
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
    obj_vs_templ_pipeline_p: process(lhc_clk, obj_vs_templ, esums_comp_o)
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
    matrix_dphi_mass_p: process(obj_vs_templ_pipe, esums_comp_o_pipe, diff_phi_comp_pipe, mass_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((calo_object_high-calo_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high-1 loop
	    if dphi_cut = true and mass_cut = false then
		index := index + 1;
		obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and esums_comp_o_pipe and diff_phi_comp_pipe(i,0);
	    elsif dphi_cut = false and mass_cut = true then
		index := index + 1;
		obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and esums_comp_o_pipe and mass_comp_pipe(i,0);
	    elsif dphi_cut = true and mass_cut = true then
		index := index + 1;
		obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and esums_comp_o_pipe and diff_phi_comp_pipe(i,0) and mass_comp_pipe(i,0);
	    end if;
        end loop;
        for i in 1 to index loop
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_dphi_mass_p;

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








