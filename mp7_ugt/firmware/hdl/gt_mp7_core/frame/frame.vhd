-- Description:
-- Contains the "framework" of GT-logic (all parts, except GTL and FDL).

-- JW 2017-04-16: v1.1.1 - added counter reset pulse
-- HB 2016-09-16: v1.1.0 - based on v1.0.0, but memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd).
--                         Removed algo_after_finor_mask_rop from port (not used anymore, because finor-mask logic removed from fdl_module.vhd).
--                         Removed multiplexer for simulation signals. Removed "resync" and "stop" from port of tcm, not used anymore.
-- HB 2016-08-31: v1.0.0 - based on v0.0.41, but used tcm.vhd with correct lumi-section.
-- JW 2016-04-19: v0.0.41 - added a delay for the bcres240 in the output mux, to compensate the 0,5BX delay which results form the clock domain change.
-- HB 2016-04-25: v0.0.40 - updated tcm.vhd (resync not used anymore and OC0 resets orbit number and lumi-section number to 1).
-- JW 2016-04-19: v0.0.39 - connected the bcres_outputmux_o to the output mux, changed the mux code to sync the bcres signal and convert it to 240MHz domain
-- HB 2016-04-11: v0.0.38 - implemented delays for EC0, OC0, RESYNC and START (same delay as BCRES) and inserted bcres_outputmux_o (delayed version of bcres for output mux) in dm.vhd.
--                Inserted reset of lumi-section number with OC0 and used signals of synchronized (and delayed) BGos in tcm.vhd.
--                Used "algo_after_gtLogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") in output_mux.vhd (according to fdl_module v0.0.24).
--                Changed tp_mux.vhd for synchronized BGos.
-- HB 2016-03-23: v0.0.37 - removed l1asim module, inserted B-Go signals and l1a (ports) for tcm module.
-- HB 2016-02-26: v0.0.36 - removed unused fdl_status, bx_nr_d_FDL and tp.
-- HEPHY 2015-06-11: v0.1.4  changed ROP for 32-bits and usage of 40Mhz clock domain for calculation the data
-- HEPHY 2015-05-07: new concpept for simulation the design and especially for ROP. The concept is based on modularity by using new input ports. The case now is for ROP, which is should be extended for ugt payload.
-- HEPHY 2015-05-29: changed the ports for simulation desing concept
-- HEPHY 2015-05-19: v0.0.17 - based on v0.0.16, but an output_mux for sending algo & finor data to tx buffer and to the links
-- HEPHY 2015-05-24: v0.0.16 - based on v0.0.15, but added a pulse reg and connected its output to reset logic
-- HEPHY 2015-05-1 :"Milestone" : lhc_rst is for doing the reset the counter in tcm module. It is implmented as resgister, which later should be re-implemented as event register.
-- HB 2015-02-05: v0.0.13 - based on v0.0.12, but cleaned up the code and changed demux_lane_data (removed port del_a).
-- HEPHY: 04.02.2015 Delay Manager out put was zero, becaue lhc_rst for ip-bus and PCI-e is different. RST_ACT is defined in package. frame version 0.0.12
-- HEPHY 2015-02-03: "bcres_d" is used, which commes from DM, frame version 0.0.11

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.frame_addr_decode.all;
use work.gt_mp7_core_pkg.all;
use work.rb_pkg.all;
use work.mp7_ttc_decl.all;

entity frame is
    generic(
        NR_LANES            : positive;
        SIMULATE_DATAPATH   : boolean := false
     );
    port(
        ipb_clk            : in std_logic;
        ipb_rst            : in std_logic;
        ipb_in             : in ipb_wbus;
        ipb_out            : out ipb_rbus;
        ctrs               : in ttc_stuff_array; --mp7 ttc ctrs
        clk240            : in std_logic;
        lhc_clk            : in std_logic;
        lhc_rst_o        : out std_logic;
        bc0            : in std_logic;
        ec0: in std_logic;
        oc0: in std_logic;
--         resync: in std_logic;
        start: in std_logic;
        l1a            : in std_logic;
        bcres_d        : out std_logic;
        bcres_d_FDL        : out std_logic;
        start_lumisection     : out std_logic;
        lane_data_in        : in ldata(NR_LANES-1 downto 0);
        lane_data_out        : out ldata(NR_LANES-1 downto 0);
        dsmux_lhc_data_o    : out lhc_data_t;
        prescale_factor_set_index_rop : in std_logic_vector(7 downto 0);
        algo_after_gtLogic_rop        : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop        : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
--         algo_after_finor_mask_rop     : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop         : in std_logic;
        local_veto_rop          : in std_logic;
        finor_rop               : in std_logic;
        local_finor_with_veto_2_spy2 : in std_logic
    );

