-- Top-level design for MP7 base firmware
--
-- Dave Newbold, July 2012
--
-- modified for uGT usage JW, May 2015

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ipbus.all;
use work.ipbus_trans_decl.all;
use work.mp7_data_types.all;
use work.mp7_readout_decl.all;
use work.mp7_ttc_decl.all;
use work.mp7_brd_decl.all;

entity top is
	port(
		eth_clkp, eth_clkn: in std_logic;
		eth_txp, eth_txn: out std_logic;
		eth_rxp, eth_rxn: in std_logic;
		leds: out std_logic_vector(11 downto 0);
		ebi_nwe: in std_logic;
		ebi_nrd: in std_logic;
		ebi_d: inout std_logic_vector(15 downto 0);
		ebi_a: inout std_logic_vector(16 downto 1);
		clk40_in_p: in std_logic;
		clk40_in_n: in std_logic;
		ttc_in_p: in std_logic;
		ttc_in_n: in std_logic;
		clk_cntrl: out std_logic_vector(17 downto 0);
		si5326_rst: out std_logic;
		si5326_int: in std_logic;
		si5326_lol: in std_logic;
		si5326_scl: out std_logic;
		si5326_sda: inout std_logic;
		minipod_top_rst_b: out std_logic;
		minipod_top_scl: out std_logic;
		minipod_top_sda_o: out std_logic;
		minipod_top_sda_i: in std_logic;
		minipod_bot_rst_b: out std_logic;
		minipod_bot_scl: out std_logic;
		minipod_bot_sda_o: out std_logic;
		minipod_bot_sda_i: in std_logic;
		mezz_p: out std_logic_vector(29 downto 0);
		mezz_n: out std_logic_vector(29 downto 0);
		refclkp: in std_logic_vector(N_REFCLK - 1 downto 0);
		refclkn: in std_logic_vector(N_REFCLK - 1 downto 0)
	);

end top;

architecture rtl of top is

	signal clk_ipb, rst_ipb, clk40ish, clk40, rst40, eth_refclk: std_logic;
	signal clk40_rst, clk40_sel, clk40_lock, clk40_stop, nuke, soft_rst: std_logic;
	signal clk_p, rst_p, clk_payload, rst_payload: std_logic;

	signal si5326_sda_o: std_logic;

	signal ipb_in_ctrl, ipb_in_ttc, ipb_in_datapath, ipb_in_readout, ipb_in_payload, ipb_in_formatter: ipb_wbus;
	signal ipb_out_ctrl, ipb_out_ttc, ipb_out_datapath, ipb_out_readout, ipb_out_payload, ipb_out_formatter: ipb_rbus;

	signal payload_d, payload_q: ldata(N_REGION * 4	- 1 downto 0);
	signal qsel: std_logic_vector(7 downto 0);
	signal ttc_l1a, dist_lock, oc_flag, ec_flag, payload_bc0: std_logic;
	signal ttc_cmd, ttc_cmd_dist: ttc_cmd_t;
	signal bunch_ctr: std_logic_vector(11 downto 0);
	signal evt_ctr, orb_ctr: std_logic_vector(23 downto 0);

	signal clkmon: std_logic_vector(2 downto 0);

	signal cap_bus: daq_cap_bus;
	signal daq_bus_top, daq_bus_bot: daq_bus;
	signal ctrs: ttc_stuff_array(N_REGION - 1 downto 0);
	signal rst_loc, clken_loc: std_logic_vector(N_REGION - 1 downto 0);

	-- uGT signals   -------------------------------------------------------
    signal finor_2_mezz_lemo: std_logic; -- to MEZZ
    signal tp_gt_mp7: std_logic_vector(7 downto 0); -- to MEZZ
    signal mezz, mezz_en: std_logic_vector(29 downto 0) := (others => '0'); -- mezzannine signals
    signal clk160 : std_logic; --160MHz for FDL
    ------------------------------------------------------------------------

begin

-- Clocks and control IO

	infra: entity work.mp7_infra
		port map(
			gt_clkp => eth_clkp,
			gt_clkn => eth_clkn,
			gt_txp => eth_txp,
			gt_txn => eth_txn,
			gt_rxp => eth_rxp,
			gt_rxn => eth_rxn,
			leds => leds,
			uc_pipe_nrd => ebi_nrd,
			uc_pipe_nwe => ebi_nwe,
			uc_pipe => ebi_d,
			uc_spi_miso => ebi_a(7),
			uc_spi_mosi => ebi_a(6),
			uc_spi_sck => ebi_a(5),
			uc_spi_cs_b => ebi_a(4),
			clk_ipb => clk_ipb,
			rst_ipb => rst_ipb,
			clk40ish => clk40ish,
			refclk_out => eth_refclk,
			nuke => nuke,
			soft_rst => soft_rst,
			oc_flag => oc_flag,
			ec_flag => ec_flag,
			ipb_in_ctrl => ipb_out_ctrl,
			ipb_out_ctrl => ipb_in_ctrl,
			ipb_in_ttc => ipb_out_ttc,
			ipb_out_ttc => ipb_in_ttc,
			ipb_in_datapath => ipb_out_datapath,
			ipb_out_datapath => ipb_in_datapath,
			ipb_in_readout => ipb_out_readout,
			ipb_out_readout => ipb_in_readout,
			ipb_in_payload => ipb_out_payload,
			ipb_out_payload => ipb_in_payload
		);

