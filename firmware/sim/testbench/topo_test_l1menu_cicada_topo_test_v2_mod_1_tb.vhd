library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library std;                  -- for Printing
use std.textio.all;

use work.txt_util.all;

use work.lhc_data_pkg.all;
use work.lhc_data_debug_util_pkg.all;

use work.gt_mp7_core_pkg.all;

use work.gtl_pkg.all;
use work.fdl_pkg.all;

entity topo_test_l1menu_cicada_topo_test_v2_mod_1_tb is
end topo_test_l1menu_cicada_topo_test_v2_mod_1_tb;

architecture rtl of topo_test_l1menu_cicada_topo_test_v2_mod_1_tb is

    constant ADT_ALGO_BIT: integer := 7;
    constant TV_FILE_LOC: string := "./topo_test/l1menu_cicada_topo_test_v2/module_1/TestVector_L1Menu_Cicada_Topo_test_v2.txt";
    constant ERROR_FILE_LOC: string := "./topo_test/l1menu_cicada_topo_test_v2/module_1/error_file_L1_TOPO_1000.txt";

    type lhc_data_t_array is array(integer range <>) of lhc_data_t;
    type algo_vector_string_array is array(integer range <>) of string(1 to 128);
    type algo_vector_data_array is array(integer range <>) of std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    type bx_nr_vector_data_array is array(integer range <>) of string(1 to 4);
    type finor_vector_string_array is array(integer range <>) of string(1 to 1);
    type finor_vector_data_array is array(integer range <>) of std_logic_vector(3 downto 0);

    constant CLK40_PERIOD  : time :=  25 ns; -- LHC_CLK_PERIOD
    constant CLK160_PERIOD  : time :=  6 ns;
    constant OFFSET_CLK80_PLL  : time :=  1200 ns;
    constant OFFSET_LHC_DATA  : time :=  7 ns;

    constant LHC_BUNCH_COUNT: integer := 3564;
    
    signal clk160 : std_logic;
    signal lhc_clk : std_logic;

    signal lhc_data : lhc_data_t := LHC_DATA_NULL;
    signal gtl_data : gtl_data_record;
    signal algo : std_logic_vector(NR_ALGOS-1 downto 0);
    signal algo_log : std_logic;
    
    signal stop : boolean := false;
    signal topo_score: std_logic_vector(17 downto 0);
    signal topo_score_tmp, topo_score_int: integer;

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
        variable algo_vector_string : algo_vector_string_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable algo_vector_data : algo_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable bx_nr_vector_data : bx_nr_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable finor_vector_string : finor_vector_string_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable finor_vector_data : finor_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable temp_counter : integer := 0;
        variable algo_error_cnt : integer := 0;
        variable finor_error_cnt : integer := 0;

        type algo_occur_array is array(integer range <>) of integer;
        variable algo_after_prescaler_rop_occur : algo_occur_array(MAX_NR_ALGOS-1 downto 0) := (others => 0);
        variable algo_vector_data_occur : algo_occur_array(MAX_NR_ALGOS-1 downto 0) := (others => 0);
        variable diff_occur, algo_mismatch : integer := 0;

        file testvector_file : text open read_mode is TV_FILE_LOC;
        file err_file : text open write_mode is ERROR_FILE_LOC;

        function str_to_slv(str : string) return std_logic_vector is
            alias str_norm : string(1 to str'length) is str;
            variable char_v : character;
            variable val_of_char_v : natural;
            variable res_v : std_logic_vector(4 * str'length - 1 downto 0);
        begin
            for str_norm_idx in str_norm'range loop
                char_v := str_norm(str_norm_idx);
                case char_v is
                    when '0' to '9' => val_of_char_v := character'pos(char_v) - character'pos('0');
                    when 'A' to 'F' => val_of_char_v := character'pos(char_v) - character'pos('A') + 10;
                    when 'a' to 'f' => val_of_char_v := character'pos(char_v) - character'pos('a') + 10;
                    when others => report "str_to_slv: Invalid characters for convert" severity ERROR;
                end case;
                res_v(res_v'left - 4 * str_norm_idx + 4 downto res_v'left - 4 * str_norm_idx + 1) := std_logic_vector(to_unsigned(val_of_char_v, 4));
            end loop;
            return res_v;
        end function;

    begin
        temp_counter := 0;
        while not endfile(testvector_file) loop
            readline(testvector_file, l);
            bx_nr_vector_data(temp_counter) := l(1 to 4); -- bx nr
            testdata(temp_counter) := string_to_lhc_data_t(l(6 to 638)); -- without bx_nr, algos and finor
            algo_vector_string(temp_counter) := l(639 to 766); -- algo strings
            algo_vector_data(temp_counter) := str_to_slv(l(639 to 766)); -- algos
            finor_vector_data(temp_counter) := str_to_slv(l(768 to 768)); -- finor
            finor_vector_string(temp_counter) := l(768 to 768); -- finor string
            temp_counter := temp_counter + 1;
        end loop;

        wait for OFFSET_CLK80_PLL + OFFSET_LHC_DATA; -- setup time for PLL for 80 MHz plus setup time for lhc_data

        for i in 0 to LHC_BUNCH_COUNT+GTL_FDL_LATENCY+1 loop
            if i < LHC_BUNCH_COUNT then
                lhc_data <= testdata(i);                        
            end if;
            if i >= GTL_FDL_LATENCY and i < LHC_BUNCH_COUNT+GTL_FDL_LATENCY-1 then
                if algo_log /= algo_vector_data(i - GTL_FDL_LATENCY)(ADT_ALGO_BIT) then
                    write(write_l, string'(bx_nr_vector_data(i - GTL_FDL_LATENCY) & " " & integer'image(topo_score_int) & " " & str(algo_log) & " " & str(algo_vector_data(i - GTL_FDL_LATENCY)(ADT_ALGO_BIT))));
                    writeline(err_file, write_l);
                end if;
            end if;
            wait for CLK40_PERIOD;
        end loop;

        wait for 100 us;
        stop <= true; --stop orbit signal generation
        wait;

    end process;

 ------------------- Instantiate  modules  -----------------

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
            topo_score
        );
        
-- delays for topological_score and algo(0) for err_file
    del1_p: process(lhc_clk, topo_score, algo(0))
    begin
        if (lhc_clk'event and lhc_clk = '1') then
            topo_score_tmp <= CONV_INTEGER(topo_score);
            algo_log <= algo(0);
        end if;
    end process;

    del2_p: process(lhc_clk, topo_score_tmp, algo(0))
    begin
        if (lhc_clk'event and lhc_clk = '1') then
            topo_score_int <= topo_score_tmp;
        end if;
    end process;

end rtl;
