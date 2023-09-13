
-- Description:
-- Multiplexer for read-out record data.

-- Version-history:
-- HB 2023-09-08: changed type (lword_array) of port in_mux of mux.vhd.
-- HB 2023-06-07: added 5G outputs on links 68-71 for loopback tests in output_mux.vhd.
-- HB 2023-03-07: used Tx links 28-31 for scouting.
-- HB 2022-09-06: cleaned up.
-- HB 2022-03-22: Port bx_nr_fdl removed, contains same data as bx_nr (because bcres_d and bcres_d_FDL are the same signal: delayed bc0 [bc0_d_int in frame.vhd]).
-- HB 2021-06-16: implemented selectors and orbit counter to quad 6 for "scouting".
-- HB 2021-05-14: added fdl_pkg use clause.
-- HB 2016-09-16: inserted for L1TM_UID_HASH and FW_UID_HASH
-- HB 2016-09-16: changed port names for algos for new read-out record structure (see proposal "https://twiki.cern.ch/twiki/bin/view/CMS/UGT_readout_proposal")
-- JW 2015-11-04: included local veto and finor, included prescale_factor_set_index in readout

library ieee;
use IEEE.std_logic_1164.all;

use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.mp7_ttc_decl.all;

use work.fdl_pkg.all;
use work.gtl_pkg.all;

entity output_mux is
    generic(
        NR_LANES: positive
    );
    port
    (
        lhc_clk     : in std_logic;
        lhc_rst     : in std_logic;
        clk240      : in std_logic;
        ctrs        : in ttc_stuff_array; --mp7 ttc ctrs
        bx_nr       : in std_logic_vector(11 downto 0);
        orbit_nr    : in orbit_nr_t;
        lmp_lhc_data         : in lhc_data_t;
        algo_after_gtlogic   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_in      : in std_logic;
        local_veto_in       : in std_logic;
        local_finor_veto_in : in std_logic;
        prescale_factor     : in std_logic_vector(7 downto 0);
        valid_lo    : in std_logic_vector(15 downto 0);
        valid_hi    : in std_logic_vector(15 downto 0);
        start       : in std_logic;
        strobe      : in std_logic;
        lane_out    : out ldata(NR_LANES-1 downto 0)
    );
end output_mux;

architecture arch of output_mux is

    signal sValid : std_logic := '0';

    signal readout_finor : std_logic_vector(31 downto 0);
    
    signal s_in_mux0,s_in_mux1,s_in_mux2,s_in_mux3,s_in_mux4,s_in_mux5,s_in_mux6,s_in_mux7,s_in_mux8,s_in_mux9 : lword_array;
    signal s_in_mux20,s_in_mux21,s_in_mux22,s_in_mux23 : lword_array;

begin

    -- set sValid process
    p_sValid: process (lhc_clk, bx_nr, valid_lo, valid_hi)
    begin
        if (lhc_clk'event and lhc_clk = '1') then -- shift range for one bx? because of possible 1bx delay
           if ((bx_nr >= valid_lo) and (bx_nr <= valid_hi)) then --define range
              sValid <= '0';
           else
              sValid <= '1';
           end if;
        end if;
--      end if;
    end process p_sValid;

    -- algo_after_gtlogic 0-191 mux
    s_in_mux0 <= ((algo_after_gtlogic(31 downto 0), sValid, start, strobe),
                 (algo_after_gtlogic(63 downto 32), sValid, start, strobe),
                 (algo_after_gtlogic(95 downto 64), sValid, start, strobe),
                 (algo_after_gtlogic(127 downto 96), sValid, start, strobe),
                 (algo_after_gtlogic(159 downto 128), sValid, start, strobe),
                 (algo_after_gtlogic(191 downto 160), sValid, start, strobe));

    mux0_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(4).ttc_cmd(0), --bcres for quad 4
            in_mux  => s_in_mux0,
            mux_out => lane_out(16)
        );

-- HB 2023-03-07: used link 28 for scouting.
    mux10_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(7).ttc_cmd(0), --bcres for quad 7
            in_mux  => s_in_mux0,
            mux_out => lane_out(28)
        );

    -- algo_after_gtlogic 192-383 mux
    s_in_mux1 <= ((algo_after_gtlogic(223 downto 192), sValid, start, strobe),
                 (algo_after_gtlogic(255 downto 224), sValid, start, strobe),
                 (algo_after_gtlogic(287 downto 256), sValid, start, strobe),
                 (algo_after_gtlogic(319 downto 288), sValid, start, strobe),
                 (algo_after_gtlogic(351 downto 320), sValid, start, strobe),
                 (algo_after_gtlogic(383 downto 352), sValid, start, strobe));

    mux1_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(4).ttc_cmd(0), --bcres for quad 4
            in_mux  => s_in_mux1,
            mux_out => lane_out(17)
        );

