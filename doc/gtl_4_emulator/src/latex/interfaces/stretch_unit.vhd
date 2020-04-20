entity stretch_unit is
   generic
   (
      MAX_BX_IN_EVENT : integer := 7;
      RST_ACT         : std_logic := '1'
   );
   port
   (
      clk : in  std_logic;
      rst : in  std_logic; --with lhc_rst

      flag_i : in  std_logic;
      sig_o  : out  std_logic
   );
end stretch_unit;
