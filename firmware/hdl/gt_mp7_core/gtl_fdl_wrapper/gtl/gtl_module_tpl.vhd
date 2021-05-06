-- Description:
-- Global Trigger Logic module.

-- Version-history:
-- HB 2021-05-05: v1.14.1: Bug fixed in sum_mass.vhd (comparison for mass 3 body).
-- HB 2021-04-16: v1.14.0: Added modules for correlation cuts calculations outside of conditions (correlation_cuts_calculation.vhd). Renamed files (differences.vhd => deta_dphi_calculations.vhd, ...). Added new modules for all and-or matrix instantiations (matrix_corr_cond.vhd, matrix_calo_cond.vhd, ...).
-- HB 2021-02-18: v1.13.0: Changed directory structure in gtl (created sub dir "common" for modules, which are not instantiated in gtl_module.vhd). Added new modules: conv_eta_phi.vhd, obj_parameter.vhd, differences.vhd and cosh_deta_cos_dphi.vhd. Cleaned up comments.
-- HB 2021-03-18: v1.12.1: Bug fix in  correlation_conditions_muon.vhd.
-- HB 2021-02-05: v1.12.0: Implemented comb_conditions.vhd, correlation_conditions_calo.vhd and correlation_conditions_muon.vhd instead of calo_conditions.vhd, muon_conditions.vhd and calo_calo_correlation_condition.vhd, muon_muon_correlation_condition.vhd, etc.
-- HB 2020-12-14: v1.11.0: Changes logic for phi cuts (similar to eta cuts). Same order in generics calo and muon conditions and for all correlation conditions (simplifies templates of VHDL Producer).
-- HB 2020-10-09: v1.10.1: Added module pipelines (including modules for ext_cond_pipe and centrality_pipe processes).
-- HB 2020-08-25: v1.10.0: Implemented new muon structure with "unconstraint pt" and "impact parameter". Added files for "invariant mass with 3 objects" and "invariant mass divided by delta R".
-- HB 2020-02-03: v1.9.4: Changed output pipeline code in esums_comparators.vhd and min_bias_hf_conditions.vhd.
-- HB 2020-01-30: v1.9.3: Cleaned up code in esums_comparators.vhd and min_bias_hf_conditions.vhd.
-- HB 2020-01-28: v1.9.2: Bug fixed in calo_calo_calo_correlation_orm_condition.vhd and calo_cond_matrix_orm.vhd.
-- HB 2019-10-21: v1.9.1: Bug fixed in calo_conditions.vhd (input ports).
-- HB 2019-10-17: v1.9.0: Added overlap removal for muon combinatorial conditions (muon_conditions_orm.vhd).
-- HB 2019-06-14: v1.8.0: Added possibility for "five eta cuts" in conditions.
-- HB 2019-05-02: v1.7.0: Added new modules (calo_cond_matrix.vhd, calo_cuts.vhd), changed calo_condition_v6_quad.vhd and calo_condition_v7_no_quad.vhd.
-- HB 2018-08-06: v1.6.0: Added ports and pipelines for "Asymmetry" (asymet_data, ...) and "Centrality" (centrality_data).
-- HB 2017-10-06: v1.5.0: Used new modules for use of std_logic_vector for limits of correlation cuts
-- HB 2017-09-15: v1.4.1: Bug fix in calo_calo_correlation_condition_v3.vhd
-- HB 2017-09-08: v1.4.0: Updated modules for correct use of object slices
-- HB 2017-07-03: v1.3.3: Charge correlation comparison inserted for different bx data (bug fix) in muon_muon_correlation_condition_v2.vhd
-- HB 2017-06-26: v1.3.2: Changed port order for muon_conditions_v5.vhd and updated gtl_pkg_tpl.vhd (and gtl_pkg_sim.vhd) for muon-esums precisions
-- HB 2017-05-15: v1.3.1: Used calo_calo_calo_correlation_orm_condition.vhd instead of calo_1plus1_orm_condition.vhd and calo_2plus1_orm_condition.vhd
-- HB 2017-04-07: v1.3.0: Prepared for using ORM conditions (calo_conditions_orm.vhd, calo_1plus1_orm_condition.vhd and calo_2plus1_orm_condition.vhd)
-- HB 2017-04-05: v1.2.1: Created new VHDL module: twobody_pt_calculator
-- HB 2016-09-16: v1.2.0: Implemented "slices" for object range in all condition types.
--                        Created new VHDL modules: mass_cuts, dr_calculator_v2, calo_conditions_v4, muon_conditions_v4,
--                        calo_calo_correlation_condition_v2, calo_esums_correlation_condition_v2, calo_muon_correlation_condition_v2
--                        muon_muon_correlation_condition_v2, muon_esums_correlation_condition_v2, calo_muon_muon_b_tagging_condition
-- HB 2016-09-16: v1.1.0: Implemented new esums with ETTEM, "TOWERCNT" (ECAL sum), ETMHF and HTMHF.
-- HB 2016-08-31: v1.0.0: Same version as v0.0.10
-- HB 2016-04-22: v0.0.10: Implemented min_bias_hf_conditions.vhd for minimum bias trigger conditions for low-pileup-run in May 2016.
--                         Updated gtl_fdl_wrapper.vhd and p_m_2_bx_pipeline.vhd for minimum bias trigger objects.
-- HB 2016-04-07: v0.0.9: Cleaned-up typing in muon_muon_correlation_condition.vhd (D_S_I_MUON_V2 instead of D_S_I_MUON in some lines).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity gtl_module is
    port(
        lhc_clk : in std_logic;
        eg_data : in calo_objects_array(0 to NR_EG_OBJECTS-1);
        jet_data : in calo_objects_array(0 to NR_JET_OBJECTS-1);
        tau_data : in calo_objects_array(0 to NR_TAU_OBJECTS-1);
        ett_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        towercount_data : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        asymet_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        centrality_data : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        muon_data : in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        external_conditions : in std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    COMPONENT rom_lut_calo_inv_dr_sq
    PORT(
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
    END COMPONENT;

    signal mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2 : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : calo_objects_array(0 to NR_EG_OBJECTS-1);
    signal jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : calo_objects_array(0 to NR_JET_OBJECTS-1);
    signal tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : calo_objects_array(0 to NR_TAU_OBJECTS-1);
    signal ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2 : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
    signal asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal centrality_bx_p2, centrality_bx_p1, centrality_bx_0, centrality_bx_m1, centrality_bx_m2 : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal cent0_bx_p2, cent0_bx_p1, cent0_bx_0, cent0_bx_m1, cent0_bx_m2 : std_logic;
    signal cent1_bx_p2, cent1_bx_p1, cent1_bx_0, cent1_bx_m1, cent1_bx_m2 : std_logic;
    signal cent2_bx_p2, cent2_bx_p1, cent2_bx_0, cent2_bx_m1, cent2_bx_m2 : std_logic;
    signal cent3_bx_p2, cent3_bx_p1, cent3_bx_0, cent3_bx_m1, cent3_bx_m2 : std_logic;
    signal cent4_bx_p2, cent4_bx_p1, cent4_bx_0, cent4_bx_m1, cent4_bx_m2 : std_logic;
    signal cent5_bx_p2, cent5_bx_p1, cent5_bx_0, cent5_bx_m1, cent5_bx_m2 : std_logic;
    signal cent6_bx_p2, cent6_bx_p1, cent6_bx_0, cent6_bx_m1, cent6_bx_m2 : std_logic;
    signal cent7_bx_p2, cent7_bx_p1, cent7_bx_0, cent7_bx_m1, cent7_bx_m2 : std_logic;
    signal ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
    signal ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2 : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

pipelines_i: entity work.pipelines
    port map(
        lhc_clk,
        muon_data, mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2,
        eg_data, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_data, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_data, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_data, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        ht_data, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
        etm_data, etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2,
        htm_data, htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2,
        mbt1hfp_data, mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2,
        mbt1hfm_data, mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2,
        mbt0hfp_data, mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2,
        mbt0hfm_data, mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2,
        ettem_data, ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2,
        etmhf_data, etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2,
        htmhf_data, htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2,
        towercount_data, towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2,
        asymet_data, asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2,
        asymht_data, asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2,
        asymethf_data, asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2,
        asymhthf_data, asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2,
        centrality_data,
        cent0_bx_p2, cent1_bx_p2, cent2_bx_p2, cent3_bx_p2, cent4_bx_p2, cent5_bx_p2, cent6_bx_p2, cent7_bx_p2,
        cent0_bx_p1, cent1_bx_p1, cent2_bx_p1, cent3_bx_p1, cent4_bx_p1, cent5_bx_p1, cent6_bx_p1, cent7_bx_p1,
        cent0_bx_0, cent1_bx_0, cent2_bx_0, cent3_bx_0, cent4_bx_0, cent5_bx_0, cent6_bx_0, cent7_bx_0,
        cent0_bx_m1, cent1_bx_m1, cent2_bx_m1, cent3_bx_m1, cent4_bx_m1, cent5_bx_m1, cent6_bx_m1, cent7_bx_m1,
        cent0_bx_m2, cent1_bx_m2, cent2_bx_m2, cent3_bx_m2, cent4_bx_m2, cent5_bx_m2, cent6_bx_m2, cent7_bx_m2,
        external_conditions, ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2
    );

{{gtl_module_instances}}

-- One pipeline stages for algorithms
algo_pipeline_p: process(lhc_clk, algo)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        algo_o <= algo;
    end if;
end process;

end architecture rtl;
