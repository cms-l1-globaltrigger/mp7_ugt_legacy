
-- Description:
-- Multiplexer for read-out record data.

-- Version-history:
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
    signal s_in0_mux0,s_in0_mux1,s_in0_mux2,s_in0_mux3,s_in0_mux4,s_in0_mux5,s_in0_mux6,s_in0_mux7,s_in0_mux8,s_in0_mux9 : lword;
    signal s_in1_mux0,s_in1_mux1,s_in1_mux2,s_in1_mux3,s_in1_mux4,s_in1_mux5,s_in1_mux6,s_in1_mux7,s_in1_mux8,s_in1_mux9 : lword;
    signal s_in2_mux0,s_in2_mux1,s_in2_mux2,s_in2_mux3,s_in2_mux4,s_in2_mux5,s_in2_mux6,s_in2_mux7,s_in2_mux8,s_in2_mux9 : lword;
    signal s_in3_mux0,s_in3_mux1,s_in3_mux2,s_in3_mux3,s_in3_mux4,s_in3_mux5,s_in3_mux6,s_in3_mux7,s_in3_mux8,s_in3_mux9 : lword;
    signal s_in4_mux0,s_in4_mux1,s_in4_mux2,s_in4_mux3,s_in4_mux4,s_in4_mux5,s_in4_mux6,s_in4_mux7,s_in4_mux8,s_in4_mux9 : lword;
    signal s_in5_mux0,s_in5_mux1,s_in5_mux2,s_in5_mux3,s_in5_mux4,s_in5_mux5,s_in5_mux6,s_in5_mux7,s_in5_mux8,s_in5_mux9 : lword;

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
    s_in0_mux0   <=     (algo_after_gtlogic(31 downto 0), sValid, start, strobe);
    s_in1_mux0   <=     (algo_after_gtlogic(63 downto 32), sValid, start, strobe);
    s_in2_mux0   <=     (algo_after_gtlogic(95 downto 64), sValid, start, strobe);
    s_in3_mux0   <=     (algo_after_gtlogic(127 downto 96), sValid, start, strobe);
    s_in4_mux0   <=     (algo_after_gtlogic(159 downto 128), sValid, start, strobe);
    s_in5_mux0   <=     (algo_after_gtlogic(191 downto 160), sValid, start, strobe);

    mux0_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux0,   -- frame 0   -> algo_after_gtlogic 0-31
            in1     =>  s_in1_mux0,   -- frame 1   -> algo_after_gtlogic 32-63
            in2     =>  s_in2_mux0,   -- frame 2   -> algo_after_gtlogic 64-95
            in3     =>  s_in3_mux0,   -- frame 3   -> algo_after_gtlogic 96-127
            in4     =>  s_in4_mux0,   -- frame 4   -> algo_after_gtlogic 128-159
            in5     =>  s_in5_mux0,   -- frame 5   -> algo_after_gtlogic 160-191
            mux_out =>  lane_out(16)
        );

