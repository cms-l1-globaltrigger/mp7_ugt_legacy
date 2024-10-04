library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.fdl_pkg.ALL;

entity check_shadow is
   port( 
      clk : in std_logic;
      prescaled_algo_1 : in std_logic;
      prescaled_algo_2 : in std_logic;
      shadow : out std_logic
   );
end check_shadow;

architecture beh of check_shadow is

begin

    shadow <= not((not prescaled_algo_1) and prescaled_algo_2);

end architecture beh;

