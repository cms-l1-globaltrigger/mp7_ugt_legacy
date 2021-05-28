-- Description:
-- Package for constant and type definitions of FDL firmware in Global Trigger Upgrade system.

-- Version-history:
-- HB 2019-10-10: removed unused code.
-- HB 2019-10-04: new file name for fractional prescale values in float notation.
-- HB 2019-10-03: Cleaned up code.
-- HB 2019-09-27: Inserted 3 new constants for fractional prescale and calculate others from those.
-- HB 2019-09-26: New constants PRESCALE_FACTOR_WIDTH and PRESCALER_INCR, updated PRESCALE_FACTOR_INIT (removed PRESCALER_COUNTER_WIDTH and PRESCALER_FRACTION_WIDTH).
-- HB 2019-07-03: New package for FDL (moved from gtl_pkg.vhd)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

use work.gt_mp7_core_pkg.all;

package fdl_pkg is

-- *******************************************************************************************************
-- FDL definitions
-- Definitions for prescalers (for FDL !)

-- HB 2019-09-27: changed for proposal of A. Bocci
-- PRESCALE_FACTOR_MAX_VALUE = 42949672 (=0xFFFFFFA0) with 2 fractional digits [and 429496729 (=0xFFFFFFFA) with 1 fractional digit] for 32 bits width
    constant PRESCALE_FACTOR_FRACTION_DIGITS : integer := 2;
    constant PRESCALE_FACTOR_WIDTH : integer := 32;
    
    constant PRESCALE_FACTOR_INIT_VALUE : real := 1.00;

    constant PRESCALE_FACTOR_INIT_VALUE_INTEGER : integer := integer(PRESCALE_FACTOR_INIT_VALUE * real(10**PRESCALE_FACTOR_FRACTION_DIGITS));
    constant PRESCALE_FACTOR_INIT_VALUE_VEC : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR(PRESCALE_FACTOR_INIT_VALUE_INTEGER, 32);   
    constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := (others => PRESCALE_FACTOR_INIT_VALUE_VEC);
    constant PRESCALER_INCR : std_logic_vector(31 downto 0) := CONV_STD_LOGIC_VECTOR((10**PRESCALE_FACTOR_FRACTION_DIGITS), 32);
    
-- *******************************************************************************************************
    
end package;
