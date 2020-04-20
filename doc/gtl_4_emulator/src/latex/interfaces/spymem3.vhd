entity spymem3 is
	generic
	(
	SIZE_IN_BYTES : integer    := 4096;
	INPUT_DATA_WIDTH : integer := 16
	);
	port
	(
		ipbus_clk   : in    std_logic;
		ipbus_rst   : in    std_logic;
		ipbus_in    : in    ipb_wbus;
		ipbus_out   : out   ipb_rbus;

		lhc_clk          : in std_logic;
		lhc_rst          : in std_logic;
		spy_i            : in std_logic;
		spy_ack_o        : out std_logic;

		rop_clk          : in std_logic;
		rop_rst          : in std_logic;
		rop_data_i       : in std_logic_vector(INPUT_DATA_WIDTH-1 downto 0);
		rop_en_i         : in std_logic;
		rop_packet_end_i : in std_logic
	);
begin
	assert(ipbus_in.ipb_wdata'length = 32 )
		report "Software data width NOT supported!"
		severity error;
	assert(INPUT_DATA_WIDTH = 16 or INPUT_DATA_WIDTH = 32 or INPUT_DATA_WIDTH = 64)
		report "Input data width NOT supported!"
		severity error;
end;
