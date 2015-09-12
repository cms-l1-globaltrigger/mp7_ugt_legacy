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
        ttc_bx_cntr : in std_logic_vector(11 downto 0);
        algo_in     : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        finor_in    : in std_logic;
        valid_lo    : in std_logic_vector(15 downto 0);
        valid_hi    : in std_logic_vector(15 downto 0);
        start       : in std_logic;
        strobe      : in std_logic;
        lane_out    : out ldata(NR_LANES-1 downto 0)
    );
end output_mux;

architecture arch of output_mux is

    signal sValid : std_logic := '0';


    signal s_in0_mux0,s_in0_mux1,s_in0_mux2,s_in0_mux3 : lword;
    signal s_in1_mux0,s_in1_mux1,s_in1_mux2,s_in1_mux3 : lword;
    signal s_in2_mux0,s_in2_mux1,s_in2_mux2,s_in2_mux3 : lword;
    signal s_in3_mux0,s_in3_mux1,s_in3_mux2,s_in3_mux3 : lword;
    signal s_in4_mux0,s_in4_mux1,s_in4_mux2,s_in4_mux3 : lword;
    signal s_in5_mux0,s_in5_mux1,s_in5_mux2,s_in5_mux3 : lword;


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



    -- algo 0-191 mux

    s_in0_mux0   <=     (algo_in(31 downto 0), sValid, start, strobe);
    s_in1_mux0   <=     (algo_in(63 downto 32), sValid, start, strobe);
    s_in2_mux0   <=    	(algo_in(95 downto 64), sValid, start, strobe);
    s_in3_mux0   <=     (algo_in(127 downto 96), sValid, start, strobe);
    s_in4_mux0   <=     (algo_in(159 downto 128), sValid, start, strobe);
    s_in5_mux0   <=    	(algo_in(191 downto 160), sValid, start, strobe);

    mux0_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(0).ttc_cmd(0), --bcres for quad 0
            in0     =>  s_in0_mux0,   -- frame 0   -> algo 0-31
            in1     =>  s_in1_mux0,   -- frame 1   -> algo 32-63
            in2     =>  s_in2_mux0,   -- frame 2   -> algo 64-95
            in3     =>  s_in3_mux0,   -- frame 3   -> algo 96-127
            in4     =>  s_in4_mux0,   -- frame 4   -> algo 128-159
            in5     =>  s_in5_mux0,   -- frame 5   -> algo 160-191
            mux_out =>  lane_out(16)
        );


    -- algo 192-383 mux
    s_in0_mux1   <=    (algo_in(223 downto 192), sValid, start, strobe);    -- frame 0   -> algo 192-223
    s_in1_mux1   <=    (algo_in(255 downto 224), sValid, start, strobe);    -- frame 1   -> algo 224-255
    s_in2_mux1   <=    (algo_in(287 downto 256), sValid, start, strobe);    -- frame 2   -> algo 256-287
    s_in3_mux1   <=    (algo_in(319 downto 288), sValid, start, strobe);    -- frame 3   -> algo 288-319
    s_in4_mux1   <=    (algo_in(351 downto 320), sValid, start, strobe);    -- frame 4   -> algo 320-351
    s_in5_mux1   <=    (algo_in(383 downto 352), sValid, start, strobe);    -- frame 5   -> algo 352-383

   mux1_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(0).ttc_cmd(0), --bcres for quad 0
            in0     =>  s_in0_mux1,    -- frame 0   -> algo 192-223
            in1     =>  s_in1_mux1,    -- frame 1   -> algo 224-255
            in2     =>  s_in2_mux1,    -- frame 2   -> algo 256-287
            in3     =>  s_in3_mux1,    -- frame 3   -> algo 288-319
            in4     =>  s_in4_mux1,    -- frame 4   -> algo 320-351
            in5     =>  s_in5_mux1,    -- frame 5   -> algo 352-383
            mux_out =>  lane_out(17)
        );



    -- algo 384-511 + finor mux

    s_in0_mux2   <=   (algo_in(415 downto 384), sValid, start, strobe);    -- frame 0   -> algo 384-415
    s_in1_mux2   <=   (algo_in(447 downto 416), sValid, start, strobe);    -- frame 1   -> algo 416-447
    s_in2_mux2   <=   (algo_in(479 downto 448), sValid, start, strobe);    -- frame 2   -> algo 448-479
    s_in3_mux2   <=   (algo_in(511 downto 480), sValid, start, strobe);    -- frame 3   -> algo 480-511
    s_in4_mux2   <=   ("0000000000000000000000000000000" & finor_in, sValid, start, strobe);     -- frame 4   -> finor
    s_in5_mux2   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free

  mux2_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(0).ttc_cmd(0), --bcres for quad 0
            in0     =>  s_in0_mux2,    -- frame 0   -> algo 384-415
            in1     =>  s_in1_mux2,    -- frame 1   -> algo 416-447
            in2     =>  s_in2_mux2,    -- frame 2   -> algo 448-479
            in3     =>  s_in3_mux2,    -- frame 3   -> algo 480-511
            in4     =>  s_in4_mux2,    -- frame 4  -> finor
            in5     =>  s_in5_mux2,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(18)
        );

    -- JW 2015-08-24: added local and mp7 bc_cntr to output
    -- bc cntr output

    s_in0_mux3   <=   (X"00000" & bx_nr, sValid, start, strobe);           -- frame 0   -> bx_nr
    s_in1_mux3   <=   (X"00000" & ttc_bx_cntr, sValid, start, strobe);     -- frame 1   -> mp7 ttc bc cntr
    s_in2_mux3   <=   (X"00000" & bx_nr_fdl, sValid, start, strobe);       -- frame 5   -> free
    s_in3_mux3   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free
    s_in4_mux3   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free
    s_in5_mux3   <=   ((others => '0'), sValid, start, strobe);            -- frame 5   -> free

  mux3_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  ctrs(0).ttc_cmd(0), --bcres for quad 0
            in0     =>  s_in0_mux3,    -- frame 0   -> bx_nr
            in1     =>  s_in1_mux3,    -- frame 1   -> mp7 ttc bc cntr
            in2     =>  s_in2_mux3,    -- frame 2   -> bx_nr_fdl
            in3     =>  s_in3_mux3,    -- frame 3   -> free
            in4     =>  s_in4_mux3,    -- frame 4  -> free
            in5     =>  s_in5_mux3,    -- frame 5 -> free
            -- sel     =>  frame_cntr,
            mux_out =>  lane_out(19)
        );


end architecture;



