entity rop is

   port
   (
      -- clk and reset signals
      lhc_clk : in  std_logic;
      lhc_rst : in  std_logic;

      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      -- sw interface
      sw_reg_in  : in  sw_reg_rop_in_t;
      sw_reg_out : out sw_reg_rop_out_t;

      -- tcm interface
      trigger_nr        : in  trigger_nr_t;
      orbit_nr          : in  orbit_nr_t;
      bx_nr             : in  bx_nr_t;
      luminosity_seg_nr : in  luminosity_seg_nr_t;
      event_nr          : in  event_nr_t;

      -- lhc interface
      lhc_data  : in  lhc_data_t;
      lhc_valid : in  std_logic;

      -- fdl interface
      algo_before_pre : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_pre  : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);
      algo_after_mask : in  std_logic_vector(MAX_NR_ALGOS-1 downto 0);

      -- finors
      finors : in  std_logic_vector(FINOR_WIDTH-1 downto 0);

      -- l1a
      l1a   : in  std_logic;
      ready : out std_logic;

      -- daq interface
      daq_data  : out std_logic_vector (DAQ_INPUT_WIDTH-1 downto 0);
      daq_oe    : out std_logic;
      daq_stop  : out std_logic;
      daq_busy  : in  std_logic

   );

end rop;
