entity address_manager is
   generic
   (
      ADDR_WIDTH	: integer := 3;
      MEM_DEPTH		: integer := 8;

      MAX_BX_IN_EVENT	: integer := 7;

      RST_ACT_ROP	: std_logic := '0';
      RST_ACT		: std_logic := '1';
      SYNC_STAGES	: integer:= 2
   );
   port
   (
      daq_clk  : in  std_logic;
      daq_rst  : in  std_logic;

      lhc_clk  : in  std_logic;
      lhc_rst  : in  std_logic;

      fdb_addr : in  std_logic_vector (ADDR_WIDTH-1 downto 0);
      fdb_wr   : in  std_logic;

      l1a : in  std_logic;

      ready : out std_logic;

      wr_addr      : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      rd_addr      : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      new_addr     : out std_logic;
      process_addr : out std_logic
   );
end address_manager;
