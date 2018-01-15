
-- HB 2017-10-12: removed sw_reset (frame v1.2.3)
-- HB 2017-09-08: reduced registers for frame v1.2.1 - no dm, no dsmux

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.gt_mp7_core_pkg.all;
use work.math_pkg.all;
use work.rb_pkg.all;

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

architecture arch of rb is
    constant rb_addr_width : natural := 5;

-- CTRL registers
    constant OFFSET_SPYTRIGGER_ORBIT_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := "00000";
    constant OFFSET_SPYTRIGGER_ORBIT_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := "00001";
    constant OFFSET_SPYTRIGGER_CONTROL : std_logic_vector(rb_addr_width-1 downto 0) := "00010";
    
--     constant OFFSET_SW_RESET_RESET_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := "00011";

    constant OFFSET_TCM_CMDIGNBCRES : std_logic_vector(rb_addr_width-1 downto 0) := "00100";
    constant OFFSET_TCM_ERR_DET_RESET_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := "00101";
    constant OFFSET_TCM_BGOS : std_logic_vector(rb_addr_width-1 downto 0) := "00110";
    constant OFFSET_TCM_BGOS_EVENT : std_logic_vector(rb_addr_width-1 downto 0) := "00111";
    constant OFFSET_TCM_TEST_REG : std_logic_vector(rb_addr_width-1 downto 0) := "01000";
    constant OFFSET_TCM_LIMINOSITY_SEG_PERIOD_MSK : std_logic_vector(rb_addr_width-1 downto 0) := "01001";

-- HEPHY 2015-05-10: changed status register addresses
    constant OFFSET_SPYTRIGGER_STATUS : std_logic_vector(rb_addr_width-1 downto 0) := "00000";

    constant OFFSET_TCM_STATUS_BX_NR : std_logic_vector(rb_addr_width-1 downto 0) := "00010";
    constant OFFSET_TCM_STATUS_EVENT_NR : std_logic_vector(rb_addr_width-1 downto 0) := "00011";
    constant OFFSET_TCM_STATUS_TRIGGER_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := "00100";
    constant OFFSET_TCM_STATUS_TRIGGER_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := "00101";
    constant OFFSET_TCM_STATUS_ORBIT_NR_L : std_logic_vector(rb_addr_width-1 downto 0) := "00110";
    constant OFFSET_TCM_STATUS_ORBIT_NR_H : std_logic_vector(rb_addr_width-1 downto 0) := "00111";
    constant OFFSET_TCM_STATUS_BX_NR_CHK : std_logic_vector(rb_addr_width-1 downto 0) := "01000";
    constant OFFSET_TCM_STATUS_BX_NR_MAX : std_logic_vector(rb_addr_width-1 downto 0) := "01001";
    constant OFFSET_TCM_STATUS_ERR_DET : std_logic_vector(rb_addr_width-1 downto 0) := "01010";
    constant OFFSET_TCM_STATUS_BX_NR_D_FDL : std_logic_vector(rb_addr_width-1 downto 0) := "01011";
    constant OFFSET_TCM_LUMINOSITY_SEG_NR : std_logic_vector(rb_addr_width-1 downto 0) := "01100";
    
    constant nr_stat_reg : natural := 13;
    constant nr_ctrl_reg : natural := 2 ** (rb_addr_width-1);

    signal stat_reg: ipb_reg_v(nr_stat_reg-1 downto 0);
    signal ctrl_reg: ipb_reg_v(nr_ctrl_reg-1 downto 0);

begin

-- ipbus_syncreg_v
--
-- Generic control / status register bank
--
-- Provides N_CTRL control registers (32b each), rw
-- Provides N_STAT status registers (32b each), ro
--
-- Bottom part of read address space is control, top is status
--
-- Both control and status are moved across clock domains with full handshaking
-- This may be overkill for some applications
--
-- Dave Newbold, June 2013

    rb_i: entity work.ipbus_syncreg_v
        generic map(
            N_CTRL => nr_ctrl_reg,
            N_STAT => nr_stat_reg
        )
        port map(
            clk => sys_clk,
            rst => sys_rst,
            ipb_in => data_acc_in,
            ipb_out => data_acc_out,
            slv_clk => lhc_clk,
            d => stat_reg(nr_stat_reg-1 downto 0),
            q => ctrl_reg(nr_ctrl_reg-1 downto 0)
        );

