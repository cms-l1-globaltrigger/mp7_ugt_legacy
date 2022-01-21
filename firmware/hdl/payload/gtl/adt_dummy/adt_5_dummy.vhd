
-- Description:
-- Dummy module for "anomaly detection trigger (ADT)" test.

-- Version history:
-- HB 2022-01-21: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity adt_5_dummy is
    port(
        lhc_clk: in std_logic;
--         clk240: in std_logic;
        adt_in: in bx_data_record;
        adt_out: out std_logic
    );
end adt_5_dummy;

architecture rtl of adt_5_dummy is

begin

-- for tests used EG bx0 object 3 bit 0 as adt
adt_out <= adt_in.eg(2)(5)(0);

end architecture rtl;
