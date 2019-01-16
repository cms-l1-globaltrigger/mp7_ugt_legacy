
-- Desription:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library std;                  -- for Printing
use std.textio.all;

use work.txt_util.all;

use work.ipbus.all;
use work.ipbus_trans_decl.all;
use work.mp7_data_types.all;

use work.lhc_data_pkg.all;
use work.lhc_data_debug_util_pkg.all;

use work.gt_mp7_core_pkg.all;

use work.gtl_pkg.all;

entity gtl_fdl_wrapper_TB is
end gtl_fdl_wrapper_TB;

architecture rtl of gtl_fdl_wrapper_TB is

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
        variable algo_vector_string : algo_vector_string_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable algo_vector_data : algo_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable bx_nr_vector_data : bx_nr_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable finor_vector_string : finor_vector_string_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable finor_vector_data : finor_vector_data_array(0 to LHC_BUNCH_COUNT-1) := (others => (others => '0'));
        variable temp_counter : integer := 0;
        variable algo_error_cnt : integer := 0;
        variable finor_error_cnt : integer := 0;
        variable index : integer := 0;

        type algo_occur_array is array(integer range <>) of integer;
        variable algo_after_prescaler_rop_occur : algo_occur_array(MAX_NR_ALGOS-1 downto 0) := (others => 0);
        variable algo_vector_data_occur : algo_occur_array(MAX_NR_ALGOS-1 downto 0) := (others => 0);
        variable diff_occur, algo_mismatch : integer := 0;

        file testvector_file : text open read_mode is "{{TESTVECTOR_FILENAME}}";
        file error_file : text open write_mode is "{{RESULTS_FILE}}";

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

        write(write_l, string'("{"));
        writeline(error_file, write_l);
        write(write_l, string'("  ""errors"": ["));
        writeline(error_file, write_l);
        report "**********************************************************************************************************************************************************************************";
        report "******************************************************************** ERROR LISTING ***********************************************************************************************";
        report "**********************************************************************************************************************************************************************************";

        for i in 0 to LHC_BUNCH_COUNT+GTL_FDL_LATENCY-1 loop
            if i < LHC_BUNCH_COUNT then
                lhc_data <= testdata(i);
            end if;
            if i >= GTL_FDL_LATENCY then
                for j in 0 to MAX_NR_ALGOS-1 loop
                    if algo_after_prescaler_rop(j) = '1' then
                        algo_after_prescaler_rop_occur(j) := algo_after_prescaler_rop_occur(j) + 1;
                    end if;
                    if algo_vector_data(i - GTL_FDL_LATENCY)(j) = '1' then
                        algo_vector_data_occur(j) := algo_vector_data_occur(j) + 1;
                    end if;
                end loop;
                if (algo_after_prescaler_rop /= algo_vector_data(i - GTL_FDL_LATENCY)) or (local_finor_with_veto /= finor_vector_data(i - GTL_FDL_LATENCY)(0)) then
                    -- JSON workaround: closing previous block with comma
                    if algo_error_cnt > 0 then
                        write(write_l, string'("    },"));
                        writeline(error_file, write_l);
                    end if;
                    algo_error_cnt := algo_error_cnt + 1;
                    finor_error_cnt := finor_error_cnt + 1;

                    write(write_l, string'("    {"));
                    writeline(error_file, write_l);
                    write(write_l, string'("      ""bx-nr"": " & integer'image(i - GTL_FDL_LATENCY) & ","));
                    writeline(error_file, write_l);
                    write(write_l, string'("      ""algos_tv"":  ""0x" & hstr(algo_vector_data(i - GTL_FDL_LATENCY)) & ""","));
                    writeline(error_file, write_l);
                    write(write_l, string'("      ""algos_sim"": ""0x" & hstr(algo_after_prescaler_rop) & ""","));
                    writeline(error_file, write_l);
                    report "***************************************************************************************************************************************************";
                    report "Error @ bx-nr: " & bx_nr_vector_data(i - GTL_FDL_LATENCY) & " => ALGO Error - Algos not as expected!!!" severity error;
                    report "Algos test vector: " & hstr(algo_vector_data(i - GTL_FDL_LATENCY));
                    report "Algos simulation:  " & hstr(algo_after_prescaler_rop);
                    write(write_l, string'("      ""finor_tv"":  " & finor_vector_string(i - GTL_FDL_LATENCY) & ","));
                    writeline(error_file, write_l);
                    write(write_l, string'("      ""finor_sim"": " & str(local_finor_with_veto)));
                    writeline(error_file, write_l);
                    report "***************************************************************************************************************************************************";
                    report "Error @ bx-nr: " & bx_nr_vector_data(i - GTL_FDL_LATENCY) & " => FINOR Error - Finor not as expected!!!" severity error;
                    report "Finor test vector: " & finor_vector_string(i - GTL_FDL_LATENCY);
                    report "Finor simulation:  " & str(local_finor_with_veto);

                    for j in 0 to MAX_NR_ALGOS-1 loop
                        index := index + 1;
                        if algo_after_prescaler_rop(j) /= algo_vector_data(i - GTL_FDL_LATENCY)(j) then
                            report "Algo mismatch @ bit: " & str(j);
                        end if;
                    end loop;
                end if;

            end if;
            wait for CLK40_PERIOD;
        end loop;

        -- JSON workaround: closing last block without comma
        if algo_error_cnt > 0 then
            write(write_l, string'("    }"));
            writeline(error_file, write_l);
        end if;

        if algo_error_cnt = 0 then
            report "***************************************************************************************************************************************************";
            report "Success! No Algorithm errors.";
        else
            report "***************************************************************************************************************************************************";
            report "Total BX with Algo errors: " & str(algo_error_cnt);
        end if;

        if finor_error_cnt = 0 then
            report "***************************************************************************************************************************************************";
            report "Success! No FINOR errors.";
        else
            report "***************************************************************************************************************************************************";
            report "Total BX with FINOR errors: " & str(finor_error_cnt);
        end if;

        report "***************************************************************************************************************************************************";
        report " Algo bits mismatched: ";
        report " Bit | FW | TV | DIFF ";

        for j in 0 to MAX_NR_ALGOS-1 loop
            diff_occur := algo_after_prescaler_rop_occur(j) - algo_vector_data_occur(j);
            if diff_occur /= 0 then
                algo_mismatch := algo_mismatch + 1;
                report " " & str(j) & " | " & str(algo_after_prescaler_rop_occur(j)) & " | " & str(algo_vector_data_occur(j)) & " | " & str(diff_occur);
            end if;
        end loop;

        report "Number of mismatched algo bits: " & str(algo_mismatch);

        write(write_l, string'("  ],"));
        writeline(error_file, write_l);
        write(write_l, string'("  ""counts"": ["));
        writeline(error_file, write_l);
        report "***************************************************************************************************************************************************";
        report " Algo bits statistic [all algos]:";
        report " Bit | FW | TV | DIFF ";

        for j in 0 to MAX_NR_ALGOS-1 loop
            if j < MAX_NR_ALGOS-1 then
                write(write_l, string'("    {""algo_index"": "& str(j) & ", ""algo_tv"": " & str(algo_vector_data_occur(j)) & ", ""algo_sim"": "& str(algo_after_prescaler_rop_occur(j)) &"},"));
                writeline(error_file, write_l);
            else
                write(write_l, string'("    {""algo_index"": "& str(j) & ", ""algo_tv"": " & str(algo_vector_data_occur(j)) & ", ""algo_sim"": "& str(algo_after_prescaler_rop_occur(j)) &"}"));
                writeline(error_file, write_l);
            end if;
            diff_occur := algo_after_prescaler_rop_occur(j) - algo_vector_data_occur(j);
            report " " & str(j) & " | " & str(algo_after_prescaler_rop_occur(j)) & " | " & str(algo_vector_data_occur(j)) & " | " & str(diff_occur);
        end loop;

        write(write_l, string'("  ]"));
        writeline(error_file, write_l);
        write(write_l, string'("}"));
        writeline(error_file, write_l);

        wait for 100 us;
        stop <= true; --stop orbit signal generation
        wait;

    end process;

 ------------------- Instantiate  modules  -----------------

dut : entity work.gtl_fdl_wrapper
    generic map(
        SIM_MODE => SIM_MODE
    )
    port map
    (
        ipb_clk            => '0',
        ipb_rst            => '0',
        ipb_in             => IPB_WBUS_NULL,
        ipb_out            => open,
        lhc_clk            => lhc_clk,
        lhc_rst            => '0',
        lhc_data           => lhc_data,
        bcres              => '0',
        test_en            => '0',
        l1a                => '0',
        begin_lumi_section => '0',
        prescale_factor_set_index_rop => open,
        algo_after_gtLogic_rop => open,
        algo_after_bxomask_rop => open,
        algo_after_prescaler_rop  => algo_after_prescaler_rop,
        local_finor_rop => open,
        local_veto_rop  => open,
        finor_2_mezz_lemo  => open,
        finor_preview_2_mezz_lemo  => open,
        veto_2_mezz_lemo  => open,
        finor_w_veto_2_mezz_lemo  => open,
        local_finor_with_veto_o  => local_finor_with_veto
    );

end rtl;