end frame;

architecture rtl of frame is

-- ================================================================================================
    signal lhc_rst : std_logic;
    signal cntr_rst : std_logic;
    signal sw_reset : std_logic; -- this reset is triggered by writing to the software register for the sw_reset
    signal ipbus_triggered_reset : std_logic; -- this is a 40mhz reset signal generated from the sys reset
-- ================================================================================================

    signal ipb_to_slaves: ipb_wbus_array(NR_IPB_SLV_FRAME-1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(NR_IPB_SLV_FRAME-1 downto 0);

    -- register bank
    signal sw_regs_in : sw_regs_in_t;
    signal sw_regs_out : sw_regs_out_t;

    signal rb2dm : sw_reg_dm_in_t;
    signal dm2rb : sw_reg_dm_out_t;

    signal rb2sw_reset : sw_reg_sw_reset_in_t;

    signal rb2spytrig : sw_reg_spytrigger_in_t;
    signal spytrig2rb : sw_reg_spytrigger_out_t;

    signal rb2dsmux : sw_reg_dsmux_in_t;

    signal rb2tcm : sw_reg_tcm_in_t;
    signal tcm2rb : sw_reg_tcm_out_t;

    signal demux_data_o : demux_lanes_data_objects_array_t(NR_LANES-1 downto 0);
    signal demux_data_valid_o : demux_lanes_data_objects_array_valid_t(NR_LANES-1 downto 0);

    signal sim_lhc_data     : lhc_data_t; -- lhc_data output of sim memory
    signal lmp_lhc_data_o   : lhc_data_t; -- lhc_data output of lane mapping process
    signal dm_lhc_data_o    : lhc_data_t; -- lhc_data output of delay manager
    signal dsmux_lhc_data_int : lhc_data_t; -- lhc_data output of dsmux
    signal dsmux_lhc_data_valid : std_logic;
    signal lmp_lhc_data_valid_o   : std_logic;
    signal dm_lhc_data_valid_o   : std_logic;

    signal bcres             : std_logic; -- NOT USED, "bc0" of mp7_ttc is used instead of "bcres"
    signal bcres_d_int       : std_logic; -- delayed version of bcres
    signal bcres_d_FDL_int   : std_logic; -- delayed version of bcres for FDL
    signal bcres_outputmux   : std_logic; -- non-delayed version of bcres for output mux

    --TCM signals
    signal bx_nr             : bx_nr_t;
    signal bx_nr_d_FDL_int   : bx_nr_t;
    signal event_nr          : event_nr_t;
    signal trigger_nr        : trigger_nr_t;
    signal orbit_nr          : orbit_nr_t;
    signal luminosity_seg_nr : luminosity_seg_nr_t;

    -- sim/spy mem
    signal spy1 : std_logic;
    signal spy2 : std_logic;
    signal spy3 : std_logic;
    signal spy3_ack : std_logic;
    signal simmem_in_use : std_logic;

-- demux_lane_adjust: default value (input to demux_lane_data.vhd [del_a] -
-- for generating a phase shifted LHC-clock to get pipeline data into a shifted LHC-clock domain.
-- Shifting is done by the inverted 240MHz clock, to prevent multistabability)
    constant INIT_DEMUX_LANE_ADJ_REG : ipb_regs_array(0 downto 0) := (others => X"00000005");
    signal demux_lane_adjust : std_logic_vector (2 downto 0);
    signal demux_lane_adjust_reg : ipb_regs_array(0 downto 0);

    signal finors_rop : std_logic_vector (FINOR_WIDTH-1 downto 0) := (others => '0');

-- HB 2016-09-16: SW_DATA_WIDTH defined in lhc_data_pkg.vhd
    constant MEMORY_BLOCKS : integer := LHC_DATA_WIDTH/SW_DATA_WIDTH;

    signal lhc_data_slv_o : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
    signal lhc_data_slv_i : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);

    signal local_finor_with_veto_2_spy2_int   : std_logic_vector (31 downto 0);

    signal pulse           : std_logic_vector(31 downto 0);

    signal mux_ctrl_regs_1 : ipb_regs_array(0 to 15);
