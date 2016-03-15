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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/gt_mp7/trunk/src/gt_mp7_core/gt_mp7_core.vhd $
-- $Date: 2014-07-02 14:05:41 +0200 (Wed, 02 Jul 2014) $
-- $Author: bergauer $
-- $Revision: 3006 $
--------------------------------------------------------------------------------

-- Description: TDF on MP7

-- TDF
-- JW 2015-02-26: v0.0.18 - added lhc_clk to reset frame_cntr
-- JW 2015-02-24: v0.0.17 - added bc0 clk domain change in mux to get a 240mhz bc0 signal with 4.166ns pulse
-- JW 2015-02-24: v0.0.16 - included piped frame_cntr reset signal
-- JW 2015-02-23: v0.0.15 - included BC0 signal in frame_cntr reset, trying to synchronize frame_cntr with other logic
-- JW 2015-01-29: v0.0.14 - set valid bits of unused lanes back to sValid value (set by control register)
-- JW 2015-01-23: v0.0.13 - added a range for setting valid bits to 0, set valid of unused lanes always to 0
-- JW 2015-01-23: v0.0.12 - included control register to set valid, start and strobe bits of links
-- JW 2015-01-21: v0.0.11 - added formatter again
-- JW 2015-01-20: v0.0.10 - added FF between 40MHz RAM and 240MHz logic
-- JW 2015-01-19: v0.0.9 - Placed all dp_mem_4096 with planAhead to avoid timing errors
-- JW 2015-01-14: v0.0.8 - Using clk_p instead of clk_240
-- JW 2015-01-13: v0.0.7 - Testing without formatter
-- JW 2015-01-08: v0.0.6 - ucf changes
-- JW 2014-12-18: v0.0.5 - put frame_counter into mux and added tdf_payload.ucf (assigned all mux to the right area groups)
-- JW 2014-12-17: v0.0.4 - added new mp7_formatter.ucf to design and changed some bugs in the link assignment
-- JW 2014-12-11: v0.0.3 - changed lane mapping for the muons to new style
-- JW 2014-12-01: v0.0.2 - adapted code for MP7XE hardware rev
-- JW 2014-11-21: v0.0.1 - created tdf

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.mp7_data_types.all;
use work.mp7_brd_decl.all;
use work.mp7_ttc_decl.all;
use work.lhc_data_pkg.all;
use work.tdf_mp7_core_pkg.all;
use work.ipbus_decode_mp7_payload.all;
use work.top_decl.all;

entity mp7_payload is
    port(
        clk: in std_logic; -- ipbus signals
        rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus;
        clk_payload : in  std_logic_vector(2 downto 0);
        rst_payload : in  std_logic_vector(2 downto 0);
        clk_p: in std_logic; -- data clock
        rst_loc: in std_logic_vector(N_REGION - 1 downto 0);
        clken_loc: in std_logic_vector(N_REGION - 1 downto 0);
        ctrs: in ttc_stuff_array;
        bc0: out std_logic;
        d: in ldata(4 * N_REGION - 1 downto 0); -- data in
        q: out ldata(4 * N_REGION - 1 downto 0); -- data out
        gpio: out std_logic_vector(29 downto 0); -- IO to mezzanine connector
        gpio_en: out std_logic_vector(29 downto 0) -- IO to mezzanine connector (three-state enables)
    );
end mp7_payload;

