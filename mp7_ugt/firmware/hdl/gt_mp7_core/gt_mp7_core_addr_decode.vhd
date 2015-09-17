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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/uGT_algos/gt_mp7_core/gt_mp7_core_addr_decode.vhd $
-- $Date: 2014-05-20 10:37:27 +0200 (Tue, 20 May 2014) $
-- $Author: bergauer $
-- $Revision: 2924 $
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.math_pkg.all;

package gt_mp7_core_addr_decode is

    constant NR_IPB_SLV_GT_MP7_CORE : positive:= 3;

    constant IPBUS_SEL_WIDTH: positive := log2c(NR_IPB_SLV_GT_MP7_CORE);
    subtype ipbus_sel_t is std_logic_vector(IPBUS_SEL_WIDTH - 1 downto 0);
    function ipbus_sel_mp7_payload(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t;

    constant C_IPB_GT_MP7_FRAME : integer := 0;
    constant C_IPB_GT_MP7_GTLFDL : integer := 1;
    constant C_IPB_GT_MP7_TP_MUX : integer := 2;

    function gt_mp7_core_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;

end gt_mp7_core_addr_decode;


package body gt_mp7_core_addr_decode is

    function ipbus_sel_mp7_payload(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t is
        variable sel: ipbus_sel_t;

  begin
        if       std_match(addr, "1000----------------------------") then sel := C_IPB_GT_MP7_FRAME;  --0x80000000
        elsif    std_match(addr, "1001----------------------------") then sel := C_IPB_GT_MP7_GTLFDL; --0x90000000
        elsif    std_match(addr, "1010----------------------------") then sel := C_IPB_GT_MP7_TP_MUX; --0xA0000000
        else
            sel := ipbus_sel_t(to_unsigned(NR_IPB_SLV_GT_MP7_CORE, IPBUS_SEL_WIDTH));
        end if;

        return sel;

    end function ipbus_sel_mp7_payload;

end gt_mp7_core_addr_decode;