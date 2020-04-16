entity calo_conditions_v3 is
     generic(
        nr_objects: positive;
        nr_templates: positive;
        et_ge_mode: boolean;
	obj_type : natural := EG_TYPE; -- eg=0, jet=1, tau=2
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_iso_array
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        condition_o: out std_logic
    );
end calo_conditions_v3;
