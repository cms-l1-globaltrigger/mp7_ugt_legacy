-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description:Lane Mapping Process, Developer HEPHY
-- $HeadURL: $
-- $Date:  $
-- $Author: ?$
-- Modification : HEPHY
-- $Revision: 0.1 $
--------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.gt_mp7_core_pkg.all;

package rb_pkg is


type sw_reg_dsmux_in_t is record
	muon_src                      : std_logic;
	eg_src                        : std_logic;
	tau_src                       : std_logic;
	jet_src                       : std_logic;
	ett_src                       : std_logic;
	ht_src                        : std_logic;
	etm_src                       : std_logic;
	htm_src                       : std_logic;
	ext_con_src                   : std_logic;
end record;
constant SW_REG_DSMUX_IN_RESET : sw_reg_dsmux_in_t :=
(
	muon_src                      => '0',
	eg_src                        => '0',
	tau_src                       => '0',
	jet_src                       => '0',
	ett_src                       => '0',
	ht_src                        => '0',
	etm_src                       => '0',
	htm_src                       => '0',
	ext_con_src                   => '0'
);
type sw_reg_l1asim_in_t is record
	enable_l1a_sim                : std_logic;
	fire_once_event               : std_logic;
	cntrl                         : std_logic_vector(1 downto 0);
	orbit_nr                      : orbit_nr_t;
	pattern_a                     : bx_nr_array_t(4 downto 0);
	pattern_b                     : bx_nr_array_t(4 downto 0);
end record;
constant SW_REG_L1ASIM_IN_RESET : sw_reg_l1asim_in_t :=
(
	enable_l1a_sim                => '0',
	fire_once_event               => '0',
	cntrl                         => (others=>('0')),
	orbit_nr                      => (others=>('0')),
	pattern_a                     => (others=>(others=>'0')),
	pattern_b                     => (others=>(others=>'0'))
);
type sw_reg_spytrigger_in_t is record
	orbit_nr                      : orbit_nr_t;
	spy12_once_event              : std_logic;
	spy12_next_event              : std_logic;
	spy3_event                    : std_logic;
	clear_spy12_ready_event       : std_logic;
	clear_spy3_ready_event        : std_logic;
	clear_spy12_error_event       : std_logic;
end record;
constant SW_REG_SPYTRIGGER_IN_RESET : sw_reg_spytrigger_in_t :=
(
	orbit_nr                      => (others=>('0')),
	spy12_once_event              => '0',
	spy12_next_event              => '0',
	spy3_event                    => '0',
	clear_spy12_ready_event       => '0',
	clear_spy3_ready_event        => '0',
	clear_spy12_error_event       => '0'
);
type sw_reg_spytrigger_out_t is record
	trig_spy12_error              : std_logic;
	trig_spy3_ready               : std_logic;
	trig_spy12_ready              : std_logic;
	trig_spy3_busy                : std_logic;
	trig_spy12_busy               : std_logic;
end record;
constant SW_REG_SPYTRIGGER_OUT_RESET : sw_reg_spytrigger_out_t :=
(
	trig_spy12_error              => '0',
	trig_spy3_ready               => '0',
	trig_spy12_ready              => '0',
	trig_spy3_busy                => '0',
	trig_spy12_busy               => '0'
);
type sw_reg_sw_reset_in_t is record
	reset_event                   : std_logic;
end record;
constant SW_REG_SW_RESET_IN_RESET : sw_reg_sw_reset_in_t :=
(
	reset_event                   => '0'
);
type sw_reg_dm_in_t is record
	delay_muons                   : std_logic_vector(11 downto 0);
	delay_eg                      : std_logic_vector(11 downto 0);
	delay_tau                     : std_logic_vector(11 downto 0);
	delay_jet                     : std_logic_vector(11 downto 0);
	delay_ett                     : std_logic_vector(11 downto 0);
	delay_ht                      : std_logic_vector(11 downto 0);
	delay_etm                     : std_logic_vector(11 downto 0);
	delay_htm                     : std_logic_vector(11 downto 0);
	delay_ext_con                 : std_logic_vector(11 downto 0);
	delay_bcres                   : std_logic_vector(11 downto 0);
	delay_bcres_fdl               : std_logic_vector(11 downto 0);
end record;
constant SW_REG_DM_IN_RESET : sw_reg_dm_in_t :=
(
	delay_muons                   => (others=>('0')),
	delay_eg                      => (others=>('0')),
	delay_tau                     => (others=>('0')),
	delay_jet                     => (others=>('0')),
	delay_ett                     => (others=>('0')),
	delay_ht                      => (others=>('0')),
	delay_etm                     => (others=>('0')),
	delay_htm                     => (others=>('0')),
	delay_ext_con                 => (others=>('0')),
	delay_bcres                   => (others=>('0')),
	delay_bcres_fdl               => (others=>('0'))
);
type sw_reg_dm_out_t is record
	valid                         : std_logic;
end record;
constant SW_REG_DM_OUT_RESET : sw_reg_dm_out_t :=
(
	valid                         => '0'
);
type sw_reg_tcm_in_t is record
	cmd_ignbcres                  : std_logic;
	err_det_reset_event           : std_logic;
	bgos                          : bgos_t;
	bgos_event                    : std_logic;
	test_reg                      : std_logic_vector(31 downto 0);
	luminosity_seg_period_msk     : luminosity_seg_period_msk_t;
