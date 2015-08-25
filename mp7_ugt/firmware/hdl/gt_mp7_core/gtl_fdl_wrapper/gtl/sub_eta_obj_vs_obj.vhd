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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/sub_eta_obj_vs_obj.vhd $
-- $Date: 2015-08-24 11:11:49 +0200 (Mon, 24 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4171 $
--------------------------------------------------------------------------------

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity sub_eta_obj_vs_obj is
    generic (
        NR_OBJ_1 : positive := 4;
        NR_OBJ_2 : positive := 4;
        ETA_WIDTH : positive := 8
    );
    port(
        in_1 : in diff_inputs_array(0 to NR_OBJ_1-1);
        in_2 : in diff_inputs_array(0 to NR_OBJ_2-1);
        diff : out diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end sub_eta_obj_vs_obj;

architecture rtl of sub_eta_obj_vs_obj is
begin
-- instantiation of subtractors for eta
    loop_1: for i in 0 to NR_OBJ_1-1 generate
        loop_2: for j in 0 to NR_OBJ_2-1 generate
            sub_i: entity work.sub_signed_eta
                port map(in_1(i)(ETA_WIDTH-1 downto 0), in_2(j)(ETA_WIDTH-1 downto 0), diff(i,j));
        end generate loop_2;
    end generate loop_1;
end architecture rtl;