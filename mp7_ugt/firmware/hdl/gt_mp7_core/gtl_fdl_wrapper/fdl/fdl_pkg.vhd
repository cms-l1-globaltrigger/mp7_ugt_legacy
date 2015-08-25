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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_pkg.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:
-- Package for constant and type definitions of fdl (GTU)

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.ALL;

package fdl_pkg is

-- Definitions for algorithms
-- constant nr_algos moved to gtl_pkg.vhd
--constant nr_algos : integer := 32; -- number of algorithmns (min. 32 for FDL registers width !!!)

-- Input flip-flops for algorithms of fdl_module.vhd
constant algo_inputs_ff: boolean := false; -- used for tests of fdl_module.vhd only

-- -- Definitions for prescalers
-- constant PRESCALER_COUNTER_WIDTH : integer := 24;
-- HB, 2013-11-13: type prescale_factor_array moved to gtl_pkg.vhd, because of getting PRESCALE_FACTOR_INIT from TME.
-- type prescale_factor_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0); -- same width as PCIe data

-- -- Definitions for rate counters
-- constant RATE_COUNTER_WIDTH : integer := 32;
-- type rate_counter_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(RATE_COUNTER_WIDTH-1 downto 0);

-- Definitions PCIe masks registers
-- HB, 24-10-2013: MAX_NR_ALGOS definition in gt_amc514_pkg.vhd
-- constant MAX_NR_ALGOS : integer := 512; -- max. number of algorithmns - needed for PCIe registers ranges for masks

-- constant NR_MASK_REG : integer := (NR_ALGOS-1)/32+1; -- number PCIe (32-bits) registers of masks per finor
-- type pcie_mask_reg_array is array (1 to nr_finors) of std_logic_vector(1 to nr_mask_reg*32);

-- -- Current address definition see gt_amc514_pkg.vhd
-- constant sw_off : natural := 2; -- 2 LSB not used for internal addresses from PCIE
-- constant sw_base_addr_fdl_module : std_logic_vector(31 downto 0) := X"00050000";
-- constant fdl_module_addr_range : integer := 11; -- address range of fdl_module registers
-- constant base_addr_fdl_module : std_logic_vector(20 downto fdl_module_addr_range)
--                               := sw_base_addr_fdl_module((20+sw_off) downto (fdl_module_addr_range+sw_off)); -- 2 LSB not used for internal addresses from PCIE
-- 
-- -- Definitions FDL addresses
-- type sw_addr_base_finor_bx_masks_array is array (0 to 15) of std_logic_vector(31 downto 0);
-- constant sw_addr_base_finor_bx_masks : sw_addr_base_finor_bx_masks_array := (
--     (sw_base_addr_fdl_module or X"00000000"), (sw_base_addr_fdl_module or X"00004000"), (sw_base_addr_fdl_module or X"00008000"), (sw_base_addr_fdl_module or X"0000C000"), 
--     (sw_base_addr_fdl_module or X"00010000"), (sw_base_addr_fdl_module or X"00014000"), (sw_base_addr_fdl_module or X"00018000"), (sw_base_addr_fdl_module or X"0001C000"), 
--     (sw_base_addr_fdl_module or X"00020000"), (sw_base_addr_fdl_module or X"00024000"), (sw_base_addr_fdl_module or X"00028000"), (sw_base_addr_fdl_module or X"0002C000"), 
--     (sw_base_addr_fdl_module or X"00030000"), (sw_base_addr_fdl_module or X"00034000"), (sw_base_addr_fdl_module or X"00038000"), (sw_base_addr_fdl_module or X"0003C000") 
-- ); -- NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_prescale_factors : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00040000"; -- 512 addresses
-- constant sw_addr_base_rate_cnt_before_pre : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00040800"; -- 512 addresses
-- constant sw_addr_base_rate_cnt_after_mask : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041000"; -- 512 addresses
-- constant sw_addr_base_veto_masks : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041800";
-- constant sw_addr_base_prescale_factor_set_index : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041840";
-- constant sw_addr_base_command_pulse : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041844";
-- constant sw_addr_base_control : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041848"; -- NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_status : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"0004184C"; -- NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_l1_trigger_menu_version : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041850"; -- fix content from TME (in gtl_pkg.vhd) - NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_gtl_fw_version : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041854"; -- fix content from TME (in gtl_pkg.vhd) - NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_fdl_fw_version : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041858"; -- fix content from TME (in gtl_pkg.vhd) - NOT IMPLEMENTED YET!!!
-- constant sw_addr_base_tme_version : std_logic_vector(31 downto 0) := sw_base_addr_fdl_module or X"00041860"; -- fix content from TME (in gtl_pkg.vhd) - NOT IMPLEMENTED YET!!!
-- 
-- type addr_base_finor_bx_masks_array is array (0 to 15) of std_logic_vector(fdl_module_addr_range-1 downto 0);
-- constant addr_base_finor_bx_masks : addr_base_finor_bx_masks_array := (
-- sw_addr_base_finor_bx_masks(0)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(1)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(2)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(3)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(4)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(5)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(6)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(7)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(8)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(9)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(10)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(11)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(12)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(13)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(14)(fdl_module_addr_range+sw_off-1 downto sw_off),
-- sw_addr_base_finor_bx_masks(15)(fdl_module_addr_range+sw_off-1 downto sw_off)
-- );
-- 
-- constant addr_base_prescale_factors : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_prescale_factors(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_rate_cnt_before_pre : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_rate_cnt_before_pre(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_rate_cnt_after_masks : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_rate_cnt_after_mask(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_veto_masks : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_veto_masks(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_prescale_factor_set_index : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_prescale_factor_set_index(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_command_pulse : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_command_pulse(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_control : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_control(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_status : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_status(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_l1_trigger_menu_version : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_l1_trigger_menu_version(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_gtl_fw_version : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_gtl_fw_version(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_fdl_fw_version : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_fdl_fw_version(fdl_module_addr_range+sw_off-1 downto sw_off);
-- constant addr_base_tme_version : std_logic_vector(fdl_module_addr_range-1 downto 0) := sw_addr_base_tme_version(fdl_module_addr_range+sw_off-1 downto sw_off);

end package;
