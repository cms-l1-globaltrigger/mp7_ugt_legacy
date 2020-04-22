entity dynamic_delay_line is
	generic
	(
		WIDTH : integer := 8;
		MAX_DELAY : integer range 1 to 7:= 3;
		STATIC_DELAY : integer := 0
	);
	port
	(
		clk   : in  std_logic;
		rst   : in  std_logic;
		delay : in  std_logic_vector(log2c(MAX_DELAY) downto 0);
		sig_i : in  std_logic_vector(WIDTH-1 downto 0);
		sig_o : out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;
