-- Description:
-- Contains the "framework" of GT-logic (all parts, except GTL and FDL).

-- HB 2023-03-07: v1.4.0 - used Tx links 28-31 for scouting (output_mux.vhd).
-- HB 2022-09-02: v1.3.1 - cleaned up.
-- HB 2022-03-22: v1.3.0 - output ports bcres_d and bcres_d_FDL not used anymore (not used in mp7_payload.vhd). Signals bcres, bcres_outputmux, bcres_d_FDL_int and bx_nr_d_FDL_int not used anymore. Updated tcm.vhd (input port bcres_d_FDL not used anymore) and output_mux.vhd (input port bx_nr_fdl not used anymore). Removed signals for spy3.
-- HB 2022-02-08: v1.2.5 - changed frame_module_info.vhd (GT_VERSION in OFFSET_FRAME_VERSION) and frame_addr_decode.vhd.
-- HB 2021-06-16: v1.2.4 - implemented selectors (set in gtl_pkg.vhd) for "scouting" (in output_mux.vhd) and use of input data spymem.
-- HB 2017-10-10: v1.2.3 - bug fix "simmem_in_use_i" input of spytrig.
-- HB 2017-10-10: v1.2.2 - removed mux control register ("mux_ctrl_regs_1"), used fixed values for output mux inputs ("mux_ctrl").
-- HB 2017-10-06: v1.2.1 - cleaned-up (unused instances and signals). Changed port name "dsmux_lhc_data_o" to "lhc_data_2_gtl_o". Removed "SIMULATE_DATAPATH" from generic.
-- HB 2017-09-08: v1.2.0 - dm and dsmux not used anymore, reduced registers in rb
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
--                Used "algo_after_gtlogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") in output_mux.vhd (according to fdl_module v0.0.24).
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

use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.frame_addr_decode.all;
use work.gt_mp7_core_pkg.all;
use work.frame_rb_pkg.all;
use work.mp7_ttc_decl.all;
use work.gtl_pkg.all;

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
        start_lumisection : out std_logic;
        lane_data_in : in ldata(NR_LANES-1 downto 0);
        lane_data_out : out ldata(NR_LANES-1 downto 0);
        lhc_data_2_gtl_o : out lhc_data_t;
        prescale_factor_set_index_rop : in std_logic_vector(7 downto 0);
        algo_after_gtlogic_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop : in std_logic;
        local_veto_rop : in std_logic;
        local_finor_with_veto_2_spy2 : in std_logic
    );

end frame;

architecture rtl of frame is

-- ================================================================================================
    signal lhc_rst : std_logic;
    signal cntr_rst : std_logic;
-- ================================================================================================

    signal ipb_to_slaves : ipb_wbus_array(NR_IPB_SLV_FRAME-1 downto 0);
    signal ipb_from_slaves : ipb_rbus_array(NR_IPB_SLV_FRAME-1 downto 0);

    -- register bank
    signal sw_regs_in : sw_regs_in_t;
    signal sw_regs_out : sw_regs_out_t;

    signal rb2spytrig : sw_reg_spytrigger_in_t;
    signal spytrig2rb : sw_reg_spytrigger_out_t;

    signal rb2tcm : sw_reg_tcm_in_t;
    signal tcm2rb : sw_reg_tcm_out_t;

    signal demux_data_o : demux_lanes_data_objects_array_t(NR_LANES-1 downto 0);
    signal demux_data_valid_o : demux_lanes_data_objects_array_valid_t(NR_LANES-1 downto 0);

    signal lmp_lhc_data_o   : lhc_data_t; -- lhc_data output of lane mapping process

    signal bc0_d_int : std_logic; -- delayed version of bcres

    --TCM signals
    signal bx_nr : bx_nr_t;
    signal orbit_nr : orbit_nr_t;

    -- sim/spy mem
    signal spy1 : std_logic;
    signal spy2 : std_logic;

    signal lhc_data_slv_o : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);
    signal lhc_data_slv_i : std_logic_vector(LHC_DATA_WIDTH-1 downto 0);

    signal local_finor_with_veto_2_spy2_int   : std_logic_vector (31 downto 0);

    signal pulse : std_logic_vector(31 downto 0);

