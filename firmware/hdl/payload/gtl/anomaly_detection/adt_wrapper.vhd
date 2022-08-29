
-- Description:
-- Wrapper for "anomaly detection".

-- Version history:
-- HB 2022-08-29: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity adt_wrapper is
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
--         htmhf: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        adt_out: out std_logic
    );
end adt_wrapper;

architecture rtl of adt_wrapper is

    signal ett_i, htt_i, etm_i, htm_i, etmhf_i, htmhf_i: std_logic_vector(31 downto 0) := X"00000000";

begin

    ett_i <= X"000" & ett;
    htt_i <= X"000" & htt;
    etm_i <= X"000" & etm;
    htm_i <= X"000" & htm;
    etmhf_i <= X"000" & etmhf;
    
    anomaly_detection_i: entity work.anomaly_detection
        port map(
            open, open,
            lhc_clk, '0', '1',
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
            open,
            adt_out
        );

--     adt_p: process(lhc_clk, adt_o)
--         begin
--         if (lhc_clk'event and lhc_clk = '1') then
--             adt_out <= adt_o;
--         end if;
--     end process;

end architecture rtl;
