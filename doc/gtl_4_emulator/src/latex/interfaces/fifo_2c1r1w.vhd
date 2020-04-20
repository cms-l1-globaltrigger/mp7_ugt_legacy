entity fifo_2c1r1w is
	generic
	(
		MIN_DEPTH	: integer := 8;
		ADDRESS_MANAGER	: boolean := false;
		DATA_WIDTH	: integer := 8
	);
	port
	(
		wr_clk    : in  std_logic;
		wr_res_n  : in  std_logic; --with daq_rst, instanciate is in address_mangaer

		rd_clk    : in  std_logic;
		rd_res_n  : in  std_logic; --with lhc_rst, instanciate is in address_mangaer

		data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		rd1       : in  std_logic;

		data_in2  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		wr2       : in  std_logic;

		empty     : out std_logic;
		full      : out std_logic
	);
end entity;
