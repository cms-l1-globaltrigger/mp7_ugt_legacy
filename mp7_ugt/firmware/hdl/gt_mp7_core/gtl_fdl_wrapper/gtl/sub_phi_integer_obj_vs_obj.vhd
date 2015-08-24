--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL$
-- $Date$
-- $Author$
-- $Revision$
--------------------------------------------------------------------------------

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity sub_phi_integer_obj_vs_obj is
    generic (
        NR_OBJ_1 : positive := 12;
        NR_OBJ_2 : positive := 8;
        PHI_HALF_RANGE: positive := 3142 -- or 31415, depends on how many digits after comma used
    );
    port(
        phi_in_1 : in diff_integer_inputs_array(0 to NR_OBJ_1-1);
        phi_in_2 : in diff_integer_inputs_array(0 to NR_OBJ_2-1);
        phi_diff_o : out diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end sub_phi_integer_obj_vs_obj;

architecture rtl of sub_phi_integer_obj_vs_obj is
    signal phi_diff_temp : diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1);
begin
-- instantiation of subtractors for phi
    loop_1: for i in 0 to NR_OBJ_1-1 generate
        loop_2: for j in 0 to NR_OBJ_2-1 generate
	    phi_diff_temp(i,j) <= abs(phi_in_1(i) - phi_in_2(j));
	    phi_diff_o(i,j) <= phi_diff_temp(i,j) when phi_diff_temp(i,j) < PHI_HALF_RANGE else
			       PHI_HALF_RANGE*2-phi_diff_temp(i,j);
        end generate loop_2;
    end generate loop_1;
end architecture rtl;