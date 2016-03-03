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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_module.vhd $
-- $Date: 2015-08-14 10:57:16 +0200 (Fre, 14 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4148 $
--------------------------------------------------------------------------------

-- Desription:
-- FDL structure

-- Version-history:
-- HB 2016-03-02: v0.0.21 - based on v0.0.20, but mapping global-local index is done for masks and counters. Inserted rate-counter for veto. Updated algo_bx_mask_sim for global index.
-- HB 2016-02-26: v0.0.20 - based on v0.0.19, but changed finor_2_mezz_lemo and veto_2_mezz_lemo (no additional delay anymore) and inserted finor_w_veto_2_mezz_lemo with
--			    1.5bx delay.
--			    Removed unused inputs (ec0, oc0, etc.) and fdl_status output.
-- HB 2016-02-23: v0.0.19 - based on v0.0.18, but implemented algo-rate-counter after prescaler. 
--                                            Fixed bug for syncr. reset of counter, "resync" not used anymore. No syncr. reset for counters except begin of lumi-section.
-- HB 2016-02-11: v0.0.18 - based on v0.0.17, but implemented L1A-rate-counter (only for monitoring and verification of incoming L1As)
-- HB 2016-02-11: v0.0.17 - based on v0.0.16, but implemented port l1a, module algo_post_dead_time_counter (in algo_slice) and register for L1A latency delay (delaying algos for post_dead_time_counter)
-- HB 2016-02-11: v0.0.16 - based on v0.0.15, but implemented finor-rate-counter
-- HB 2016-01-18: v0.0.15 - based on v0.0.14, but used internal bx number for algo-bx-memory
-- HB 2015-09-01: v0.0.14 - based on v0.0.13, but implemented "prescale_factor_set_index_reg" and "command_pulses" register. "ALGO_INPUTS_FF" is now part of generic declaration. Additionally
--                          inserted input ports "ec0", "resync" and "oc0" for reset logic.
-- HB 2015-08-14: v0.0.13 - based on v0.0.12, but added algo_bx_mask_sim input for simulation use. Send a delayed "finor_with_veto" (currently assumed 1.5 bx latency over FINOR-AMC502)
--                          to ports "finor_2_mezz_lemo" and "veto_2_mezz_lemo", which go to MP7-mezzanine to send "finor gated with veto" to TCDS directly (without AMC502).
--                          Moved constant "ALGO_INPUTS_FF" from fdl_pkg.vhd to fdl_module.vhd, fdl_pkg.vhd not used anymore.
-- HB 2015-06-26: v0.0.12 - based on v0.0.11, but used an additional port "veto_2_mezz_lemo", which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502. 
-- HB 2015-05-29: v0.0.11 - based on v0.0.10, but renamed port "ser_finor_veto" to "finor_2_mezz_lemo" and inserted FDL_OUT_MEZZ_2_TCDS in generic. 
-- HB 2015-05-26: v0.0.10 - based on v0.0.9, but inserted SIM_MODE for algo_bx_mask and instanciated all modules with "entity work.xxx" and used clk160 for "serializer_2_to_1.vhd". 
-- HB 2014-12-15: v0.0.9 - based on v0.0.8, but bug fixed at "local_finor_with_veto_o" (removed FF). 
-- HB 2014-12-10: v0.0.8 - based on v0.0.7, but removed serializer. 
-- HB 2014-12-10: v0.0.7 - based on v0.0.6, but clk160 used for serializer. 
-- HB 2014-11-21: v0.0.6 - based on v0.0.5, but implemented "ser_finor_veto_2_to_1" (only"local FINOR" and "local VETO" serialized) 
--                         and "sel_finor_lemo_out" for selection of signal to finor LEMO output (on FINOR-mezzanine).
-- HB 2014-11-18: v0.0.5 - based on v0.0.4, but "sel_local_finor_with_veto" instead of "sel_ser_finor_veto".
-- HB 2014-10-30: v0.0.4 - based on v0.0.3, but added local_finor_with_veto_o for SPY2_FINOR.
-- HB 2014-10-22: v0.0.3 - based on v0.0.2, but redesigned FINOR logic and added serializer for "local FINOR" and "local VETO" to send these signals to "FINOR-FMC".
-- HB 11-08-2014: v0.0.2 - instantiate all algo_bx_mem instead of NR_ALGOS dependecies by a fixed value (0 to 15).
-- BR 08-08-2014: instantiate all algo_bx_mem instead of NR_ALGOS dependecies.

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL; -- for function "CONV_INTEGER"

use work.ipbus.all;

use work.gtl_pkg.ALL;

use work.gt_mp7_core_pkg.ALL;
use work.fdl_addr_decode.all;

use work.math_pkg.all;

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
        l1a                 : in std_logic;
        begin_lumi_section  : in std_logic;
        algo_i              : in std_logic_vector(NR_ALGOS-1 downto 0);
        prescale_factor_set_index_rop : out std_logic_vector(PRESCALE_FACTOR_SET_INDEX_WIDTH-1 downto 0);
        algo_before_prescaler_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        finor_2_mezz_lemo      : out std_logic; -- to tp_mux.vhd
        veto_2_mezz_lemo      : out std_logic; -- to tp_mux.vhd
        finor_w_veto_2_mezz_lemo      : out std_logic; -- to tp_mux.vhd
	local_finor_with_veto_o       : out std_logic; -- to SPY2_FINOR
-- -- HB 2015-08-14: v0.0.13 - algo_bx_mask_sim input for simulation use.
--         algo_bx_mask_sim    : in std_logic_vector(NR_ALGOS-1 downto 0)
-- HB 2016-03-02: v0.0.21 - algo_bx_mask_sim input for simulation use with MAX_NR_ALGOS (because of global index).
        algo_bx_mask_sim    : in std_logic_vector(MAX_NR_ALGOS-1 downto 0)
    );
