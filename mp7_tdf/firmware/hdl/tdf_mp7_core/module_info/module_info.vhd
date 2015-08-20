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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/tdf_mp7/trunk/src/tdf_mp7_core/module_info/module_info.vhd $
-- $Date: 2014-05-13 17:16:28 +0200 (Tue, 13 May 2014) $
-- $Author: bergauer $
-- $Revision: 2919 $
--------------------------------------------------------------------------------

-- Description: this module contains the "tdf module info"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.ipbus.all;
use work.tdf_mp7_core_addr_decode.all;
use work.tdf_mp7_core_pkg.all;

entity module_info is
    port(
        ipb_clk: in std_logic;
        ipb_rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus
    );
end module_info;

architecture rtl of module_info is

    constant MODULE_INFO_ADDR_WIDTH     :   integer := 5; -- this fits for up to 32 registers
    constant MODULE_INFO_BEGIN_INDEX    :   integer := 0; -- start of module info regs
    constant MODULE_INFO_END_INDEX      :   integer := 21; -- end of module info regs

    signal module_info_2_ipb: ipb_regs_array(MODULE_INFO_BEGIN_INDEX to MODULE_INFO_END_INDEX);

begin

--===============================================================================================--
-- Module Info
    module_info_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => MODULE_INFO_ADDR_WIDTH,
        regs_beg_index => MODULE_INFO_BEGIN_INDEX,
        regs_end_index => MODULE_INFO_END_INDEX
    )
    port map
    (
        clk => ipb_clk,
        reset => ipb_rst,
        ipbus_in => ipb_in,
        ipbus_out => ipb_out,
        ------------------
        regs_i => module_info_2_ipb
    );

    module_info_2_ipb(0) <= TIMESTAMP;

    hostname_l: for i in 0 to HOSTNAME'length/32-1 generate
		module_info_2_ipb(i+1) <= HOSTNAME(i*32+31 downto i*32);
    end generate hostname_l;

--     hostname_l: for i in OFFSET_HOSTNAME to OFFSET_HOSTNAME+HOSTNAME'length/32-1 generate
-- 		module_info_2_ipb(i-OFFSET_HOSTNAME) <= HOSTNAME((i-OFFSET_HOSTNAME)*32+31 downto (i-OFFSET_HOSTNAME)*32);
--     end generate hostname_l;
--
    username_l: for i in 0 to USERNAME'length/32-1 generate
		module_info_2_ipb(i+9) <= USERNAME(i*32+31 downto i*32);
    end generate username_l;

--     username_l: for i in OFFSET_USERNAME to OFFSET_USERNAME+USERNAME'length/32-1 generate
-- 		module_info_2_ipb(i-OFFSET_USERNAME) <= USERNAME((i-OFFSET_USERNAME)*32+31 downto (i-OFFSET_USERNAME)*32);
--     end generate username_l;
--
    module_info_2_ipb(17) <= MODULE_TYPE;

--     module_serial_vendor_l: for i in 0 to MODULE_SERIAL_VENDOR'length/32-1 generate
-- 		module_info_2_ipb(i+18) <= MODULE_SERIAL_VENDOR(i*32+31 downto i*32);
--     end generate module_serial_vendor_l;

--     module_serial_vendor_l: for i in OFFSET_MODULE_SERIAL_VENDOR to OFFSET_MODULE_SERIAL_VENDOR+MODULE_SERIAL_VENDOR'length/32-1 generate
-- 		module_info_2_ipb(i-OFFSET_MODULE_SERIAL_VENDOR) <= MODULE_SERIAL_VENDOR((i-OFFSET_MODULE_SERIAL_VENDOR)*32+31 downto (i-OFFSET_MODULE_SERIAL_VENDOR)*32);
--     end generate module_serial_vendor_l;
--
    module_info_2_ipb(20) <= TDF_VERSION;

    module_info_2_ipb(21) <= BUILD_VERSION;

end rtl;

