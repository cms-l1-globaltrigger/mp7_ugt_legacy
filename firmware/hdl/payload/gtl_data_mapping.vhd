-- Description:
-- Data mapping for GTL

-- Version-history:
-- HB 2023-09-06: cicada on link 11 (removed zdc10g on link 11).
-- HB 2023-08-25: updated for new ZDC data structure.
-- HB 2023-03-01: updated for ZDC.
-- HB 2023-02-09: updated comments.
-- HB 2022-10-10: inserted ZDC.
-- HB 2022-09-05: cleaned up.
-- HB 2021-06-01: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity gtl_data_mapping is
    port(
        lhc_data : in lhc_data_t;
        gtl_data : out gtl_data_record
    );
end gtl_data_mapping;

architecture rtl of gtl_data_mapping is

begin

    eg_l: for i in 0 to NR_EG_OBJECTS-1 generate
       gtl_data.eg(i) <= lhc_data.eg(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    jet_l: for i in 0 to NR_JET_OBJECTS-1 generate
        gtl_data.jet(i) <= lhc_data.jet(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    tau_l: for i in 0 to NR_TAU_OBJECTS-1 generate
        gtl_data.tau(i) <= lhc_data.tau(i)(MAX_CALO_BITS-1 downto 0);
    end generate;

    muon_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        gtl_data.mu(i) <= lhc_data.muon(i)(MAX_MUON_BITS-1 downto 0);
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

    gtl_data.ett(ETT_ET_HIGH downto ETT_ET_LOW) <= lhc_data.ett(ETT_ET_HIGH downto ETT_ET_LOW);
    gtl_data.htt(HTT_ET_high downto HTT_ET_LOW) <= lhc_data.ht(HTT_ET_high downto HTT_ET_LOW);
    gtl_data.etm(ETM_PHI_high downto ETM_ET_LOW) <= lhc_data.etm(ETM_PHI_high downto ETM_ET_LOW);
    gtl_data.htm(HTM_PHI_high downto HTM_ET_LOW) <= lhc_data.htm(HTM_PHI_high downto HTM_ET_LOW);
-- HB 2016-09-16: inserted new esums
    gtl_data.ettem(ETTEM_ET_high downto ETTEM_ET_LOW) <= lhc_data.ett(ETTEM_IN_ETT_HIGH downto ETTEM_IN_ETT_LOW);
    gtl_data.etmhf(ETMHF_PHI_high downto ETMHF_ET_LOW) <= lhc_data.etmhf(ETMHF_PHI_high downto ETMHF_ET_LOW);
    gtl_data.htmhf(HTMHF_PHI_high downto HTMHF_ET_LOW) <= lhc_data.htmhf(HTMHF_PHI_high downto HTMHF_ET_LOW);
    gtl_data.towercount(TOWERCOUNT_COUNT_high-TOWERCOUNT_COUNT_LOW downto 0) <= lhc_data.ht(TOWERCOUNT_IN_HTT_HIGH downto TOWERCOUNT_IN_HTT_LOW);

    gtl_data.mbt0hfp(MBT0HFP_COUNT_high downto MBT0HFP_COUNT_LOW) <= lhc_data.ett(MBT0HFP_IN_ETT_HIGH downto MBT0HFP_IN_ETT_LOW);
    gtl_data.mbt0hfm(MBT0HFM_COUNT_high downto MBT0HFM_COUNT_LOW) <= lhc_data.ht(MBT0HFM_IN_HTT_HIGH downto MBT0HFM_IN_HTT_LOW);
    gtl_data.mbt1hfp(MBT1HFP_COUNT_high downto MBT1HFP_COUNT_LOW) <= lhc_data.etm(MBT1HFP_IN_ETM_HIGH downto MBT1HFP_IN_ETM_LOW);
    gtl_data.mbt1hfm(MBT1HFM_COUNT_high downto MBT1HFM_COUNT_LOW) <= lhc_data.htm(MBT1HFM_IN_HTM_HIGH downto MBT1HFM_IN_HTM_LOW);

-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
-- see: https://indico.cern.ch/event/746381/contributions/3085360/subcontributions/260912/attachments/1693846/2725976/DemuxOutput.pdf

-- Frame 2, ETM: bits 27..20 => ASYMET
-- Frame 3, HTM: bits 27..20 => ASYMHT
-- Frame 4, ETMHF: bits 27..20 => ASYMETHF
-- Frame 5, HTMHF: bits 27..20 => ASYMHTHF

-- Frame 4, ETMHF: bits 31..28 => CENT3..CENT0
-- Frame 5, HTMHF: bits 31..28 => CENT7..CENT4

    gtl_data.asymet(ASYMET_HIGH downto ASYMET_LOW) <= lhc_data.etm(ASYMET_IN_ETM_HIGH downto ASYMET_IN_ETM_LOW);
    gtl_data.asymht(ASYMHT_HIGH downto ASYMHT_LOW) <= lhc_data.htm(ASYMHT_IN_HTM_HIGH downto ASYMHT_IN_HTM_LOW);
    gtl_data.asymethf(ASYMETHF_HIGH downto ASYMETHF_LOW) <= lhc_data.etmhf(ASYMETHF_IN_ETMHF_HIGH downto ASYMETHF_IN_ETMHF_LOW);
    gtl_data.asymhthf(ASYMHTHF_HIGH downto ASYMHTHF_LOW) <= lhc_data.htmhf(ASYMHTHF_IN_HTMHF_HIGH downto ASYMHTHF_IN_HTMHF_LOW);

    gtl_data.centrality(CENT_LBITS_HIGH downto CENT_LBITS_LOW) <= lhc_data.etmhf(CENT_IN_ETMHF_HIGH downto CENT_IN_ETMHF_LOW);
    gtl_data.centrality(CENT_UBITS_HIGH downto CENT_UBITS_LOW) <= lhc_data.htmhf(CENT_IN_HTMHF_HIGH downto CENT_IN_HTMHF_LOW);

-- ****************************************************************************************

    gtl_data.ext_cond <= lhc_data.external_conditions(NR_EXTERNAL_CONDITIONS-1 downto 0);

-- ****************************************************************************************

    gtl_data.zdc(0) <= lhc_data.zdc5g_0;
    gtl_data.zdc(1) <= lhc_data.zdc5g_1;
    gtl_data.zdc(2) <= lhc_data.zdc5g_2;
    gtl_data.zdc(3) <= lhc_data.zdc5g_3;
    gtl_data.zdc(4) <= lhc_data.zdc5g_4;
    gtl_data.zdc(5) <= lhc_data.zdc5g_5;
    
-- HB 2023-10-19: new CICADA data mapping - no bjets
    --bjet_l: for i in 0 to NR_BJET_OBJECTS-1 generate
        --gtl_data.bjet(i)(BJET_ET_HIGH downto BJET_ET_LOW) <= lhc_data.cicada(i)(10 downto 0); -- bjet Et
        --gtl_data.bjet(i)(BJET_ETA_HIGH downto BJET_ETA_LOW) <= lhc_data.cicada(i)(18 downto 11); -- bjet eta
        --gtl_data.bjet(i)(BJET_PHI_HIGH downto BJET_PHI_LOW) <= lhc_data.cicada(i)(26 downto 19); -- bjet phi
        --gtl_data.bjet(i)(BJET_FLAG_BIT) <= lhc_data.cicada(i)(27); -- bjet flag (currently unused)
    --end generate;

    gtl_data.cicada_ad(AD_INT_HIGH downto AD_INT_HIGH-3) <= lhc_data.cicada(0)(31 downto 28); -- anomaly detection integer part high
    gtl_data.cicada_ad(AD_INT_LOW+3 downto AD_INT_LOW) <= lhc_data.cicada(1)(31 downto 28); -- anomaly detection integer part low
    gtl_data.cicada_ad(AD_DEC_HIGH downto AD_DEC_HIGH-3) <= lhc_data.cicada(2)(31 downto 28); -- anomaly detection decimal part high
    gtl_data.cicada_ad(AD_DEC_LOW+3 downto AD_DEC_LOW) <= lhc_data.cicada(3)(31 downto 28); -- anomaly detection decimal part low
        
    gtl_data.cicada_hi(HI_HIGH downto HI_HIGH-3) <= lhc_data.cicada(4)(31 downto 28); -- heavy ion bits high
    gtl_data.cicada_hi(HI_LOW+3 downto HI_LOW) <= lhc_data.cicada(5)(31 downto 28); -- heavy ion bits low
        
end architecture rtl;
