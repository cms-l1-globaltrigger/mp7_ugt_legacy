
-- Desription:
-- FDL structure for one algo (slice)
-- algo-bx-mask at algo input

-- HB 2017-01-10: fixed bug with 1 bx delay for "begin_lumi_per" for rate counter after pre-scaler.
-- HB 2016-11-17: inserted prescaler, rate_cnt_after_prescaler and algo_after_prescaler for "prescaler preview" in monitoring. Removed port "finor_mask".
-- HB 2016-08-31: removed logic with finor_mask. algo_rate_counter after prescaler. Removed port "algo_after_finor_mask".
-- HB 2016-07-04: algo_rate_counter after finor-mask. No algo_rate_counter between algo_pre_scaler and finor_mask.
-- HB 2016-06-17: added suppress_cal_trigger, used to suppress counting algos caused by calibration trigger at bx=3490.
-- HB 2016-04-12: renamed "algo_before_prescaler" to "algo_after_bxomask".
-- HB 2016-02-23: added algo_rate_counter after prescaler.
-- HB 2016-02-22: moved "algo_post_dead_time_counter" after prescaler.
-- HB 2016-02-16: inserted "algo_post_dead_time_counter".
-- HB 2015-09-17: inserted ports "sres_algo_rate_counter" and "sres_algo_pre_scaler".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.math_pkg.all;

entity algo_slice is
    generic( 
        RATE_COUNTER_WIDTH : integer := 32;
        PRESCALER_COUNTER_WIDTH : integer := 24;
        PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0) := X"00000001";
        MAX_DELAY : integer := 128
    );
    port( 
        sys_clk : in std_logic;
        lhc_clk : in std_logic;
        lhc_rst : in std_logic;
-- HB 2015-09-17: added "sres_algo_rate_counter" and "sres_algo_pre_scaler"
	sres_algo_rate_counter : in std_logic;
	sres_algo_pre_scaler : in std_logic;
	sres_algo_post_dead_time_counter : in std_logic;
-- HB 2016-06-17: added suppress_cal_trigger, used to suppress counting algos caused by calibration trigger at bx=3490.
	suppress_cal_trigger : in std_logic; -- pos. active signal: '1' = suppression of algos caused by calibration trigger !!!
-- HB 2015-09-2: added "l1a" and "l1a_latency_delay" for post-dead-time counter
	l1a : in std_logic;
	l1a_latency_delay : in std_logic_vector(log2c(MAX_DELAY)-1 downto 0);
        request_update_factor_pulse : in std_logic;
        begin_lumi_per : in std_logic;
        algo_i : in std_logic;
        prescale_factor : in std_logic_vector(PRESCALER_COUNTER_WIDTH-1 DOWNTO 0);
        prescale_factor_preview : in std_logic_vector(PRESCALER_COUNTER_WIDTH-1 DOWNTO 0);
        algo_bx_mask : in std_logic;
        veto_mask : in std_logic;
        rate_cnt_before_prescaler : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        rate_cnt_after_prescaler : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        rate_cnt_after_prescaler_preview : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        rate_cnt_post_dead_time : out std_logic_vector(RATE_COUNTER_WIDTH-1 DOWNTO 0);
        algo_after_bxomask : out std_logic;
        algo_after_prescaler : out std_logic;
        algo_after_prescaler_preview : out std_logic;
        veto : out std_logic
    );
end algo_slice;

architecture rtl of algo_slice is
    signal algo_after_algo_bx_mask_int : std_logic;
    signal algo_after_prescaler_int : std_logic;
    signal algo_after_prescaler_preview_int : std_logic;
    signal begin_lumi_per_del1 : std_logic;
begin

