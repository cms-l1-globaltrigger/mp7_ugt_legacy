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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_unsigned_phi.vhd $
-- $Date: 2015-06-19 10:59:58 +0200 (Fre, 19 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4054 $
--------------------------------------------------------------------------------

-- Desription:
-- Calculation of differences in phi.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity sub_unsigned_phi is
    generic (
        PHI_BINS_DIV2: positive := 72
    );
	port(
        phi_1 : in std_logic_vector;
        phi_2 : in std_logic_vector;
        phi_diff_o : out natural;
        phi_diff_abs : out natural; -- for simulation
        phi_diff_o_sim : out natural -- for simulation
    );
end sub_unsigned_phi;

architecture rtl of sub_unsigned_phi is
    signal phi_1_value : integer;
    signal phi_2_value : integer;
begin

    phi_1_value <= (CONV_INTEGER(phi_1));

    phi_2_value <= (CONV_INTEGER(phi_2));

    phi_diff_p: process(phi_1_value, phi_2_value)
        variable phi_diff : integer;
    begin
-- only positive difference in phi
        phi_diff := abs(phi_1_value - phi_2_value);
        phi_diff_abs <= phi_diff;
-- if positive difference is greater than half range of phi, take full range of phi minus positive difference
        if phi_diff < PHI_BINS_DIV2 then
            phi_diff_o <= phi_diff;
        else
            phi_diff_o <= 2 * PHI_BINS_DIV2 - phi_diff;
        end if;
        
    end process phi_diff_p;

end architecture rtl;
