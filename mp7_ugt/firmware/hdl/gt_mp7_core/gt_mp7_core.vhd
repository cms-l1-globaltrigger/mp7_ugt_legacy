--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gt_mp7_core.vhd $
-- $Date: 2015-06-17 11:00:37 +0200 (Wed, 17 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4046 $
--------------------------------------------------------------------------------

-- Description: Global Trigger on MP7
-- Version-history:
-- HB 2014-12-10: added clk160 for serializer in fdl_module.vhd
-- HB 2014-10-30: updated for local_finor_with_veto_2_spy2 output.
-- HB 2014-10-22: updated for FINOR and VETO logic with serialized output.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.gt_mp7_core_addr_decode.all;

entity gt_mp7_core is
    generic(
        NR_LANES: positive
    );
    port(
        ipb_clk: in std_logic;
        ipb_rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus;
-- ==========================================================================
        clk240: in std_logic;
        clk160: in std_logic;
        lhc_clk: in std_logic;
        bc0: in std_logic;
        l1a: in std_logic;
        tp: out std_logic_vector(7 downto 0);
        lane_data_in: in ldata(NR_LANES-1 downto 0);
        lane_data_out: out ldata(NR_LANES-1 downto 0);
        finor_2_mezz_lemo: out std_logic
    );

end gt_mp7_core;

architecture rtl of gt_mp7_core is

    signal ipb_to_slaves: ipb_wbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);

    signal dsmux_lhc_data : lhc_data_t;

    signal tp_frame : std_logic_vector(3 downto 0);
    signal tp_gtl_fdl : std_logic_vector(3 downto 0) := "0000";

    signal fdl_status : std_logic_vector(3 downto 0);
    signal prescale_factor_set_index_rop : std_logic_vector(7 downto 0);
    signal algo_before_prescaler_rop     : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_prescaler_rop      : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_finor_mask_rop     : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal local_finor_rop     : std_logic;
    signal local_veto_rop      : std_logic;
    signal local_finor_with_veto_o      : std_logic;

	signal bcres_d_FDL       : std_logic;
	signal bx_nr_d_FDL       : bx_nr_t;
	signal start_lumisection : std_logic;

	signal lhc_rst           : std_logic;

begin

    fabric_i: entity work.gt_mp7_core_fabric
        generic map(NSLV => NR_IPB_SLV_GT_MP7_CORE)
        port map(
            ipb_clk => ipb_clk,
            ipb_rst => ipb_rst,
            ipb_in => ipb_in,
            ipb_out => ipb_out,
            ipb_to_slaves => ipb_to_slaves,
            ipb_from_slaves => ipb_from_slaves
    );

    frame_i : entity work.frame
        generic map(NR_LANES => NR_LANES)
        port map
        (
            ipb_clk            => ipb_clk,
            ipb_rst            => ipb_rst,
            ipb_in             => ipb_to_slaves(C_IPB_GT_MP7_FRAME),
            ipb_out            => ipb_from_slaves(C_IPB_GT_MP7_FRAME),
-- ========================================================
            clk240             => clk240,
            lhc_clk            => lhc_clk,
            lhc_rst_o          => lhc_rst,
            bc0                => bc0,
            l1a                => l1a,
-- HB 2014-06-05: to get bgo_cmd, mp7_ttc must be changed ("cmd" as outputs)
--             bgo_cmd            => bgo_cmd,
            bcres_d_FDL        => bcres_d_FDL,
            bx_nr_d_FDL        => bx_nr_d_FDL,
            start_lumisection  => start_lumisection,
            tp                 => tp_frame,
            lane_data_in       => lane_data_in,
            lane_data_out      => lane_data_out,
            dsmux_lhc_data_o   => dsmux_lhc_data,
            fdl_status         => fdl_status,
            prescale_factor_set_index_rop => prescale_factor_set_index_rop,
            algo_before_prescaler_rop    => algo_before_prescaler_rop,
            algo_after_prescaler_rop     => algo_after_prescaler_rop,
            algo_after_finor_mask_rop    => algo_after_finor_mask_rop,
            local_finor_rop    => local_finor_rop,
            local_veto_rop     => local_veto_rop, -- HB 2014-10-22: added for ROP
            finor_rop          => '0', -- HB 2014-10-30: no total_finor to ROP
            local_finor_with_veto_2_spy2 => local_finor_with_veto_o -- HB 2014-10-30: to SPY2_FINOR
        );

    gtl_fdl_wrapper_i : entity work.gtl_fdl_wrapper
        port map
        (
            ipb_clk            => ipb_clk,
            ipb_rst            => ipb_rst,
            ipb_in             => ipb_to_slaves(C_IPB_GT_MP7_GTLFDL),
            ipb_out            => ipb_from_slaves(C_IPB_GT_MP7_GTLFDL),
-- ========================================================
            clk160             => clk160,
            lhc_clk            => lhc_clk,
            lhc_rst            => lhc_rst,
            lhc_data           => dsmux_lhc_data,
            bcres              => bcres_d_FDL,
            lhc_gap            => '0',
            begin_lumi_section => start_lumisection,
            bx_nr              => bx_nr_d_FDL,
            fdl_status         => fdl_status,
            prescale_factor_set_index_rop => prescale_factor_set_index_rop,
            algo_before_prescaler_rop    => algo_before_prescaler_rop,
            algo_after_prescaler_rop     => algo_after_prescaler_rop,
            algo_after_finor_mask_rop    => algo_after_finor_mask_rop,
			local_finor_rop => local_finor_rop,
			local_veto_rop  => local_veto_rop,
			finor_2_mezz_lemo  => finor_2_mezz_lemo,
			local_finor_with_veto_o  => local_finor_with_veto_o
        );

	tp <= tp_gtl_fdl & tp_frame;

end rtl;

