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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/fdl/serializer_2_to_1.vhd $
-- $Date: 2015-06-16 13:26:25 +0200 (Tue, 16 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4045 $
--------------------------------------------------------------------------------

-- Desription:
-- Serializer for local finor and local veto. Serialized signal is send via mezzanine board to FINOR-FMC.

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity serializer_2_to_1 is
    port( 
        clk160           : in     std_logic;
        lhc_clk          : in     std_logic;
        local_finor      : in     std_logic;
        local_veto       : in     std_logic;
        serialized_o     : out    std_logic
    );
end serializer_2_to_1;

architecture rtl of serializer_2_to_1 is
    signal serialized_int : std_logic;
begin

-- HB 2014-11-20: mux for serializing.
    serialized_int <= local_finor when lhc_clk = '1' else
		      local_veto when lhc_clk = '0' else '0';

-- HB 2015-06-01: output with neg.edge og clk160.
    out_p: process (clk160, serialized_int)
    begin
        if (clk160'event and clk160 = '0') then
	    serialized_o <= serialized_int;
        end if;
    end process out_p;

end architecture rtl;

