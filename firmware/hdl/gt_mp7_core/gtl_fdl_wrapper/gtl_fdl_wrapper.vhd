-- Description:
-- Wrapper for GTL and FDL

-- Version-history:
-- HB 2018-08-08: changed names for internal signals.
-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
-- HB 2016-11-17: inserted port "finor_preview_2_mezz_lemo" for "prescaler preview" in monitoring.
-- HB 2016-09-16: removed algo_after_finor_mask_rop, not used anymore in read-out record. Inserted new esums.
-- HB 2016-09-01: added BGo "test-enable" not synchronized (!) occures at bx=~3300 (used to suppress counting algos caused by calibration trigger at bx=3490) for fdl_module.
-- HB 2016-04-06: used algo_mapping_rop with "algo_after_gtLogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") according to fdl_module v0.0.24.
-- HB 2016-02-26: inserted finor_w_veto_2_mezz_lemo with 1.5bx delay. Removed unused inputs (ec0, oc0, etc.) and fdl_status output (see fdl_module v0.0.20).
-- HB 2016-02-16: added "l1a" for algo post dead time counter in fdl_module (v0.0.17).
-- HB 2015-09-17: added "ec0", "resync" and "oc0" from "ctrs" for fdl_module (v0.0.14).
-- HB 2015-08-24: added algo_bx_mask_sim input for fdl_module (v0.0.13).
-- HB 2015-06-26: used an additional port "veto_2_mezz_lemo" (in fdl_module), which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502.
-- HB 2015-05-29: renamed port "ser_finor_veto" to "finor_2_mezz_lemo", because of renaming in fdl_module. 
-- HB 2014-12-10: added clk160 for serializer in fdl_module.vhd
-- HB 2014-10-30: updated for local_finor_with_veto_2_spy2 output - fdl v0.0.4.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.ipbus.all;

use work.gtl_pkg.all;

use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;

entity gtl_fdl_wrapper is
    generic(
        SIM_MODE : boolean := false -- if SIM_MODE = true, "algo_bx_mask" by default = 1.
    );
    port
    (
        ipb_clk             : in std_logic;
        ipb_rst             : in std_logic;
        ipb_in              : in ipb_wbus;
        ipb_out             : out ipb_rbus;
-- ==========================================================================
        lhc_clk             : in std_logic;
        lhc_rst             : in std_logic;
        lhc_data            : in lhc_data_t;
        bcres               : in std_logic;
        test_en             : in std_logic;
        l1a                 : in std_logic;
        begin_lumi_section  : in std_logic;
        prescale_factor_set_index_rop : out std_logic_vector(7 downto 0);
        algo_after_gtLogic_rop        : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop        : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        finor_2_mezz_lemo      : out std_logic;
        finor_preview_2_mezz_lemo      : out std_logic;
        veto_2_mezz_lemo      : out std_logic;
        finor_w_veto_2_mezz_lemo      : out std_logic;
        local_finor_with_veto_o      : out std_logic
    );
end gtl_fdl_wrapper;

architecture rtl of gtl_fdl_wrapper is

    signal algo : std_logic_vector(nr_algos-1 downto 0);

    signal eg_internal : calo_objects_array(0 to NR_EG_OBJECTS-1);
    signal jet_internal : calo_objects_array(0 to NR_JET_OBJECTS-1);
    signal tau_internal : calo_objects_array(0 to NR_TAU_OBJECTS-1);
    signal ett_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal ht_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal etm_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal htm_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal muon_internal : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal ext_cond_internal : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
    signal mbt1hfp_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt1hfm_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt0hfp_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt0hfm_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
-- HB 2016-09-16: inserted new esums
    signal ettem_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal etmhf_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal htmhf_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal towercount_internal : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0) := (others => '0');
-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality"
    signal asymet_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymht_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymethf_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymhthf_internal : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal centrality_internal : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);