architecture rtl of mp7_payload is


    signal ipb_to_slaves: ipb_wbus_array(N_SLAVES-1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(N_SLAVES-1 downto 0);

    signal dsmux_lhc_data : lhc_data_t;

	-- tdf signals
    signal bx_nr                       : std_logic_vector (15 DOWNTO 0); --! Bunch crossing counter (16 bits)
    signal bx_length                   : std_logic_vector (15 DOWNTO 0); --! Length between two orbit signals
    signal sbc0                        : std_logic_vector(0 downto 0); --bc0 signal for pipeline
    signal piped_bc0                   : piped_frame_reset;
--  JW - 18.12.2014 put frame_counter code into mux
--  signal frame_cntr                       : std_logic_vector (2 downto 0); --! counter for frame mux: 0 to 5

    signal mux_out                          : lword; --output to gth (1 for each lane)
    signal tdf_data_o                       : tdf_data_array(59 downto 0); -- output of MEMs to pipe
    signal s_tdf_data                       : tdf_data_array(59 downto 0); -- pipe to mux

    signal sw_reset                         : std_logic := '0';
    signal sw_reset_in                      : std_logic;
    signal ipbus_triggered_reset            : std_logic;
    signal lhc_rst                          : std_logic;


    signal lane                             : ldata(4 * N_REGION - 1 downto 0);

    signal sValid                           : std_logic;
    signal sStart                           : std_logic;
    signal sStrobe                          : std_logic;
    signal sThresholdValid_lo               : std_logic_vector (15 DOWNTO 0); -- same as bx_counter
    signal sThresholdValid_hi               : std_logic_vector (15 DOWNTO 0); -- same as bx_counter
    signal tdf_ctrl_regs_1                  : ipb_regs_array(0 to 3);
    constant TDF_CTRL_REGS_1_INIT           : ipb_regs_array(0 to 3) := (X"00000bb8", X"00000c80", X"00000000", X"00000001"); -- bb8 =^ 3000, c80 =^ 3200

    constant LWORD_RESET_VALUE   : lword := ((others => '0'), '0', '0', '0');
    signal s_mux0_in0            : lword := LWORD_RESET_VALUE;
    signal s_mux0_in1            : lword := LWORD_RESET_VALUE;
    signal s_mux0_in2            : lword := LWORD_RESET_VALUE;
    signal s_mux0_in3            : lword := LWORD_RESET_VALUE;
    signal s_mux0_in4            : lword := LWORD_RESET_VALUE;
    signal s_mux0_in5            : lword := LWORD_RESET_VALUE;

begin

-- Definition of patterns structure for TX/RX-buffer memories of MP7 for MicroGT
--
-- Naming convention:
-- Quad/Chan : qxxcy => GTH transceiver of FPGA quad xx channel y - here 4 quads are used
-- Link : number of the link
-- MUx => muon object x
-- EGx => electro/gamma object x
-- JETx => jet object x
-- TAUx => jet object x
-- ET, HT, ETmiss and HTmiss => esums objects
-- E(x:y) => external-condition bits
--
--  Quad/Chan :    q00c0      q00c1      q00c2      q00c3      q01c0      q01c1      q01c2      q01c3      q02c0      q02c1      q02c2      q02c3      q03c0      q03c1      q03c2      q03c3
--       Link :     00         01         02         03         04         05         06         07         08         09         10         11         12         13         14         15
-- Frame 0000 :    free       free       free       free       EG0        EG6        JET0       JET6       TAU0       TAU6       ET         free     E(31:0)   E(95:64)   E(159:128) E(223:192)
-- Frame 0001 :    free       free       free       free       EG1        EG7        JET1       JET7       TAU1       TAU7       HT         free     E(63:32)  E(127:96)  E(191:160) E(255:224)
-- Frame 0002 : MU0 (31:0) MU2 (31:0) MU4 (31:0) MU6 (31:0)    EG2        EG8        JET2       JET8       TAU2       free       ETmiss     free       free       free       free       free
-- Frame 0003 : MU0(63:32) MU2(63:32) MU4(63:32) MU6(63:32)    EG3        EG9        JET3       JET9       TAU3       free       HTmiss     free       free       free       free       free
-- Frame 0004 : MU1 (31:0) MU3 (31:0) MU5 (31:0) MU7 (31:0)    EG4        EG10       JET4       JET10      TAU4       free       free       free       free       free       free       free
-- Frame 0005 : MU1(63:32) MU3(63:32) MU5(63:32) MU7(63:32)    EG5        EG11       JET5       JET11      TAU5       free       free       free       free       free       free       free
-- Frame 0006 :    free       free       free       free       EG0        EG6        JET0       JET6       TAU0       TAU6       ET         free      E(31:0)   E(95:64)  E(159:128) E(223:192)
-- Frame 0007 :    free       free       free       free       EG1        EG7        JET1       JET7       TAU1       TAU7       HT         free     E(63:32)  E(127:96)  E(191:160) E(255:224)
-- Frame 0008 : MU0 (31:0) MU2 (31:0) MU4 (31:0) MU6 (31:0)    EG2        EG8        JET2       JET8       TAU2       free       ETmiss     free       free       free       free       free
-- Frame 0009 : MU0(63:32) MU2(63:32) MU4(63:32) MU6(63:32)    EG3        EG9        JET3       JET9       TAU3       free       HTmiss     free       free       free       free       free
-- Frame 0010 : MU1 (31:0) MU3 (31:0) MU5 (31:0) MU7 (31:0)    EG4        EG10       JET4       JET10      TAU4       free       free       free       free       free       free       free
-- Frame 0011 : MU1(63:32) MU3(63:32) MU5(63:32) MU7(63:32)    EG5        EG11       JET5       JET11      TAU5       free       free       free       free       free       free       free
-- ...
-- ... and so on, up to Frame 1023 !!!
--
-- Data-structure:
-- 1v03030000 => avbbbbbbbb: a means valid bit, always set to 1, bbbbbbbb: 32 bits data of objects

    fabric_i: entity work.ipbus_fabric_sel
    generic map(
        NSLV => N_SLAVES,
        SEL_WIDTH => IPBUS_SEL_WIDTH)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_mp7_payload(ipb_in.ipb_addr),
      ipb_to_slaves => ipb_to_slaves,
      ipb_from_slaves => ipb_from_slaves
    );

    -- Module Info register
    module_info_i: entity work.module_info
    port map(
        ipb_clk => clk,
        ipb_rst => rst,
        ipb_in => ipb_to_slaves(C_IPB_TDF_MODULE_INFO),
        ipb_out => ipb_from_slaves(C_IPB_TDF_MODULE_INFO)
    );

    -- Module Info register
    tdf_control_i: entity work.ipb_write_regs
    generic map(
        init_value => TDF_CTRL_REGS_1_INIT,
        addr_width => 4,
        regs_beg_index => 0,
        regs_end_index => 3
        )
    port map(
        clk => clk,
        reset => rst,
        ipbus_in => ipb_to_slaves(C_IPB_TDF_CONTROL),
        ipbus_out => ipb_from_slaves(C_IPB_TDF_CONTROL),
        regs_o => tdf_ctrl_regs_1
    );

    sThresholdValid_lo <= tdf_ctrl_regs_1(0)(15 downto 0);
    sThresholdValid_hi <= tdf_ctrl_regs_1(1)(15 downto 0);
    sStart          <= tdf_ctrl_regs_1(2)(0);
    sStrobe         <= tdf_ctrl_regs_1(3)(0);

    sbc0(0) <= ctrs(0).ttc_cmd(0);
    bc0 <= piped_bc0(0)(0);

