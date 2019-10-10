
-- Description: this module contains the "frame module info"
-- HEPHY:21-11-2014 TOP_SERIAL_VENDOR is not mor relevant, because in future we will read from hardware over ipmi just MAC address

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.ipbus.all;
use work.frame_addr_decode.all;
use work.gt_mp7_core_pkg.all;

entity frame_module_info is
    port(
        ipb_clk: in std_logic;
        ipb_rst: in std_logic;
        ipb_in: in ipb_wbus;
        ipb_out: out ipb_rbus
    );
end frame_module_info;

architecture rtl of frame_module_info is

    signal module_info_2_ipb: ipb_regs_array(C_MODINFO_REGS_BEGIN_INDEX to C_MODINFO_REGS_END_INDEX);

begin

--===============================================================================================--
-- Module Info
    module_info_i: entity work.ipb_read_regs
    generic map
    (
        addr_width => C_MODINFO_REGS_ADDR_WIDTH,
        regs_beg_index => C_MODINFO_REGS_BEGIN_INDEX,
        regs_end_index => C_MODINFO_REGS_END_INDEX
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

    module_info_2_ipb(OFFSET_TIMESTAMP) <= TIMESTAMP;

    hostname_l: for i in 0 to HOSTNAME'length/32-1 generate
		module_info_2_ipb(i+OFFSET_HOSTNAME) <= HOSTNAME(i*32+31 downto i*32);
    end generate hostname_l;

--     hostname_l: for i in OFFSET_HOSTNAME to OFFSET_HOSTNAME+HOSTNAME'length/32-1 generate
-- 		module_info_2_ipb(i-OFFSET_HOSTNAME) <= HOSTNAME((i-OFFSET_HOSTNAME)*32+31 downto (i-OFFSET_HOSTNAME)*32);
--     end generate hostname_l;
--
    username_l: for i in 0 to USERNAME'length/32-1 generate
		module_info_2_ipb(i+OFFSET_USERNAME) <= USERNAME(i*32+31 downto i*32);
    end generate username_l;

--     username_l: for i in OFFSET_USERNAME to OFFSET_USERNAME+USERNAME'length/32-1 generate
-- 		module_info_2_ipb(i-OFFSET_USERNAME) <= USERNAME((i-OFFSET_USERNAME)*32+31 downto (i-OFFSET_USERNAME)*32);
--     end generate username_l;
--
    module_info_2_ipb(OFFSET_MODULE_TYPE) <= MODULE_TYPE;

    module_info_2_ipb(OFFSET_FRAME_VERSION) <= FRAME_VERSION;

    module_info_2_ipb(OFFSET_BUILD_VERSION) <= BUILD_VERSION;

end rtl;

