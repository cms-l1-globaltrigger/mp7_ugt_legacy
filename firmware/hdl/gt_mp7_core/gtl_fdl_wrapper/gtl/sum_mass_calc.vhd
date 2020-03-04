-- Description:
-- Calculation of sum mass of 3 objects.

-- Version history:
-- HB 2020-03-04: Added attribute use_dsp.
-- HB 2020-02-18: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity sum_mass_calc is
    generic(
        DATA_WIDTH : positive
    );
    port(
        in1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
        in2 : in std_logic_vector(DATA_WIDTH-1 downto 0);
        in3 : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sum_mass : out std_logic_vector(DATA_WIDTH+1 downto 0)
    );
end sum_mass_calc;

architecture rtl of sum_mass_calc is

    signal sum_mass_1_2 : std_logic_vector(DATA_WIDTH downto 0);
    
    attribute use_dsp : string;
    attribute use_dsp of sum_mass_1_2 : signal is "yes";
    attribute use_dsp of sum_mass : signal is "yes";

begin

    sum_mass_1_2 <= ('0' & in1) + in2;
    sum_mass <= ('0' & sum_mass_1_2) + in3;
          
end architecture rtl;
