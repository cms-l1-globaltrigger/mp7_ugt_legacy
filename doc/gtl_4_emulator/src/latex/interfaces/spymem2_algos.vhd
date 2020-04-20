entity spymem2_algos is
	generic
	(
		GTL_FDL_LATENCY : integer := 0;
		USE_SW_OUTPUT_REGISTER : boolean := true
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

		bx_nr      : in bx_nr_t;
		spy_i      : in std_logic;
		algos_i    : in std_logic_vector(MAX_NR_ALGOS-1 downto 0)
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
	assert(ipbus_in.ipb_addr'length > (log2c(MAX_NR_ALGOS/ipbus_in.ipb_wdata'length)+log2c(BUNCHES_PER_ORBIT)) )
		report "address space too small for spy II (algos)!"
		severity error;
end;