-- Control registers and board IO

	ctrl: entity work.mp7_ctrl
		port map(
			clk => clk_ipb,
			rst => rst_ipb,
			ipb_in => ipb_in_ctrl,
			ipb_out => ipb_out_ctrl,
			nuke => nuke,
			soft_rst => soft_rst,
			qsel => qsel,
			clk40_rst => clk40_rst,
			clk40_sel => clk40_sel,
			clk40_lock => clk40_lock,
			clk40_stop => clk40_stop,
			clk_cntrl => clk_cntrl,
			si5326_rst => si5326_rst,
			si5326_int => si5326_int,
			si5326_lol => si5326_lol,
			si5326_scl => si5326_scl,
			si5326_sda_i => si5326_sda,
			si5326_sda_o => si5326_sda_o,
			minipod_top_rst_b => minipod_top_rst_b,
			minipod_top_scl => minipod_top_scl,
			minipod_top_sda_o => minipod_top_sda_o,
			minipod_top_sda_i => minipod_top_sda_i,
			minipod_bot_rst_b => minipod_bot_rst_b,
			minipod_bot_scl => minipod_bot_scl,
			minipod_bot_sda_o => minipod_bot_sda_o,
			minipod_bot_sda_i => minipod_bot_sda_i
		);

	si5326_sda <= '0' when si5326_sda_o = '0' else 'Z';

-- TTC signal handling

	ttc: entity work.mp7_ttc
		port map(
			clk => clk_ipb,
			rst => rst_ipb,
			mmcm_rst => clk40_rst,
			sel => clk40_sel,
			lock => clk40_lock,
			stop => clk40_stop,
			ipb_in => ipb_in_ttc,
			ipb_out => ipb_out_ttc,
			clk40_in_p => clk40_in_p,
			clk40_in_n => clk40_in_n,
			clk40ish_in => clk40ish,
			clk40 => clk40,
            clk160 => clk160, --inserted for uGT
			rsto40 => rst40,
			clk_p => clk_p,
			rst_p => rst_p,
			clk_payload => clk_payload,
			rst_payload => rst_payload,
			ttc_in_p => ttc_in_p,
			ttc_in_n => ttc_in_n,
			ttc_cmd => ttc_cmd,
			ttc_cmd_dist => ttc_cmd_dist,
			ttc_l1a => ttc_l1a,
			dist_lock => dist_lock,
			bunch_ctr => bunch_ctr,
			evt_ctr => evt_ctr,
			orb_ctr => orb_ctr,
			oc_flag => oc_flag,
			ec_flag => ec_flag,
			monclk => clkmon
		);

-- MGTs, buffers and TTC fanout

	datapath: entity work.mp7_datapath
		port map(
			clk => clk_ipb,
			rst => rst_ipb,
			ipb_in => ipb_in_datapath,
			ipb_out => ipb_out_datapath,
			qsel => qsel,
			clk40 => clk40,
			clk_p => clk_p,
			rst_p => rst_p,
			ttc_cmd => ttc_cmd_dist,
			lock => dist_lock,
			ctrs_out => ctrs,
			rst_out => rst_loc,
			clken_out => clken_loc,
			cap_bus => cap_bus,
			daq_bus_in => daq_bus_top,
			daq_bus_out => daq_bus_bot,
			payload_bc0 => payload_bc0,
			refclkp => refclkp,
			refclkn => refclkn,
			clkmon => clkmon,
			q => payload_d,
			d => payload_q
		);

-- Readout

	readout: entity work.mp7_readout
		port map(
			clk => clk_ipb,
			rst => rst_ipb,
			ipb_in => ipb_in_readout,
			ipb_out => ipb_out_readout,
			ttc_clk => clk40,
			ttc_rst => rst40,
			ttc_cmd => ttc_cmd,
			l1a => ttc_l1a,
			bunch_ctr => bunch_ctr,
			evt_ctr => evt_ctr,
			orb_ctr => orb_ctr,
			clk_p => clk_p,
			rst_p => rst_p,
			cap_bus => cap_bus,
			daq_bus_out => daq_bus_top,
			daq_bus_in => daq_bus_bot,
			amc13_refclk => eth_refclk
		);

-- =======================================
    payload: entity work.gt_mp7_core
        generic map(
            NR_LANES => 16
        )
        port map(
            ipb_clk => clk_ipb,
            ipb_rst => rst_ipb,
            ipb_in => ipb_in_payload,
            ipb_out => ipb_out_payload,
            clk240 => clk_p,
            clk160 => clk160,
            lhc_clk => clk40,
            bc0 => ttc_cmd_dist(0),
            l1a => ttc_l1a,
            tp => tp_gt_mp7,
            lane_data_in => payload_d(15 downto 0),
            lane_data_out => payload_q(15 downto 0),
            finor_2_mezz_lemo => finor_2_mezz_lemo
        );
-- =======================================

    mezz(0) <= finor_2_mezz_lemo;
    mezz_en(0) <= '1';

    mezz(1) <= clk40;
    mezz_en(1) <= '1';

    mezz(2) <= ttc_cmd_dist(0);
    mezz_en(2) <= '1';

    mezz(3) <= tp_gt_mp7(0); -- simmem_in_use_o from frame.vhd
    mezz_en(3) <= '1';

    mezz(4) <= tp_gt_mp7(1); -- bcres_d_FDL_int from frame.vhd
    mezz_en(4) <= '1';

-- =======================================

-- Debugging connector

    mezz_inst: entity work.mezz_out_lvds
        generic map(
            NMEZZ => mezz_p'length
        )
        port map(
-- HB 2015-01-15: bug fixed with unconnected "mezz" signals
--          mezz => (others => '0'),
--          mezz_en => (others => '0'),
            mezz => mezz,
            mezz_en => mezz_en,
            mezz_n => mezz_n,
            mezz_p => mezz_p
        );

end rtl;
