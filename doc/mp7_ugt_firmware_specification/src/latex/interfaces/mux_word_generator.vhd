entity mux_word_generator is
   port
   (
      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      bx_in_event_array_in : in  bx_in_event_array_t;

      -- pkt_buffer interface
      pkt_available : in  std_logic;
      pkt_req       : out std_logic;

      addr_bx_in_event : out std_logic_vector(log2c(MAX_BX_IN_EVENT)-1 downto 0);
      mux_ctrl_word    : out std_logic_vector(OL_INSTR_MUX_WIDTH-1 downto 0);

      -- daq interface
      daq_oe   : out std_logic;
      daq_sof  : out std_logic;
      daq_stop : out std_logic;
      daq_busy : in  std_logic
   );
end mux_word_generator;
