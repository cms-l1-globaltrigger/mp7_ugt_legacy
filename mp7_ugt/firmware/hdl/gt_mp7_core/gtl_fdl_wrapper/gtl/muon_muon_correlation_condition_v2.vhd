
-- Desription:
-- Correlation Condition module for muon objects.

-- Definition of mass_type:
-- 0 => invariant mass
-- 1 => invariant mass with pt cut
-- 2 => transverse mass
-- 3 => transverse mass with pt cut

-- Version history:
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations only for one half of permutations, second half by assignment of "mirrored" indices
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "muon_object_low" and "muon_object_high" for object ranges.
-- HB 2017-01-20: used only "pt_width" generic parameter instead of "pt_width_1" and "pt_width_2".
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2017-01-18: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_correlation_condition_v2 is
     generic(
	same_bx: boolean := true; 
	
        deta_cut: boolean := true;
        dphi_cut: boolean := true;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
	mass_type : natural := 0;

	muon_object_low: natural;
        muon_object_high: natural;
--         nr_muon_objects: positive;
        pt_ge_mode_muon1: boolean;
        pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon1: boolean;
        eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon1: boolean;
        eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon1: boolean;
        phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon1: boolean;
        phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon1: string(1 to 3);
        qual_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);
        
        pt_ge_mode_muon2: boolean;
        pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon2: boolean;
        eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon2: boolean;
        eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon2: boolean;
        phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon2: boolean;
        phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon2: string(1 to 3);
        qual_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);
        
        requested_charge_correlation: string(1 to 2);

        diff_eta_upper_limit: diff_eta_range_real;
        diff_eta_lower_limit: diff_eta_range_real;

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;
        
	DETA_DPHI_VECTOR_WIDTH: positive ;
	DETA_DPHI_PRECISION: positive;

        mass_upper_limit: real;
        mass_lower_limit: real;
        
        MASS_PRECISION: positive;
	pt_width: positive; 
	MASS_COSH_COS_PRECISION : positive;
	cosh_cos_width: positive;
	
	pt_sq_threshold: real;
	sin_cos_width: positive;
	PT_PRECISION : positive;
	PT_SQ_SIN_COS_PRECISION : positive

    );
    port(
        lhc_clk: in std_logic;
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
	cosh_deta : in muon_cosh_cos_vector_array;
        cos_dphi : in muon_cosh_cos_vector_array;
        cos_phi_1_integer : in muon_sin_cos_integer_array;
        cos_phi_2_integer : in muon_sin_cos_integer_array;
        sin_phi_1_integer : in muon_sin_cos_integer_array;
        sin_phi_2_integer : in muon_sin_cos_integer_array;
        condition_o: out std_logic
    );
end muon_muon_correlation_condition_v2; 

