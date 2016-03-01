--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL:  $
-- $Date:  $
-- $Author: Babak $
-- $Revision: 0.1  $
--------------------------------------------------------------------------------
-- TODO: review the core and and modify it
--
-- HB 2016-02-26: changed inputs of tp_mux.vhd, removed unused signals in frame (v0.0.36) and fdl_module (v0.0.20)
-- HB 2016-02-16: added "l1a" for post dead time counter in fdl_module (v0.0.17)
-- JW 2015-11-04: added bgo sync stage
-- HB 2015-09-16: added "ec0_in", "resync_in" and "oc0_in" from "ctrs" for FDL
-- JW 2015-08-24: modified the core and adapted it for mp7_fw_v1_8_2 usage

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.gt_mp7_core_addr_decode.all;
use work.mp7_brd_decl.all;
use work.mp7_ttc_decl.all;
use work.top_decl.all;

entity mp7_payload is
    port(
        clk: in std_logic; -- ipbus signals
        rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus;
        clk_payload: in std_logic;
        rst_payload: in std_logic;
        clk_p: in std_logic; -- data clock
        rst_loc: in std_logic_vector(N_REGION - 1 downto 0);
        clken_loc: in std_logic_vector(N_REGION - 1 downto 0);
        ctrs: in ttc_stuff_array;
	l1a: in std_logic; -- L1A input
        bc0: out std_logic;
        d: in ldata(4 * N_REGION - 1 downto 0); -- data in
        q: out ldata(4 * N_REGION - 1 downto 0); -- data out
        gpio: out std_logic_vector(29 downto 0); -- IO to mezzanine connector
        gpio_en: out std_logic_vector(29 downto 0) -- IO to mezzanine connector (three-state enables)
    );
end mp7_payload;

architecture rtl of mp7_payload is

    signal ipb_to_slaves    : ipb_wbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);
    signal ipb_from_slaves  : ipb_rbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);

    signal dsmux_lhc_data                : lhc_data_t;

    signal tp_frame                      : std_logic_vector(3 downto 0);

    signal fdl_status                    : std_logic_vector(3 downto 0);
    signal prescale_factor_set_index_rop : std_logic_vector(7 downto 0);
    signal algo_before_prescaler_rop     : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_prescaler_rop      : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_finor_mask_rop     : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal local_finor_rop               : std_logic;
    signal local_veto_rop                : std_logic;
    signal local_finor_with_veto_o       : std_logic;
    signal finor_2_mezz_lemo             : std_logic;
    signal veto_2_mezz_lemo              : std_logic;
    signal finor_w_veto_2_mezz_lemo      : std_logic;

    signal bcres_d           : std_logic;
    signal bcres_d_FDL       : std_logic;
    signal bx_nr_d_FDL       : bx_nr_t;
    signal start_lumisection : std_logic;

    signal lhc_rst           : std_logic;
    signal lhc_clk           : std_logic;
    signal ipb_clk	         : std_logic;
    signal ipb_rst	         : std_logic;
    signal clk240            : std_logic;
    signal bc0_in            : std_logic;

    signal lane_data_in      : ldata(4 * N_REGION - 1 downto 0);
    signal lane_data_out     : ldata(4 * N_REGION - 1 downto 0);

    --JW 2015-09-17: added a specific module which selects the mezzanine output per IPBUS
    signal tp0            : std_logic;
    signal tp1            : std_logic;
    signal tp2            : std_logic;

    signal l1a_int            : std_logic := '0';

begin

-- ***********************************************************************
-- HB 2016-02-17: L1A connection has to be done (for post dead time counter in fdl_module.vhd) in top (mp7xe_690.vhd) !!!
    l1a_int <= l1a; -- from MP7