-- HEPHY 25.05.2015 - change to constant for avoiding the metastability and warning in simulator as well as in syntheseis process
    constant  mux_ctrl_regs_1_init  : ipb_regs_array(0 to 15) := (X"00000bb8", X"00000c80", X"00000000", X"00000001", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",); -- bb8 =^ 3000, c80 =^ 3200

    signal dsmux_lhc_data_int_sim : lhc_data_t; -- lhc_data output of dsmux
    signal dsmux_lhc_data_int_rop : lhc_data_t; --simulation data for ROP
    signal lhc_rst_internal       : std_logic;

--TCM signals
    signal bx_nr_internal    : bx_nr_t;
    signal event_nr_internal    : event_nr_t;
    signal trigger_nr_internal    : trigger_nr_t;
    signal orbit_nr_internal    : orbit_nr_t;
    signal luminosity_seg_nr_internal    : luminosity_seg_nr_t;

    signal ec0_d_int       : std_logic;
    signal oc0_d_int       : std_logic;
    signal start_d_int       : std_logic;

    begin

--===============================================================================================--
--                         RESET LOGIC
--===============================================================================================--

-- similar to gt_amc514
    -- provides the possibility for a sw-reset
    sw_reset_inst : entity work.sw_reset
        port map(
                lhc_clk   => lhc_clk,
                sw_reg_in => rb2sw_reset,
                sw_reset  => sw_reset
        );

    --! generates 40Mhz reset signal from IPBus reset
    lhc40mhz_rst0: entity work.slow_cd_reset
        port map(
            sys_rst => ipb_rst,
            sys_clk => ipb_clk,
            slow_clk => lhc_clk,
            slow_rst => ipbus_triggered_reset
        );

--  lhc_rst = RST_ACT (= '1' in this version) and ipb_rst => high active !!!
--                    sw_reset = low active !!!
--     lhc_rst <= sw_reset and ipbus_triggered_reset; -- old !!!
-- HEPHY "Milestone" : lhc_rst is for doing the reset the counter in tcm module. It is implmented as resgister, which later should be re-implemented as event register.
--  added pulse reg output to reset logic

    lhc_rst <= not sw_reset or ipbus_triggered_reset or pulse(0);
    cntr_rst <= pulse(1); -- counter reset
    lhc_rst_o <= lhc_rst;
    lhc_rst_internal <= lhc_rst;
--     rop_rst_internal <= not(not sw_reset or ipbus_triggered_reset or pulse(0));

--===============================================================================================--
    fabric_i: entity work.frame_fabric
        generic map(NSLV => NR_IPB_SLV_FRAME)
        port map(
            ipb_clk => ipb_clk,
            ipb_rst => ipb_rst,
            ipb_in => ipb_in,
            ipb_out => ipb_out,
            ipb_to_slaves => ipb_to_slaves,
            ipb_from_slaves => ipb_from_slaves
    );

--===============================================================================================--
-- Module Info register
    module_info_i: entity work.frame_module_info
    port map(
        ipb_clk => ipb_clk,
        ipb_rst => ipb_rst,
        ipb_in => ipb_to_slaves(C_IPB_MODULE_INFO),
        ipb_out => ipb_from_slaves(C_IPB_MODULE_INFO)
    );

--===============================================================================================--
-- HEPHY 24.05.2015 - added ipb event register
-- IPBus pulse registger (sw_reset)
    pulse_reg_i: entity work.ipb_pulse_regs
    port map(
        ipb_clk => ipb_clk,
        ipb_reset => ipb_rst,
        ipb_mosi_i => ipb_to_slaves(C_IPB_PULSEREG),
        ipb_miso_o => ipb_from_slaves(C_IPB_PULSEREG),
        lhc_clk             =>  lhc_clk,
        pulse_o             => pulse
    );

--===============================================================================================--
-- MUX ctrl register
    tdf_control_i: entity work.ipb_write_regs
    generic map(
        init_value => mux_ctrl_regs_1_init,
        addr_width => 4,
        regs_beg_index => 0,
        regs_end_index => 15
        )
    port map(
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_MUX_CONTROL),
        ipbus_out => ipb_from_slaves(C_IPB_MUX_CONTROL),
        regs_o => mux_ctrl_regs_1
    );