begin

    eg_internal_l: for i in 0 to NR_EG_OBJECTS-1 generate
       eg_internal(i) <= lhc_data.eg(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    jet_internal_l: for i in 0 to NR_JET_OBJECTS-1 generate
        jet_internal(i) <= lhc_data.jet(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    tau_internal_l: for i in 0 to NR_TAU_OBJECTS-1 generate
        tau_internal(i) <= lhc_data.tau(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    muon_internal_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        muon_internal(i) <= lhc_data.muon(i)(MAX_MUON_BITS-1 downto 0);
    end generate;

-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
-- HB 2016-04-21: see email from Johannes (Andrew Rose), 2016-04-20 15:34
-- Frame 0: (HF+ thresh 0) ... ... (Scalar ET) - 4 MSBs
-- Frame 1: (HF- thresh 0) ... ... (Scalar HT) - 4 MSBs
-- Frame 2: (HF+ thresh 1) ... ... (Vector ET) - 4 MSBs
-- Frame 3: (HF- thresh 1) ... ... (Vector HT) - 4 MSBs
-- HB 2016-04-26: grammar notation
-- HF+ thresh 0 => MBT0HFP
-- HF- thresh 0 => MBT0HFM
-- HF+ thresh 1 => MBT1HFP
-- HF- thresh 1 => MBT1HFM

    ett_internal(D_S_I_ETT_V2.et_high downto D_S_I_ETT_V2.et_low) <= lhc_data.ett(D_S_I_ETT_V2.et_high downto D_S_I_ETT_V2.et_low);
    ht_internal(D_S_I_HTT_V2.et_high downto D_S_I_HTT_V2.et_low) <= lhc_data.ht(D_S_I_HTT_V2.et_high downto D_S_I_HTT_V2.et_low);
    etm_internal(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.et_low) <= lhc_data.etm(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.et_low);
    htm_internal(D_S_I_HTM_V2.phi_high downto D_S_I_HTM_V2.et_low) <= lhc_data.htm(D_S_I_HTM_V2.phi_high downto D_S_I_HTM_V2.et_low);
-- HB 2016-09-16: inserted new esums
    ettem_internal(D_S_I_ETTEM_V2.et_high downto D_S_I_ETTEM_V2.et_low) <= lhc_data.ett(ETTEM_IN_ETT_HIGH downto ETTEM_IN_ETT_LOW);
    etmhf_internal(D_S_I_ETMHF_V2.phi_high downto D_S_I_ETMHF_V2.et_low) <= lhc_data.etmhf(D_S_I_ETMHF_V2.phi_high downto D_S_I_ETMHF_V2.et_low);
    htmhf_internal(D_S_I_HTMHF_V2.phi_high downto D_S_I_HTMHF_V2.et_low) <= lhc_data.htmhf(D_S_I_HTMHF_V2.phi_high downto D_S_I_HTMHF_V2.et_low);
    towercount_internal(D_S_I_TOWERCOUNT_V2.count_high-D_S_I_TOWERCOUNT_V2.count_low downto 0) <= lhc_data.ht(TOWERCOUNT_IN_HTT_HIGH downto TOWERCOUNT_IN_HTT_LOW);

    mbt0hfp_internal(D_S_I_MBT0HFP_V2.count_high downto D_S_I_MBT0HFP_V2.count_low) <= lhc_data.ett(MBT0HFP_IN_ETT_HIGH downto MBT0HFP_IN_ETT_LOW);
    mbt0hfm_internal(D_S_I_MBT0HFM_V2.count_high downto D_S_I_MBT0HFM_V2.count_low) <= lhc_data.ht(MBT0HFM_IN_HTT_HIGH downto MBT0HFM_IN_HTT_LOW);
    mbt1hfp_internal(D_S_I_MBT1HFP_V2.count_high downto D_S_I_MBT1HFP_V2.count_low) <= lhc_data.etm(MBT1HFP_IN_ETM_HIGH downto MBT1HFP_IN_ETM_LOW);
    mbt1hfm_internal(D_S_I_MBT1HFM_V2.count_high downto D_S_I_MBT1HFM_V2.count_low) <= lhc_data.htm(MBT1HFM_IN_HTM_HIGH downto MBT1HFM_IN_HTM_LOW);

-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
-- see: https://indico.cern.ch/event/746381/contributions/3085360/subcontributions/260912/attachments/1693846/2725976/DemuxOutput.pdf

-- Frame 2, ETM: bits 27..20 => ASYMET
-- Frame 3, HTM: bits 27..20 => ASYMHT
-- Frame 4, ETMHF: bits 27..20 => ASYMETHF
-- Frame 5, HTMHF: bits 27..20 => ASYMHTHF

-- Frame 4, ETMHF: bits 31..28 => CENT3..CENT0
-- Frame 5, HTMHF: bits 31..28 => CENT7..CENT4

    asymet_internal(D_S_I_ASYMET.high downto D_S_I_ASYMET.low) <= lhc_data.etm(ASYMET_IN_ETM_HIGH downto ASYMET_IN_ETM_LOW);
    asymht_internal(D_S_I_ASYMHT.high downto D_S_I_ASYMHT.low) <= lhc_data.htm(ASYMHT_IN_HTM_HIGH downto ASYMHT_IN_HTM_LOW);
    asymethf_internal(D_S_I_ASYMETHF.high downto D_S_I_ASYMETHF.low) <= lhc_data.etmhf(ASYMETHF_IN_ETMHF_HIGH downto ASYMETHF_IN_ETMHF_LOW);
    asymhthf_internal(D_S_I_ASYMHTHF.high downto D_S_I_ASYMHTHF.low) <= lhc_data.htmhf(ASYMHTHF_IN_HTMHF_HIGH downto ASYMHTHF_IN_HTMHF_LOW);
    
    centrality_internal(CENT_LBITS_HIGH downto CENT_LBITS_LOW) <= lhc_data.etmhf(CENT_IN_ETMHF_HIGH downto CENT_IN_ETMHF_LOW);
    centrality_internal(CENT_UBITS_HIGH downto CENT_UBITS_LOW) <= lhc_data.htmhf(CENT_IN_HTMHF_HIGH downto CENT_IN_HTMHF_LOW);
    
-- ****************************************************************************************
    
    ext_cond_internal <= lhc_data.external_conditions(NR_EXTERNAL_CONDITIONS-1 downto 0);

gtl_module_i: entity work.gtl_module
    port map( 
        lhc_clk         => lhc_clk,
        eg_data         => eg_internal,
        jet_data        => jet_internal,
        tau_data        => tau_internal,
        ett_data        => ett_internal,
        ht_data         => ht_internal,
        etm_data        => etm_internal,
        htm_data        => htm_internal,
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
        mbt1hfp_data    => mbt1hfp_internal,
        mbt1hfm_data    => mbt1hfm_internal,
        mbt0hfp_data    => mbt0hfp_internal,
        mbt0hfm_data    => mbt0hfm_internal,
-- HB 2016-09-16: inserted new esums
        ettem_data      => ettem_internal,
        etmhf_data      => etmhf_internal,
        htmhf_data      => htmhf_internal,
        towercount_data => towercount_internal,
-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
        asymet_data      => asymet_internal,
        asymht_data      => asymht_internal,
        asymethf_data      => asymethf_internal,
        asymhthf_data      => asymhthf_internal,
        centrality_data       => centrality_internal,
-- ****************************************************************************************
        muon_data       => muon_internal,
        external_conditions => ext_cond_internal,
        algo_o          => algo
    );

fdl_module_i: entity work.fdl_module
    generic map(
        SIM_MODE => SIM_MODE,
        PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT,
        MASKS_INIT => MASKS_INIT
    )
    port map( 
        ipb_clk         => ipb_clk,
        ipb_rst         => ipb_rst,
        ipb_in          => ipb_in,
        ipb_out         => ipb_out,
-- ========================================================
        lhc_clk         => lhc_clk,
        lhc_rst         => lhc_rst,
        bcres           => bcres,
        test_en         => test_en,
        l1a             => l1a,
        begin_lumi_section => begin_lumi_section,
        algo_i          => algo,
        prescale_factor_set_index_rop => prescale_factor_set_index_rop,
        algo_after_gtLogic_rop => algo_after_gtLogic_rop,
        algo_after_bxomask_rop => algo_after_bxomask_rop,
        algo_after_prescaler_rop  => algo_after_prescaler_rop,
        local_finor_rop => local_finor_rop,
        local_veto_rop  => local_veto_rop,
        finor_2_mezz_lemo  => finor_2_mezz_lemo,
        finor_preview_2_mezz_lemo  => finor_preview_2_mezz_lemo,
        veto_2_mezz_lemo  => veto_2_mezz_lemo,
        finor_w_veto_2_mezz_lemo  => finor_w_veto_2_mezz_lemo,
        local_finor_with_veto_o  => local_finor_with_veto_o,
        algo_bx_mask_sim => (others => '1')  
    );

end architecture rtl;