end record;
constant SW_REG_TCM_IN_RESET : sw_reg_tcm_in_t :=
(
	cmd_ignbcres                  => '0',
	err_det_reset_event           => '0',
	bgos                          => (others=>('0')),
	bgos_event                    => '0',
	test_reg                      => (others=>('0')),
	luminosity_seg_period_msk     => LUM_SEG_PERIOD_MSK_RESET
);
type sw_reg_tcm_out_t is record
	bx_nr                         : bx_nr_t;
	event_nr                      : event_nr_t;
	trigger_nr                    : trigger_nr_t;
	orbit_nr                      : orbit_nr_t;
	bx_nr_chk                     : std_logic_vector(31 downto 0);
	bx_nr_max                     : std_logic_vector(31 downto 0);
	err_det                       : std_logic;
	bx_nr_d_fdl                   : bx_nr_t;
	luminosity_seg_nr             : luminosity_seg_nr_t;
end record;
constant SW_REG_TCM_OUT_RESET : sw_reg_tcm_out_t :=
(
	bx_nr                         => (others=>('0')),
	event_nr                      => (others=>('0')),
	trigger_nr                    => (others=>('0')),
	orbit_nr                      => (others=>('0')),
	bx_nr_chk                     => (others=>('0')),
	bx_nr_max                     => (others=>('0')),
	err_det                       => '0',
	bx_nr_d_fdl                   => (others=>('0')),
	luminosity_seg_nr             => (others=>('0'))
);
type sw_reg_rop_in_t is record
	version                       : std_logic_vector(31 downto 0);
	BoardID                       : std_logic_vector(15 downto 0);
	total_bx_in_event_decision    : std_logic_vector(3 downto 0);
	total_bx_in_event_ext_cond    : std_logic_vector(3 downto 0);
	total_bx_in_event_gmt         : std_logic_vector(3 downto 0);
	total_bx_in_event_gct         : std_logic_vector(3 downto 0);
	prescale_factor_set_index     : std_logic_vector(7 downto 0);
	lhc_data_delay                : std_logic_vector(3 downto 0);
	tcm_delay                     : std_logic_vector(3 downto 0);
	algo_delay                    : std_logic_vector(3 downto 0);
	busy_reset_event              : std_logic;
	Payload                       : std_logic_vector(19 downto 0);
end record;
constant SW_REG_ROP_IN_RESET : sw_reg_rop_in_t :=
(
	version                       => (0 => '1', others => '0'),
	BoardID                       => "0000000000000011",
	total_bx_in_event_decision    => "0011",
	total_bx_in_event_ext_cond    => "0101",
	total_bx_in_event_gmt         => "0001",
	total_bx_in_event_gct         => "0011",
	prescale_factor_set_index     => (0 => '1', others => '0'),
	lhc_data_delay                => (others => '0'),
	tcm_delay                     => (others => '0'),
	algo_delay                    => (others => '0'),
	busy_reset_event              => '0',
	Payload                       => X"000D6"
);
type sw_reg_rop_out_t is record
	busy                          : std_logic;
end record;
constant SW_REG_ROP_OUT_RESET : sw_reg_rop_out_t :=
(
	busy                          => '0'
);


type sw_regs_in_t is record
	dsmux                         : sw_reg_dsmux_in_t;
	l1asim                        : sw_reg_l1asim_in_t;
	spytrigger                    : sw_reg_spytrigger_in_t;
	sw_reset                      : sw_reg_sw_reset_in_t;
	dm                            : sw_reg_dm_in_t;
	tcm                           : sw_reg_tcm_in_t;
	rop                           : sw_reg_rop_in_t;
end record;
constant SW_REGS_IN_RESET : sw_regs_in_t :=
(
	dsmux                         => SW_REG_DSMUX_IN_RESET,
	l1asim                        => SW_REG_L1ASIM_IN_RESET,
	spytrigger                    => SW_REG_SPYTRIGGER_IN_RESET,
	sw_reset                      => SW_REG_SW_RESET_IN_RESET,
	dm                            => SW_REG_DM_IN_RESET,
	tcm                           => SW_REG_TCM_IN_RESET,
	rop                           => SW_REG_ROP_IN_RESET
);
type sw_regs_out_t is record
	spytrigger                    : sw_reg_spytrigger_out_t;
	dm                            : sw_reg_dm_out_t;
	tcm                           : sw_reg_tcm_out_t;
	rop                           : sw_reg_rop_out_t;
end record;
constant SW_REGS_OUT_RESET : sw_regs_out_t :=
(
	spytrigger                    => SW_REG_SPYTRIGGER_OUT_RESET,
	dm                            => SW_REG_DM_OUT_RESET,
	tcm                           => SW_REG_TCM_OUT_RESET,
	rop                           => SW_REG_ROP_OUT_RESET
);

	component rb
		generic(
			addr_width : natural
		);
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
			sw_regs_in  : out sw_regs_in_t; -- sw registers written via pci and read by the fpga
			sw_regs_out : in sw_regs_out_t  -- sw registers read via pci and written by the fpga
		);
	end component;


end package;