-- HB 2023-03-07: used link 29 for scouting.
    mux11_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(7).ttc_cmd(0), --bcres for quad 7
            in_mux  => s_in_mux1,
            mux_out => lane_out(29)
        );

    -- algo_after_gtlogic 384-511 + finor mux
    s_in_mux2 <= ((algo_after_gtlogic(415 downto 384), sValid, start, strobe),
                 (algo_after_gtlogic(447 downto 416), sValid, start, strobe),
                 (algo_after_gtlogic(479 downto 448), sValid, start, strobe),
                 (algo_after_gtlogic(511 downto 480), sValid, start, strobe),
                 (L1TM_UID_HASH, sValid, start, strobe),                     
                 (FW_UID_HASH, sValid, start, strobe));                       

    mux2_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(4).ttc_cmd(0), --bcres for quad 4
            in_mux  => s_in_mux2,
            mux_out => lane_out(18)
        );

-- HB 2023-03-07: used link 30 for scouting.
    mux12_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(7).ttc_cmd(0), --bcres for quad 7
            in_mux  => s_in_mux2,
            mux_out => lane_out(30)
        );

    -- algo_after_bxomask 0-191 mux
    s_in_mux3 <= ((algo_after_bxomask(31 downto 0), sValid, start, strobe),
                 (algo_after_bxomask(63 downto 32), sValid, start, strobe),
                 (algo_after_bxomask(95 downto 64), sValid, start, strobe),
                 (algo_after_bxomask(127 downto 96), sValid, start, strobe),
                 (algo_after_bxomask(159 downto 128), sValid, start, strobe),
                 (algo_after_bxomask(191 downto 160), sValid, start, strobe));

    mux3_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(4).ttc_cmd(0), --bcres for quad 4
            in_mux  => s_in_mux3,
            mux_out => lane_out(19)
        );


    -- algo_after_bxomask 192-383 mux
    s_in_mux4 <= ((algo_after_bxomask(223 downto 192), sValid, start, strobe),
                 (algo_after_bxomask(255 downto 224), sValid, start, strobe),
                 (algo_after_bxomask(287 downto 256), sValid, start, strobe),
                 (algo_after_bxomask(319 downto 288), sValid, start, strobe),
                 (algo_after_bxomask(351 downto 320), sValid, start, strobe),
                 (algo_after_bxomask(383 downto 352), sValid, start, strobe));

    mux4_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(5).ttc_cmd(0), --bcres for quad 5
            in_mux  => s_in_mux4,
            mux_out => lane_out(20)
        );


    -- algo_after_bxomask 384-511 + finor mux
    s_in_mux5 <= ((algo_after_bxomask(415 downto 384), sValid, start, strobe),    
                 (algo_after_bxomask(447 downto 416), sValid, start, strobe),
                 (algo_after_bxomask(479 downto 448), sValid, start, strobe),
                 (algo_after_bxomask(511 downto 480), sValid, start, strobe),
                 ((others => '0'), sValid, start, strobe),                   
                 ((others => '0'), sValid, start, strobe));                   

    mux5_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(5).ttc_cmd(0), --bcres for quad 5
            in_mux  => s_in_mux5,
            mux_out => lane_out(21)
        );


    -- algo_after_prescaler_mask 0-191 mux
    s_in_mux6 <= ((algo_after_prescaler(31 downto 0), sValid, start, strobe),
                  (algo_after_prescaler(63 downto 32), sValid, start, strobe),
                  (algo_after_prescaler(95 downto 64), sValid, start, strobe),
                  (algo_after_prescaler(127 downto 96), sValid, start, strobe),
                  (algo_after_prescaler(159 downto 128), sValid, start, strobe),
                  (algo_after_prescaler(191 downto 160), sValid, start, strobe));

    mux6_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(5).ttc_cmd(0), --bcres for quad 5
            in_mux  => s_in_mux6,
            mux_out => lane_out(22)
        );


    -- algo_after_prescaler_mask 192-383 mux
    s_in_mux7 <= ((algo_after_prescaler(223 downto 192), sValid, start, strobe),
                  (algo_after_prescaler(255 downto 224), sValid, start, strobe),
                  (algo_after_prescaler(287 downto 256), sValid, start, strobe),
                  (algo_after_prescaler(319 downto 288), sValid, start, strobe),
                  (algo_after_prescaler(351 downto 320), sValid, start, strobe),
                  (algo_after_prescaler(383 downto 352), sValid, start, strobe));

    mux7_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(5).ttc_cmd(0), --bcres for quad 5
            in_mux  => s_in_mux7,
            mux_out => lane_out(23)
        );


    -- algo_after_prescaler_mask 384-511 + finor mux
    readout_finor <=  "000000000000000" & local_finor_veto_in & "0000000" & local_veto_in & "0000000" & local_finor_in;
    s_in_mux8 <= ((algo_after_prescaler(415 downto 384), sValid, start, strobe),
                  (algo_after_prescaler(447 downto 416), sValid, start, strobe),
                  (algo_after_prescaler(479 downto 448), sValid, start, strobe),
                  (algo_after_prescaler(511 downto 480), sValid, start, strobe),
                  (readout_finor, sValid, start, strobe),                       
                  (X"000000" & prescale_factor, sValid, start, strobe));         

    mux8_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(6).ttc_cmd(0), --bcres for quad 6
            in_mux  => s_in_mux8,
            mux_out => lane_out(24)
        );

    -- JW 2015-08-24: added local and mp7 bc_cntr to output
    -- bc cntr output

    s_in_mux9 <= ((X"00000" & bx_nr, sValid, start, strobe),                 
                  (X"00000" & ctrs(6).bctr, sValid, start, strobe),          
                  (X"00000" & bx_nr, sValid, start, strobe),                 
                  (X"0000" & orbit_nr(47 downto 32), sValid, start, strobe), 
                  (orbit_nr(31 downto 0), sValid, start, strobe),            
                  ((others => '0'), sValid, start, strobe));                  

    mux9_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(6).ttc_cmd(0), --bcres for quad 6
            in_mux  => s_in_mux9,
            mux_out => lane_out(25)
        );

