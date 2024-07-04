
-- Description:
-- Wrapper for "AXO model v4".

-- Version history:
-- HB 2024-07-04: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.gtl_pkg.all;

entity axol1tl_v4_wrapper is
    generic	(
        sim_mode: boolean := true;
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
        adt_out: out std_logic;
        anomaly_score_o: out std_logic_vector(17 downto 0)
    );
end axol1tl_v4_wrapper;

architecture rtl of axol1tl_v4_wrapper is

    signal ett_i, htt_i, etm_i, htm_i, etmhf_i, htmhf_i: std_logic_vector(31 downto 0) := X"00000000";
    signal anomaly_score: std_logic_vector(17 downto 0);
    signal ap_rst: std_logic := '0';
    signal ap_start: std_logic := '1';
    signal adt: std_logic_vector(0 downto 0) := "0";
    
begin

    ett_i(MAX_ESUMS_BITS-1 downto 0) <= ett;
    htt_i(MAX_ESUMS_BITS-1 downto 0) <= htt;
    etm_i(MAX_ESUMS_BITS-1 downto 0) <= etm;
    htm_i(MAX_ESUMS_BITS-1 downto 0) <= htm;
    etmhf_i(MAX_ESUMS_BITS-1 downto 0) <= etmhf;
    
    anomaly_detection_i: entity work.axol1tl_v4
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
            anomaly_score,
            open
        );

    adt(0) <= '1' when to_integer(unsigned(anomaly_score)) >= threshold else '0';

    adt_out <= adt(0);
    
    anomaly_score_o <= anomaly_score;

end architecture rtl;