-- HB 2017-01-10: one bx delay for "begin_lumi_per" for rate counter after pre-scaler
    begin_lumi_per_del_p: process(lhc_clk, begin_lumi_per)
        begin
        if (lhc_clk'event and (lhc_clk = '1')) then
            begin_lumi_per_del1 <= begin_lumi_per;
        end if;
    end process;

-- HB 2016-06-17: added "suppress_cal_trigger", used to suppress counting of algos caused by calibration trigger at bx=3490.
--                Signal pos. active: '1' = suppression algos caused by calibration trigger !!!
    algo_after_algo_bx_mask_int <= algo_i and algo_bx_mask and not suppress_cal_trigger;

    rate_cnt_before_prescaler_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => RATE_COUNTER_WIDTH
	)
	port map( 
	    sys_clk => sys_clk,
	    lhc_clk => lhc_clk,
	    sres_counter => sres_algo_rate_counter,
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
	    algo_i => algo_after_algo_bx_mask_int,
	    request_update_factor_pulse => request_update_factor_pulse,
	    update_factor_pulse => begin_lumi_per,
	    prescale_factor => prescale_factor,
	    prescaled_algo_o => algo_after_prescaler_int
	);

    veto <= algo_after_prescaler_int and veto_mask;

-- HB 2016-08-31: renamed algo_rate_counter after finor-mask to algo_rate_counter after presclaer.
    rate_cnt_after_prescaler_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => RATE_COUNTER_WIDTH
	)
	port map( 
	    sys_clk => sys_clk,
	    lhc_clk => lhc_clk,
	    sres_counter => sres_algo_rate_counter,
-- 	    store_cnt_value => begin_lumi_per,
	    store_cnt_value => begin_lumi_per_del1,
	    algo_i => algo_after_prescaler_int,
	    counter_o => rate_cnt_after_prescaler
	);

-- ****************************************************************************************************
-- HB 2016-11-17: section "prescaler preview" in monitoring

    prescaler_preview_i: entity work.algo_pre_scaler
	generic map( 
	    COUNTER_WIDTH => PRESCALER_COUNTER_WIDTH,
	    PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT
	)
	port map( 
	    clk => lhc_clk,
	    sres_counter => sres_algo_pre_scaler,
	    algo_i => algo_after_algo_bx_mask_int,
	    request_update_factor_pulse => request_update_factor_pulse,
	    update_factor_pulse => begin_lumi_per,
	    prescale_factor => prescale_factor_preview,
	    prescaled_algo_o => algo_after_prescaler_preview_int
	);

    rate_cnt_after_prescaler_preview_i: entity work.algo_rate_counter
	generic map( 
	    COUNTER_WIDTH => RATE_COUNTER_WIDTH
	)
	port map( 
	    sys_clk => sys_clk,
	    lhc_clk => lhc_clk,
	    sres_counter => sres_algo_rate_counter,
-- 	    store_cnt_value => begin_lumi_per,
	    store_cnt_value => begin_lumi_per_del1,
	    algo_i => algo_after_prescaler_preview_int,
	    counter_o => rate_cnt_after_prescaler_preview
	);

    algo_after_prescaler_preview <= algo_after_prescaler_preview_int;

-- ****************************************************************************************************

-- HB 2016-07-04: algo_post_dead_time_counter after finor-mask
    rate_cnt_post_dead_time_i: entity work.algo_post_dead_time_counter
	generic map( 
	    COUNTER_WIDTH => RATE_COUNTER_WIDTH,
	    MAX_DELAY => MAX_DELAY
	)
	port map( 
	    sys_clk => sys_clk,
	    lhc_clk => lhc_clk,
	    lhc_rst => lhc_rst,
	    sres_counter => sres_algo_post_dead_time_counter,
	    store_cnt_value => begin_lumi_per,
	    l1a => l1a,
	    delay => l1a_latency_delay,
	    algo_i => algo_after_prescaler_int,
	    counter_o => rate_cnt_post_dead_time
	);

    algo_after_bxomask <= algo_after_algo_bx_mask_int;
    algo_after_prescaler <= algo_after_prescaler_int;

end architecture rtl;