--===============================================================================================--
--                        REGISTER BANK
--===============================================================================================--

    register_bank: entity work.rb
--         generic map(addr_width => C_RB_ADDR_WIDTH) -- C_IPB_RB definition in frame_addr_decode.vhd
        port map(
            sys_clk       => ipb_clk,
            lhc_clk       => lhc_clk,
            sys_rst       => ipb_rst,
            lhc_rst       => lhc_rst,

            -- data interface for IPBus
            data_acc_in  => ipb_to_slaves(C_IPB_RB),
            data_acc_out => ipb_from_slaves(C_IPB_RB),

            -- data interface for fpga access
            sw_regs_in  => sw_regs_in, -- sw registers written via IPBus and read by the fpga
            sw_regs_out => sw_regs_out  -- sw registers read via IPBus and written by the fpga
        );

    rb2dm       <= sw_regs_in.dm;
    rb2sw_reset <= sw_regs_in.sw_reset;
    rb2spytrig  <= sw_regs_in.spytrigger;
    rb2dsmux    <= sw_regs_in.dsmux;
    rb2tcm      <= sw_regs_in.tcm;

    sw_regs_out.dm         <= dm2rb;
    sw_regs_out.spytrigger <= spytrig2rb;
    sw_regs_out.tcm        <= tcm2rb;

--===============================================================================================--
--                          TIMER COUNTER MODULE                             --
--===============================================================================================--

    tcm_inst: entity work.tcm
        port map(
            lhc_clk           => lhc_clk,
            lhc_rst           => lhc_rst,
            cntr_rst          => cntr_rst,
-- HB 2016-03-17: all bgos from dm.vhd
	    ec0               => ec0_d_int,
	    oc0               => oc0_d_int,
	    start             => start_d_int,
            l1a_sync          => l1a,
            bcres_d           => bcres_d_int,
            bcres_d_FDL       => bcres_d_FDL_int,
            sw_reg_in         => rb2tcm,
            sw_reg_out        => tcm2rb,
            bx_nr             => bx_nr,
            bx_nr_d_FDL       => bx_nr_d_FDL_int,
            event_nr          => event_nr,
            trigger_nr        => trigger_nr,
            orbit_nr          => orbit_nr,
            luminosity_seg_nr => luminosity_seg_nr,
            start_lumisection => start_lumisection
        );

    trigger_nr_internal <= trigger_nr;
    orbit_nr_internal <= orbit_nr;
    luminosity_seg_nr_internal <= luminosity_seg_nr;
    event_nr_internal <= event_nr;
    bx_nr_internal <= bx_nr;