architecture rtl of muon_muon_correlation_condition_v2 is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type object_vs_template_array is array (muon_object_low to muon_object_high, 1 to 2) of std_logic;
    type muon_object_vs_template_array is array (muon_object_low to muon_object_high, 1 to 1) of std_logic;
    type diff_comp_array is array (muon_object_low to muon_object_high, muon_object_low to muon_object_high) of std_logic;

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--***************************************************************

    signal diff_eta_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_eta_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    
    signal diff_phi_upper_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    signal diff_phi_lower_limit_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH-1 downto 0);
    
    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
    signal muon1_obj_vs_templ : muon_object_vs_template_array;
    signal muon1_obj_vs_templ_pipe : muon_object_vs_template_array;
    signal muon2_obj_vs_templ : muon_object_vs_template_array;
    signal muon2_obj_vs_templ_pipe : muon_object_vs_template_array;
    signal diff_eta_comp : diff_comp_array := (others => (others => '1'));
    signal diff_eta_comp_temp : diff_comp_array := (others => (others => '1'));
    signal diff_eta_comp_pipe : diff_comp_array := (others => (others => '1'));
    signal diff_phi_comp : diff_comp_array := (others => (others => '1'));
    signal diff_phi_comp_temp : diff_comp_array := (others => (others => '1'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '1'));
    signal dr_comp : diff_comp_array := (others => (others => '1'));
    signal dr_comp_temp : diff_comp_array := (others => (others => '1'));
    signal dr_comp_pipe : diff_comp_array := (others => (others => '1'));
    signal mass_comp : diff_comp_array := (others => (others => '1'));
    signal mass_comp_temp : diff_comp_array := (others => (others => '1'));
    signal mass_comp_pipe : diff_comp_array := (others => (others => '1'));

    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************
    -- Conversion of limits to std_logic_vector.
    diff_eta_upper_limit_int <= conv_std_logic_vector(integer(diff_eta_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_eta_lower_limit_int <= conv_std_logic_vector(integer(diff_eta_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_upper_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_lower_limit*real(10**DETA_DPHI_PRECISION)),DETA_DPHI_VECTOR_WIDTH);

    -- Comparison with limits.
    delta_l_1: for i in muon_object_low to muon_object_high generate 
	delta_l_2: for j in muon_object_low to muon_object_high generate
	    same_bx_i: if same_bx generate
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations of cuts only for one half of permutations, second half by assignment of "mirrored" indices.
		if_j_gr_i: if j > i generate
		    deta_diff_i: if deta_cut = true generate
			diff_eta_comp_temp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit_int and diff_eta(i,j) <= diff_eta_upper_limit_int else '0';
			diff_eta_comp(i,j) <= diff_eta_comp_temp(i,j);
			diff_eta_comp(j,i) <= diff_eta_comp_temp(i,j);
		    end generate deta_diff_i;		    
		    dphi_diff_i: if dphi_cut = true generate
			diff_phi_comp_temp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit_int and diff_phi(i,j) <= diff_phi_upper_limit_int else '0';
			diff_phi_comp(i,j) <= diff_phi_comp_temp(i,j);
			diff_phi_comp(j,i) <= diff_phi_comp_temp(i,j);
		    end generate dphi_diff_i;
		    dr_i: if dr_cut = true generate
			dr_calculator_i: entity work.dr_calculator_v2
			    generic map(
				upper_limit => dr_upper_limit,
				lower_limit => dr_lower_limit,
				DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH,
				DETA_DPHI_PRECISION => DETA_DPHI_PRECISION
			    )
			    port map(
				diff_eta => diff_eta(i,j),
				diff_phi => diff_phi(i,j),
				dr_comp => dr_comp_temp(i,j)
			    );
			dr_comp(i,j) <= dr_comp_temp(i,j);
			dr_comp(j,i) <= dr_comp_temp(i,j);
		    end generate dr_i;
		    mass_i: if mass_cut = true generate
			mass_calculator_i: entity work.mass_cuts
			    generic map(
				mass_type => mass_type,
				mass_upper_limit => mass_upper_limit,
				mass_lower_limit => mass_lower_limit,
				pt1_width => pt_width, 
				pt2_width => pt_width, 
				cosh_cos_width => cosh_cos_width,
				MASS_PRECISION => MASS_PRECISION,
				MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
				pt_sq_threshold => pt_sq_threshold,
				sin_cos_width => sin_cos_width,
				PT_PRECISION => PT_PRECISION,
				PT_SQ_SIN_COS_PRECISION => PT_SQ_SIN_COS_PRECISION
			    )
			    port map(
				pt1 => pt1(i)(pt_width-1 downto 0),
				pt2 => pt2(j)(pt_width-1 downto 0),
				cosh_deta => cosh_deta(i,j),
				cos_dphi => cos_dphi(i,j),
				cos_phi_1_integer => cos_phi_1_integer(i),
				cos_phi_2_integer => cos_phi_2_integer(j),
				sin_phi_1_integer => sin_phi_1_integer(i),
				sin_phi_2_integer => sin_phi_2_integer(j),
				mass_comp => mass_comp_temp(i,j)
			    );
			mass_comp(i,j) <= mass_comp_temp(i,j);
			mass_comp(j,i) <= mass_comp_temp(i,j);
		    end generate mass_i;
		end generate if_j_gr_i;
	    end generate same_bx_i;
	    different_bx_i: if (not same_bx) generate
		deta_diff_i: if deta_cut = true generate
		    diff_eta_comp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit_int and diff_eta(i,j) <= diff_eta_upper_limit_int else '0';
		end generate deta_diff_i;
		dphi_diff_i: if dphi_cut = true generate
		    diff_phi_comp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit_int and diff_phi(i,j) <= diff_phi_upper_limit_int else '0';
		end generate dphi_diff_i;
		dr_i: if dr_cut = true generate
		    dr_calculator_i: entity work.dr_calculator_v2
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
		end generate dr_i;
		mass_i: if mass_cut = true generate
		    mass_calculator_i: entity work.mass_cuts
			generic map(
			    mass_type => mass_type,
			    mass_upper_limit => mass_upper_limit,
			    mass_lower_limit => mass_lower_limit,
			    pt1_width => pt_width, 
			    pt2_width => pt_width, 
			    cosh_cos_width => cosh_cos_width,
			    MASS_PRECISION => MASS_PRECISION,
			    MASS_COSH_COS_PRECISION => MASS_COSH_COS_PRECISION,
			    pt_sq_threshold => pt_sq_threshold,
			    sin_cos_width => sin_cos_width,
			    PT_PRECISION => PT_PRECISION,
			    PT_SQ_SIN_COS_PRECISION => PT_SQ_SIN_COS_PRECISION
			)
			port map(
			    pt1 => pt1(i)(pt_width-1 downto 0),
			    pt2 => pt2(j)(pt_width-1 downto 0),
			    cosh_deta => cosh_deta(i,j),
			    cos_dphi => cos_dphi(i,j),
			    cos_phi_1_integer => cos_phi_1_integer(i),
			    cos_phi_2_integer => cos_phi_2_integer(j),
			    sin_phi_1_integer => sin_phi_1_integer(i),
			    sin_phi_2_integer => sin_phi_2_integer(j),
			    mass_comp => mass_comp(i,j)
			);
		end generate mass_i;
	    end generate different_bx_i;
        end generate delta_l_2;
    end generate delta_l_1;

    -- Pipeline stage for diff_eta_comp, diff_phi_comp, dr_comp and mass_comp
    diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp, dr_comp, mass_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            diff_eta_comp_pipe <= diff_eta_comp;
            diff_phi_comp_pipe <= diff_phi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                diff_eta_comp_pipe <= diff_eta_comp;
                diff_phi_comp_pipe <= diff_phi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    -- *** section: objects vs requirements for same bx - begin ******************************************************
    obj_same_bx_l: if same_bx = true generate
        obj_templ1_l: for i in muon_object_low to muon_object_high generate
            obj_templ1_comp_i: entity work.muon_comparators_v2
                generic map(pt_ge_mode_muon1,
                    pt_threshold_muon1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                    eta_full_range_muon1,
                    eta_w1_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w1_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_ignore_muon1,
                    eta_w2_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    phi_full_range_muon1,
                    phi_w1_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w1_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_ignore_muon1,
                    phi_w2_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    requested_charge_muon1,
                    qual_lut_muon1,
                    iso_lut_muon1
	   	)
                port map(muon1_data_i(i), obj_vs_templ(i,1));
        end generate obj_templ1_l;

        obj_templ2_l_l: for i in muon_object_low to muon_object_high generate
            obj_templ2_comp_i: entity work.muon_comparators_v2
                generic map(pt_ge_mode_muon2,
                    pt_threshold_muon2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                    eta_full_range_muon2,
                    eta_w1_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w1_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_ignore_muon2,
                    eta_w2_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    phi_full_range_muon2,
                    phi_w1_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w1_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_ignore_muon2,
                    phi_w2_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    requested_charge_muon2,
                    qual_lut_muon2,
                    iso_lut_muon2
	   	)
                port map(muon1_data_i(i), obj_vs_templ(i,2));
        end generate obj_templ2_l_l;

	-- Pipeline stage for obj_vs_templ
	obj_vs_templ_pipeline_p: process(lhc_clk, obj_vs_templ)
	    begin
		if obj_vs_templ_pipeline_stage = false then 
		    obj_vs_templ_pipe <= obj_vs_templ;
		else
		    if (lhc_clk'event and lhc_clk = '1') then
			obj_vs_templ_pipe <= obj_vs_templ;
		    end if;
		end if;
	end process;

	-- Charge correlation comparison
        charge_double_l_1: for i in muon_object_low to muon_object_high generate 
            charge_double_l_2: for j in muon_object_low to muon_object_high generate
                charge_double_if: if j/=i generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                               '1' when requested_charge_correlation = "ig" else
                                               '0';
                end generate charge_double_if;
            end generate charge_double_l_2;
        end generate charge_double_l_1;

        -- Pipeline stage for charge correlation comparison
        charge_comp_2_pipeline_p: process(lhc_clk, charge_comp_double)
            begin
                if obj_vs_templ_pipeline_stage = false then 
                    charge_comp_double_pipe <= charge_comp_double;
                else
                    if (lhc_clk'event and lhc_clk = '1') then
                        charge_comp_double_pipe <= charge_comp_double;
                    end if;
                end if;
        end process;
         
	-- "Matrix" of permutations in an and-or-structure.
        matrix_p: process(obj_vs_templ_pipe, charge_comp_double_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, mass_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((muon_object_high-muon_object_low+1)*(muon_object_high-muon_object_low+1) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_low to muon_object_high loop 
                for j in muon_object_low to muon_object_high loop
                    if j/=i then
			index := index + 1;
			obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and charge_comp_double_pipe(i,j) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j)
						   and dr_comp_pipe(i,j) and mass_comp_pipe(i,j);
		    end if;
		end loop;
	    end loop;
	    for i in 1 to index loop 
		-- ORs for matrix
		condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	    end loop;
	    condition_and_or <= condition_and_or_tmp;
	end process matrix_p;
    end generate obj_same_bx_l;
    -- *** section: objects vs requirements for same bx - end ******************************************************

    -- *** section: objects vs requirements for different bx - begin ***********************************************
    obj_different_bx_l: if same_bx = false generate
        -- Instance of comparators for muon objects.
        muon1_templ1_l: for i in muon_object_low to muon_object_high generate
            muon1_templ1_l_comp_i: entity work.muon_comparators_v2
                generic map(pt_ge_mode_muon1,
                    pt_threshold_muon1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                    eta_full_range_muon1,
                    eta_w1_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w1_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_ignore_muon1,
                    eta_w2_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    phi_full_range_muon1,
                    phi_w1_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w1_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_ignore_muon1,
                    phi_w2_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    requested_charge_muon1,
                    qual_lut_muon1,
                    iso_lut_muon1
	   	)
                port map(muon1_data_i(i), muon1_obj_vs_templ(i,1));
        end generate muon1_templ1_l;

        muon2_templ1_l: for i in muon_object_low to muon_object_high generate
            muon2_templ1_comp_i: entity work.muon_comparators_v2
                generic map(pt_ge_mode_muon2,
                    pt_threshold_muon2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                    eta_full_range_muon2,
                    eta_w1_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w1_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_ignore_muon2,
                    eta_w2_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    eta_w2_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                    phi_full_range_muon2,
                    phi_w1_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w1_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_ignore_muon2,
                    phi_w2_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    phi_w2_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                    requested_charge_muon2,
                    qual_lut_muon2,
                    iso_lut_muon2
	   	)
                port map(muon2_data_i(i), muon2_obj_vs_templ(i,1));
        end generate muon2_templ1_l;

        -- Pipeline stage for obj_vs_templ
        obj_vs_templ_pipeline_p: process(lhc_clk, muon1_obj_vs_templ, muon2_obj_vs_templ)
            begin
            if obj_vs_templ_pipeline_stage = false then 
                muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
                muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
                    muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
                end if;
            end if;
        end process;
        
	-- "Matrix" of permutations in an and-or-structure.
        matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, mass_comp_pipe)
            variable index : integer := 0;
            variable obj_vs_templ_vec : std_logic_vector((muon_object_high-muon_object_low+1)*(muon_object_high-muon_object_low+1) downto 1) := (others => '0');
            variable condition_and_or_tmp : std_logic := '0';
        begin
            index := 0;
            obj_vs_templ_vec := (others => '0');
            condition_and_or_tmp := '0';
            for i in muon_object_low to muon_object_high loop 
                for j in muon_object_low to muon_object_high loop
		    index := index + 1;
		    obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j)
					       and dr_comp_pipe(i,j) and mass_comp_pipe(i,j);
		end loop;
	    end loop;
	    for i in 1 to index loop 
		-- ORs for matrix
		condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
	    end loop;
	    condition_and_or <= condition_and_or_tmp;
	end process matrix_p;
    end generate obj_different_bx_l;
    -- *** section: objects vs requirements for different bx - end ***********************************************

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
    
    
    
    
    
    
    
    
    
    