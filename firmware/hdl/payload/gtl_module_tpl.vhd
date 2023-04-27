-- Description:
-- Global Trigger Logic module.

-- Version history:
-- HB 2023-04-27: v1.18.2: Implemented topological trigger.
-- HB 2023-04-15: v1.18.1: Bug fix muon index bits.
-- HB 2023-03-14: v1.18.0: Implemented "MUS2" (new hadronic shower bit), Anomaly Detection Trigger, ZDC conditions and cuts for muon index bits.
-- HB 2022-11-29: v1.17.6: Bug fix in algo_pre_scaler_fractional_float.vhd.
-- HB 2022-11-16: v1.17.5: Bug fix in correlation_conditions.vhd.
-- HB 2022-09-23: v1.17.4: Used "delay_pipeline" for condition output in esums_conditions.vhd, min_bias_hf_conditions.vhd and towercount_condition.vhd.
-- HB 2022-09-05: v1.17.3: Cleaned up.
-- HB 2022-02-16: v1.17.2: Bug fixed in comb_conditions.vhd.
-- HB 2021-10-23: v1.17.1: Updated logic for jet DISP cut.
-- HB 2021-10-23: v1.17.0: Implemented logic for jet DISP (displaced) cut [DISP = bit 27 of jet data] in calo_comparators.vhd. Bug fixed in correlation_cuts_wrapper.vhd.
-- HB 2021-10-27: v1.16.2: Bug fix in matrix_corr_cond.vhd.
-- HB 2021-10-18: v1.16.1: Bug fix in calo_comparators.vhd.
-- HB 2021-08-31: v1.16.0: Changed logic for ROMs (mass over DR) [regenerated IPs for ROMs].
-- HB 2021-06-10: v1.15.1: Added hadronic shower triggers.
-- HB 2021-05-21: v1.15.0: Added fdl_pkg use clause. Added bx_pipeline (to simplify code).
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

use work.fdl_pkg.all;
use work.gtl_pkg.all;

entity gtl_module is
    port(
        lhc_clk : in std_logic;
        gtl_data : in gtl_data_record;
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

    signal bx_data : bx_data_record;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

bx_pipeline_i: entity work.bx_pipeline
    port map(
        lhc_clk,
        gtl_data,
        bx_data
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
