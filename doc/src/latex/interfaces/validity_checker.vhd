entity validity_checker is
   generic
   (
      MAX_BX_IN_EVENT : integer := 7;
      RST_ACT         : std_logic := '1'
   );
   port
   (
      clk : in  std_logic;
      rst : in  std_logic; --with lhc_rst

      valid_i : in  std_logic;
      valid_o : out std_logic
   );
end validity_checker;