end fdl_module;

architecture rtl of fdl_module is

-- Input flip-flops for algorithms of fdl_module.vhd
--     constant ALGO_INPUTS_FF: boolean := false; -- used for tests of fdl_module.vhd only

    constant FINOR_BIT_IN_MASKS_REG : integer := 0;
    constant VETO_BIT_IN_MASKS_REG : integer := 1;
    constant FINOR_RATE_COUNTER_WIDTH : integer := RATE_COUNTER_WIDTH;
    constant VETO_RATE_COUNTER_WIDTH : integer := RATE_COUNTER_WIDTH;
    constant L1A_RATE_COUNTER_WIDTH : integer := RATE_COUNTER_WIDTH;
--     constant MAX_DELAY_L1A_LATENCY : integer := 64;
    constant MAX_DELAY_L1A_LATENCY : integer := 63; -- values = 2**x causes "fatal error" at simulation in module "delay_element.vhd" !!!

    signal ipb_to_slaves: ipb_wbus_array(NR_IPB_SLV_FDL-1 downto 0);
    signal ipb_from_slaves: ipb_rbus_array(NR_IPB_SLV_FDL-1 downto 0);

    signal rate_cnt_before_prescaler_reg: ipb_regs_array(0 to OFFSET_END_RATE_CNT_BEFORE_PRESCALER-OFFSET_BEG_RATE_CNT_BEFORE_PRESCALER);
    signal rate_cnt_after_prescaler_reg: ipb_regs_array(0 to OFFSET_END_RATE_CNT_AFTER_PRESCALER-OFFSET_BEG_RATE_CNT_AFTER_PRESCALER);
    signal rate_cnt_post_dead_time_reg: ipb_regs_array(0 to OFFSET_END_RATE_CNT_POST_DEAD_TIME-OFFSET_BEG_RATE_CNT_POST_DEAD_TIME);
    signal prescale_factor_reg: ipb_regs_array(0 to OFFSET_END_PRESCALE_FACTOR-OFFSET_BEG_PRESCALE_FACTOR);
    signal masks_reg: ipb_regs_array(0 to OFFSET_END_MASKS-OFFSET_BEG_MASKS);
    signal versions_to_ipb: ipb_regs_array(0 to OFFSET_END_READ_VERSIONS-OFFSET_BEG_READ_VERSIONS) := (others => (others => '0'));
    signal control_reg: ipb_regs_array(0 to 1);
    signal prescale_factor_set_index_reg: ipb_regs_array(0 to 1);
    signal command_pulses: std_logic_vector(31 downto 0); -- see ipb_pulse_regs.vhd
    
