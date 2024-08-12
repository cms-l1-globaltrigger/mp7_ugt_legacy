
-- Description:
-- Wrapper for "topological trigger".

-- Version history:
-- HB 2023-03-22: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.gtl_pkg.all;

entity topo_trigger_hh_mu_v1_wrapper is
    generic	(
        threshold: integer := 4150
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
        topo_out: out std_logic;
        topo_score_o: out std_logic_vector(15 downto 0)
    );
end topo_trigger_hh_mu_v1_wrapper;

architecture rtl of topo_trigger_hh_mu_v1_wrapper is

    signal ett_i, htt_i, etm_i, htm_i, etmhf_i, htmhf_i: std_logic_vector(31 downto 0) := X"00000000";
    signal topo_score: std_logic_vector(15 downto 0);
    signal ap_rst: std_logic := '0';
    signal ap_start: std_logic := '1';
    signal topo: std_logic_vector(0 downto 0) := "0";
    
begin

    ett_i(MAX_ESUMS_BITS-1 downto 0) <= ett;
    htt_i(MAX_ESUMS_BITS-1 downto 0) <= htt;
    etm_i(MAX_ESUMS_BITS-1 downto 0) <= etm;
    htm_i(MAX_ESUMS_BITS-1 downto 0) <= htm;
    etmhf_i(MAX_ESUMS_BITS-1 downto 0) <= etmhf;
    htmhf_i(MAX_ESUMS_BITS-1 downto 0) <= htmhf;
    
    topo_trigger_hh_mu_v1_i: entity work.topo_trigger_hh_mu_v1
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
            topo_score,
            open
        );

    topo(0) <= '1' when to_integer(unsigned(topo_score)) >= threshold else '0';

    topo_out <= topo(0);
    
    topo_score_o(15 downto 0) <= topo_score;

end architecture rtl;
