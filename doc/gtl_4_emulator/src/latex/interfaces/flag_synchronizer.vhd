entity flag_synchronizer is
   generic
   (
      RST_ACTIVE_LHC : std_logic := '1';
      RST_ACTIVE_ROP :std_logic  := '0'
   );
   port
   (
      wr_clk : in  std_logic;
      wr_rst : in  std_logic; -- with lhc_rst
      rd_clk : in  std_logic;
      rd_rst : in  std_logic; --with daq_rst

      flagi  : in  std_logic;
      busy   : out std_logic;

      flago  : out std_logic
   );
end flag_synchronizer;
