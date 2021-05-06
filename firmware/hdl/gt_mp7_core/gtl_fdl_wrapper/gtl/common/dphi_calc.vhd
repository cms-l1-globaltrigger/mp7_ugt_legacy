
library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity dphi_calc is
    generic (
        nr_obj1 : positive := 12;
        nr_obj2 : positive := 8;
        phi_half_range: positive := 72 -- in bins
    );
    port(
        phi_in_1 : in integer_array(0 to nr_obj1-1);
        phi_in_2 : in integer_array(0 to nr_obj2-1);
        phi_diff_o : out dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1)
    );
end dphi_calc;

architecture rtl of dphi_calc is
    signal phi_diff_temp : dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1);

begin
-- instantiation of subtractors for phi
    loop_1: for i in 0 to nr_obj1-1 generate
        loop_2: for j in 0 to nr_obj2-1 generate
            phi_diff_temp(i,j) <= abs(phi_in_1(i) - phi_in_2(j));
            phi_diff_o(i,j) <= phi_diff_temp(i,j) when phi_diff_temp(i,j) < phi_half_range else phi_half_range*2-phi_diff_temp(i,j);
        end generate loop_2;
    end generate loop_1;
end architecture rtl;
