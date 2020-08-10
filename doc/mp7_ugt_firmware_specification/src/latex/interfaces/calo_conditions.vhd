entity calo_conditions is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        calo_object_slice_3_low: natural;
        calo_object_slice_3_high: natural;
        calo_object_slice_4_low: natural;
        calo_object_slice_4_high: natural;
        nr_templates: positive;
        et_ge_mode: boolean;
        obj_type : natural := EG_TYPE;
        et_thresholds: calo_templates_array;
        nr_eta_windows : calo_templates_natural_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        eta_w3_upper_limits: calo_templates_array;
        eta_w3_lower_limits: calo_templates_array;
        eta_w4_upper_limits: calo_templates_array;
        eta_w4_lower_limits: calo_templates_array;
        eta_w5_upper_limits: calo_templates_array;
        eta_w5_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array;
        
        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        condition_o: out std_logic;
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS-1) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS-1) := (others => 0)
    );
end calo_conditions;
