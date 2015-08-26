--------------------------------------------------------------------------------
-- Simulator   : Modelsim 10.1
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Simulation
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/sim/testbench/esums_conditions_tb.vhd $
-- $Date: 2015-05-20 11:40:51 +0200 (Mit, 20 Mai 2015) $
-- $Author: bergauer $
-- $Revision: 3958 $
--------------------------------------------------------------------------------

-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

-- use work.gtl_lib.all;
use work.gtl_pkg.all;

entity esums_conditions_TB is
end esums_conditions_TB;

architecture rtl of esums_conditions_TB is

component esums_conditions
    generic	(
        et_ge_mode : boolean;
	obj_type : natural;
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_full_range : boolean;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore : boolean;
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector;
        condition_o : out std_logic
    );
end component esums_conditions;

    constant LHC_CLK_PERIOD  : time :=  25.2 ns;

    signal lhc_clk : std_logic;
    
-- ************************************************************************************************
-- -- HB 2015-04-29: simulation of ETM condition, for other esums condition change this setting and the stimuli for data_i
--     constant obj_type : natural := ETM_TYPE;
--     constant et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0100";
--     constant phi_full_range : boolean :=false;
--     constant phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"008F";
--     constant phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0048";
--     constant phi_w2_ignore : boolean := true;
--     constant phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
--     constant phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";

-- HB 2015-04-29: simulation of HTT condition
    constant obj_type : natural := HTT_TYPE;
    constant et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0200";
    constant phi_full_range : boolean :=false;
    constant phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_ignore : boolean := false;
    constant phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
    constant phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := X"0000";
-- ************************************************************************************************

    signal data_i: std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := X"00000000";
    
--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

-- HB 2015-04-27: used integer for obj_type
-- ett_obj_type=0
-- htt_obj_type=1
-- etm_obj_type=2
-- htm_obj_type=3

    process
    begin
      if obj_type = 2 then
-- stimuli for ETM
	wait for 5 * LHC_CLK_PERIOD; 
        data_i <= X"000000F8"; -- no trigger => et to low
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000100"; -- no trigger => phi not in range
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00049200"; -- trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00070050"; -- no trigger => et to low
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00070101"; -- trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000038"; -- no trigger => et to low
        wait for LHC_CLK_PERIOD; 
        wait;
      elsif obj_type = 1 then
-- stimuli for HTT
        wait for 5 * LHC_CLK_PERIOD; 
        data_i <= X"00000205"; -- trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"000001FF"; -- no trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000200"; -- trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000050"; -- no trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000201"; -- trigger
        wait for LHC_CLK_PERIOD; 
        data_i <= X"00000038"; -- no trigger
        wait for LHC_CLK_PERIOD; 
        wait; 
      end if;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: esums_conditions
    generic map(true, obj_type,
        et_threshold,
        phi_full_range, phi_w1_upper_limit, phi_w1_lower_limit,
        phi_w2_ignore, phi_w2_upper_limit,phi_w2_lower_limit)
    port map(lhc_clk, data_i, open);

end rtl;

