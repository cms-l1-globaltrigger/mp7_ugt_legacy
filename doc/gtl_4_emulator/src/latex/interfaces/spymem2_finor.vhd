entity spymem2_finor is
	generic
	(
		GTL_FDL_LATENCY : integer := 2
	);
	port
	(
        ipbus_clk   : in    std_logic;
        ipbus_rst   : in    std_logic;
        ipbus_in    : in    ipb_wbus;
        ipbus_out   : out   ipb_rbus;
        ------------
		lhc_clk    : in std_logic;
		lhc_rst    : in std_logic;

		bx_nr      : in std_logic_vector(11 downto 0);
		spy_i      : in std_logic;
		finor_i    : in std_logic
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
end;
