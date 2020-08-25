entity muon_conditions is
    generic (
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        pt_ge_mode : boolean;
        pt_thresholds: muon_templates_array;
        nr_eta_windows : muon_templates_natural_array;
        eta_w1_upper_limits: muon_templates_array;
        eta_w1_lower_limits: muon_templates_array;
        eta_w2_upper_limits: muon_templates_array;
        eta_w2_lower_limits: muon_templates_array;
        eta_w3_upper_limits: muon_templates_array;
        eta_w3_lower_limits: muon_templates_array;
        eta_w4_upper_limits: muon_templates_array;
        eta_w4_lower_limits: muon_templates_array;
        eta_w5_upper_limits: muon_templates_array;
        eta_w5_lower_limits: muon_templates_array;
        phi_full_range : muon_templates_boolean_array;
        phi_w1_upper_limits: muon_templates_array;
        phi_w1_lower_limits: muon_templates_array;
        phi_w2_ignore : muon_templates_boolean_array;
        phi_w2_upper_limits: muon_templates_array;
        phi_w2_lower_limits: muon_templates_array;
        requested_charges: muon_templates_string_array;
        qual_luts: muon_templates_quality_array;
        iso_luts: muon_templates_iso_array;
        upt_cuts: muon_templates_boolean_array;
        upt_upper_limits: muon_templates_array;
        upt_lower_limits: muon_templates_array;
        ip_luts: muon_templates_ip_array;
        requested_charge_correlation: string(1 to 2);
        
        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1

    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
        condition_o : out std_logic;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        ls_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
        pt : in diff_inputs_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to NR_MUON_OBJECTS-1) := (others => 0)
    );
end muon_conditions;