-- =================================================================================

    signal algo_int : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');
    signal sres_algo_pre_scaler : std_logic := '0';
    signal prescale_factor_int : prescale_factor_array;
    signal sres_algo_rate_counter : std_logic := '0';
    
    signal sres_finor_rate_counter : std_logic := '0';
    signal rate_cnt_finor_reg : ipb_regs_array(0 to 0) := (others => (others => '0'));

    signal sres_veto_rate_counter : std_logic := '0';
    signal rate_cnt_veto_reg : ipb_regs_array(0 to 0) := (others => (others => '0'));

    signal sres_l1a_rate_counter : std_logic := '0';
    signal rate_cnt_l1a_reg : ipb_regs_array(0 to 0) := (others => (others => '0'));

    signal sres_algo_post_dead_time_counter : std_logic := '0';
    signal l1a_latency_delay_reg : ipb_regs_array(0 to 1) := (others => (others => '0'));
    signal rate_cnt_post_dead_time : rate_counter_array;

    signal algo_before_prescaler : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_after_prescaler : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_after_finor_mask : std_logic_vector(NR_ALGOS-1 downto 0);
    signal veto : std_logic_vector(NR_ALGOS-1 downto 0);
    signal local_finor : std_logic := '0';
    signal local_veto : std_logic := '0';
    signal local_finor_pipe : std_logic;
    signal local_veto_pipe : std_logic;
--     signal algo_bx_mask : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '1');
    signal algo_bx_mask_mem_out : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '1');
--     signal algo_bx_mask_default : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '1');
--     signal algo_bx_mask_sim_internal : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '1');

    signal lhc_clk_algo_bx_mem : std_logic := '0';
    signal sync_en_algo_bx_mem : std_logic := '0';

    signal request_update_factor_pulse : std_logic;
    signal prescale_factor_set_index_reg_updated : std_logic_vector(PRESCALE_FACTOR_SET_INDEX_WIDTH-1 downto 0);

    signal finor_with_veto_temp1 : std_logic;
    signal finor_with_veto_temp2 : std_logic;

    signal bx_nr_internal : std_logic_vector(11 downto 0) := (others => '0');

    signal algo_bx_mask_global : std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '1');
    signal algo_bx_mask_local : std_logic_vector(NR_ALGOS-1 downto 0);
    signal rate_cnt_before_prescaler_local : rate_counter_array;
    signal rate_cnt_before_prescaler_global : rate_counter_global_array;
    signal prescale_factor_global : prescale_factor_global_array;
    signal prescale_factor_local : prescale_factor_array;
    signal rate_cnt_after_prescaler_local : rate_counter_array;
    signal rate_cnt_after_prescaler_global : rate_counter_global_array;
    signal rate_cnt_post_dead_time_local : rate_counter_array;
    signal rate_cnt_post_dead_time_global : rate_counter_global_array;
    signal finor_masks_global : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal finor_masks_local : std_logic_vector(NR_ALGOS-1 downto 0);
    signal veto_masks_global : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal veto_masks_local : std_logic_vector(NR_ALGOS-1 downto 0);

begin

-- ******************************************************************************************************************
    fabric_i: entity work.fdl_fabric
        generic map(NSLV => NR_IPB_SLV_FDL)
        port map(
            ipb_clk => ipb_clk,
            ipb_rst => ipb_rst,
            ipb_in => ipb_in,
            ipb_out => ipb_out,
            ipb_to_slaves => ipb_to_slaves,
            ipb_from_slaves => ipb_from_slaves
    );

