
-- Description:

-- Version history:
-- HB 2017-05-10: inserted "twobody_pt" cut for double condition.
-- HB 2017-04-24: inserted "calo2_obj_vs_templ" in and-structure.
-- HB 2017-04-21: wrong typo fixed.
-- HB 2017-04-20: removed "orm mask" (roll back to version from 2017-04-05).
-- HB 2017-04-10: inserted "orm mask" for use in "and structure" of "obj_vs_templ_vec".
-- HB 2017-04-06: max. 6 objects for nr_templates = 3 and nr_templates = 4 are allowed, because of length of "obj_vs_templ_vec".
-- HB 2017-04-05: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_orm is
     generic(
        deta_orm_cut: boolean := false;
        dphi_orm_cut: boolean := false;
        dr_orm_cut: boolean := true;

	calo1_object_low: natural;
        calo1_object_high: natural;
        nr_templates: positive;
        et_ge_mode_calo1: boolean;
	obj_type_calo1 : natural := EG_TYPE; -- eg=0, jet=1, tau=2
        et_thresholds_calo1: calo_templates_array;
        eta_full_range_calo1 : calo_templates_boolean_array;
        eta_w1_upper_limits_calo1: calo_templates_array;
        eta_w1_lower_limits_calo1: calo_templates_array;
        eta_w2_ignore_calo1 : calo_templates_boolean_array;
        eta_w2_upper_limits_calo1: calo_templates_array;
        eta_w2_lower_limits_calo1: calo_templates_array;
        phi_full_range_calo1 : calo_templates_boolean_array;
        phi_w1_upper_limits_calo1: calo_templates_array;
        phi_w1_lower_limits_calo1: calo_templates_array;
        phi_w2_ignore_calo1 : calo_templates_boolean_array;
        phi_w2_upper_limits_calo1: calo_templates_array;
        phi_w2_lower_limits_calo1: calo_templates_array;
        iso_luts_calo1: calo_templates_iso_array;
	
	calo2_object_low: natural;
	calo2_object_high: natural;
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
	iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

	DETA_DPHI_VECTOR_WIDTH: positive;
	DETA_DPHI_ORM_PRECISION: positive;

	diff_eta_orm_upper_limit: diff_eta_range_real;
        diff_eta_orm_lower_limit: diff_eta_range_real;

        diff_phi_orm_upper_limit: diff_phi_range_real;
        diff_phi_orm_lower_limit: diff_phi_range_real;

        dr_orm_upper_limit: dr_squared_range_real;
        dr_orm_lower_limit: dr_squared_range_real;
        
        twobody_pt_cut: boolean := false;
	pt_width: positive; 
	pt_sq_threshold: real;
	sin_cos_width: positive;
	pt_precision : positive;
	pt_sq_sin_cos_precision : positive
    );
    port(
        clk: in std_logic;
        calo1: in calo_objects_array;
        calo2: in calo_objects_array;
        diff_eta_orm: in deta_dphi_vector_array;
        diff_phi_orm: in deta_dphi_vector_array;
        pt : in diff_inputs_array;
        cos_phi_integer : in calo_sin_cos_integer_array;
        sin_phi_integer : in calo_sin_cos_integer_array;
        condition_o: out std_logic;
        sim_obj_vs_templ_vec_single: out std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
        sim_obj_vs_templ_vec_double: out std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo1_object_high-calo1_object_low+1-1)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
        sim_obj_vs_templ_vec_triple: out std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo1_object_high-calo1_object_low+1-1)*(calo1_object_high-calo1_object_low+1-2)
	    *(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0')
    );
end calo_conditions_orm;

