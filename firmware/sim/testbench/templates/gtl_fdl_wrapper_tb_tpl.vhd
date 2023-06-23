
-- Description:
-- Testbench for simulation of gtl_data_mapping, gtl_module and fdl_module

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

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
use work.fdl_pkg.all;

entity gtl_fdl_wrapper_TB is
end gtl_fdl_wrapper_TB;

architecture rtl of gtl_fdl_wrapper_TB is

-- ***************************************************************
-- TV data structure
    constant bx_str_w : positive := 4;
    constant muon_str_w : positive := 16*8+8; -- 8 obj 64 bits (16 hex digits) + 8 blancs
    constant calo_str_w : positive := 8*48+48; -- 48 obj 32 bits (8 hex digits) + 48 blancs
    constant ext_cond_str_w : positive := 64+1; -- 256 bits (64 hex digits) + 1 blanc
    constant cicada_str_w : positive := 8*6+5; -- 6 obj 32 bits (8 hex digits) + 5 blancs
    constant data_str_w : positive := muon_str_w+calo_str_w+ext_cond_str_w+cicada_str_w;
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
            bx_nr_vector_data(temp_counter) := l(bx_beg to bx_end); -- bx nr
            testdata(temp_counter) := string_to_lhc_data_t(l(data_beg to data_end)); -- without bx_nr, algos and finor
            algo_vector_string(temp_counter) := l(algo_beg to algo_end); -- algo strings
            algo_vector_data(temp_counter) := str_to_slv(l(algo_beg to algo_end)); -- algos
            finor_vector_data(temp_counter) := str_to_slv(l(finor_beg to finor_beg)); -- finor
            finor_vector_string(temp_counter) := l(finor_beg to finor_beg); -- finor string
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
        write(write_l, string'("  ""algo_error_count"": ["& str(algo_error_cnt) &"],"));
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

    fdl_module_i: entity work.fdl_module
        generic map(
            SIM_MODE => SIM_MODE,
            PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT,
            MASKS_INIT => MASKS_INIT
        )
        port map(
            ipb_clk => '0',
            ipb_rst => '0',
            ipb_in => IPB_WBUS_NULL,
            ipb_out => open,
            lhc_clk => lhc_clk,
            lhc_rst => '0',
            bcres => '0',
            test_en => '0',
            start => '0',
            l1a => '0',
            begin_lumi_section => '0',
            algo_i => algo,
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
            local_finor_with_veto_o  => local_finor_with_veto,
            algo_bx_mask_sim => (others => '1')
        );

end rtl;
