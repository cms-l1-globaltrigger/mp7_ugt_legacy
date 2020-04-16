entity sw_reset is
	port
	(
		lhc_clk    : in std_logic;

		-- data interface for fpga access
		sw_reg_in  : in sw_reg_sw_reset_in_t; -- sw registers written via pci and read by the fpga

		-- the synchronized lhc reset
		sw_reset   : out std_logic
	);
end;
