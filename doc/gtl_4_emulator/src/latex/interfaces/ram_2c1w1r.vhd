entity ram_2c1w1r is
	generic
	(
		DATA_WIDTH : integer := 32;
		SIZE : integer := 256;
		USE_OUTPUT_REGISTER : boolean := false
	);
	port
	(
		wr_clk  : in  std_logic;
		rd_clk  : in  std_logic;

		wr_en   : in  std_logic;
		wr      : in  std_logic;
		rd      : in  std_logic;

		wr_addr : in  std_logic_vector(log2c(SIZE)-1 downto 0);
		rd_addr : in  std_logic_vector(log2c(SIZE)-1 downto 0);

		rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
		wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0)

	);
end entity;
