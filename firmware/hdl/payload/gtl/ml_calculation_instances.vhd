
-- Description:
-- Instance for ML score calculation.

-- Version history:
-- HB 2024-04-19: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.gtl_pkg.all;

entity ml_calculation_instances is
    generic	(
        obj: natural := AXO_SEL;
        model: natural := AXO_MODEL_V3;
        score_width: natural := AXO_SCORE_WIDTH
    );
    port(
        lhc_clk: in std_logic;
        mu: in muon_objects_array;
        eg: in calo_objects_array;
        jet: in calo_objects_array;
        tau: in calo_objects_array;
        ett: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htt: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ml_score_o: out std_logic_vector(score_width-1 downto 0)
    );
end ml_calculation_instances;

architecture rtl of ml_calculation_instances is

    signal ett_i, htt_i, etm_i, htm_i, etmhf_i, htmhf_i: std_logic_vector(31 downto 0) := X"00000000";
    signal ml_score: std_logic_vector(score_width-1 downto 0);
    signal ap_rst: std_logic := '0';
    signal ap_start: std_logic := '1';
    
begin

    ett_i(MAX_ESUMS_BITS-1 downto 0) <= ett;
    htt_i(MAX_ESUMS_BITS-1 downto 0) <= htt;
    etm_i(MAX_ESUMS_BITS-1 downto 0) <= etm;
    htm_i(MAX_ESUMS_BITS-1 downto 0) <= htm;
    etmhf_i(MAX_ESUMS_BITS-1 downto 0) <= etmhf;
    htmhf_i(MAX_ESUMS_BITS-1 downto 0) <= htmhf;
    
    axo_i: if obj = AXO_SEL generate
        v1_i: if model = AXO_MODEL_V1 generate
            axol1tl_v1_i: entity work.axol1tl_v1
                port map(
                    lhc_clk, ap_rst, ap_start,
                    open, open, open,
                    mu(0),mu(1),mu(2),mu(3),
                    mu(4),mu(5),mu(6),mu(7),
                    jet(0),jet(1),jet(2),jet(3),
                    jet(4),jet(5),jet(6),jet(7),
                    jet(8),jet(9),jet(10),jet(11),
                    eg(0),eg(1),eg(2),eg(3),
                    eg(4),eg(5),eg(6),eg(7),
                    eg(8),eg(9),eg(10),eg(11),
                    tau(0),tau(1),tau(2),tau(3),
                    tau(4),tau(5),tau(6),tau(7),
                    tau(8),tau(9),tau(10),tau(11),
                    ett_i,htt_i,etm_i,htm_i,etmhf_i,htmhf_i,
                    ml_score(score_width-1 downto 0),
                    open
                );
        end generate v1_i;
        v3_i: if model = AXO_MODEL_V3 generate
            axol1tl_v3_i: entity work.axol1tl_v3
                port map(
                    lhc_clk, ap_rst, ap_start,
                    open, open, open,
                    mu(0),mu(1),mu(2),mu(3),
                    mu(4),mu(5),mu(6),mu(7),
                    jet(0),jet(1),jet(2),jet(3),
                    jet(4),jet(5),jet(6),jet(7),
                    jet(8),jet(9),jet(10),jet(11),
                    eg(0),eg(1),eg(2),eg(3),
                    eg(4),eg(5),eg(6),eg(7),
                    eg(8),eg(9),eg(10),eg(11),
                    tau(0),tau(1),tau(2),tau(3),
                    tau(4),tau(5),tau(6),tau(7),
                    tau(8),tau(9),tau(10),tau(11),
                    ett_i,htt_i,etm_i,htm_i,etmhf_i,htmhf_i,
                    ml_score(score_width-1 downto 0),
                    open
                );
        end generate v3_i;
        v4_i: if model = AXO_MODEL_V4 generate
            axol1tl_v3_i: entity work.axol1tl_v4
                port map(
                    lhc_clk, ap_rst, ap_start,
                    open, open, open,
                    mu(0),mu(1),mu(2),mu(3),
                    mu(4),mu(5),mu(6),mu(7),
                    jet(0),jet(1),jet(2),jet(3),
                    jet(4),jet(5),jet(6),jet(7),
                    jet(8),jet(9),jet(10),jet(11),
                    eg(0),eg(1),eg(2),eg(3),
                    eg(4),eg(5),eg(6),eg(7),
                    eg(8),eg(9),eg(10),eg(11),
                    tau(0),tau(1),tau(2),tau(3),
                    tau(4),tau(5),tau(6),tau(7),
                    tau(8),tau(9),tau(10),tau(11),
                    ett_i,htt_i,etm_i,htm_i,etmhf_i,htmhf_i,
                    ml_score(score_width-1 downto 0),
                    open
                );
        end generate v4_i;
        v5_i: if model = AXO_MODEL_V5 generate
            axol1tl_v3_i: entity work.axol1tl_v5
                port map(
                    lhc_clk, ap_rst, ap_start,
                    open, open, open,
                    mu(0),mu(1),mu(2),mu(3),
                    mu(4),mu(5),mu(6),mu(7),
                    jet(0),jet(1),jet(2),jet(3),
                    jet(4),jet(5),jet(6),jet(7),
                    jet(8),jet(9),jet(10),jet(11),
                    eg(0),eg(1),eg(2),eg(3),
                    eg(4),eg(5),eg(6),eg(7),
                    eg(8),eg(9),eg(10),eg(11),
                    tau(0),tau(1),tau(2),tau(3),
                    tau(4),tau(5),tau(6),tau(7),
                    tau(8),tau(9),tau(10),tau(11),
                    ett_i,htt_i,etm_i,htm_i,etmhf_i,htmhf_i,
                    ml_score(score_width-1 downto 0),
                    open
                );
        end generate v5_i;
    end generate axo_i;
    topo_i: if obj = TOPO_SEL generate
        base_v1_i: if model = TOPO_MODEL_BASE_V1 generate
            base_v1_inst_i: entity work.topo_base_v1
                port map(
                    lhc_clk, ap_rst, ap_start,
                    open, open, open,
                    mu(0),mu(1),mu(2),mu(3),
                    mu(4),mu(5),mu(6),mu(7),
                    jet(0),jet(1),jet(2),jet(3),
                    jet(4),jet(5),jet(6),jet(7),
                    jet(8),jet(9),jet(10),jet(11),
                    eg(0),eg(1),eg(2),eg(3),
                    eg(4),eg(5),eg(6),eg(7),
                    eg(8),eg(9),eg(10),eg(11),
                    tau(0),tau(1),tau(2),tau(3),
                    tau(4),tau(5),tau(6),tau(7),
                    tau(8),tau(9),tau(10),tau(11),
                    ett_i,htt_i,etm_i,htm_i,etmhf_i,htmhf_i,
                    ml_score(score_width-1 downto 0),
                    open
                );
        end generate base_v1_i;
    end generate topo_i;
    
    ml_score_o(score_width-1 downto 0) <= ml_score(score_width-1 downto 0);

end architecture rtl;
