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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/fdl/algo_slice.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:
-- FDL structure for one algo (slice)
-- algo-bx-mask at algo input
-- rate-counter before prescaler only (no rate-counter after finor-mask)

-- HB 2015-09-17: inserted ports "sres_algo_rate_counter" and "sres_algo_pre_scaler".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity algo_slice is
    generic( 
        RATE_COUNTER_WIDTH : integer := 32;
        PRESCALER_COUNTER_WIDTH : integer := 24;
        PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0) := X"00000001"
    );
    port( 
        sys_clk : in std_logic;
        lhc_clk : in std_logic;
-- HB 2015-09-17: added "sres_algo_rate_counter" and "sres_algo_pre_scaler"
	sres_algo_rate_counter : in std_logic;
	sres_algo_pre_scaler : in std_logic;
        request_update_factor_pulse : in std_logic;
        begin_lumi_per : in std_logic;
        algo_i : in std_logic;
        prescale_factor : in std_logic_vector(PRESCALER_COUNTER_WIDTH-1 DOWNTO 0);
        algo_bx_mask : in std_logic;
        finor_mask : in std_logic;
        veto_mask : in std_logic;
        rate_cnt_before_prescaler : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        algo_before_prescaler : out std_logic;
        algo_after_prescaler : out std_logic;
        algo_after_finor_mask : out std_logic;
        veto : out std_logic
    );
end algo_slice;

architecture rtl of algo_slice is
    signal algo_after_algo_bx_mask_int : std_logic;
    signal algo_after_prescaler_int : std_logic;
    signal algo_after_finor_mask_int : std_logic;
begin

algo_after_algo_bx_mask_int <= algo_i and algo_bx_mask;

rate_cnt_before_prescaler_i: entity work.algo_rate_counter
    generic map( 
        COUNTER_WIDTH => RATE_COUNTER_WIDTH
    )
    port map( 
        sys_clk => sys_clk,
        lhc_clk => lhc_clk,
        sres_counter => sres_algo_rate_counter,
--         sres_counter => '0',
        store_cnt_value => begin_lumi_per,
        algo_i => algo_after_algo_bx_mask_int,
        counter_o => rate_cnt_before_prescaler
    );

prescaler_i: entity work.algo_pre_scaler
    generic map( 
        COUNTER_WIDTH => PRESCALER_COUNTER_WIDTH,
        PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT
    )
    port map( 
        clk => lhc_clk,
        sres_counter => sres_algo_pre_scaler,
--         sres_counter => '0',
        algo_i => algo_after_algo_bx_mask_int,
        request_update_factor_pulse => request_update_factor_pulse,
        update_factor_pulse => begin_lumi_per,
        prescale_factor => prescale_factor,
        prescaled_algo_o => algo_after_prescaler_int
    );

algo_after_finor_mask_int <= algo_after_prescaler_int and finor_mask;

veto <= algo_after_finor_mask_int and veto_mask;

algo_before_prescaler <= algo_after_algo_bx_mask_int;
algo_after_prescaler <= algo_after_prescaler_int;
algo_after_finor_mask <= algo_after_finor_mask_int;

end architecture rtl;

