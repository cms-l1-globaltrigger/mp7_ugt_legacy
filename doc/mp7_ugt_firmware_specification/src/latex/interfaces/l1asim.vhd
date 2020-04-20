entity l1asim is
	port
	(
		lhc_clk    : in std_logic;
		lhc_rst    : in std_logic;

		bx_nr      : in bx_nr_t;
		orbit_nr   : in orbit_nr_t;

		sw_reg_i   : in sw_reg_l1asim_in_t;

		l1a_real_i : in std_logic;
		l1a_o      : out std_logic
	);
end;
