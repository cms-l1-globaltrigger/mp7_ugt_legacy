entity frame is
    generic(
        NR_LANES : positive
     );
    port(
        ipb_clk : in std_logic;
        ipb_rst : in std_logic;
        ipb_in : in ipb_wbus;
        ipb_out : out ipb_rbus;
        ctrs : in ttc_stuff_array; --mp7 ttc ctrs
        clk240 : in std_logic;
        lhc_clk : in std_logic;
        lhc_rst_o : out std_logic;
        bc0 : in std_logic;
        ec0 : in std_logic;
        oc0 : in std_logic;
        start : in std_logic;
        l1a : in std_logic;
        bcres_d : out std_logic;
        bcres_d_FDL : out std_logic;
        start_lumisection : out std_logic;
        lane_data_in : in ldata(NR_LANES-1 downto 0);
        lane_data_out : out ldata(NR_LANES-1 downto 0);
        lhc_data_2_gtl_o : out lhc_data_t;
        prescale_factor_set_index_rop : in std_logic_vector(7 downto 0);
        algo_after_gtLogic_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop : in std_logic;
        local_veto_rop : in std_logic;
        finor_rop : in std_logic;
        local_finor_with_veto_2_spy2 : in std_logic
    );
end frame;