-- HB 2023-03-07: used link 31 for scouting.
    mux13_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(7).ttc_cmd(0), --bcres for quad 7
            in_mux  => s_in_mux9,
            mux_out => lane_out(31)
        );

-- HB 2023-06-07: used link 68-71 for 5G output for loopback tests (ZDC)
    s_in_mux20 <= ((lmp_lhc_data.eg(0), sValid, start, strobe),
                  (lmp_lhc_data.eg(1), sValid, start, strobe),
                  (lmp_lhc_data.eg(2), sValid, start, strobe),
                  (lmp_lhc_data.eg(3), sValid, start, strobe),
                  (lmp_lhc_data.eg(4), sValid, start, strobe),
                  (lmp_lhc_data.eg(5), sValid, start, strobe));

    mux20_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(17).ttc_cmd(0), --bcres for quad 17
            in_mux  => s_in_mux20,
            mux_out => lane_out(68)
        );

    s_in_mux21 <= ((lmp_lhc_data.eg(6), sValid, start, strobe),
                  (lmp_lhc_data.eg(7), sValid, start, strobe),
                  (lmp_lhc_data.eg(8), sValid, start, strobe),
                  (lmp_lhc_data.eg(9), sValid, start, strobe),
                  (lmp_lhc_data.eg(10), sValid, start, strobe),
                  (lmp_lhc_data.eg(11), sValid, start, strobe));

    mux21_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(17).ttc_cmd(0), --bcres for quad 17
            in_mux  => s_in_mux21,
            mux_out => lane_out(69)
        );

    s_in_mux22 <= ((lmp_lhc_data.jet(0), sValid, start, strobe),
                  (lmp_lhc_data.jet(1), sValid, start, strobe),
                  (lmp_lhc_data.jet(2), sValid, start, strobe),
                  (lmp_lhc_data.jet(3), sValid, start, strobe),
                  (lmp_lhc_data.jet(4), sValid, start, strobe),
                  (lmp_lhc_data.jet(5), sValid, start, strobe));

    mux22_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(17).ttc_cmd(0), --bcres for quad 17
            in_mux  => s_in_mux22,
            mux_out => lane_out(70)
        );

    s_in_mux23 <= ((lmp_lhc_data.jet(6), sValid, start, strobe),
                  (lmp_lhc_data.jet(7), sValid, start, strobe),
                  (lmp_lhc_data.jet(8), sValid, start, strobe),
                  (lmp_lhc_data.jet(9), sValid, start, strobe),
                  (lmp_lhc_data.jet(10), sValid, start, strobe),
                  (lmp_lhc_data.jet(11), sValid, start, strobe));

    mux23_i: entity work.mux
        port map(
            clk     => clk240,
            res     => lhc_rst,
            bcres   => ctrs(17).ttc_cmd(0), --bcres for quad 17
            in_mux  => s_in_mux23,
            mux_out => lane_out(71)
        );
        
end architecture;
