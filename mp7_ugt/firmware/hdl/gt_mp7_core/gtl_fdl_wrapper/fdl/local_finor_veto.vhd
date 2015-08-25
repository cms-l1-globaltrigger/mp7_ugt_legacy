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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/local_finor_veto.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity local_finor_veto is
    port( 
        lhc_clk          : in     std_logic;
        local_finor      : in     std_logic;
        local_veto       : in     std_logic;
        local_finor_with_veto     : out    std_logic
    );
end local_finor_veto;

architecture rtl of local_finor_veto is
begin

total_finor_p: process(lhc_clk, local_finor, local_veto)
    begin
    if (lhc_clk'event and (lhc_clk = '1')) then
        local_finor_with_veto <= local_finor and not local_veto;
    end if;
end process;

end architecture rtl;

