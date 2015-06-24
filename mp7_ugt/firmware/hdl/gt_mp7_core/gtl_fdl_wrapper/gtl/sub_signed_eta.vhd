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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_signed_eta.vhd $
-- $Date: 2015-06-16 11:48:44 +0200 (Tue, 16 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4043 $
--------------------------------------------------------------------------------

-- Desription:
-- Calculation of differences in eta.
-- Eta values have Two"s Complement notation, therefore differences calculated "signed".
-- Only positive values of the substraction are taken for the difference.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"
use ieee.std_logic_signed.all;

use work.gtl_pkg.all;

entity sub_signed_eta is
    port(
        eta_1 : in std_logic_vector;
        eta_2 : in std_logic_vector;
        eta_diff_o : out natural;
        eta_1_value_o_sim : out integer;
        eta_2_value_o_sim : out integer
    );
end sub_signed_eta;

architecture rtl of sub_signed_eta is
    signal eta_1_value : integer;
    signal eta_2_value : integer;
begin

    eta_1_value <= (CONV_INTEGER(signed(eta_1)));
    eta_1_value_o_sim <= eta_1_value;
    eta_2_value <= (CONV_INTEGER(signed(eta_2)));
    eta_2_value_o_sim <= eta_2_value;

-- only positive difference in eta
    eta_diff_o <= abs(eta_1_value - eta_2_value);

end rtl;
