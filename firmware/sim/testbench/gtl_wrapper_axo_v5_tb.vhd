
-- Description:
-- Simulation of "./axo_v5_score_test/gtl_module_axo_v5_test.vhd" with "./axo_v5_score_test/L1Menu_Collisions2025_v1_0_0_TestVector_ttBar_000.txt"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library std;                  -- for Printing
use std.textio.all;

use work.txt_util.all;

use work.mp7_data_types.all;

use work.lhc_data_pkg.all;
use work.lhc_data_debug_util_pkg.all;

use work.gt_mp7_core_pkg.all;

use work.gtl_pkg.all;
use work.fdl_pkg.all;

entity gtl_wrapper_axo_v5_tb is
end gtl_wrapper_axo_v5_tb;

architecture rtl of gtl_wrapper_axo_v5_tb is

-- ***************************************************************
-- TV data structure
    constant bx_str_w : positive := 4;
    constant muon_str_w : positive := 16*8+8; -- 8 obj 64 bits (16 hex digits) + 8 blancs
    constant calo_str_w : positive := 8*48+48; -- 48 obj 32 bits (8 hex digits) + 48 blancs
    constant ext_cond_str_w : positive := 64; -- 256 bits (64 hex digits)
    constant data_str_w : positive := muon_str_w+calo_str_w+ext_cond_str_w;

    constant bx_beg : positive := 1;
    constant bx_end : positive := bx_beg+bx_str_w-1;
    constant data_beg : positive := bx_end+2;
    constant data_end : positive := data_beg+data_str_w-1;
-- ***************************************************************
            
    type lhc_data_t_array is array(integer range <>) of lhc_data_t;
    type bx_nr_vector_data_array is array(integer range <>) of string(1 to 4);

    constant CLK40_PERIOD  : time :=  24 ns; -- LHC_CLK_PERIOD
    constant CLK160_PERIOD  : time :=  6 ns;

    constant LHC_BUNCH_COUNT: integer := 3564;

    constant CONST_DELAY: integer := 5; -- delay for proper listing in "result_file"

    signal clk160 : std_logic;
    signal lhc_clk : std_logic;

    signal lhc_data : lhc_data_t := LHC_DATA_NULL;
    signal gtl_data : gtl_data_record;
    signal gtl_data_del : gtl_data_record;
    signal algo : std_logic_vector(NR_ALGOS-1 downto 0);
    signal axol1tl_score : std_logic_vector(17 downto 0);

--*********************************Main Body of Code**********************************
begin

    -- Clock
    gen_lhc_40mhz_clock: process
    begin
        lhc_clk  <=  '1';
        wait for CLK40_PERIOD/2;
        lhc_clk  <=  '0';
        wait for CLK40_PERIOD/2;
    end process;

    gen_160mhz_clock: process
    begin
        clk160  <=  '1';
        wait for CLK160_PERIOD/2;
        clk160  <=  '0';
        wait for CLK160_PERIOD/2;
    end process;

    stimulus : process
        variable l : line;
        variable write_l : line;
        variable testdata : lhc_data_t_array(0 to LHC_BUNCH_COUNT-1) := (others => LHC_DATA_NULL);
        variable bx_nr_vector_data : bx_nr_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable bx_nr : bx_nr_vector_data_array(0 to LHC_BUNCH_COUNT+CONST_DELAY-1) := (others => (others => '0'));
        variable temp_counter : integer := 0;

        file testvector_file : text open read_mode is "./axo_v5_score_test/L1Menu_Collisions2025_v1_0_0_TestVector_ttBar_000.txt";
        file result_file : text open write_mode is "./axo_v5_score_test/result_axo_v5_scores.txt";

    begin
        temp_counter := 0;
        while not endfile(testvector_file) loop
            readline(testvector_file, l);
            bx_nr_vector_data(temp_counter) := l(bx_beg to bx_end); -- bx nr
            testdata(temp_counter) := string_to_lhc_data_t(l(data_beg to data_end)); -- without bx_nr, algos and finor
            temp_counter := temp_counter + 1;
        end loop;

        write(write_l, string'("-------------------------------|-------|   score"));
        writeline(result_file, write_l);
        write(write_l, string'("bx   mu(0)            eg(0)    | algos | hex     dec"));
        writeline(result_file, write_l);

        wait for 5 ns;
        for i in 0 to LHC_BUNCH_COUNT-1 loop
            lhc_data <= testdata(i);
            bx_nr(i+CONST_DELAY) := bx_nr_vector_data(i);
            if i >= CONST_DELAY then
                write(write_l, string'(bx_nr(i) & " " & hstr(gtl_data_del.mu(0)) & " " & hstr(gtl_data_del.eg(0)) & " | " & hstr(algo) & "    | " & hstr(axol1tl_score) &  "   " & str(CONV_INTEGER(axol1tl_score))));
                writeline(result_file, write_l);
            end if;

            wait for CLK40_PERIOD;
        end loop;

        wait;

    end process;

 ------------------- Instantiate  modules  -----------------

-- Delays of input data for proper listing in "result_file" (for checks)
    eg_del_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 32,
            STAGES => CONST_DELAY
        )
        port map(
            lhc_clk, gtl_data.eg(0), gtl_data_del.eg(0)
        );

    mu_del_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 64,
            STAGES => CONST_DELAY
        )
	port map(
            lhc_clk, gtl_data.mu(0), gtl_data_del.mu(0)
        );

-- DUTs:
    gtl_data_mapping_i: entity work.gtl_data_mapping
        port map(
            lhc_data,
            gtl_data
        );

    gtl_module_i: entity work.gtl_module
        port map(
            lhc_clk,
            gtl_data,
            algo,
            axol1tl_score
        );

end rtl;