-- HB 2023-03-07: used link 28 for scouting.
    mux10_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(7).ttc_cmd(0), --bcres for quad 7
            in0     =>  s_in0_mux0,   -- frame 0   -> algo_after_gtlogic 0-31
            in1     =>  s_in1_mux0,   -- frame 1   -> algo_after_gtlogic 32-63
            in2     =>  s_in2_mux0,   -- frame 2   -> algo_after_gtlogic 64-95
            in3     =>  s_in3_mux0,   -- frame 3   -> algo_after_gtlogic 96-127
            in4     =>  s_in4_mux0,   -- frame 4   -> algo_after_gtlogic 128-159
            in5     =>  s_in5_mux0,   -- frame 5   -> algo_after_gtlogic 160-191
            mux_out =>  lane_out(28)
        );

    -- algo_after_gtlogic 192-383 mux
    s_in0_mux1   <=    (algo_after_gtlogic(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_after_gtlogic 192-223
    s_in1_mux1   <=    (algo_after_gtlogic(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_after_gtlogic 224-255
    s_in2_mux1   <=    (algo_after_gtlogic(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_after_gtlogic 256-287
    s_in3_mux1   <=    (algo_after_gtlogic(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_after_gtlogic 288-319
    s_in4_mux1   <=    (algo_after_gtlogic(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_after_gtlogic 320-351
    s_in5_mux1   <=    (algo_after_gtlogic(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_after_gtlogic 352-383

    mux1_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux1,    -- frame 0   -> algo_after_gtlogic 192-223
            in1     =>  s_in1_mux1,    -- frame 1   -> algo_after_gtlogic 224-255
            in2     =>  s_in2_mux1,    -- frame 2   -> algo_after_gtlogic 256-287
            in3     =>  s_in3_mux1,    -- frame 3   -> algo_after_gtlogic 288-319
            in4     =>  s_in4_mux1,    -- frame 4   -> algo_after_gtlogic 320-351
            in5     =>  s_in5_mux1,    -- frame 5   -> algo_after_gtlogic 352-383
            mux_out =>  lane_out(17)
        );

-- HB 2023-03-07: used link 29 for scouting.
    mux11_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(7).ttc_cmd(0), --bcres for quad 7
            in0     =>  s_in0_mux1,    -- frame 0   -> algo_after_gtlogic 192-223
            in1     =>  s_in1_mux1,    -- frame 1   -> algo_after_gtlogic 224-255
            in2     =>  s_in2_mux1,    -- frame 2   -> algo_after_gtlogic 256-287
            in3     =>  s_in3_mux1,    -- frame 3   -> algo_after_gtlogic 288-319
            in4     =>  s_in4_mux1,    -- frame 4   -> algo_after_gtlogic 320-351
            in5     =>  s_in5_mux1,    -- frame 5   -> algo_after_gtlogic 352-383
            mux_out =>  lane_out(29)
        );

    -- algo_after_gtlogic 384-511 + finor mux
    s_in0_mux2   <=   (algo_after_gtlogic(415 downto 384), sValid, start, strobe);   -- frame 0   -> algo_after_gtlogic 384-415
    s_in1_mux2   <=   (algo_after_gtlogic(447 downto 416), sValid, start, strobe);   -- frame 1   -> algo_after_gtlogic 416-447
    s_in2_mux2   <=   (algo_after_gtlogic(479 downto 448), sValid, start, strobe);   -- frame 2   -> algo_after_gtlogic 448-479
    s_in3_mux2   <=   (algo_after_gtlogic(511 downto 480), sValid, start, strobe);   -- frame 3   -> algo_after_gtlogic 480-511
    s_in4_mux2   <=   (L1TM_UID_HASH, sValid, start, strobe);                        -- frame 4   -> free
    s_in5_mux2   <=   (FW_UID_HASH, sValid, start, strobe);                          -- frame 5   -> free

    mux2_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux2,    -- frame 0   -> algo_after_gtlogic 384-415
            in1     =>  s_in1_mux2,    -- frame 1   -> algo_after_gtlogic 416-447
            in2     =>  s_in2_mux2,    -- frame 2   -> algo_after_gtlogic 448-479
            in3     =>  s_in3_mux2,    -- frame 3   -> algo_after_gtlogic 480-511
            in4     =>  s_in4_mux2,    -- frame 4   -> free
            in5     =>  s_in5_mux2,    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(18)
        );

-- HB 2023-03-07: used link 30 for scouting.
    mux12_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(7).ttc_cmd(0), --bcres for quad 7
            in0     =>  s_in0_mux2,    -- frame 0   -> algo_after_gtlogic 384-415
            in1     =>  s_in1_mux2,    -- frame 1   -> algo_after_gtlogic 416-447
            in2     =>  s_in2_mux2,    -- frame 2   -> algo_after_gtlogic 448-479
            in3     =>  s_in3_mux2,    -- frame 3   -> algo_after_gtlogic 480-511
            in4     =>  s_in4_mux2,    -- frame 4   -> free
            in5     =>  s_in5_mux2,    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(30)
        );

    -- algo_after_bxomask 0-191 mux
    s_in0_mux3   <=     (algo_after_bxomask(31 downto 0), sValid, start, strobe);
    s_in1_mux3   <=     (algo_after_bxomask(63 downto 32), sValid, start, strobe);
    s_in2_mux3   <=     (algo_after_bxomask(95 downto 64), sValid, start, strobe);
    s_in3_mux3   <=     (algo_after_bxomask(127 downto 96), sValid, start, strobe);
    s_in4_mux3   <=     (algo_after_bxomask(159 downto 128), sValid, start, strobe);
    s_in5_mux3   <=     (algo_after_bxomask(191 downto 160), sValid, start, strobe);

    mux3_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux3,   -- frame 0   -> algo_after_bxomask 0-31
            in1     =>  s_in1_mux3,   -- frame 1   -> algo_after_bxomask 32-63
            in2     =>  s_in2_mux3,   -- frame 2   -> algo_after_bxomask 64-95
            in3     =>  s_in3_mux3,   -- frame 3   -> algo_after_bxomask 96-127
            in4     =>  s_in4_mux3,   -- frame 4   -> algo_after_bxomask 128-159
            in5     =>  s_in5_mux3,   -- frame 5   -> algo_after_bxomask 160-191
            mux_out =>  lane_out(19)
        );


    -- algo_after_bxomask 192-383 mux
    s_in0_mux4   <=    (algo_after_bxomask(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_after_bxomask 192-223
    s_in1_mux4   <=    (algo_after_bxomask(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_after_bxomask 224-255
    s_in2_mux4   <=    (algo_after_bxomask(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_after_bxomask 256-287
    s_in3_mux4   <=    (algo_after_bxomask(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_after_bxomask 288-319
    s_in4_mux4   <=    (algo_after_bxomask(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_after_bxomask 320-351
    s_in5_mux4   <=    (algo_after_bxomask(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_after_bxomask 352-383

    mux4_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux4,    -- frame 0   -> algo_after_bxomask 192-223
            in1     =>  s_in1_mux4,    -- frame 1   -> algo_after_bxomask 224-255
            in2     =>  s_in2_mux4,    -- frame 2   -> algo_after_bxomask 256-287
            in3     =>  s_in3_mux4,    -- frame 3   -> algo_after_bxomask 288-319
            in4     =>  s_in4_mux4,    -- frame 4   -> algo_after_bxomask 320-351
            in5     =>  s_in5_mux4,    -- frame 5   -> algo_after_bxomask 352-383
            mux_out =>  lane_out(20)
        );


    -- algo_after_bxomask 384-511 + finor mux
    s_in0_mux5   <=   (algo_after_bxomask(415 downto 384), sValid, start, strobe);      -- frame 0   -> algo_after_bxomask 384-415
    s_in1_mux5   <=   (algo_after_bxomask(447 downto 416), sValid, start, strobe);      -- frame 1   -> algo_after_bxomask 416-447
    s_in2_mux5   <=   (algo_after_bxomask(479 downto 448), sValid, start, strobe);      -- frame 2   -> algo_after_bxomask 448-479
    s_in3_mux5   <=   (algo_after_bxomask(511 downto 480), sValid, start, strobe);      -- frame 3   -> algo_after_bxomask 480-511
    s_in4_mux5   <=   ((others => '0'), sValid, start, strobe);                         -- frame 4   -> free
    s_in5_mux5   <=   ((others => '0'), sValid, start, strobe);                         -- frame 5   -> free

    mux5_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux5,    -- frame 0   -> algo_after_bxomask 384-415
            in1     =>  s_in1_mux5,    -- frame 1   -> algo_after_bxomask 416-447
            in2     =>  s_in2_mux5,    -- frame 2   -> algo_after_bxomask 448-479
            in3     =>  s_in3_mux5,    -- frame 3   -> algo_after_bxomask 480-511
            in4     =>  s_in4_mux5,    -- frame 4   -> free
            in5     =>  s_in5_mux5,    -- frame 5   -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(21)
        );


    -- algo_after_prescaler_mask 0-191 mux
    s_in0_mux6   <=     (algo_after_prescaler(31 downto 0), sValid, start, strobe);
    s_in1_mux6   <=     (algo_after_prescaler(63 downto 32), sValid, start, strobe);
    s_in2_mux6   <=     (algo_after_prescaler(95 downto 64), sValid, start, strobe);
    s_in3_mux6   <=     (algo_after_prescaler(127 downto 96), sValid, start, strobe);
    s_in4_mux6   <=     (algo_after_prescaler(159 downto 128), sValid, start, strobe);
    s_in5_mux6   <=     (algo_after_prescaler(191 downto 160), sValid, start, strobe);

    mux6_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux6,   -- frame 0   -> algo_after_prescaler_mask 0-31
            in1     =>  s_in1_mux6,   -- frame 1   -> algo_after_prescaler_mask 32-63
            in2     =>  s_in2_mux6,   -- frame 2   -> algo_after_prescaler_mask 64-95
            in3     =>  s_in3_mux6,   -- frame 3   -> algo_after_prescaler_mask 96-127
            in4     =>  s_in4_mux6,   -- frame 4   -> algo_after_prescaler_mask 128-159
            in5     =>  s_in5_mux6,   -- frame 5   -> algo_after_prescaler_mask 160-191
            mux_out =>  lane_out(22)
        );


    -- algo_after_prescaler_mask 192-383 mux
    s_in0_mux7   <=    (algo_after_prescaler(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_after_prescaler_mask 192-223
    s_in1_mux7   <=    (algo_after_prescaler(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_after_prescaler_mask 224-255
    s_in2_mux7   <=    (algo_after_prescaler(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_after_prescaler_mask 256-287
    s_in3_mux7   <=    (algo_after_prescaler(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_after_prescaler_mask 288-319
    s_in4_mux7   <=    (algo_after_prescaler(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_after_prescaler_mask 320-351
    s_in5_mux7   <=    (algo_after_prescaler(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_after_prescaler_mask 352-383

    mux7_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux7,    -- frame 0   -> algo_after_prescaler_mask 192-223
            in1     =>  s_in1_mux7,    -- frame 1   -> algo_after_prescaler_mask 224-255
            in2     =>  s_in2_mux7,    -- frame 2   -> algo_after_prescaler_mask 256-287
            in3     =>  s_in3_mux7,    -- frame 3   -> algo_after_prescaler_mask 288-319
            in4     =>  s_in4_mux7,    -- frame 4   -> algo_after_prescaler_mask 320-351
            in5     =>  s_in5_mux7,    -- frame 5   -> algo_after_prescaler_mask 352-383
            mux_out =>  lane_out(23)
        );


    -- algo_after_prescaler_mask 384-511 + finor mux
    readout_finor <=  "000000000000000" & local_finor_veto_in & "0000000" & local_veto_in & "0000000" & local_finor_in; -- local finor, veto and combination
    s_in0_mux8   <=   (algo_after_prescaler(415 downto 384), sValid, start, strobe);    -- frame 0   -> algo_after_prescaler_mask 384-415
    s_in1_mux8   <=   (algo_after_prescaler(447 downto 416), sValid, start, strobe);    -- frame 1   -> algo_after_prescaler_mask 416-447
    s_in2_mux8   <=   (algo_after_prescaler(479 downto 448), sValid, start, strobe);    -- frame 2   -> algo_after_prescaler_mask 448-479
    s_in3_mux8   <=   (algo_after_prescaler(511 downto 480), sValid, start, strobe);    -- frame 3   -> algo_after_prescaler_mask 480-511
    s_in4_mux8   <=   (readout_finor, sValid, start, strobe);                           -- frame 4   -> finor
    s_in5_mux8   <=   (X"000000" & prescale_factor, sValid, start, strobe);            -- frame 5   -> free

    mux8_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(6).ttc_cmd(0), --bcres for quad 6
            in0     =>  s_in0_mux8,    -- frame 0   -> algo_after_prescaler_mask 384-415
            in1     =>  s_in1_mux8,    -- frame 1   -> algo_after_prescaler_mask 416-447
            in2     =>  s_in2_mux8,    -- frame 2   -> algo_after_prescaler_mask 448-479
            in3     =>  s_in3_mux8,    -- frame 3   -> algo_after_prescaler_mask 480-511
            in4     =>  s_in4_mux8,    -- frame 4   -> finor
            in5     =>  s_in5_mux8,    -- frame 5   -> free
            mux_out =>  lane_out(24)
        );

    -- JW 2015-08-24: added local and mp7 bc_cntr to output
    -- bc cntr output

    s_in0_mux9   <=   (X"00000" & bx_nr, sValid, start, strobe);                    -- frame 0   -> frame bx_nr
    s_in1_mux9   <=   (X"00000" & ctrs(6).bctr, sValid, start, strobe);             -- frame 1   -> mp7 ttc bc cntr for Quad 6!
    s_in2_mux9   <=   (X"00000" & bx_nr, sValid, start, strobe);                    -- frame 2   -> frame bx_nr (kept for same read-out structure)
    s_in3_mux9   <=   (X"0000" & orbit_nr(47 downto 32), sValid, start, strobe);    -- frame 3   -> orbit counter 47..32
    s_in4_mux9   <=   (orbit_nr(31 downto 0), sValid, start, strobe);               -- frame 4   -> orbit counter 31..0
    s_in5_mux9   <=   ((others => '0'), sValid, start, strobe);                     -- frame 5   -> free

    mux9_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(6).ttc_cmd(0), --bcres for quad 6
            in0     =>  s_in0_mux9,    -- frame 0   -> bx_nr
            in1     =>  s_in1_mux9,    -- frame 1   -> mp7 ttc bc cntr
            in2     =>  s_in2_mux9,    -- frame 2   -> bx_nr
            in3     =>  s_in3_mux9,    -- frame 3   -> orbit counter 47..32
            in4     =>  s_in4_mux9,    -- frame 4   -> orbit counter 31..0
            in5     =>  s_in5_mux9,    -- frame 5   -> free
            mux_out =>  lane_out(25)
        );

-- HB 2023-03-07: used link 31 for scouting.
    mux13_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(7).ttc_cmd(0), --bcres for quad 7
            in0     =>  s_in0_mux9,    -- frame 0   -> bx_nr
            in1     =>  s_in1_mux9,    -- frame 1   -> mp7 ttc bc cntr
            in2     =>  s_in2_mux9,    -- frame 2   -> bx_nr
            in3     =>  s_in3_mux9,    -- frame 3   -> free / orbit counter 47..32
            in4     =>  s_in4_mux9,    -- frame 4   -> free / orbit counter 31..0
            in5     =>  s_in5_mux9,    -- frame 5   -> free
            mux_out =>  lane_out(31)
        );

end architecture;
