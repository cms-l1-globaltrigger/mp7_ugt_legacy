entity fdl_module is
    generic(
        SIM_MODE : boolean := false; -- if SIM_MODE = true, "algo_bx_mask" is given by "algo_bx_mask_sim".
        PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := (others => X"00000001");
        MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := (others => X"00000001");
        PRESCALE_FACTOR_SET_INDEX_WIDTH : positive := 8;
        PRESCALE_FACTOR_SET_INDEX_REG_INIT : ipb_regs_array(0 to 1) := (others => X"00000000");
        L1A_LATENCY_DELAY_INIT : ipb_regs_array(0 to 1) := (others => X"00000000");
        CNTRL_REG_INIT : ipb_regs_array(0 to 1) := (others => X"00000000");
-- Input flip-flops for algorithms of fdl_module.vhd - used for tests of fdl_module.vhd only
        ALGO_INPUTS_FF: boolean := false
    );
    port(
        ipb_clk             : in std_logic;
        ipb_rst             : in std_logic;
        ipb_in              : in ipb_wbus;
        ipb_out             : out ipb_rbus;
-- ==========================================================================
        lhc_clk             : in std_logic;
        lhc_rst             : in std_logic;
        bcres               : in std_logic;
        test_en             : in std_logic;
        l1a                 : in std_logic;
        begin_lumi_section  : in std_logic;
        algo_i              : in std_logic_vector(NR_ALGOS-1 downto 0);
        prescale_factor_set_index_rop : out std_logic_vector(PRESCALE_FACTOR_SET_INDEX_WIDTH-1 downto 0);
        algo_after_gtLogic_rop  : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        finor_2_mezz_lemo      : out std_logic; -- to LEMO
        finor_preview_2_mezz_lemo      : out std_logic; -- to LEMO
        veto_2_mezz_lemo      : out std_logic; -- to LEMO
        finor_w_veto_2_mezz_lemo      : out std_logic; -- to tp_mux.vhd
	local_finor_with_veto_o       : out std_logic; -- to SPY2_FINOR
-- HB 2016-03-02: v0.0.21 - algo_bx_mask_sim input for simulation use with MAX_NR_ALGOS (because of global index).
        algo_bx_mask_sim    : in std_logic_vector(MAX_NR_ALGOS-1 downto 0)
    );
end fdl_module;
