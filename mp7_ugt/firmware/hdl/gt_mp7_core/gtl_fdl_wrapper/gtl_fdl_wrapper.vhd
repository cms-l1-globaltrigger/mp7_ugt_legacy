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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl_fdl_wrapper.vhd $
-- $Date: 2015-08-24 11:52:20 +0200 (Mon, 24 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4174 $
--------------------------------------------------------------------------------

-- Version-history:
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
use work.fdl_pkg.all;

use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;

entity gtl_fdl_wrapper is
    generic(
        SIM_MODE : boolean := false -- if SIM_MODE = true, "algo_bx_mask" by default = 1.
-- HB 2015-06-26: v0.0.12 - based on v0.0.11, but used an additional port "veto_2_mezz_lemo", which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502.
--                FDL_OUT_MEZZ_2_TCDS not used anymore.
-- 	FDL_OUT_MEZZ_2_TCDS : boolean := false -- if FDL_OUT_MEZZ_2_TCDS = true, "local_finor_with_veto" send to LEMO on mezzanine for TCDS.
    );
    port
    (
        ipb_clk             : in std_logic;
        ipb_rst             : in std_logic;
        ipb_in              : in ipb_wbus;
        ipb_out             : out ipb_rbus;
-- ==========================================================================
-- HB 2015-06-26: v0.0.12 - based on v0.0.11, but used an additional port "veto_2_mezz_lemo", which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502.
--                clk160 not used anymore.
--         clk160              : in std_logic;
        lhc_clk             : in std_logic;
        lhc_rst             : in std_logic;
        lhc_data            : in lhc_data_t;
        bcres               : in std_logic;
        lhc_gap             : in std_logic;
        begin_lumi_section  : in std_logic;
        bx_nr               : in std_logic_vector(11 downto 0);
        fdl_status          : out std_logic_vector(3 downto 0);
        prescale_factor_set_index_rop : out std_logic_vector(7 downto 0);
        algo_before_prescaler_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        finor_2_mezz_lemo      : out std_logic;
        veto_2_mezz_lemo      : out std_logic;
        local_finor_with_veto_o      : out std_logic
    );
end gtl_fdl_wrapper;

architecture rtl of gtl_fdl_wrapper is

    signal algo : std_logic_vector(nr_algos-1 downto 0);

    signal eg_temp : calo_objects_array(0 to NR_EG_OBJECTS-1);
    signal jet_temp : calo_objects_array(0 to NR_JET_OBJECTS-1);
    signal tau_temp : calo_objects_array(0 to NR_TAU_OBJECTS-1);
    signal ett_temp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal ht_temp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_temp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_temp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal muon_temp : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal ext_cond_temp : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
    
begin

    eg_temp_l: for i in 0 to NR_EG_OBJECTS-1 generate
       eg_temp(i) <= lhc_data.eg(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    jet_temp_l: for i in 0 to NR_JET_OBJECTS-1 generate
        jet_temp(i) <= lhc_data.jet(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    tau_temp_l: for i in 0 to NR_TAU_OBJECTS-1 generate
        tau_temp(i) <= lhc_data.tau(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    muon_temp_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        muon_temp(i) <= lhc_data.muon(i)(MAX_MUON_BITS-1 downto 0);
    end generate;

    ett_temp <= lhc_data.ett(MAX_ESUMS_BITS-1 downto 0);
    ht_temp <= lhc_data.ht(MAX_ESUMS_BITS-1 downto 0);
    etm_temp <= lhc_data.etm(MAX_ESUMS_BITS-1 downto 0);
    htm_temp <= lhc_data.htm(MAX_ESUMS_BITS-1 downto 0);

    ext_cond_temp <= lhc_data.external_conditions(NR_EXTERNAL_CONDITIONS-1 downto 0);

gtl_module_i: entity work.gtl_module
    port map( 
        lhc_clk         => lhc_clk,
        eg_data         => eg_temp,
        jet_data        => jet_temp,
        tau_data        => tau_temp,
        ett_data        => ett_temp,
        ht_data         => ht_temp,
        etm_data        => etm_temp,
        htm_data        => htm_temp,
        muon_data       => muon_temp,
        external_conditions => ext_cond_temp,
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
-- HB 2015-06-26: v0.0.12 - based on v0.0.11, but used an additional port "veto_2_mezz_lemo", which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502.
--                clk160 not used anymore.
--         clk160              : in std_logic;
        lhc_clk         => lhc_clk,
        lhc_rst         => lhc_rst,
        bcres           => bcres,
        lhc_gap         => lhc_gap,
        begin_lumi_section => begin_lumi_section,
        bx_nr           => bx_nr,
        algo_i          => algo,
        fdl_status      => fdl_status,
        prescale_factor_set_index_rop => prescale_factor_set_index_rop,
        algo_before_prescaler_rop => algo_before_prescaler_rop,
        algo_after_prescaler_rop  => algo_after_prescaler_rop,
        algo_after_finor_mask_rop => algo_after_finor_mask_rop,
        local_finor_rop => local_finor_rop,
        local_veto_rop  => local_veto_rop,
        finor_2_mezz_lemo  => finor_2_mezz_lemo,
        veto_2_mezz_lemo  => veto_2_mezz_lemo,
        local_finor_with_veto_o  => local_finor_with_veto_o,
	algo_bx_mask_sim => (others => '1')  
    );

end architecture rtl;
