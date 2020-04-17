entity rb is
    port
    (
        sys_clk           : in std_logic;
        lhc_clk           : in std_logic;
        sys_rst           : in std_logic;
        lhc_rst           : in std_logic;

        -- data interface for IPBus
        data_acc_in  : in ipb_wbus;
        data_acc_out : out ipb_rbus;

        -- data interface for fpga access
        sw_regs_in  : out sw_regs_in_t; -- sw registers written via software(uhal) and read by the fpga(Ipbus:frame_fabric)
        sw_regs_out : in sw_regs_out_t  -- sw registers read via software(uhal) and written by the fpga(Ipbus:frame_fabric)
    );
end;