--===============================================================================================--
--                             Proposed structure of lanes:
-- ===============================================================================================
-- Object types/Objects from Calop Layer 2 to uGT:
-- protocol : 192 bits/lane, one object has 32-bits.
-- =======================================================
--
-- Object-type         Objects     used GTHs   link
--                     (32 bits)
-- electron/gamma      6 (5..0)        1        4
-- electron/gamma      6 (11..6)       1        5
-- jet                 6 (5..0)        1        6
-- jet                 6 (11..6)       1        7
-- tau                 6 (5..0)        1        8
-- tau                 6 (11..6)       1        9
-- esums               6               1       10
-- spare               6               1       11
-- ext-cond(63..0)     2               1       12
-- ext-cond(127..64)   2               1       13
-- ext-cond(191..128)  2               1       14
-- ext-cond(255..192)  2               1       15
--                     (64 bits)
-- muon                2 (1..0)        1        0
-- muon                2 (3..2)        1        1
-- muon                2 (5..4)        1        2
-- muon                2 (7..6)        1        3
-- __________________________________________________________
-- Summary             72 (32 bits)    16
--
-- Proposed structure of objects (32 bits) within the 192 bits:
--             192...........................0
-- e/g         5      4     3    2    1      0
-- e/g         11     10    9    8    7      6
-- jet         5      4     3    2    1      0
-- jet         11     10    9    8    7      6
-- tau         5      4     3    2    1      0
-- tau         11     10    9    8    7      6
-- esums       HTmHF  ETmHF HTm* ETm* HT,TC* ET,ETTEM*
-- ext-cond    x      x     x    x    1      0
-- ext-cond    x      x     x    x    3      2
-- ext-cond    x      x     x    x    5      4
-- ext-cond    x      x     x    x    7      6
-- muon        1h     1l    0h   0l   x      x
-- muon        3h     3l    2h   2l   x      x
-- muon        5h     5l    4h   4l   x      x
-- muon        7h     7l    6h   6l   x      x
--
-- *) in addition 4 MSBs for Minimum Bias bits. TC means "TOWERCNT" (ECAL sum)