--     frame_rst(0) <= lhc_rst or bc0;

--      JW - 18.12.2014 put frame_counter code into mux
--     -- frame counter
--     frame_counter: process (clk_p, lhc_rst)
--     begin
--         if (lhc_rst = '1') then
--            frame_cntr <= "000";      -- async. res
--         elsif (clk_p'event and clk_p = '1') then
--             if (frame_cntr = "101") then
--                 frame_cntr <= "000";   -- sync BCReset
--             else
--                 frame_cntr <= frame_cntr + '1';
--             end if;
--         end if;
--     end process frame_counter;

    s_mux0_in0 <= ((others => '0'), sValid, sStart, sStrobe);    -- frame 0   -> free
    s_mux0_in1 <= ((others => '0'), sValid, sStart, sStrobe);    -- frame 1   -> free
    s_mux0_in2 <= (s_tdf_data(0), sValid, sStart, sStrobe);    -- frame 2   -> mu0_lo
    s_mux0_in3 <= (s_tdf_data(1), sValid, sStart, sStrobe);    -- frame 3   -> mu0_hi
    s_mux0_in4 <= (s_tdf_data(2), sValid, sStart, sStrobe);    -- frame 4   -> mu1_lo
    s_mux0_in5 <= (s_tdf_data(3), sValid, sStart, sStrobe);     -- frame 5   -> mu1_hi

    -- mu0,mu1 mux
    mux0_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(0)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  s_mux0_in0,   -- frame 0   -> free
            in1     =>  s_mux0_in1,   -- frame 1   -> free
            in2     =>  s_mux0_in2,   -- frame 2   -> mu0_lo
            in3     =>  s_mux0_in3,   -- frame 3   -> mu0_hi
            in4     =>  s_mux0_in4,   -- frame 4   -> mu1_lo
            in5     =>  s_mux0_in5,   -- frame 5   -> mu1_hi
            -- sel     =>  frame_cntr,
            mux_out =>  q(0)
        );

    -- mu2,mu3 mux
    mux1_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(1)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 0   -> free
            in1     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 1   -> free
            in2     =>  (s_tdf_data(4), sValid, sStart, sStrobe),    -- frame 2   -> mu2_lo
            in3     =>  (s_tdf_data(5), sValid, sStart, sStrobe),      -- frame 3   -> mu2_hi
            in4     =>  (s_tdf_data(6), sValid, sStart, sStrobe),       -- frame 4   -> mu3_lo
            in5     =>  (s_tdf_data(7), sValid, sStart, sStrobe),       -- frame 5   -> mu3_hi
            -- sel     =>  frame_cntr,
            mux_out =>  q(1)
        );

    -- mu4,mu5 mux
    mux2_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(2)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 0   -> free
            in1     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 1   -> free
            in2     =>  (s_tdf_data(8), sValid, sStart, sStrobe),    -- frame 2   -> mu4_lo
            in3     =>  (s_tdf_data(9), sValid, sStart, sStrobe),      -- frame 3   -> mu4_hi
            in4     =>  (s_tdf_data(10), sValid, sStart, sStrobe),       -- frame 4   -> mu5_lo
            in5     =>  (s_tdf_data(11), sValid, sStart, sStrobe),       -- frame 5   -> mu5_hi
            -- sel     =>  frame_cntr,
            mux_out =>  q(2)
        );

    -- mu6,mu7 mux
    mux3_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(3)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 0   -> free
            in1     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 1   -> free
            in2     =>  (s_tdf_data(12), sValid, sStart, sStrobe),    -- frame 2   -> mu6_lo
            in3     =>  (s_tdf_data(13), sValid, sStart, sStrobe),      -- frame 3   -> mu6_hi
            in4     =>  (s_tdf_data(14), sValid, sStart, sStrobe),       -- frame 4   -> mu7_lo
            in5     =>  (s_tdf_data(15), sValid, sStart, sStrobe),       -- frame 5   -> mu7_hi
            -- sel     =>  frame_cntr,
            mux_out =>  q(3)
        );

    -- eg0-eg5 mux
    mux4_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(4)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(16), sValid, sStart, sStrobe),    -- frame 0   -> eg0
            in1     =>  (s_tdf_data(17), sValid, sStart, sStrobe),      -- frame 1   -> eg1
            in2     =>  (s_tdf_data(18), sValid, sStart, sStrobe),       -- frame 2   -> eg2
            in3     =>  (s_tdf_data(19), sValid, sStart, sStrobe),       -- frame 3   -> eg3
            in4     =>  (s_tdf_data(20), sValid, sStart, sStrobe),    -- frame 4   -> eg4
            in5     =>  (s_tdf_data(21), sValid, sStart, sStrobe),    -- frame 5   -> eg5
            -- sel     =>  frame_cntr,
            mux_out =>  q(4)
        );

    -- eg6-eg11 mux
    mux5_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(5)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(22), sValid, sStart, sStrobe),    -- frame 0   -> eg6
            in1     =>  (s_tdf_data(23), sValid, sStart, sStrobe),      -- frame 1   -> eg7
            in2     =>  (s_tdf_data(24), sValid, sStart, sStrobe),       -- frame 2   -> eg8
            in3     =>  (s_tdf_data(25), sValid, sStart, sStrobe),       -- frame 3   -> eg9
            in4     =>  (s_tdf_data(26), sValid, sStart, sStrobe),    -- frame 4   -> eg10
            in5     =>  (s_tdf_data(27), sValid, sStart, sStrobe),    -- frame 5   -> eg11
            -- sel     =>  frame_cntr,
            mux_out =>  q(5)
        );

    -- tau0-tau5 mux
    mux6_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(6)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(28), sValid, sStart, sStrobe),    -- frame 0   -> tau0
            in1     =>  (s_tdf_data(29), sValid, sStart, sStrobe),      -- frame 1   -> tau1
            in2     =>  (s_tdf_data(30), sValid, sStart, sStrobe),       -- frame 2   -> tau2
            in3     =>  (s_tdf_data(31), sValid, sStart, sStrobe),       -- frame 3   -> tau3
            in4     =>  (s_tdf_data(32), sValid, sStart, sStrobe),    -- frame 4   -> tau4
            in5     =>  (s_tdf_data(33), sValid, sStart, sStrobe),    -- frame 5   -> tau5
            -- sel     =>  frame_cntr,
            mux_out =>  q(8)
        );

    -- tau6-tau7 mux
    mux7_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(7)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(34), sValid, sStart, sStrobe),    -- frame 0   -> tau6
            in1     =>  (s_tdf_data(35), sValid, sStart, sStrobe),      -- frame 1   -> tau7
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(9)
        );

    -- jet0-jet5 mux
    mux8_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(8)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(36), sValid, sStart, sStrobe),    -- frame 0   -> jet0
            in1     =>  (s_tdf_data(37), sValid, sStart, sStrobe),      -- frame 1   -> jet1
            in2     =>  (s_tdf_data(38), sValid, sStart, sStrobe),       -- frame 2   -> jet2
            in3     =>  (s_tdf_data(39), sValid, sStart, sStrobe),       -- frame 3   -> jet3
            in4     =>  (s_tdf_data(40), sValid, sStart, sStrobe),    -- frame 4   -> jet4
            in5     =>  (s_tdf_data(41), sValid, sStart, sStrobe),    -- frame 5   -> jet5
            -- sel     =>  frame_cntr,
            mux_out =>  q(6)
        );

    -- jet6-jet11 mux
    mux9_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(9)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(42), sValid, sStart, sStrobe),    -- frame 0   -> jet6
            in1     =>  (s_tdf_data(43), sValid, sStart, sStrobe),      -- frame 1   -> jet7
            in2     =>  (s_tdf_data(44), sValid, sStart, sStrobe),       -- frame 2   -> jet8
            in3     =>  (s_tdf_data(45), sValid, sStart, sStrobe),       -- frame 3   -> jet9
            in4     =>  (s_tdf_data(46), sValid, sStart, sStrobe),    -- frame 4   -> jet10
            in5     =>  (s_tdf_data(47), sValid, sStart, sStrobe),    -- frame 5   -> jet11
            -- sel     =>  frame_cntr,
            mux_out =>  q(7)
        );

    -- et, ht, etm, htm mux
    mux10_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(10)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(48), sValid, sStart, sStrobe),    -- frame 0   -> et
            in1     =>  (s_tdf_data(49), sValid, sStart, sStrobe),      -- frame 1   -> ht
            in2     =>  (s_tdf_data(50), sValid, sStart, sStrobe),       -- frame 2   -> etm
            in3     =>  (s_tdf_data(51), sValid, sStart, sStrobe),       -- frame 3   -> htm
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(10)
        );

    -- free mux
    mux11_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(11)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 0   -> free
            in1     =>  ((others => '0'), sValid, sStart, sStrobe),      -- frame 1   -> free
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(11)
        );

    -- E(31:0), E(63:31) mux
    mux12_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(12)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(52), sValid, sStart, sStrobe),    -- frame 0   -> E(31:0)
            in1     =>  (s_tdf_data(53), sValid, sStart, sStrobe),      -- frame 1   -> E(63:31)
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(12)
        );

    --  E(95:64), E(127:96) mux
    mux13_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(13)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(54), sValid, sStart, sStrobe),    -- frame 0   -> E(95:64)
            in1     =>  (s_tdf_data(55), sValid, sStart, sStrobe),      -- frame 1   -> E(127:96)
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(13)
        );

    -- E(159:128), E(191:160)  mux
    mux14_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(14)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(56), sValid, sStart, sStrobe),    -- frame 0   -> E(159:128)
            in1     =>  (s_tdf_data(57), sValid, sStart, sStrobe),      -- frame 1   -> E(191:160)
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(14)
        );

    -- E(223:192), E(255:224) mux
    mux15_i: entity work.mux
        port map
        (
            clk     =>  clk_p,
            res     =>  lhc_rst,
            bcres   =>  piped_bc0(15)(0),
            -- lhc_clk   =>  clk_payload,
            in0     =>  (s_tdf_data(58), sValid, sStart, sStrobe),    -- frame 0   -> E(223:192)
            in1     =>  (s_tdf_data(59), sValid, sStart, sStrobe),      -- frame 1   -> E(255:224)
            in2     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 2   -> free
            in3     =>  ((others => '0'), sValid, sStart, sStrobe),       -- frame 3   -> free
            in4     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 4   -> free
            in5     =>  ((others => '0'), sValid, sStart, sStrobe),    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  q(15)
        );

    -- bc counter
    bc_cntr: process (clk_payload(0), ctrs(0).ttc_cmd(0))
    begin
