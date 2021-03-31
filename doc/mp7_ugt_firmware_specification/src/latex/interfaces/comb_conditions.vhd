entity comb_conditions is
     generic(

        slice_1_low_obj1: natural := 0;
        slice_1_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_2_low_obj1: natural := 0;
        slice_2_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_3_low_obj1: natural := 0;
        slice_3_high_obj1: natural := NR_MU_OBJECTS-1;
        slice_4_low_obj1: natural := 0;
        slice_4_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_thresholds_obj1: common_templates_array := (others => (others => '0'));
        nr_eta_windows_obj1: common_templates_natural_array := (others => 0);
        eta_w1_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w1_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w2_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w2_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w3_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w3_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w4_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w4_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w5_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        eta_w5_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        nr_phi_windows_obj1: common_templates_natural_array := (others => 0);
        phi_w1_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w1_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w2_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        phi_w2_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        iso_luts_obj1: common_templates_iso_array := (others => (others => '1'));
        requested_charges_obj1: common_templates_string_array := (others => "ign");
        qual_luts_obj1: common_templates_quality_array := (others => (others => '1'));
        upt_cuts_obj1: common_templates_boolean_array := (others => false);
        upt_upper_limits_obj1: common_templates_array := (others => (others => '0'));
        upt_lower_limits_obj1: common_templates_array := (others => (others => '0'));
        ip_luts_obj1: common_templates_ip_array := (others => (others => '1'));

        requested_charge_correlation: string(1 to 2) := "ig";

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_TAU_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2: natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj2: natural := 0;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj2: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');

        twobody_pt_cut: boolean := false;
        pt_width: positive := EG_PT_VECTOR_WIDTH;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        twobody_upt_cut: boolean := false;
        upt_width: positive := MU_UPT_VECTOR_WIDTH;
        upt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1 : natural := EG_TYPE;
        nr_obj2: natural := NR_TAU_OBJECTS;
        type_obj2 : natural := TAU_TYPE;
        nr_templates: positive := COMMON_NR_TEMPLATES

    );
    port(
        lhc_clk: in std_logic;
        obj1_calo: in calo_objects_array(0 to nr_obj1-1) := (others => (others => '0'));
        obj1_muon: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        obj2: in calo_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        deta_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt : in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        condition_o: out std_logic
    );
end comb_conditions;
