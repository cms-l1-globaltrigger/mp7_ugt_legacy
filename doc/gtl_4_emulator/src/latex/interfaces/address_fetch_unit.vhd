entity address_fetch_unit is
   generic
   (
      ADDR_WIDTH : integer := 8;
      MEM_DEPTH  : integer := 8
   );
   port
   (
      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      offset_fifo_empty : in  std_logic;
      offset_fifo_rd    : out std_logic;
      offset_fifo_addr  : in  std_logic_vector (ADDR_WIDTH-1 downto 0);

      pkt_buffer_addr : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      pkt_buffer_rd   : out std_logic;
      pkt_buffer_dout : in  std_logic_vector (ADDR_WIDTH-1 downto 0);

      bx_in_event : in  std_logic_vector (log2c(MAX_BX_IN_EVENT)-1 downto 0);

      pkt_available : out std_logic;
      pkt_req       : in  std_logic;

      free_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
      free      : out std_logic;

      main_ram_addr : out std_logic_vector (ADDR_WIDTH-1 downto 0);
      main_ram_rd   : out std_logic
   );
end address_fetch_unit;
