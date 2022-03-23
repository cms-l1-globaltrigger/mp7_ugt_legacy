entity spytrig is
    port
    (
        lhc_clk    : in  std_logic;
        lhc_rst    : in  std_logic;
        orbit_nr   : in  orbit_nr_t;
        bx_nr      : in bx_nr_t;
        sw_reg_i   : in  sw_reg_spytrigger_in_t;
        sw_reg_o   : out sw_reg_spytrigger_out_t;
        spy1_o     : out std_logic;
        spy2_o     : out std_logic
    );
end;
