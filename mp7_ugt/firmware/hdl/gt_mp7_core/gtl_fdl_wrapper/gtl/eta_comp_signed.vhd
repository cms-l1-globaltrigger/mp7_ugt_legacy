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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/eta_comp_signed.vhd $
-- $Date: 2015-04-30 11:07:09 +0200 (Don, 30 Apr 2015) $
-- $Author: bergauer $
-- $Revision: 3879 $
--------------------------------------------------------------------------------

-- Desription:
-- Comparator for pseudorapidity (eta)
-- Eta scale is defined with Two's Complement notation values for HW index.
-- Therefore a comparison with "signed" is implemented, which needs ieee.std_logic_signed.all library.
-- This module is for use in calo_comparators.vhd and muon_comparators.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all; -- for eta comparison with "signed", because of Eta-scale with Two's Complement notation for HW index.

entity eta_comp_signed is
	generic	(
        eta_upper_limit: std_logic_vector;
        eta_lower_limit: std_logic_vector
    );
    port(
        eta: in std_logic_vector;
        eta_comp: out std_logic
    );
end eta_comp_signed;

architecture rtl of eta_comp_signed is
begin

    eta_comp <= '1' when eta >= eta_lower_limit and eta <= eta_upper_limit else '0';

end architecture rtl;
