-- Description:
-- Module for p_m_2_bx_pipeline, ext_cond_pipeline and centrality_pipeline.

-- Version-history:
-- HB 2020-09-08: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity pipelines is
    port(
        lhc_clk : in std_logic;
        muon_data : in muon_objects_array(0 to nr_muon_objects-1);
        mu_bx_p2 : out muon_objects_array(0 to nr_muon_objects-1);
        mu_bx_p1 : out muon_objects_array(0 to nr_muon_objects-1);
        mu_bx_0 : out muon_objects_array(0 to nr_muon_objects-1);
        mu_bx_m1 : out muon_objects_array(0 to nr_muon_objects-1);
        mu_bx_m2 : out muon_objects_array(0 to nr_muon_objects-1);
        eg_data : in calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p2 : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p1 : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_0 : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m1 : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m2 : out calo_objects_array(0 to nr_eg_objects-1);
        jet_data : in calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p2 : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p1 : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_0 : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m1 : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m2 : out calo_objects_array(0 to nr_jet_objects-1);
        tau_data : in calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p2 : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p1 : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_0 : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m1 : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m2 : out calo_objects_array(0 to nr_tau_objects-1);
        ett_data : in std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htt_data : in std_logic_vector(max_esums_bits-1 downto 0);
        htt_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htt_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htt_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        htt_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htt_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_data : in std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_data : in std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_data : in std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfp_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_data : in std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt1hfm_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_data : in std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfp_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_data : in std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        mbt0hfm_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        ettem_data : in std_logic_vector(max_esums_bits-1 downto 0);
        ettem_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        ettem_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        ettem_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        ettem_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        ettem_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_data : in std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        etmhf_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_data : in std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        htmhf_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        towercount_data : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_p2 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_p1 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_0 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_m1 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_m2 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        asymet_data : in std_logic_vector(max_esums_bits-1 downto 0);
        asymet_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymet_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymet_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymet_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymet_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymht_data : in std_logic_vector(max_esums_bits-1 downto 0);
        asymht_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymht_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymht_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymht_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymht_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_data : in std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymethf_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_data : in std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_bx_p2 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_bx_p1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_bx_0 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_bx_m1 : out std_logic_vector(max_esums_bits-1 downto 0);
        asymhthf_bx_m2 : out std_logic_vector(max_esums_bits-1 downto 0);
        cent_data : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        cent0_bx_p2 : out std_logic;
        cent1_bx_p2 : out std_logic;
        cent2_bx_p2 : out std_logic;
        cent3_bx_p2 : out std_logic;
        cent4_bx_p2 : out std_logic;
        cent5_bx_p2 : out std_logic;
        cent6_bx_p2 : out std_logic;
        cent7_bx_p2 : out std_logic;
        cent0_bx_p1 : out std_logic;
        cent1_bx_p1 : out std_logic;
        cent2_bx_p1 : out std_logic;
        cent3_bx_p1 : out std_logic;
        cent4_bx_p1 : out std_logic;
        cent5_bx_p1 : out std_logic;
        cent6_bx_p1 : out std_logic;
        cent7_bx_p1 : out std_logic;
        cent0_bx_0 : out std_logic;
        cent1_bx_0 : out std_logic;
        cent2_bx_0 : out std_logic;
        cent3_bx_0 : out std_logic;
        cent4_bx_0 : out std_logic;
        cent5_bx_0 : out std_logic;
        cent6_bx_0 : out std_logic;
        cent7_bx_0 : out std_logic;
        cent0_bx_m1 : out std_logic;
        cent1_bx_m1 : out std_logic;
        cent2_bx_m1 : out std_logic;
        cent3_bx_m1 : out std_logic;
        cent4_bx_m1 : out std_logic;
        cent5_bx_m1 : out std_logic;
        cent6_bx_m1 : out std_logic;
        cent7_bx_m1 : out std_logic;
        cent0_bx_m2 : out std_logic;
        cent1_bx_m2 : out std_logic;
        cent2_bx_m2 : out std_logic;
        cent3_bx_m2 : out std_logic;
        cent4_bx_m2 : out std_logic;
        cent5_bx_m2 : out std_logic;
        cent6_bx_m2 : out std_logic;
        cent7_bx_m2 : out std_logic;
        ext_cond_data : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p2 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p1 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_0 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m1 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m2 : out std_logic_vector(nr_external_conditions-1 downto 0)        
    );
end pipelines;

architecture rtl of pipelines is

--     signal mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2 : muon_objects_array(0 to NR_MUON_OBJECTS-1);
--     signal eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : calo_objects_array(0 to NR_EG_OBJECTS-1);
--     signal jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : calo_objects_array(0 to NR_JET_OBJECTS-1);
--     signal tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : calo_objects_array(0 to NR_TAU_OBJECTS-1);
--     signal ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2 : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
--     signal asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--     signal asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

begin

p_m_2_bx_pipeline_i: entity work.p_m_2_bx_pipeline
    port map(
        lhc_clk,
        muon_data, mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2,
        eg_data, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_data, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_data, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_data, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        htt_data, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
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
        cent_data, centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int,
        ext_cond_data, ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int
    );

ext_cond_pipeline_i: entity work.ext_cond_pipeline
    port map(
        lhc_clk, 
        ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int,
        ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2
    );
        
centrality_pipeline_i: entity work.centrality_pipeline
    port map(
        lhc_clk, 
        centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int,
        cent0_bx_p2, cent1_bx_p2, cent2_bx_p2, cent3_bx_p2, cent4_bx_p2, cent5_bx_p2, cent6_bx_p2, cent7_bx_p2,
        cent0_bx_p1, cent1_bx_p1, cent2_bx_p1, cent3_bx_p1, cent4_bx_p1, cent5_bx_p1, cent6_bx_p1, cent7_bx_p1,
        cent0_bx_0, cent1_bx_0, cent2_bx_0, cent3_bx_0, cent4_bx_0, cent5_bx_0, cent6_bx_0, cent7_bx_0,
        cent0_bx_m1, cent1_bx_m1, cent2_bx_m1, cent3_bx_m1, cent4_bx_m1, cent5_bx_m1, cent6_bx_m1, cent7_bx_m1,
        cent0_bx_m2, cent1_bx_m2, cent2_bx_m2, cent3_bx_m2, cent4_bx_m2, cent5_bx_m2, cent6_bx_m2, cent7_bx_m2
    );

end architecture rtl;