-- 	type muon_array_t is array(0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(MUON_DATA_WIDTH-1 downto 0);
-- 	type eg_array_t is array(0 to EG_ARRAY_LENGTH-1) of std_logic_vector(EG_DATA_WIDTH-1 downto 0);
-- 	type tau_array_t is array(0 to TAU_ARRAY_LENGTH-1) of std_logic_vector(TAU_DATA_WIDTH-1 downto 0);
-- 	type jet_array_t is array(0 to JET_ARRAY_LENGTH-1) of std_logic_vector(JET_DATA_WIDTH-1 downto 0);
--
-- 	type lhc_data_t is record
-- 		muon : muon_array_t;
-- 		eg : eg_array_t;
-- 		tau : tau_array_t;
-- 		jet : jet_array_t;
-- 		ett : std_logic_vector(ETT_DATA_WIDTH-1 downto 0);
-- 		ht : std_logic_vector(HT_DATA_WIDTH-1 downto 0);
-- 		etm : std_logic_vector(ETM_DATA_WIDTH-1 downto 0);
-- 		htm : std_logic_vector(HTM_DATA_WIDTH-1 downto 0);
-- 		etmhf : std_logic_vector(ETMHF_DATA_WIDTH-1 downto 0);
-- 		htmhf : std_logic_vector(HTMHF_DATA_WIDTH-1 downto 0);
-- 		link_11_fr_0_data : std_logic_vector(LINK_11_FR_0_WIDTH-1 downto 0);
-- 		link_11_fr_1_data : std_logic_vector(LINK_11_FR_1_WIDTH-1 downto 0);
-- 		link_11_fr_2_data : std_logic_vector(LINK_11_FR_2_WIDTH-1 downto 0);
-- 		link_11_fr_3_data : std_logic_vector(LINK_11_FR_3_WIDTH-1 downto 0);
-- 		link_11_fr_4_data : std_logic_vector(LINK_11_FR_4_WIDTH-1 downto 0);
-- 		link_11_fr_5_data : std_logic_vector(LINK_11_FR_5_WIDTH-1 downto 0);
-- 		external_conditions : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
-- 	end record;

--===============================================================================================--

--===============================================================================================--
--                                     BEGIN OF DATA-PATH
--================================================================================================

-- DEMUX LANES
    demux_lane_data_l: for i in 0 to NR_LANES-1 generate
        demux_lane_data_i: entity work.demux_lane_data
            port map(clk240 => clk240, lhc_clk => lhc_clk,
                lane_data_in => lane_data_in(i),
                demux_data_o => demux_data_o(i),
                demux_data_valid_o => demux_data_valid_o(i)
        );
    end generate;

-- LMP (containt to be checked)
    lmp_i: entity work.lmp
        generic map(NR_LANES => NR_LANES)
        port map(
            demux_data_i => demux_data_o(NR_LANES-1 downto 0),
            demux_data_valid_i => demux_data_valid_o(NR_LANES-1 downto 0),
            lhc_data_o => lmp_lhc_data_o,
            lhc_data_valid_o => lmp_lhc_data_valid_o
        );

-- DM
    dm_i: entity work.dm
        port map(
            lhc_clk => lhc_clk,
            lhc_rst => lhc_rst,
            lhc_data_i => lmp_lhc_data_o,
            lhc_data_o => dm_lhc_data_o,
            bcres_i => bc0,
            ec0_i => ec0,
            oc0_i => oc0,
            resync_i => '0',
            start_i => start,
            bcres_o => bcres_d_int,
            ec0_o => ec0_d_int,
            oc0_o => oc0_d_int,
            resync_o => open,
            start_o => start_d_int,
            bcres_fdl_o => bcres_d_FDL_int,
            bcres_outputmux_o => bcres_outputmux,
            valid_i => lmp_lhc_data_valid_o,
            valid_o => dm_lhc_data_valid_o,
            sw_reg_i    => rb2dm,
            sw_reg_o    => dm2rb
        );

    bcres_d_FDL <= bcres_d_FDL_int;
    bcres_d <= bcres_d_int;

--===============================================================================================--
--                           SIM/SPY MEMORY
--===============================================================================================--

    spytrig_inst: entity work.spytrig
        port map(
            lhc_clk    => lhc_clk,
            lhc_rst    => lhc_rst,
            orbit_nr   => orbit_nr,
            bx_nr      => bx_nr,
            sw_reg_i   => rb2spytrig,
            sw_reg_o   => spytrig2rb,

            spy1_o     => spy1,
            spy2_o     => spy2,
            spy3_o     => spy3,
            spy3_ack_i => spy3_ack,

            simmem_in_use_i => simmem_in_use
        );

--===============================================================================================--
--                                SIMSPYMEM          lhc_data_slv_i_simulator
--===============================================================================================--
-- HB 2106-05-31: memory structure with all frames of calo links for extended test-vector-file structure (see lhc_data_pkg.vhd)
-- 72 memory blocks with LHC_DATA_WIDTH = 2304
--     simspy_mem_l: for i in 0 to LHC_DATA_WIDTH/SW_DATA_WIDTH-1 generate
    simspy_mem_l: for i in 0 to 71 generate

      simspy_mem_i: entity work.ipb_dpmem_4096_32
         port map(
             ipbus_clk => ipb_clk,
             reset     => ipb_rst,
             ipbus_in  => ipb_to_slaves(C_IPB_SIMSPYMEM(i)),
             ipbus_out => ipb_from_slaves(C_IPB_SIMSPYMEM(i)),
             ------------------
             clk_b     => lhc_clk,
             enb       => '1',
             web       => spy1, -- spy1 = 1 => spying, spy1 = 0 => simulation data out
             addrb     => bx_nr, -- HB 2014-08-18: no write and no read latency
	     dinb      => lhc_data_slv_i( (i+1)*SW_DATA_WIDTH-1 downto i*SW_DATA_WIDTH ),
             doutb     => lhc_data_slv_o( (i+1)*SW_DATA_WIDTH-1 downto i*SW_DATA_WIDTH )
         );
     end generate simspy_mem_l;

    sim_lhc_data <= std_logic_vector_to_lhc_data_t(lhc_data_slv_o);
    lhc_data_slv_i <= lhc_data_t_to_std_logic_vector(dm_lhc_data_o);

--===============================================================================================--
--                           Data Source Multiplex--DSMUX
--===============================================================================================--

    dsmux_i: entity work.dsmux
        generic map(    USE_SW_INPUT_REGISTER => false,
            USE_SIMMEM_IN_USE_OUTPUT_REGISTER => true
            )
        port map(
            lhc_clk => lhc_clk,
            lhc_rst => lhc_rst,
        sw_reg_i => rb2dsmux,
            lhc_data_sim_i => sim_lhc_data,
            lhc_data_ext_i => dm_lhc_data_o,
            lhc_data_sim_valid_i => '0',
            lhc_data_ext_valid_i => dm_lhc_data_valid_o,
            lhc_data_o => dsmux_lhc_data_int,
            lhc_data_valid_o => dsmux_lhc_data_valid,
            simmem_in_use_o => simmem_in_use
        );

    dsmux_lhc_data_o <= dsmux_lhc_data_int;  -- data to GTL (gtl_fdl_wrapper.vhd)
    dsmux_lhc_data_int_rop <= dsmux_lhc_data_int;

--===============================================================================================--
--                                 spymem2_algos
--===============================================================================================--

-- DATA-PATH: gtl_fdl_wrapper.vhd
-- SPYMEM2 ALGOS
      spymem2_algos_l: for i in 0 to 15 generate -- 16 memory blocks for 512 algos
         spymem2_algos_i: entity work.ipb_dpmem_4096_32
             port map(
                 ipbus_clk => ipb_clk,
                 reset     => ipb_rst,
                 ipbus_in  => ipb_to_slaves(C_IPB_SPYMEM2_ALGOS(i)),
                 ipbus_out => ipb_from_slaves(C_IPB_SPYMEM2_ALGOS(i)),
                 ------------------
                 clk_b     => lhc_clk,
                 enb       => '1',
                 web       => spy2,
                 addrb     => bx_nr, -- : no write and no read latency
                 dinb      => algo_after_prescaler_rop ( (i+1)*SW_DATA_WIDTH-1 downto i*SW_DATA_WIDTH ), -- data from FDL (gtl_fdl_wrapper.vhd)
                 doutb     => open
             );
     end generate spymem2_algos_l;

--===============================================================================================--
--                               SPYMEM2 FINOR
--===============================================================================================--

-- HEPHY :[Synth 8-1565] actual for formal port dinb is neither a static name nor a globally static expression. It should be fixed
    local_finor_with_veto_2_spy2_int <= (X"0000000" & "000" & local_finor_with_veto_2_spy2);
    spymem2_finor_i: entity work.ipb_dpmem_4096_32
         port map(
             ipbus_clk => ipb_clk,
             reset     => ipb_rst,
             ipbus_in  => ipb_to_slaves(C_IPB_SPYMEM2_FINOR),
             ipbus_out => ipb_from_slaves(C_IPB_SPYMEM2_FINOR),
             ------------------
             clk_b     => lhc_clk,
             enb       => '1',
             web       => spy2,
             addrb     => bx_nr, -- HB 2014-08-18: no write and no read latency
	     dinb      => local_finor_with_veto_2_spy2_int,
             doutb     => open
         );

--===============================================================================================--
--                              Output multiplexer -- GTL/FDL data to Tx-buffer
--===============================================================================================--

    output_mux_i: entity work.output_mux
        generic map(
            NR_LANES => NR_LANES
        )
        port map(
            lhc_clk     => lhc_clk,
            clk240      => clk240,
            lhc_rst     => lhc_rst,
            ctrs        => ctrs,
            bx_nr       => bx_nr,
            bx_nr_fdl   => bx_nr_d_FDL_int,
            algo_after_gtLogic   => algo_after_gtLogic_rop,
            algo_after_bxomask   => algo_after_bxomask_rop,
            algo_after_prescaler => algo_after_prescaler_rop,
            local_finor_in      => local_finor_rop,
            local_veto_in       => local_veto_rop,
            local_finor_veto_in => local_finor_with_veto_2_spy2,
            prescale_factor     => prescale_factor_set_index_rop,
            valid_lo    => mux_ctrl_regs_1(0)(15 downto 0),
            valid_hi    => mux_ctrl_regs_1(1)(15 downto 0),
            start       => mux_ctrl_regs_1(2)(0),
            strobe      => mux_ctrl_regs_1(3)(0),
            lane_out     => lane_data_out
        );

-- END OF DATA-PATH

end rtl;