--===============================================================================================--
-- Version register
    read_versions_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => ADDR_WIDTH_READ_VERSIONS,
        regs_beg_index => OFFSET_BEG_READ_VERSIONS,
        regs_end_index => OFFSET_END_READ_VERSIONS
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_READ_VERSIONS),
        ipbus_out => ipb_from_slaves(C_IPB_READ_VERSIONS),
        ------------------
        regs_i => versions_to_ipb
    );

    l1tm_name_l: for i in 0 to L1TM_NAME'length/32-1 generate
		versions_to_ipb(i+OFFSET_L1TM_NAME) <= L1TM_NAME(i*32+31 downto i*32);
    end generate l1tm_name_l;                        

    l1tm_uid_l: for i in 0 to L1TM_UID'length/32-1 generate
		versions_to_ipb(i+OFFSET_L1TM_UID) <= L1TM_UID(i*32+31 downto i*32);
    end generate l1tm_uid_l;                        

	versions_to_ipb(OFFSET_L1TM_COMPILER_VERSION) <= L1TM_COMPILER_VERSION;
	versions_to_ipb(OFFSET_GTL_FW_VERSION) <= GTL_FW_VERSION;
	versions_to_ipb(OFFSET_FDL_FW_VERSION) <= FDL_FW_VERSION;

--===============================================================================================--
-- Control register
--     control_reg_i: entity work.ipb_write_regs
--     generic map
--     (
--         init_value => CNTRL_REG_INIT,
--         addr_width => 2,
--         regs_beg_index => 0,
--         regs_end_index => 1
--     )
--     port map
--     (
--         clk => ipb_clk,
--         reset => ipb_rst,
--         ipbus_in => ipb_to_slaves(C_IPB_CONTROL),
--         ipbus_out => ipb_from_slaves(C_IPB_CONTROL),
--         ------------------
--         regs_o => control_reg
--     );

-- HB 2015-08-31: control_reg not used currently

--===============================================================================================--
-- bx counter
    bc_cntr: process (lhc_clk, bcres)
	begin
        if (lhc_clk'event and lhc_clk = '1') then
           if (bcres = '1') then
              bx_nr_internal <= X"000";   -- sync BCReset
           else
              bx_nr_internal <= bx_nr_internal + 1;
           end if;
        end if;
    end process bc_cntr;

-- Algo-bx-memory
-- HB 2016-02-11: 16 (MAX_NR_ALGOS/SW_DATA_WIDTH) memory-blocks instantiated, same as defined in XML for addresses
    algo_bx_mem_l: for i in 0 to 15 generate
        algo_bx_mem_i: entity work.ipb_dpmem_4096_32
        port map
        (
            ipbus_clk => ipb_clk,
            reset     => ipb_rst,
            ipbus_in  => ipb_to_slaves(C_IPB_ALGO_BX_MEM(i)),
            ipbus_out => ipb_from_slaves(C_IPB_ALGO_BX_MEM(i)),
            ------------------
            clk_b     => lhc_clk,
            enb       => '1',
--             enb       => en_algo_bx_mem,
            web       => '0', -- read
-- HB 2016-01-18: using internal bx number for algo_bx_mem
--             addrb     => bx_nr(11 downto 0),
            addrb     => bx_nr_internal(11 downto 0),
            dinb      => X"FFFFFFFF", -- dummy
            doutb     => algo_bx_mask_mem_out(32*i+31 downto 32*i)
        );
    end generate algo_bx_mem_l;                        

--     algo_bx_mask_sim_sync_p: process(lhc_clk, algo_bx_mask_sim)
--         begin
--         if (lhc_clk'event and (lhc_clk = '1')) then
-- 	    algo_bx_mask_sim_internal(NR_ALGOS-1 downto 0) <= algo_bx_mask_sim(NR_ALGOS-1 downto 0);
--         end if;
--     end process;
-- 
-- -- HB 2015-08-14: v0.0.13 - algo_bx_mask_sim input for simulation use.
--     algo_bx_mask_global <= algo_bx_mask_mem_out when not SIM_MODE else
-- 		           algo_bx_mask_sim_internal when SIM_MODE else (others => '1');
--     
-- HB 2015-08-14: v0.0.13 - algo_bx_mask_sim input for simulation use.
    algo_bx_mask_global <= algo_bx_mask_mem_out when not SIM_MODE else
		           algo_bx_mask_sim when SIM_MODE else (others => '1');
    
--===============================================================================================--
-- Rate counter before prescaler registers
    read_rate_cnt_before_prescaler_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => ADDR_WIDTH_RATE_CNT_BEFORE_PRESCALER,
        regs_beg_index => OFFSET_BEG_RATE_CNT_BEFORE_PRESCALER,
        regs_end_index => OFFSET_END_RATE_CNT_BEFORE_PRESCALER
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_BEFORE_PRESCALER),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_BEFORE_PRESCALER),
        ------------------
        regs_i => rate_cnt_before_prescaler_reg
    );