-- HEPHY 25.05.2015 - change to constant for avoiding the metastability and warning in simulator as well as in syntheseis process
    constant  mux_ctrl : ipb_regs_array(0 to 15) := (0 => X"00000bb8", 1 => X"00000c80", 2 => X"00000000", 3 => X"00000001", others => X"00000000"); -- bb8 =^ 3000, c80 =^ 3200

--TCM signals
    signal ec0_d_int : std_logic;
    signal oc0_d_int : std_logic;
    signal start_d_int : std_logic;

    begin

--===============================================================================================--
--                         RESET LOGIC
--===============================================================================================--

    lhc_rst <= pulse(0);
    cntr_rst <= pulse(1); -- counter reset
    lhc_rst_o <= lhc_rst;

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
        lhc_clk => lhc_clk,
        pulse_o => pulse
    );

--===============================================================================================--
--                        REGISTER BANK
--===============================================================================================--

    register_bank: entity work.rb
        port map(
            sys_clk => ipb_clk,
            lhc_clk => lhc_clk,
            sys_rst => ipb_rst,
            lhc_rst => lhc_rst,

            -- data interface for IPBus
            data_acc_in  => ipb_to_slaves(C_IPB_RB),
            data_acc_out => ipb_from_slaves(C_IPB_RB),

            -- data interface for fpga access
            sw_regs_in  => sw_regs_in, -- sw registers written via IPBus and read by the fpga
            sw_regs_out => sw_regs_out  -- sw registers read via IPBus and written by the fpga
        );

    rb2spytrig  <= sw_regs_in.spytrigger;
    rb2tcm      <= sw_regs_in.tcm;

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
-- HB 2017-09-11: all bgos from sync_proc_i instead of dm.vhd
            ec0               => ec0_d_int,
            oc0               => oc0_d_int,
            start             => start_d_int,
            l1a_sync          => l1a,
            bcres_d           => bc0_d_int,
            sw_reg_in         => rb2tcm,
            sw_reg_out        => tcm2rb,
            bx_nr             => bx_nr,
            event_nr          => open,
            trigger_nr        => open,
            orbit_nr          => orbit_nr,
            luminosity_seg_nr => open,
            start_lumisection => start_lumisection
        );

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

-- LMP (lane mapping process)
    lmp_i: entity work.lmp
        generic map(NR_LANES => NR_LANES)
        port map(
            demux_data_i => demux_data_o(NR_LANES-1 downto 0),
            demux_data_valid_i => demux_data_valid_o(NR_LANES-1 downto 0),
            lhc_data_o => lmp_lhc_data_o,
            lhc_data_valid_o => open
        );

-- HB 2017-09-08: no dm used, only sync process from dm for BGos
    sync_proc_i : process (lhc_clk, lhc_rst)
    begin
        if lhc_rst = RST_ACT then
            bc0_d_int <= '0';
            ec0_d_int <= '0';
            oc0_d_int <= '0';
            start_d_int <= '0';
        elsif rising_edge(lhc_clk) then
            bc0_d_int  <= bc0;
            ec0_d_int <= ec0;
            oc0_d_int <= oc0;
            start_d_int <= start;
        end if;
    end process;

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
            spy2_o     => spy2
        );

-- use of spymem depends on selector SPYMEM (set in gtl_pkg.vhd)
    sel_spymem_i: if SPYMEM generate

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

        lhc_data_slv_i <= lhc_data_t_to_std_logic_vector(lmp_lhc_data_o);

    end generate sel_spymem_i;

-- HB 2017-10-06: no dm and dsmux used, simmem not used anymore for tests
    lhc_data_2_gtl_o <= lmp_lhc_data_o;  -- data to GTL (gtl_fdl_wrapper.vhd)

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
            orbit_nr    => orbit_nr,
            algo_after_gtlogic   => algo_after_gtlogic_rop,
            algo_after_bxomask   => algo_after_bxomask_rop,
            algo_after_prescaler => algo_after_prescaler_rop,
            local_finor_in      => local_finor_rop,
            local_veto_in       => local_veto_rop,
            local_finor_veto_in => local_finor_with_veto_2_spy2,
            prescale_factor     => prescale_factor_set_index_rop,
            valid_lo    => mux_ctrl(0)(15 downto 0),
            valid_hi    => mux_ctrl(1)(15 downto 0),
            start       => mux_ctrl(2)(0),
            strobe      => mux_ctrl(3)(0),
            lane_out     => lane_data_out
        );

-- END OF DATA-PATH

end rtl;

