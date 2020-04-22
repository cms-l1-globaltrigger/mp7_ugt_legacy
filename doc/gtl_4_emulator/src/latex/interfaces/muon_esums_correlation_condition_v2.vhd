entity muon_esums_correlation_condition_v2 is
     generic(

        dphi_cut: boolean := true;
        mass_cut: boolean := false;
	mass_type : natural := 2;

	muon_object_low: natural;
        muon_object_high: natural;
        pt_ge_mode_muon: boolean;
        pt_threshold_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon : boolean;
        eta_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon : boolean;
        eta_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon : boolean;
        phi_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon : boolean;
        phi_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon: string(1 to 3);
        qual_lut_muon: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

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
	sin_cos_width_1: positive; -- for pt**2 calculation
	sin_cos_width_2: positive; -- for pt**2 calculation
	PT_PRECISION : positive;
	PT_SQ_SIN_COS_PRECISION : positive

    );
    port(
        lhc_clk: in std_logic;
        muon_data_i: in muon_objects_array;
        esums_data_i: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
        cos_dphi : in calo_muon_cosh_cos_vector_array;
        cos_phi_1 : in muon_sin_cos_vector_array;
        cos_phi_2 : in calo_sin_cos_vector_array;
        sin_phi_1 : in muon_sin_cos_vector_array;
        sin_phi_2 : in calo_sin_cos_vector_array;
        condition_o: out std_logic
    );
end muon_esums_correlation_condition_v2;