--===============================================================================================--
-- Rate counter after prescaler registers
    read_rate_cnt_after_prescaler_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => ADDR_WIDTH_RATE_CNT_AFTER_PRESCALER,
        regs_beg_index => OFFSET_BEG_RATE_CNT_AFTER_PRESCALER,
        regs_end_index => OFFSET_END_RATE_CNT_AFTER_PRESCALER
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_AFTER_PRESCALER),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_AFTER_PRESCALER),
        ------------------
        regs_i => rate_cnt_after_prescaler_reg
    );

--===============================================================================================--
-- Rate counter post dead time registers
    read_rate_cnt_post_dead_time_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => ADDR_WIDTH_RATE_CNT_POST_DEAD_TIME,
        regs_beg_index => OFFSET_BEG_RATE_CNT_POST_DEAD_TIME,
        regs_end_index => OFFSET_END_RATE_CNT_POST_DEAD_TIME
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_POST_DEAD_TIME),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_POST_DEAD_TIME),
        ------------------
        regs_i => rate_cnt_post_dead_time_reg
    );

--===============================================================================================--
-- L1A latency delay register
    l1a_latency_delay_reg_i: entity work.ipb_write_regs
    generic map
    (
        init_value => L1A_LATENCY_DELAY_INIT,
        addr_width => 2,
        regs_beg_index => 0,
        regs_end_index => 1
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_L1A_LATENCY_DELAY),
        ipbus_out => ipb_from_slaves(C_IPB_L1A_LATENCY_DELAY),
        ------------------
        regs_o => l1a_latency_delay_reg
    );

--===============================================================================================--
-- Prescale factor registers
    prescale_factor_reg_i: entity work.ipb_write_regs
    generic map
    (
        init_value => PRESCALE_FACTOR_INIT,
        addr_width => ADDR_WIDTH_PRESCALE_FACTOR,
        regs_beg_index => OFFSET_BEG_PRESCALE_FACTOR,
        regs_end_index => OFFSET_END_PRESCALE_FACTOR
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_PRESCALE_FACTOR),
        ipbus_out => ipb_from_slaves(C_IPB_PRESCALE_FACTOR),
        ------------------
        regs_o => prescale_factor_reg
    );

--===============================================================================================--
-- Prescale factor set index register
    prescale_factors_set_index_i: entity work.ipb_write_regs
    generic map
    (
        init_value => PRESCALE_FACTOR_SET_INDEX_REG_INIT,
        addr_width => 2,
        regs_beg_index => 0,
        regs_end_index => 1
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_PRESCALE_FACTOR_SET_INDEX),
        ipbus_out => ipb_from_slaves(C_IPB_PRESCALE_FACTOR_SET_INDEX),
        ------------------
        regs_o => prescale_factor_set_index_reg
    );

    prescale_factor_set_index_update_i: entity work.update_process
        generic map(
            WIDTH => PRESCALE_FACTOR_SET_INDEX_WIDTH,
            INIT_VALUE => X"00000000"
        )
        port map( 
            clk => lhc_clk,
            request_update_pulse => request_update_factor_pulse,
            update_pulse => begin_lumi_section,
            data_i => prescale_factor_set_index_reg(0)(PRESCALE_FACTOR_SET_INDEX_WIDTH-1 downto 0),
            data_o => prescale_factor_set_index_reg_updated
        );
        
    prescale_factor_set_index_rop <= prescale_factor_set_index_reg_updated;

