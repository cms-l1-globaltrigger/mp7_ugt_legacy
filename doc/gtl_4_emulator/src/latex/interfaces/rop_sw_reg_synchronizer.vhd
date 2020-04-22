entity rop_sw_reg_synchronizer is
   port
   (
      lhc_clk : in  std_logic;
      lhc_rst : in  std_logic;

      daq_clk : in  std_logic;
      daq_rst : in  std_logic;

      sw_regs_lhc : in  sw_reg_rop_in_t;
      sw_regs_daq : out sw_reg_rop_in_t
   );
end rop_sw_reg_synchronizer;
