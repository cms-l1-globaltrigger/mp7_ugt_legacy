
-- Description:
-- Dummy module for "anomaly detection trigger (ADT)" test.

-- Version history:
-- HB 2022-01-24: all input data of bx 0.
-- HB 2022-01-20: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity adt_5_dummy is
    port(
        lhc_clk: in std_logic;
--         clk240: in std_logic;
        muon: in muon_objects_array;
        eg: in calo_objects_array;
        jet: in calo_objects_array;
        tau: in calo_objects_array;
        ett: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htt: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        adt_out: out std_logic
    );
end adt_5_dummy;

architecture rtl of adt_5_dummy is

begin

-- for tests used EG object 5 bit 0 as adt
adt_out <= egamma(5)(0);

end architecture rtl;