-- --===============================================================================================--
-- Finor and veto masks registers (bit 0 = finor, bit 1 = veto)
    masks_reg_i: entity work.ipb_write_regs
    generic map
    (
        init_value => MASKS_INIT,
        addr_width => ADDR_WIDTH_MASKS,
        regs_beg_index => OFFSET_BEG_MASKS,
        regs_end_index => OFFSET_END_MASKS
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_MASKS),
        ipbus_out => ipb_from_slaves(C_IPB_MASKS),
        ------------------
        regs_o => masks_reg
    );

--===============================================================================================--
-- Command pulses register
    pulse_reg_i: entity work.ipb_pulse_regs
    port map(
        ipb_clk => ipb_clk,
        ipb_reset => ipb_rst,
        ipb_mosi_i => ipb_to_slaves(C_IPB_COMMAND_PULSES),
        ipb_miso_o => ipb_from_slaves(C_IPB_COMMAND_PULSES),
        lhc_clk => lhc_clk,
        pulse_o => command_pulses
    );

-- HB 2015-08-31: "request_update_factor_pulse" is bit 0 of "pulseregister 0 (C_IPB_COMMAND_PULSES)";
    request_update_factor_pulse <= command_pulses(0);
    
--===============================================================================================--
-- Rate counter finor register
-- HB 2016-02-11: requested for monitoring (in legacy system part of TCS). Has to be moved to FINOR-AMC502 !!!
    read_rate_cnt_finor_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => 1,
        regs_beg_index => 0,
        regs_end_index => 0
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_FINOR),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_FINOR),
        ------------------
        regs_i => rate_cnt_finor_reg
    );

--===============================================================================================--
-- Rate counter veto register
-- HB 2016-03-02: for monitoring only
    read_rate_cnt_veto_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => 1,
        regs_beg_index => 0,
        regs_end_index => 0
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_VETO),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_VETO),
        ------------------
        regs_i => rate_cnt_veto_reg
    );

--===============================================================================================--
-- Rate counter L1A register
    read_rate_cnt_l1a_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => 1,
        regs_beg_index => 0,
        regs_end_index => 0
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_to_slaves(C_IPB_RATE_CNT_L1A),
        ipbus_out => ipb_from_slaves(C_IPB_RATE_CNT_L1A),
        ------------------
        regs_i => rate_cnt_l1a_reg
    );

--===============================================================================================--

    reg_l: for i in 0 to NR_ALGOS-1 generate
        rate_cnt_before_prescaler_reg(i)(RATE_COUNTER_WIDTH-1 downto 0) <= rate_cnt_before_prescaler_global(i);
        rate_cnt_after_prescaler_reg(i)(RATE_COUNTER_WIDTH-1 downto 0) <= rate_cnt_after_prescaler_global(i);
        rate_cnt_post_dead_time_reg(i)(RATE_COUNTER_WIDTH-1 downto 0) <= rate_cnt_post_dead_time_global(i);
    end generate reg_l;

    masks_reg_l: for i in 0 to MAX_NR_ALGOS-1 generate
        prescale_factor_global(i) <= prescale_factor_reg(i);
	finor_masks_global(i) <= masks_reg(i)(FINOR_BIT_IN_MASKS_REG);
	veto_masks_global(i) <= masks_reg(i)(VETO_BIT_IN_MASKS_REG);
    end generate masks_reg_l;

--===============================================================================================--

-- HB 2016-02-23: sync reset for counters not used anymore - resync was a bug !!! Reset with begin of lumi-section is ok.
    sres_algo_rate_counter <= '0';
    sres_algo_pre_scaler <= '0'; 
    sres_finor_rate_counter <= '0';
    sres_veto_rate_counter <= '0';
    sres_l1a_rate_counter <= '0';
    sres_algo_post_dead_time_counter <= '0';
    
-- ******************************************************************************************************************
-- FDL data flow - begin

