
-- HB 2017-09-08: reduced registers for frame v1.2.1 - no dm, no dsmux

library ieee;
use IEEE.std_logic_1164.all;

library work;
use work.ipbus.all;
use work.gt_mp7_core_pkg.all;

package rb_pkg is

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
-- type sw_reg_sw_reset_in_t is record
--     reset_event                   : std_logic;
-- end record;
-- constant SW_REG_SW_RESET_IN_RESET : sw_reg_sw_reset_in_t :=
-- (
--     reset_event                   => '0'
-- );
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
type sw_regs_in_t is record
    spytrigger                    : sw_reg_spytrigger_in_t;
--     sw_reset                      : sw_reg_sw_reset_in_t;
    tcm                           : sw_reg_tcm_in_t;
end record;
constant SW_REGS_IN_RESET : sw_regs_in_t :=
(
    spytrigger                    => SW_REG_SPYTRIGGER_IN_RESET,
--     sw_reset                      => SW_REG_SW_RESET_IN_RESET,
    tcm                           => SW_REG_TCM_IN_RESET
);
type sw_regs_out_t is record
    spytrigger                    : sw_reg_spytrigger_out_t;
--     dm                            : sw_reg_dm_out_t;
    tcm                           : sw_reg_tcm_out_t;
--     rop                           : sw_reg_rop_out_t;
end record;
constant SW_REGS_OUT_RESET : sw_regs_out_t :=
(
    spytrigger                    => SW_REG_SPYTRIGGER_OUT_RESET,
    tcm                           => SW_REG_TCM_OUT_RESET
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