architecture rtl of calo_conditions_orm is

    constant nr_calo1_objects_int: natural := calo1_object_high-calo1_object_low+1;
    constant nr_calo2_objects_int: natural := calo2_object_high-calo2_object_low+1;

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

    signal diff_eta_orm_comp, diff_eta_orm_comp_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal diff_eta_orm_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_eta_orm_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_orm_comp, diff_phi_orm_comp_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal diff_phi_orm_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_orm_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal dr_orm_comp, dr_orm_comp_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) := (others => (others => '0'));
    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, 1 to nr_templates) := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1) := (others => (others => '0'));

    signal condition_and_or : std_logic;
    
    signal obj_vs_templ_vec_sig1: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(1023 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(1023 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;

    signal twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : 
	std_logic_2dim_array(calo_object_low to calo_object_high, calo_object_low to calo_object_high) := (others => (others => '1'));

begin

-- HB 2017-04-06: max. 6 objects for nr_templates = 3 and nr_templates = 4 are allowed, because of length of obj_vs_templ_vec
    check_nr_obj_i: if nr_templates = 3 or nr_templates = 4 generate
	assert (nr_calo1_objects_int < 7 and nr_calo2_objects_int < 7) report 
	    "number of objects to high for triple and quad conditions: nr calo1 objects = " & integer'image(nr_calo1_objects_int) & ", nr calo2 objects = " & integer'image(nr_calo2_objects_int) 
	severity failure;	
    end generate check_nr_obj_i;
    
-- Conversion of limits to std_logic_vector.
    diff_eta_orm_upper_limit_int <= conv_std_logic_vector(integer(diff_eta_orm_upper_limit*real(10**DETA_DPHI_ORM_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_eta_orm_lower_limit_int <= conv_std_logic_vector(integer(diff_eta_orm_lower_limit*real(10**DETA_DPHI_ORM_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_orm_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_orm_upper_limit*real(10**DETA_DPHI_ORM_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_orm_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_orm_lower_limit*real(10**DETA_DPHI_ORM_PRECISION)),DETA_DPHI_VECTOR_WIDTH);

-- Instantiation of two-body pt cut.
    twobody_pt_cut_i: if twobody_pt_cut = true and nr_templates = 2 generate
	twobody_pt_l_1: for i in calo1_object_low to calo1_object_high generate 
	    twobody_pt_l_2: for j in calo1_object_low to calo1_object_high generate
		if_j_gr_i: if j > i generate
		    twobody_pt_calculator_i: entity work.twobody_pt_calculator
			generic map(
			    pt1_width => pt_width, 
			    pt2_width => pt_width, 
			    pt_sq_threshold => pt_sq_threshold,
			    sin_cos_width => sin_cos_width,
			    pt_precision => pt_precision,
			    pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
			)
			port map(
			    pt1 => pt(i)(pt_width-1 downto 0),
			    pt2 => pt(j)(pt_width-1 downto 0),
			    cos_phi_1_integer => cos_phi_integer(i),
			    cos_phi_2_integer => cos_phi_integer(j),
			    sin_phi_1_integer => sin_phi_integer(i),
			    sin_phi_2_integer => sin_phi_integer(j),
			    pt_square_comp => twobody_pt_comp_temp(i,j)
		    );
		    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
		    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
		end generate if_j_gr_i;
	    end generate twobody_pt_l_2;
	end generate twobody_pt_l_1;
    end generate twobody_pt_cut_i;
    
-- Instance of comparators for calorimeter objects. All permutations between objects and thresholds/luts.
    obj_l: for i in calo1_object_low to calo1_object_high generate
	templ_l: for j in 1 to nr_templates generate
	    comp_i: entity work.calo_comparators_v2
		generic map(et_ge_mode_calo1, obj_type_calo1,
		    et_thresholds_calo1(j),
		    eta_full_range_calo1(j),
		    eta_w1_upper_limits_calo1(j),
		    eta_w1_lower_limits_calo1(j),
		    eta_w2_ignore_calo1(j),
		    eta_w2_upper_limits_calo1(j),
		    eta_w2_lower_limits_calo1(j),
		    phi_full_range_calo1(j),
		    phi_w1_upper_limits_calo1(j),
		    phi_w1_lower_limits_calo1(j),
		    phi_w2_ignore_calo1(j),
		    phi_w2_upper_limits_calo1(j),
		    phi_w2_lower_limits_calo1(j),
		    iso_luts_calo1(j)
		    )
		port map(calo1(i), calo1_obj_vs_templ(i,j));
	end generate templ_l;
    end generate obj_l;

    calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
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
	    port map(calo2(i), calo2_obj_vs_templ(i,1));
    end generate calo2_obj_l;

    cuts_orm_l_1: for i in calo1_object_low to calo1_object_high generate 
	cuts_orm_l_2: for k in calo2_object_low to calo2_object_high generate
	    deta_orm_cut_i: if deta_orm_cut = true generate
		diff_eta_orm_comp(i,k) <= '1' when diff_eta_orm(i,k) >= diff_eta_orm_lower_limit_int and diff_eta_orm(i,k) <= diff_eta_orm_upper_limit_int else '0';
	    end generate deta_orm_cut_i;
	    dphi_orm_cut_i: if dphi_orm_cut = true generate
		diff_phi_orm_comp(i,k) <= '1' when diff_phi_orm(i,k) >= diff_phi_orm_lower_limit_int and diff_phi_orm(i,k) <= diff_phi_orm_upper_limit_int else '0';
	    end generate dphi_orm_cut_i;
	    dr_orm_cut_i: if dr_orm_cut = true generate
		dr_calculator_i: entity work.dr_calculator_v2
		generic map(
		    upper_limit => dr_orm_upper_limit,
		    lower_limit => dr_orm_lower_limit,
		    DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH,
		    DETA_DPHI_PRECISION => DETA_DPHI_ORM_PRECISION
		)
		port map(
		    diff_eta => diff_eta_orm(i,k),
		    diff_phi => diff_phi_orm(i,k),
		    dr_comp => dr_orm_comp(i,k)
		);
	    end generate dr_orm_cut_i;
	end generate cuts_orm_l_2;
    end generate cuts_orm_l_1;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, calo1_obj_vs_templ, calo2_obj_vs_templ, diff_eta_orm_comp, diff_phi_orm_comp, dr_orm_comp)
	begin
	    if obj_vs_templ_pipeline_stage = false then
		calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
		calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
		diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
		diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
		dr_orm_comp_pipe <= dr_orm_comp;
		twobody_pt_comp_pipe <= twobody_pt_comp;
	    else
		if (clk'event and clk = '1') then
		    calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
		    calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
		    diff_eta_orm_comp_pipe <= diff_eta_orm_comp;
		    diff_phi_orm_comp_pipe <= diff_phi_orm_comp;
		    dr_orm_comp_pipe <= dr_orm_comp;
		    twobody_pt_comp_pipe <= twobody_pt_comp;
		end if;
	    end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "single".
    matrix_single_i: if nr_templates = 1 generate
	matrix_single_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe)
	    variable index : integer := 0;
	    variable obj_vs_templ_vec : std_logic_vector(nr_calo1_objects_int*(calo2_object_high-calo2_object_low+1) downto 1) := (others => '0');
	    variable condition_and_or_tmp : std_logic := '0';
	begin
	    index := 0;
	    obj_vs_templ_vec := (others => '0');
	    condition_and_or_tmp := '0';
	    for i in calo1_object_low to calo1_object_high loop
		for j in calo2_object_low to calo2_object_high loop
		    index := index + 1;
		    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and
					      not (diff_eta_orm_comp_pipe(i,j) and calo2_obj_vs_templ_pipe(j,1)) and 
					      not (diff_phi_orm_comp_pipe(i,j) and calo2_obj_vs_templ_pipe(j,1)) and 
					      not (dr_orm_comp_pipe(i,j) and calo2_obj_vs_templ_pipe(j,1));
		end loop;
	    end loop;
	    for i in 1 to index loop
		condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	    end loop;
	    sim_obj_vs_templ_vec_single <= obj_vs_templ_vec;
	    condition_and_or <= condition_and_or_tmp;
	end process matrix_single_p;
    end generate matrix_single_i;

-- Condition type: "double".
    matrix_double_i: if nr_templates = 2 generate
	matrix_double_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe)
	    variable index : integer := 0;
	    variable obj_vs_templ_vec : std_logic_vector((nr_calo1_objects_int*(nr_calo1_objects_int-1)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
	    variable condition_and_or_tmp : std_logic := '0';
	begin
	    index := 0;
	    obj_vs_templ_vec := (others => '0');
	    condition_and_or_tmp := '0';
	    for i in calo1_object_low to calo1_object_high loop
		for j in calo1_object_low to calo1_object_high loop
		    for k in calo2_object_low to calo2_object_high loop
			if j/=i then
			    index := index + 1;
			    obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo1_obj_vs_templ_pipe(j,2) and calo2_obj_vs_templ_pipe(k,1) and twobody_pt_comp_pipe(i,j) and
						      not (diff_eta_orm_comp_pipe(i,k) and calo2_obj_vs_templ_pipe(k,1)) and 
						      not (diff_eta_orm_comp_pipe(j,k) and calo2_obj_vs_templ_pipe(k,1)) and 
						      not (diff_phi_orm_comp_pipe(i,k) and calo2_obj_vs_templ_pipe(k,1)) and 
						      not (diff_phi_orm_comp_pipe(j,k) and calo2_obj_vs_templ_pipe(k,1)) and 
						      not (dr_orm_comp_pipe(i,k) and calo2_obj_vs_templ_pipe(k,1)) and 
						      not (dr_orm_comp_pipe(j,k) and calo2_obj_vs_templ_pipe(k,1)); 
			end if;
		    end loop;
		end loop;
	    end loop;
	    for i in 1 to index loop
		condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	    end loop;
	    sim_obj_vs_templ_vec_double <= obj_vs_templ_vec;
	    condition_and_or <= condition_and_or_tmp;
	end process matrix_double_p;
    end generate matrix_double_i;

-- HB 2017-04-06: max. 6 objects for nr_templates = 3 are allowed, because of length of obj_vs_templ_vec. Max length = (6*5*4)*6 = 720
-- Condition type: "triple".
    matrix_triple_i: if nr_templates = 3 generate
	matrix_triple_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe)
	    variable index : integer := 0;
	    variable obj_vs_templ_vec : std_logic_vector((nr_calo1_objects_int*(nr_calo1_objects_int-1)*(nr_calo1_objects_int-2)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
	    variable condition_and_or_tmp : std_logic := '0';
	begin
	    index := 0;
	    obj_vs_templ_vec := (others => '0');
	    condition_and_or_tmp := '0';
	    for i in calo1_object_low to calo1_object_high loop
		for j in calo1_object_low to calo1_object_high loop
		    for k in calo1_object_low to calo1_object_high loop
			for l in calo2_object_low to calo2_object_high loop
			    if (j/=i and k/=i and k/=j) then
				index := index + 1;
				obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo1_obj_vs_templ_pipe(j,2) and calo1_obj_vs_templ_pipe(k,3) and calo2_obj_vs_templ_pipe(l,1) and
							  not (diff_eta_orm_comp_pipe(i,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (diff_eta_orm_comp_pipe(j,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (diff_eta_orm_comp_pipe(k,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (diff_phi_orm_comp_pipe(i,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (diff_phi_orm_comp_pipe(j,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (diff_phi_orm_comp_pipe(k,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (dr_orm_comp_pipe(i,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (dr_orm_comp_pipe(j,l) and calo2_obj_vs_templ_pipe(l,1)) and 
							  not (dr_orm_comp_pipe(k,l) and calo2_obj_vs_templ_pipe(l,1));
			    end if;
			end loop;
		    end loop;
		end loop;
	    end loop;
	    for i in 1 to index loop
		condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	    end loop;
	    sim_obj_vs_templ_vec_triple <= obj_vs_templ_vec;
	    condition_and_or <= condition_and_or_tmp;
	end process matrix_triple_p;
    end generate matrix_triple_i;

-- HB 2017-04-06: max. 6 objects for nr_templates = 4 are allowed, because of length of obj_vs_templ_vec. Max length = (6*5*4*3)*6 = 2160 ==> 2160/1024 = 2,11 ==> 3 obj_vs_templ_vecs.
-- Condition type: "quad".
    matrix_quad_i: if nr_templates = 4 generate
	matrix_quad_p_1: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, diff_eta_orm_comp_pipe, diff_phi_orm_comp_pipe, dr_orm_comp_pipe)
	    variable index : integer := 0;
	    variable index2 : integer := 0;
	    variable test_index : integer := 0;
	    variable obj_vs_templ_vec1  : std_logic_vector(1023 downto 0) := (others => '0');
	    variable obj_vs_templ_vec2  : std_logic_vector(1023 downto 0) := (others => '0');
	    variable obj_vs_templ_vec3  : std_logic_vector(1023 downto 0) := (others => '0');
	begin
	    index := 0;
	    index2 := 0;
	    test_index := 0;
	    obj_vs_templ_vec1  := (others => '0');
	    obj_vs_templ_vec2  := (others => '0');
	    obj_vs_templ_vec3  := (others => '0');
	    for i in calo1_object_low to calo1_object_high loop
		for j in calo1_object_low to calo1_object_high loop
		    for k in calo1_object_low to calo1_object_high loop
			for l in calo1_object_low to calo1_object_high loop
			    for m in calo2_object_low to calo2_object_high loop
				if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
				    if((index mod 1024) = 0) then
					if(index /= 0) then
					    index2 := 0;
					    test_index := test_index + 1;
					end if;
				    end if;
				    if(test_index = 0) then
					obj_vs_templ_vec1(index2) := calo1_obj_vs_templ_pipe(i,1) and calo1_obj_vs_templ_pipe(j,2) and calo1_obj_vs_templ_pipe(k,3) and calo1_obj_vs_templ_pipe(l,4) and
								    calo2_obj_vs_templ_pipe(m,1) and
								    not (diff_eta_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)); 
				    elsif(test_index = 1) then
					obj_vs_templ_vec2(index2) := calo1_obj_vs_templ_pipe(i,1) and calo1_obj_vs_templ_pipe(j,2) and calo1_obj_vs_templ_pipe(k,3) and calo1_obj_vs_templ_pipe(l,4) and
								    calo2_obj_vs_templ_pipe(m,1) and
								    not (diff_eta_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)); 
				    elsif(test_index = 2) then
					obj_vs_templ_vec3(index2) := calo1_obj_vs_templ_pipe(i,1) and calo1_obj_vs_templ_pipe(j,2) and calo1_obj_vs_templ_pipe(k,3) and calo1_obj_vs_templ_pipe(l,4) and
								    calo2_obj_vs_templ_pipe(m,1) and
								    not (diff_eta_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_eta_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (diff_phi_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(i,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(j,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(k,m) and calo2_obj_vs_templ_pipe(m,1)) and 
								    not (dr_orm_comp_pipe(l,m) and calo2_obj_vs_templ_pipe(m,1)); 
				    end if;
				    index := index + 1;
				    index2 := index2 +1;
				end if;
			    end loop;
			end loop;
		    end loop;
		end loop;
	    end loop;
	    obj_vs_templ_vec_sig1 <= obj_vs_templ_vec1;
	    obj_vs_templ_vec_sig2 <= obj_vs_templ_vec2;
	    obj_vs_templ_vec_sig3 <= obj_vs_templ_vec3;
	end process matrix_quad_p_1;

	matrix_quad_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3)
	    variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3 : std_logic := '0';
	begin
	    condition_and_or_tmp1  := '0';
	    condition_and_or_tmp2  := '0';
	    condition_and_or_tmp3  := '0';
	    for i in 0 to 1023 loop
		condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
		condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
		condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
	    end loop;
	    condition_and_or_sig1 <= condition_and_or_tmp1;
	    condition_and_or_sig2 <= condition_and_or_tmp2;
	    condition_and_or_sig3 <= condition_and_or_tmp3;
	end process matrix_quad_p_2;
	condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3;
    end generate matrix_quad_i;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(clk, condition_and_or)
	begin
	    if conditions_pipeline_stage = false then
		condition_o <= condition_and_or;
	    else
		if (clk'event and clk = '1') then
		    condition_o <= condition_and_or;
		end if;
	    end if;
    end process;

end architecture rtl;