-- CTRL registers

-- spytrigger
    sw_regs_in.spytrigger.orbit_nr(31 downto 0) <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_ORBIT_NR_L)))(31 downto 0);
    sw_regs_in.spytrigger.orbit_nr(ORBIT_NR_WIDTH-1 downto 32) <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_ORBIT_NR_H)))(ORBIT_NR_WIDTH-1-32 downto 0);

-- HEPHY 2015-05-04:: changed event register (not working) to "in-register"
    sw_regs_in.spytrigger.spy12_once_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(0);
    sw_regs_in.spytrigger.spy12_next_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(1);
    sw_regs_in.spytrigger.spy3_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(2);
    sw_regs_in.spytrigger.clear_spy12_ready_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(3);
    sw_regs_in.spytrigger.clear_spy3_ready_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(4);
    sw_regs_in.spytrigger.clear_spy12_error_event <= ctrl_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_CONTROL)))(5);
-- **********************

-- tcm
    sw_regs_in.tcm.cmd_ignbcres <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_CMDIGNBCRES)))(0);

    -- HEPHY 2015-05-04: changed event register (not working) to "in-register"
    sw_regs_in.tcm.err_det_reset_event <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_ERR_DET_RESET_EVENT)))(0);
    sw_regs_in.tcm.bgos_event <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_BGOS_EVENT)))(0);
-- **********************
    sw_regs_in.tcm.luminosity_seg_period_msk <= LUM_SEG_PERIOD_MSK_RESET; --ctrl_reg(to_integer(unsigned(OFFSET_TCM_LIMINOSITY_SEG_PERIOD_MSK)))(31 downto 0);   JW 10.09.2015 set to fixed value
    sw_regs_in.tcm.bgos <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_BGOS)))(3 downto 0);
    sw_regs_in.tcm.test_reg <= ctrl_reg(to_integer(unsigned(OFFSET_TCM_TEST_REG)))(31 downto 0);


-- STAT registers
-- spytrigger
    stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(27) <= sw_regs_out.spytrigger.trig_spy12_error;
    stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(28) <= sw_regs_out.spytrigger.trig_spy3_ready;
    stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(29) <= sw_regs_out.spytrigger.trig_spy12_ready;
    stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(30) <= sw_regs_out.spytrigger.trig_spy3_busy;
    stat_reg(to_integer(unsigned(OFFSET_SPYTRIGGER_STATUS)))(31) <= sw_regs_out.spytrigger.trig_spy12_busy;

-- dm
--     stat_reg(to_integer(unsigned(OFFSET_DM_STATUS)))(0) <= sw_regs_out.dm.valid;

-- tcm
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR)))(11 downto 0) <= sw_regs_out.tcm.bx_nr;
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_EVENT_NR)))(31 downto 0) <= sw_regs_out.tcm.event_nr;
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_TRIGGER_NR_L)))(31 downto 0) <= sw_regs_out.tcm.trigger_nr(31 downto 0);
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_TRIGGER_NR_H)))(TRIGGER_NR_WIDTH-1-32 downto 0) <= sw_regs_out.tcm.trigger_nr(TRIGGER_NR_WIDTH-1 downto 32);
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ORBIT_NR_L)))(31 downto 0) <= sw_regs_out.tcm.orbit_nr(31 downto 0);
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ORBIT_NR_H)))(ORBIT_NR_WIDTH-1-32 downto 0) <= sw_regs_out.tcm.orbit_nr(ORBIT_NR_WIDTH-1 downto 32);
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_CHK)))(31 downto 0) <= sw_regs_out.tcm.bx_nr_chk;
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_MAX)))(31 downto 0) <= sw_regs_out.tcm.bx_nr_max;
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_ERR_DET)))(0) <= sw_regs_out.tcm.err_det;
    stat_reg(to_integer(unsigned(OFFSET_TCM_STATUS_BX_NR_D_FDL)))(11 downto 0) <= sw_regs_out.tcm.bx_nr_d_fdl;
    stat_reg(to_integer(unsigned(OFFSET_TCM_LUMINOSITY_SEG_NR)))(31 downto 0) <= sw_regs_out.tcm.luminosity_seg_nr;

end architecture;



