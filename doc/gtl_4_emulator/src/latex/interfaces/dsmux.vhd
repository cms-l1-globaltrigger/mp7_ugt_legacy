entity dsmux is
	generic
	(
		USE_SW_INPUT_REGISTER : boolean := true;
		USE_SIMMEM_IN_USE_OUTPUT_REGISTER : boolean := true
	);
	port
	(
		lhc_clk : std_logic;
		lhc_rst : std_logic;

		sw_reg_i : in sw_reg_dsmux_in_t;

		lhc_data_sim_i : in lhc_data_t;
		lhc_data_ext_i : in lhc_data_t;

		lhc_data_sim_valid_i : in std_logic;
		lhc_data_ext_valid_i : in std_logic;

		lhc_data_o : out lhc_data_t;
		lhc_data_valid_o : out std_logic;

		simmem_in_use_o : out std_logic
	);
end;
