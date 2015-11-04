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
---Description: Mux
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/tdf_mp7/trunk/src/tdf_mp7_core/mux/mux.vhd $
-- $Date: 2014-11-17 18:19:16 +0100 (Mon, 17 Nov 2014) $
-- $Author: wittmann $
-- $Revision: 3435 $

-- JW 2015-11-04: included local veto and finor, included prescale_factor_set_index in readout

library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;
use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.mp7_ttc_decl.all;

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
        bx_nr_fdl   : in std_logic_vector(11 downto 0);
        --ttc_bx_cntr : in std_logic_vector(11 downto 0);
        algo_in_1   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_in_2   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_in_3   : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
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


    -- algo_before_prescaler 0-191 mux
    s_in0_mux0   <=     (algo_in_1(31 downto 0), sValid, start, strobe);
    s_in1_mux0   <=     (algo_in_1(63 downto 32), sValid, start, strobe);
    s_in2_mux0   <=    	(algo_in_1(95 downto 64), sValid, start, strobe);
    s_in3_mux0   <=     (algo_in_1(127 downto 96), sValid, start, strobe);
    s_in4_mux0   <=     (algo_in_1(159 downto 128), sValid, start, strobe);
    s_in5_mux0   <=    	(algo_in_1(191 downto 160), sValid, start, strobe);

    mux0_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux0,   -- frame 0   -> algo_before_prescaler 0-31
            in1     =>  s_in1_mux0,   -- frame 1   -> algo_before_prescaler 32-63
            in2     =>  s_in2_mux0,   -- frame 2   -> algo_before_prescaler 64-95
            in3     =>  s_in3_mux0,   -- frame 3   -> algo_before_prescaler 96-127
            in4     =>  s_in4_mux0,   -- frame 4   -> algo_before_prescaler 128-159
            in5     =>  s_in5_mux0,   -- frame 5   -> algo_before_prescaler 160-191
            mux_out =>  lane_out(16)
        );


    -- algo_before_prescaler 192-383 mux
    s_in0_mux1   <=    (algo_in_1(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_before_prescaler 192-223
    s_in1_mux1   <=    (algo_in_1(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_before_prescaler 224-255
    s_in2_mux1   <=    (algo_in_1(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_before_prescaler 256-287
    s_in3_mux1   <=    (algo_in_1(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_before_prescaler 288-319
    s_in4_mux1   <=    (algo_in_1(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_before_prescaler 320-351
    s_in5_mux1   <=    (algo_in_1(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_before_prescaler 352-383

   mux1_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux1,    -- frame 0   -> algo_before_prescaler 192-223
            in1     =>  s_in1_mux1,    -- frame 1   -> algo_before_prescaler 224-255
            in2     =>  s_in2_mux1,    -- frame 2   -> algo_before_prescaler 256-287
            in3     =>  s_in3_mux1,    -- frame 3   -> algo_before_prescaler 288-319
            in4     =>  s_in4_mux1,    -- frame 4   -> algo_before_prescaler 320-351
            in5     =>  s_in5_mux1,    -- frame 5   -> algo_before_prescaler 352-383
            mux_out =>  lane_out(17)
        );


    -- algo_before_prescaler 384-511 + finor mux
    s_in0_mux2   <=   (algo_in_1(415 downto 384), sValid, start, strobe);    -- frame 0   -> algo_before_prescaler 384-415
    s_in1_mux2   <=   (algo_in_1(447 downto 416), sValid, start, strobe);    -- frame 1   -> algo_before_prescaler 416-447
    s_in2_mux2   <=   (algo_in_1(479 downto 448), sValid, start, strobe);    -- frame 2   -> algo_before_prescaler 448-479
    s_in3_mux2   <=   (algo_in_1(511 downto 480), sValid, start, strobe);    -- frame 3   -> algo_before_prescaler 480-511
    s_in4_mux2   <=   ((others => '0'), sValid, start, strobe);            -- frame 4   -> free
    s_in5_mux2   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free

  mux2_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux2,    -- frame 0   -> algo_before_prescaler 384-415
            in1     =>  s_in1_mux2,    -- frame 1   -> algo_before_prescaler 416-447
            in2     =>  s_in2_mux2,    -- frame 2   -> algo_before_prescaler 448-479
            in3     =>  s_in3_mux2,    -- frame 3   -> algo_before_prescaler 480-511
            in4     =>  s_in4_mux2,    -- frame 4  -> free
            in5     =>  s_in5_mux2,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(18)
        );


    -- algo_after_prescaler 0-191 mux
    s_in0_mux3   <=     (algo_in_2(31 downto 0), sValid, start, strobe);
    s_in1_mux3   <=     (algo_in_2(63 downto 32), sValid, start, strobe);
    s_in2_mux3   <=     (algo_in_2(95 downto 64), sValid, start, strobe);
    s_in3_mux3   <=     (algo_in_2(127 downto 96), sValid, start, strobe);
    s_in4_mux3   <=     (algo_in_2(159 downto 128), sValid, start, strobe);
    s_in5_mux3   <=     (algo_in_2(191 downto 160), sValid, start, strobe);

    mux3_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(4).ttc_cmd(0), --bcres for quad 4
            in0     =>  s_in0_mux3,   -- frame 0   -> algo_after_prescaler 0-31
            in1     =>  s_in1_mux3,   -- frame 1   -> algo_after_prescaler 32-63
            in2     =>  s_in2_mux3,   -- frame 2   -> algo_after_prescaler 64-95
            in3     =>  s_in3_mux3,   -- frame 3   -> algo_after_prescaler 96-127
            in4     =>  s_in4_mux3,   -- frame 4   -> algo_after_prescaler 128-159
            in5     =>  s_in5_mux3,   -- frame 5   -> algo_after_prescaler 160-191
            mux_out =>  lane_out(19)
        );


    -- algo_after_prescaler 192-383 mux
    s_in0_mux4   <=    (algo_in_2(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_after_prescaler 192-223
    s_in1_mux4   <=    (algo_in_2(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_after_prescaler 224-255
    s_in2_mux4   <=    (algo_in_2(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_after_prescaler 256-287
    s_in3_mux4   <=    (algo_in_2(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_after_prescaler 288-319
    s_in4_mux4   <=    (algo_in_2(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_after_prescaler 320-351
    s_in5_mux4   <=    (algo_in_2(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_after_prescaler 352-383

   mux4_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux4,    -- frame 0   -> algo_after_prescaler 192-223
            in1     =>  s_in1_mux4,    -- frame 1   -> algo_after_prescaler 224-255
            in2     =>  s_in2_mux4,    -- frame 2   -> algo_after_prescaler 256-287
            in3     =>  s_in3_mux4,    -- frame 3   -> algo_after_prescaler 288-319
            in4     =>  s_in4_mux4,    -- frame 4   -> algo_after_prescaler 320-351
            in5     =>  s_in5_mux4,    -- frame 5   -> algo_after_prescaler 352-383
            mux_out =>  lane_out(20)
        );


    -- algo_after_prescaler 384-511 + finor mux
    s_in0_mux5   <=   (algo_in_2(415 downto 384), sValid, start, strobe);    -- frame 0   -> algo_after_prescaler 384-415
    s_in1_mux5   <=   (algo_in_2(447 downto 416), sValid, start, strobe);    -- frame 1   -> algo_after_prescaler 416-447
    s_in2_mux5   <=   (algo_in_2(479 downto 448), sValid, start, strobe);    -- frame 2   -> algo_after_prescaler 448-479
    s_in3_mux5   <=   (algo_in_2(511 downto 480), sValid, start, strobe);    -- frame 3   -> algo_after_prescaler 480-511
    s_in4_mux5   <=   ((others => '0'), sValid, start, strobe);              -- frame 4   -> free
    s_in5_mux5   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free

  mux5_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux5,    -- frame 0   -> algo_after_prescaler 384-415
            in1     =>  s_in1_mux5,    -- frame 1   -> algo_after_prescaler 416-447
            in2     =>  s_in2_mux5,    -- frame 2   -> algo_after_prescaler 448-479
            in3     =>  s_in3_mux5,    -- frame 3   -> algo_after_prescaler 480-511
            in4     =>  s_in4_mux5,    -- frame 4  -> free
            in5     =>  s_in5_mux5,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(21)
        );


    -- algo_after_finor_mask 0-191 mux
    s_in0_mux6   <=     (algo_in_3(31 downto 0), sValid, start, strobe);
    s_in1_mux6   <=     (algo_in_3(63 downto 32), sValid, start, strobe);
    s_in2_mux6   <=     (algo_in_3(95 downto 64), sValid, start, strobe);
    s_in3_mux6   <=     (algo_in_3(127 downto 96), sValid, start, strobe);
    s_in4_mux6   <=     (algo_in_3(159 downto 128), sValid, start, strobe);
    s_in5_mux6   <=     (algo_in_3(191 downto 160), sValid, start, strobe);

    mux6_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux6,   -- frame 0   -> algo_after_finor_mask 0-31
            in1     =>  s_in1_mux6,   -- frame 1   -> algo_after_finor_mask 32-63
            in2     =>  s_in2_mux6,   -- frame 2   -> algo_after_finor_mask 64-95
            in3     =>  s_in3_mux6,   -- frame 3   -> algo_after_finor_mask 96-127
            in4     =>  s_in4_mux6,   -- frame 4   -> algo_after_finor_mask 128-159
            in5     =>  s_in5_mux6,   -- frame 5   -> algo_after_finor_mask 160-191
            mux_out =>  lane_out(22)
        );


    -- algo_after_finor_mask 192-383 mux
    s_in0_mux7   <=    (algo_in_3(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo_after_finor_mask 192-223
    s_in1_mux7   <=    (algo_in_3(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo_after_finor_mask 224-255
    s_in2_mux7   <=    (algo_in_3(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo_after_finor_mask 256-287
    s_in3_mux7   <=    (algo_in_3(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo_after_finor_mask 288-319
    s_in4_mux7   <=    (algo_in_3(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo_after_finor_mask 320-351
    s_in5_mux7   <=    (algo_in_3(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo_after_finor_mask 352-383

   mux7_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(5).ttc_cmd(0), --bcres for quad 5
            in0     =>  s_in0_mux7,    -- frame 0   -> algo_after_finor_mask 192-223
            in1     =>  s_in1_mux7,    -- frame 1   -> algo_after_finor_mask 224-255
            in2     =>  s_in2_mux7,    -- frame 2   -> algo_after_finor_mask 256-287
            in3     =>  s_in3_mux7,    -- frame 3   -> algo_after_finor_mask 288-319
            in4     =>  s_in4_mux7,    -- frame 4   -> algo_after_finor_mask 320-351
            in5     =>  s_in5_mux7,    -- frame 5   -> algo_after_finor_mask 352-383
            mux_out =>  lane_out(23)
        );


    -- algo_after_finor_mask 384-511 + finor mux
    readout_finor <=  "000000000000000" & local_finor_veto_in & "0000000" & local_veto_in & "0000000" & local_finor_in; -- local finor, veto and combination
    s_in0_mux8   <=   (algo_in_3(415 downto 384), sValid, start, strobe);    -- frame 0   -> algo_after_finor_mask 384-415
    s_in1_mux8   <=   (algo_in_3(447 downto 416), sValid, start, strobe);    -- frame 1   -> algo_after_finor_mask 416-447
    s_in2_mux8   <=   (algo_in_3(479 downto 448), sValid, start, strobe);    -- frame 2   -> algo_after_finor_mask 448-479
    s_in3_mux8   <=   (algo_in_3(511 downto 480), sValid, start, strobe);    -- frame 3   -> algo_after_finor_mask 480-511
    s_in4_mux8   <=   (readout_finor, sValid, start, strobe);     -- frame 4   -> finor
    s_in5_mux8   <=   (X"000000" & prescale_factor, sValid, start, strobe);            -- frame 5   -> free

  mux8_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(6).ttc_cmd(0), --bcres for quad 6
            in0     =>  s_in0_mux8,    -- frame 0   -> algo_after_finor_mask 384-415
            in1     =>  s_in1_mux8,    -- frame 1   -> algo_after_finor_mask 416-447
            in2     =>  s_in2_mux8,    -- frame 2   -> algo_after_finor_mask 448-479
            in3     =>  s_in3_mux8,    -- frame 3   -> algo_after_finor_mask 480-511
            in4     =>  s_in4_mux8,    -- frame 4  -> finor
            in5     =>  s_in5_mux8,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(24)
        );


    -- JW 2015-08-24: added local and mp7 bc_cntr to output
    -- bc cntr output

    s_in0_mux9   <=   (X"00000" & bx_nr, sValid, start, strobe);           -- frame 0   -> frame bx_nr
    s_in1_mux9   <=   (X"00000" & ctrs(6).bctr, sValid, start, strobe);    -- frame 1   -> mp7 ttc bc cntr for Quad 6!
    s_in2_mux9   <=   (X"00000" & bx_nr_fdl, sValid, start, strobe);       -- frame 5   -> frame bx_nr_fdl
    s_in3_mux9   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free
    s_in4_mux9   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free
    s_in5_mux9   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free

  mux9_i: entity work.mux
        port map(
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(6).ttc_cmd(0), --bcres for quad 6
            in0     =>  s_in0_mux9,    -- frame 0   -> bx_nr
            in1     =>  s_in1_mux9,    -- frame 1   -> mp7 ttc bc cntr
            in2     =>  s_in2_mux9,    -- frame 2   -> bx_nr_fdl
            in3     =>  s_in3_mux9,    -- frame 3   -> free
            in4     =>  s_in4_mux9,    -- frame 4  -> free
            in5     =>  s_in5_mux9,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(25)
        );

end architecture;



