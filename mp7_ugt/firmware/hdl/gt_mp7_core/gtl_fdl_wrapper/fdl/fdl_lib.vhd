--------------------------------------------------------------------------------
-- Synthesizer : ISE 13.2
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/fdl/fdl_lib.vhd $
-- $Date: 2015-05-13 16:04:44 +0200 (Wed, 13 May 2015) $
-- $Author: wittmann $
-- $Revision: 3945 $
--------------------------------------------------------------------------------

-- Desription:
-- Package for constant and type definitions of gtl (GTU)

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.gtl_pkg.all;
use work.fdl_pkg.all;
use work.gt_mp7_core_pkg.all;

package fdl_lib is

component fdl_module
    generic(
        PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1);
        MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1)
    );
    port(
        ipb_clk             : in std_logic;
        ipb_rst             : in std_logic;
        ipb_in              : in ipb_wbus;
        ipb_out             : out ipb_rbus;
-- ==========================================================================
        --clk160              : in std_logic;   --JW 13.05.2015 not used
        lhc_clk             : in std_logic;
        lhc_rst             : in std_logic;
        bcres               : in std_logic;
        lhc_gap             : in std_logic;
        begin_lumi_section  : in std_logic;
        bx_nr               : in std_logic_vector(11 downto 0);
        algo_i              : in std_logic_vector(NR_ALGOS-1 downto 0);
        fdl_status          : out std_logic_vector(3 downto 0);
        prescale_factor_set_index_rop : out std_logic_vector(7 downto 0);
        algo_before_prescaler_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop     : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        ser_finor_veto      : out std_logic;
        local_finor_with_veto_o       : out std_logic -- to SPY2_FINOR
    );
end component fdl_module;

component algo_slice
    generic(
        RATE_COUNTER_WIDTH : integer;
        PRESCALER_COUNTER_WIDTH : integer;
        PRESCALE_FACTOR_INIT : std_logic_vector(31 downto 0)
    );
    port(
        sys_clk : in std_logic;
        lhc_clk : in std_logic;
        request_update_factor_pulse : in std_logic;
        begin_lumi_per : in std_logic;
        algo_i : in std_logic;
        prescale_factor : in std_logic_vector(PRESCALER_COUNTER_WIDTH-1 DOWNTO 0);
        algo_bx_mask : in std_logic;
        finor_mask : in std_logic;
        veto_mask : in std_logic;
        rate_cnt_before_prescaler : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
--         rate_cnt_after_mask : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        algo_before_prescaler : out std_logic;
        algo_after_prescaler : out std_logic;
        algo_after_finor_mask : out std_logic;
        veto : out std_logic
    );
end component algo_slice;

component algo_pre_scaler
   generic(
      COUNTER_WIDTH : integer;
      PRESCALE_FACTOR_INIT : std_logic_vector(31 downto 0)
   );
   port(
      clk              : in     std_logic;
      sres_counter     : in     std_logic;
      algo_i           : in     std_logic;
      request_update_factor_pulse   : in     std_logic;
      update_factor_pulse    : in     std_logic;
      prescale_factor  : in     std_logic_vector (COUNTER_WIDTH-1 downto 0); -- why counter_width ???
      prescaled_algo_o : out    std_logic
   );
end component algo_pre_scaler;

component update_process
   generic(
      WIDTH : integer;
      INIT_VALUE : std_logic_vector(31 DOWNTO 0)
   );
   port(
      clk              : in std_logic;
      request_update_pulse : in std_logic;
      update_pulse : in std_logic;
      data_i           : in std_logic_vector(WIDTH-1 downto 0);
      data_o           : out std_logic_vector(WIDTH-1 downto 0)
   );
end component update_process;

component algo_rate_counter
   generic(
      COUNTER_WIDTH : integer := 32
   );
   port(
      sys_clk          : in     std_logic;
      lhc_clk          : in     std_logic;
      sres_counter     : in     std_logic;
      store_cnt_value  : in     std_logic;
      algo_i           : in     std_logic;
      counter_o        : out    std_logic_vector (COUNTER_WIDTH-1 DOWNTO 0)
   );
end component algo_rate_counter;

component algo_mapping_rop
    port(
        lhc_clk : in std_logic;
        algo_before_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_finor_mask : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_before_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0)
    );
end component algo_mapping_rop;

component pulse_converter
    port(
        pulse_in         : in     std_logic;
        lhc_clk          : in     std_logic;
        pulse_25ns_out   : out    std_logic
    );
end component pulse_converter;

component serializer_finor_veto
    port(
        clk_160mhz       : in     std_logic;
        lhc_clk          : in     std_logic;
        lhc_rst          : in     std_logic;
        local_finor      : in     std_logic;
        local_veto       : in     std_logic;
        serialized_o     : out    std_logic
    );
end component serializer_finor_veto;

component local_finor_veto
    port(
        lhc_clk          : in     std_logic;
        local_finor      : in     std_logic;
        local_veto       : in     std_logic;
        local_finor_with_veto     : out    std_logic
    );
end component local_finor_veto;

end package;