--      if ( internal_reset_i = '1') then
--            bx_nr <= X"0000";      -- async. clr
--            bx_length <= X"0000";      -- async. clr
--      else
        if (clk_payload(0)'event and clk_payload(0) = '1') then
           if (ctrs(0).ttc_cmd(0) = '1') then
              bx_length <= bx_nr; -- "store" counter value for reading
              bx_nr <= X"0000";   -- sync BCReset
           else
              bx_nr <= bx_nr + 1;
           end if;
        end if;
--      end if;
    end process bc_cntr;

    -- set sValid process
    p_sValid: process (clk_payload(0), bx_nr, sThresholdValid_lo, sThresholdValid_hi)
    begin
        if (clk_payload(0)'event and clk_payload(0) = '1') then -- shift range for one bx? because of possible 1bx delay
           if ((bx_nr >= sThresholdValid_lo) and (bx_nr <= sThresholdValid_hi)) then --define range
              sValid <= '0';
           else
              sValid <= '1';
           end if;
        end if;
--      end if;
    end process p_sValid;

    -- tdf memory
    tdf_mem_l: for i in 0 to 59 generate -- 60 memory blocks with LHC_DATA_WIDTH = 1920
        tdfspy_mem_i: entity work.ipb_dpmem_4096_32
        port map
        (
            ipbus_clk => clk,
            reset     => rst,
            ipbus_in  => ipb_to_slaves(C_IPB_TDFMEM(i)),
            ipbus_out => ipb_from_slaves(C_IPB_TDFMEM(i)),
            ------------------
            clk_b     => clk_payload(0),
            enb       => '1',
            web       => '0', -- spy1 = 1 => spying, spy1 = 0 => simulation data out
            addrb     => bx_nr(11 downto 0), -- HB 2014-08-18: no write and no read latency
            dinb      => (others => '0'),
            doutb     => tdf_data_o(i)
        );
    end generate tdf_mem_l;



    tdf_pipe_l: for j in 0 to 59 generate -- 60 piplines for 32 bit vectors
        -- memory pipeline
        mem_pipe_i: entity work.mem_pipe
        port map
        (
            clk     =>  clk_payload(0),
            pipe_in =>  tdf_data_o(j),
            pipe_out => s_tdf_data(j)
        );
    end generate tdf_pipe_l;


    bcres_pipe_l: for k in 0 to 15 generate -- 15 piplines for bcres for each frame_cntr
        -- memory pipeline
        bcres_pipe_i: entity work.mem_pipe
        generic map
        (
        addr_width => 0
        )
        port map
        (
            clk     =>  clk_payload(0),
            pipe_in =>  sbc0,
            pipe_out => piped_bc0(k)
        );
    end generate bcres_pipe_l;

--     --=============================--
--     process(res, clk)
--     --=============================--
--     begin
--     if res = '1' then
--         clk_temp0 <= '0';
--         clk_temp1 <= '0';
--         bcres240 <= '0';
--     elsif rising_edge(clk_p) then
--         clk_temp0 <= clk_p;
--         clk_temp1 <= clk_temp0;
--         bcres240 <= temp0 and not temp1;
--     end if;
--     end process;

--     mux_clk <=          clk_p     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"00" else    --CONV_00
--                         fmc1_from_pin_to_fabric.la_cmos_n(0)     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"01" else    --CONV_01
--                         fmc1_from_pin_to_fabric.la_cmos_p(3)     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"02" else    --CONV_02
--                         fmc1_from_pin_to_fabric.la_cmos_n(3)     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"03" else    --CONV_03
--                         fmc1_from_pin_to_fabric.la_cmos_p(8)     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"04" else    --CONV_04
--                         fmc1_from_pin_to_fabric.la_cmos_n(8)     when   regs_from_ipb(WRITE_REGS_BEGIN_INDEX)(15 downto 8)   =   X"05" else    --CONV_05

--     -- memory_pipeline
--     mem_pipe: process (clk_payload, tdf_data_o)
--     begin
--         if (clk_payload'event and clk_payload = '1') then
--            s_tdf_data <= tdf_data_o;
--         end if;
-- --      end if;
--     end process mem_pipe;
--

-- 	q <= lane;

end rtl;

