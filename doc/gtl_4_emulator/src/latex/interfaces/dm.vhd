entity dm is
	generic
	(
		USE_REGISTERED_OUTPUT : boolean := false
	);
	port
	(
		lhc_clk : in std_logic;
		lhc_rst : in std_logic;

		lhc_data_i : in lhc_data_t;
		lhc_data_o : out lhc_data_t; -- delayed version of lhc_data

		bcres_i : in std_logic;
		ec0_i : in std_logic;
		oc0_i : in std_logic;
		resync_i : in std_logic;
		start_i : in std_logic;
		bcres_o : out std_logic;     -- delayed version of bcres. This signal has an additional delay on 1BX to compensate the regional delay in the output mux
		ec0_o : out std_logic;     -- delayed ec0
		oc0_o : out std_logic;     -- delayed oc0
		resync_o : out std_logic;     -- delayed resync
		start_o : out std_logic;     -- delayed start
		bcres_fdl_o : out std_logic; -- delayed version of bcres for fdl. This signal has an additional delay on 1BX to compensate the regional delay in the output mux
		bcres_outputmux_o : out std_logic; -- delayed version of bcres for output mux
		valid_i : in std_logic;
		valid_o : out std_logic;     -- 1 if lhc_data is valid

		sw_reg_i : in sw_reg_dm_in_t;
		sw_reg_o : out sw_reg_dm_out_t
	);
end;
