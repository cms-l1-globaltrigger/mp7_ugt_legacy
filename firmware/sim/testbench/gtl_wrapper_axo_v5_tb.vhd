
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library std;                  -- for Printing
use std.textio.all;

use work.txt_util.all;

--use work.ipbus.all;
--use work.ipbus_trans_decl.all;
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
    constant algo_str_w : positive := MAX_NR_ALGOS/4;
   
    constant bx_beg : positive := 1;
    constant bx_end : positive := bx_beg+bx_str_w-1;
    constant data_beg : positive := bx_end+2;
    constant data_end : positive := data_beg+data_str_w-1;
    constant algo_beg : positive := data_end+2;
    constant algo_end : positive := algo_beg+algo_str_w-1;
    constant finor_beg : positive := algo_end+2;
-- ***************************************************************
            
    type lhc_data_t_array is array(integer range <>) of lhc_data_t;
    type algo_vector_string_array is array(integer range <>) of string(1 to 128);
    type algo_vector_data_array is array(integer range <>) of std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    type bx_nr_vector_data_array is array(integer range <>) of string(1 to 4);
    type finor_vector_string_array is array(integer range <>) of string(1 to 1);
    type finor_vector_data_array is array(integer range <>) of std_logic_vector(3 downto 0);

    constant SIM_MODE : boolean := true; -- if SIM_MODE = true, "algo_bx_mask" by default = 1.
--     constant FDL_OUT_MEZZ_2_TCDS : boolean := true; -- if FDL_OUT_MEZZ_2_TCDS = true, "local_finor_with_veto" send to LEMO on mezzanine for TCDS.
    constant FDL_OUT_MEZZ_2_TCDS : boolean := false; -- if FDL_OUT_MEZZ_2_TCDS = true, "local_finor_with_veto" send to LEMO on mezzanine for TCDS.

    constant CLK40_PERIOD  : time :=  24 ns; -- LHC_CLK_PERIOD
    constant CLK160_PERIOD  : time :=  6 ns;
    constant OFFSET_CLK80_PLL  : time :=  1200 ns;
    constant OFFSET_LHC_DATA  : time :=  7 ns;

    constant LHC_BUNCH_COUNT: integer := 3564;

    signal clk160 : std_logic;
    signal lhc_clk : std_logic;

    signal lhc_data : lhc_data_t := LHC_DATA_NULL;
    signal gtl_data : gtl_data_record;
    signal algo : std_logic_vector(NR_ALGOS-1 downto 0);
    signal algo_after_prescaler_rop : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal local_finor_with_veto : std_logic;

    signal stop : boolean := false;

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
        variable temp_counter : integer := 0;
        variable index : integer := 0;

        file testvector_file : text open read_mode is "./axo_v5_score_test/L1Menu_Collisions2025_v1_0_0_TestVector_ttBar_000.txt";

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
            bx_nr_vector_data(temp_counter) := l(bx_beg to bx_end); -- bx nr
            testdata(temp_counter) := string_to_lhc_data_t(l(data_beg to data_end)); -- without bx_nr, algos and finor
            temp_counter := temp_counter + 1;
        end loop;

        wait for CLK40_PERIOD;
        for i in 0 to LHC_BUNCH_COUNT-1 loop
            lhc_data <= testdata(i);
            wait for CLK40_PERIOD;
        end loop;

--        lhc_data <= testdata(5);
--        wait for CLK40_PERIOD;
--        lhc_data <= testdata(0);

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
            algo
        );

end rtl;