-- ***********************************************************************

    lhc_clk <= clk_payload;
    ipb_clk <= clk;
    ipb_rst <= rst;
    clk240  <= clk_p;
    --bc0_in  <= '1' when ctrs(4).ttc_cmd = TTC_BCMD_BC0 else '0';

    lane_data_in  <= d;
    q <= lane_data_out;

    -- HB 2016-02-26: ec0, oc0 and resync not used anymore
    -- JW 2015-10-24: added bgo sync stage to avoid timing issues
    bgo_sync_i: entity work.bgo_sync
    port map(
        clk_payload => lhc_clk,
        rst_payload => rst_payload,
        ttc_in      => ctrs(4).ttc_cmd,
        bc0_out     => bc0_in,
        ec0_out     => open,
        oc0_out     => open,
        resync_out  => open
    );

    fabric_i: entity work.ipbus_fabric_sel
    generic map(
        NSLV => NR_IPB_SLV_GT_MP7_CORE,
        SEL_WIDTH => IPBUS_SEL_WIDTH)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_mp7_payload(ipb_in.ipb_addr),
      ipb_to_slaves => ipb_to_slaves,
      ipb_from_slaves => ipb_from_slaves
    );

    frame_i: entity work.frame
    generic map(
        NR_LANES            => (4 * N_REGION),
        SIMULATE_DATAPATH   => false
    )
    port map(
        ipb_clk            => ipb_clk,
        ipb_rst            => ipb_rst,
        ipb_in             => ipb_to_slaves(C_IPB_GT_MP7_FRAME),
        ipb_out            => ipb_from_slaves(C_IPB_GT_MP7_FRAME),
-- ====================Simulator interface===============================
        lane_data_in_sim	=>  LHC_DATA_NULL,
        lhc_rst_sim         => '0',
        rop_rst_sim         => '0',
        ctrs                => ctrs,
        trigger_nr_sim          => (others => '0'),
        orbit_nr_sim            => (others => '0'),
        bx_nr_sim               => (others => '0'),
        luminosity_seg_nr_sim   => (others => '0'),
        event_nr_sim            => (others => '0'),
        l1a_sim             => '0',
        daq_oe_sim          => open,
        daq_stop_sim        => open,
        daq_data_sim        => open,
-- ====================end of Simulator interface========================
        clk240             => clk240,
        lhc_clk            => lhc_clk,
        lhc_rst_o          => lhc_rst,
        bc0                => bc0_in,
        bcres_d            => bcres_d,
        bcres_d_FDL        => bcres_d_FDL,
        start_lumisection  => start_lumisection,
        lane_data_in       => lane_data_in,
        lane_data_out      => lane_data_out,
        dsmux_lhc_data_o   => dsmux_lhc_data,
        prescale_factor_set_index_rop   => prescale_factor_set_index_rop,
        algo_before_prescaler_rop       => algo_before_prescaler_rop,
        algo_after_prescaler_rop        => algo_after_prescaler_rop,
        algo_after_finor_mask_rop       => algo_after_finor_mask_rop,
        local_finor_rop                 => local_finor_rop,
        local_veto_rop                  => local_veto_rop, -- HB 2014-10-22: added for ROP
        finor_rop                       => '0', -- HB 2014-10-30: no total_finor to ROP
        local_finor_with_veto_2_spy2    => local_finor_with_veto_o -- HB 2014-10-30: to SPY2_FINOR
    );

    gtl_fdl_wrapper_i: entity work.gtl_fdl_wrapper
    port map(
        ipb_clk            => ipb_clk,
        ipb_rst            => ipb_rst,
        ipb_in             => ipb_to_slaves(C_IPB_GT_MP7_GTLFDL),
        ipb_out            => ipb_from_slaves(C_IPB_GT_MP7_GTLFDL),
-- ========================================================
        lhc_clk            => lhc_clk,
        lhc_rst            => lhc_rst,
        lhc_data           => dsmux_lhc_data,
        bcres              => bcres_d_FDL,
        l1a                => l1a_int,
        begin_lumi_section => start_lumisection,
        prescale_factor_set_index_rop   => prescale_factor_set_index_rop,
        algo_before_prescaler_rop       => algo_before_prescaler_rop,
        algo_after_prescaler_rop        => algo_after_prescaler_rop,
        algo_after_finor_mask_rop       => algo_after_finor_mask_rop,
        local_finor_rop         => local_finor_rop,
        local_veto_rop          => local_veto_rop,
        finor_2_mezz_lemo      => finor_2_mezz_lemo,
        veto_2_mezz_lemo      =>  veto_2_mezz_lemo,
        finor_w_veto_2_mezz_lemo      =>  finor_w_veto_2_mezz_lemo,
        local_finor_with_veto_o => local_finor_with_veto_o
    );

    tp_mux_i: entity work.tp_mux
    port map(
        clk             => ipb_clk,
        rst             => ipb_rst,
        ipb_in          => ipb_to_slaves(C_IPB_GT_MP7_TP_MUX),
        ipb_out         => ipb_from_slaves(C_IPB_GT_MP7_TP_MUX),
        clk_payload     => lhc_clk,
        rst_payload     => lhc_rst,
        clk_p           => clk240,
        bc0             => bc0_in,
        l1a             => l1a_int,
        local_finor     => finor_2_mezz_lemo,
        local_veto      => veto_2_mezz_lemo,
        finor_w_veto_local => finor_w_veto_2_mezz_lemo,
        start_lumisection => start_lumisection,
        bcres_d         => bcres_d,
        bcres_d_FDL     => bcres_d_FDL,
        out0            => tp0,
        out1            => tp1,
        out2            => tp2
    );

    gpio(0) <= tp0; -- per default: finor_2_mezz_lemo
    gpio(1) <= tp1; -- per default: finor_2_mezz_lemo
    gpio(2) <= tp2; -- per default: finor_2_mezz_lemo
    gpio_en(0) <= '1'; --enable output 0
    gpio_en(1) <= '1'; --enable output 1
    gpio_en(2) <= '1'; --enable output 2

    bc0 <= bc0_in;

end rtl;

