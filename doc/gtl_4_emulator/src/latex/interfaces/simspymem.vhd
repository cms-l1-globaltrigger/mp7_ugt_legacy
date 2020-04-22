entity simspymem is
	generic
	(
		USE_SW_OUTPUT_REGISTER : boolean := true;
		USE_SW_INPUT_REGISTER : boolean := true
	);
	port
	(
        ipbus_clk   : in    std_logic;
        ipbus_rst   : in    std_logic;
        ipbus_in    : in    ipb_wbus;
        ipbus_out   : out   ipb_rbus;
        ------------
		lhc_clk    : in std_logic;
-- 		lhc_rst    : in std_logic;
		lhc_data_o : out lhc_data_t;
		lhc_data_i : in lhc_data_t;
		bx_nr      : in std_logic_vector(11 downto 0);
		spy        : in std_logic
	);
begin
	assert ipbus_in.ipb_addr'length >= (log2c(BUNCHES_PER_ORBIT)+log2c(LHC_DATA_WIDTH/ipbus_in.ipb_wdata'length))
		report "address space too small for simspy memory!"
		severity failure;
	assert LHC_DATA_WIDTH mod (ipbus_in.ipb_wdata'length) = 0
		report "LHC_DATA_WIDTH is no multiple of software data width --> This is not supported"
		severity failure;
end;
