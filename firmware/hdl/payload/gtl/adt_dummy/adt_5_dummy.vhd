
-- Description:
-- Dummy module for "anomaly detection trigger (ADT)" test.

-- Version history:
-- HB 2022-01-25: all input data with +/-2bx.
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
        mu: in bx_muon_objects_array;
        eg: in bx_eg_objects_array;
        jet: in bx_jet_objects_array;
        tau: in bx_tau_objects_array;
        ett: in bx_esums_array;
        htt: in bx_esums_array;
        etm: in bx_esums_array;
        htm: in bx_esums_array;
        ettem: in bx_esums_array;
        etmhf: in bx_esums_array;
        adt_out: out std_logic
    );
end adt_5_dummy;

architecture rtl of adt_5_dummy is

begin

-- for tests used EG bx 0 object 5 bit 0 as adt
adt_out <= eg(2)(5)(0);

end architecture rtl;