-- Input register for algorithms inputs (used for timing analysis of fdl_module).
    algo_in_ff_p: process(lhc_clk, algo_i)
        begin
        if (ALGO_INPUTS_FF = false) then 
            algo_int <= algo_i;
        elsif (lhc_clk'event and (lhc_clk = '1') and (ALGO_INPUTS_FF = true)) then
            algo_int <= algo_i;
        end if;
    end process;

-- Prescalers and rate counters
    algo_slices_l: for i in 0 to NR_ALGOS-1 generate
        algo_slice_i: entity work.algo_slice
        generic map( 
            RATE_COUNTER_WIDTH => RATE_COUNTER_WIDTH,
            PRESCALER_COUNTER_WIDTH => PRESCALER_COUNTER_WIDTH,
            PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT(i),
            MAX_DELAY => MAX_DELAY_L1A_LATENCY
        )
        port map( 
            sys_clk => ipb_clk,
            lhc_clk => lhc_clk,
            lhc_rst => lhc_rst,
-- HB 2015-09-17: added "sres_algo_rate_counter" and "sres_algo_pre_scaler"
	    sres_algo_rate_counter => sres_algo_rate_counter,
	    sres_algo_pre_scaler => sres_algo_pre_scaler,
	    sres_algo_post_dead_time_counter => sres_algo_post_dead_time_counter,
	    l1a => l1a,
	    l1a_latency_delay => l1a_latency_delay_reg(0)(log2c(MAX_DELAY_L1A_LATENCY)-1 downto 0),
            request_update_factor_pulse => request_update_factor_pulse,
            begin_lumi_per => begin_lumi_section,
            algo_i => algo_int(i),
            prescale_factor => prescale_factor_local(i)(PRESCALER_COUNTER_WIDTH-1 downto 0),
            algo_bx_mask => algo_bx_mask_local(i),
            finor_mask => finor_masks_local(i),
            veto_mask => veto_masks_local(i),
            rate_cnt_before_prescaler => rate_cnt_before_prescaler_local(i),
            rate_cnt_after_prescaler => rate_cnt_after_prescaler_local(i),
            rate_cnt_post_dead_time => rate_cnt_post_dead_time_local(i),
            algo_before_prescaler => algo_before_prescaler(i),
            algo_after_prescaler => algo_after_prescaler(i),
	    algo_after_finor_mask => algo_after_finor_mask(i),
	    veto => veto(i)
	);
    end generate algo_slices_l;

-- Finors
    local_finor_p: process(algo_after_finor_mask)
       variable or_algo_var : std_logic := '0';
	begin
        or_algo_var := '0';
        for i in 0 to NR_ALGOS-1 loop
            or_algo_var := or_algo_var or algo_after_finor_mask(i);
        end loop;
        local_finor <= or_algo_var;
    end process local_finor_p;
    
-- Vetos
    local_veto_or_p: process(veto)
        variable or_veto_var : std_logic := '0';
	begin
        or_veto_var := '0';
        for i in 0 to NR_ALGOS-1 loop
            or_veto_var := or_veto_var or veto(i); 
        end loop;
	local_veto <= or_veto_var;
    end process local_veto_or_p;

-- One pipeline stage for finor and veto to ROP
    local_finor_veto_pipeline_p: process(lhc_clk, local_finor, local_veto)
        begin
        if (lhc_clk'event and (lhc_clk = '1')) then
            local_finor_pipe <= local_finor;
            local_veto_pipe <= local_veto;
        end if;
    end process;

    local_finor_rop <= local_finor_pipe;
    local_veto_rop <= local_veto_pipe;
    
-- HB 2014-12-15: bug fixed - local_finor_with_veto used for finor_2_mezz_lemo not for SPY2_FINOR !!!
    local_finor_with_veto_o <= local_finor_pipe and not local_veto_pipe;

-- HB 2016-02-26: local finor and local veto to tp_mux for LEMO connectors
    finor_2_mezz_lemo <= local_finor;
    veto_2_mezz_lemo <= local_veto;
        
-------------------------------------------------------------------------------------------------------------------------------------
-- Pipeline stages for "simulating" the stages of FINOR-AMC502, to get the same latency for both possibilities of connecting to TCDS.
-- HB 2015-08-21: currently assumed 1.5 bx latency over FINOR-AMC502
    stage1_finor_amc502_sim_p: process(lhc_clk, local_finor, local_veto)
        begin
        if (lhc_clk'event and (lhc_clk = '1')) then
            finor_with_veto_temp1 <= local_finor and not local_veto;
            finor_with_veto_temp2 <= finor_with_veto_temp1;
        end if;
    end process;

-- HB HB 2016-02-26: finor_w_veto_2_mezz_lemo to tp_mux for LEMO connectors
    mezz_finor_veto_pipeline_p: process(lhc_clk, finor_with_veto_temp2)
        begin
        if (lhc_clk'event and (lhc_clk = '0')) then
            finor_w_veto_2_mezz_lemo <= finor_with_veto_temp2;
        end if;
    end process;
-------------------------------------------------------------------------------------------------------------------------------------

-- Rate counter finor
-- HB 2016-02-26: requested for monitoring (in legacy system part of TCS). Has to be implemented in FINOR-AMC502, too - for vetoed finor for TCDS !!!
    rate_cnt_finor_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => FINOR_RATE_COUNTER_WIDTH
	)
	port map( 
            sys_clk => ipb_clk,
            lhc_clk => lhc_clk,
            sres_counter => sres_finor_rate_counter,
            store_cnt_value => begin_lumi_section,
            algo_i => local_finor,
            counter_o => rate_cnt_finor_reg(0)(FINOR_RATE_COUNTER_WIDTH-1 downto 0)
	);

-- Rate counter veto
-- HB 2016-03-02: for monitoring only
    rate_cnt_veto_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => VETO_RATE_COUNTER_WIDTH
	)
	port map( 
            sys_clk => ipb_clk,
            lhc_clk => lhc_clk,
            sres_counter => sres_veto_rate_counter,
            store_cnt_value => begin_lumi_section,
            algo_i => local_veto,
            counter_o => rate_cnt_veto_reg(0)(VETO_RATE_COUNTER_WIDTH-1 downto 0)
	);

-- Rate counter L1A
-- HB 2016-02-19: only for monitoring and verification of incoming L1As
    rate_cnt_l1a_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => L1A_RATE_COUNTER_WIDTH
	)
	port map( 
            sys_clk => ipb_clk,
            lhc_clk => lhc_clk,
            sres_counter => sres_l1a_rate_counter,
            store_cnt_value => begin_lumi_section,
            algo_i => l1a,
            counter_o => rate_cnt_l1a_reg(0)(L1A_RATE_COUNTER_WIDTH-1 downto 0)
	);

-- FDL data flow - end
-- ********************************************

-- Algorithms to ROP
    algo_mapping_rop_i: entity work.algo_mapping_rop
        port map ( 
            lhc_clk => lhc_clk,
            algo_bx_masks_global => algo_bx_mask_global,
            algo_bx_masks_local => algo_bx_mask_local,
            rate_cnt_before_prescaler_local => rate_cnt_before_prescaler_local,
            rate_cnt_before_prescaler_global => rate_cnt_before_prescaler_global,
            prescale_factor_global => prescale_factor_global,
            prescale_factor_local => prescale_factor_local,
            rate_cnt_after_prescaler_local => rate_cnt_after_prescaler_local,
            rate_cnt_after_prescaler_global => rate_cnt_after_prescaler_global,
            rate_cnt_post_dead_time_local => rate_cnt_post_dead_time_local,
            rate_cnt_post_dead_time_global => rate_cnt_post_dead_time_global,
            finor_masks_global => finor_masks_global,
            finor_masks_local => finor_masks_local,
            veto_masks_global => veto_masks_global,
            veto_masks_local => veto_masks_local,
            algo_before_prescaler => algo_before_prescaler,
            algo_after_prescaler => algo_after_prescaler,
            algo_after_finor_mask => algo_after_finor_mask,
            algo_before_prescaler_rop => algo_before_prescaler_rop,
            algo_after_prescaler_rop => algo_after_prescaler_rop,
            algo_after_finor_mask_rop => algo_after_finor_mask_rop
        );
    
end architecture rtl;
    
    