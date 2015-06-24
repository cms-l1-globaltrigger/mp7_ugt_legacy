-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
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

entity output_mux is
    generic(
        NR_LANES: positive
    );
	port
	(   lhc_clk     : in std_logic;
        lhc_rst     : in std_logic;
        clk240      : in std_logic;
        bx_nr       : in std_logic_vector(11 downto 0);
        algo_in     : in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        finor_in    : in std_logic;
        --daq_in      : in std_logic_vector(DAQ_INPUT_WIDTH-1 downto 0);
        valid_lo    : in std_logic_vector(15 downto 0);
        valid_hi    : in std_logic_vector(15 downto 0);
        start       : in std_logic;
        strobe      : in std_logic;
		lane_out    : out ldata(NR_LANES-1 downto 0)
	);
end output_mux;

architecture arch of output_mux is

    signal sValid : std_logic := '0';

    signal s_m0in0 : lword := ((others => '0'), '0', '0', '0');
    signal s_m0in1 : lword := ((others => '0'), '0', '0', '0');
    signal s_m0in2 : lword := ((others => '0'), '0', '0', '0');
    signal s_m0in3 : lword := ((others => '0'), '0', '0', '0');
    signal s_m0in4 : lword := ((others => '0'), '0', '0', '0');
    signal s_m0in5 : lword := ((others => '0'), '0', '0', '0');


    signal s_m1in0 : lword := ((others => '0'), '0', '0', '0');
    signal s_m1in1 : lword := ((others => '0'), '0', '0', '0');
    signal s_m1in2 : lword := ((others => '0'), '0', '0', '0');
    signal s_m1in3 : lword := ((others => '0'), '0', '0', '0');
    signal s_m1in4 : lword := ((others => '0'), '0', '0', '0');
    signal s_m1in5 : lword := ((others => '0'), '0', '0', '0');


    signal s_m2in0 : lword := ((others => '0'), '0', '0', '0');
    signal s_m2in1 : lword := ((others => '0'), '0', '0', '0');
    signal s_m2in2 : lword := ((others => '0'), '0', '0', '0');
    signal s_m2in3 : lword := ((others => '0'), '0', '0', '0');
    signal s_m2in4 : lword := ((others => '0'), '0', '0', '0');
    signal s_m2in5 : lword := ((others => '0'), '0', '0', '0');


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

    s_m0in0   <=     (algo_in(31 downto 0), sValid, start, strobe);
    s_m0in1   <=     (algo_in(63 downto 32), sValid, start, strobe);
    s_m0in2   <=     (algo_in(95 downto 64), sValid, start, strobe);
    s_m0in3   <=     (algo_in(127 downto 96), sValid, start, strobe);
    s_m0in4   <=     (algo_in(159 downto 128), sValid, start, strobe);
    s_m0in5   <=     (algo_in(191 downto 160), sValid, start, strobe);

    -- algo 0-191 mux
    mux0_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  '0',
            in0     =>  s_m0in0,   -- frame 0   -> algo 0-31
            in1     =>  s_m0in1,   -- frame 1   -> algo 32-63
            in2     =>  s_m0in2,   -- frame 2   -> algo 64-95
            in3     =>  s_m0in3,   -- frame 3   -> algo 96-127
            in4     =>  s_m0in4,   -- frame 4   -> algo 128-159
            in5     =>  s_m0in5,   -- frame 5   -> algo 160-191
            mux_out =>  lane_out(0)
        );


    s_m1in0   <=     (algo_in(223 downto 192), sValid, start, strobe);
    s_m1in1   <=     (algo_in(255 downto 224), sValid, start, strobe);
    s_m1in2   <=     (algo_in(287 downto 256), sValid, start, strobe);
    s_m1in3   <=     (algo_in(319 downto 288), sValid, start, strobe);
    s_m1in4   <=     (algo_in(351 downto 320), sValid, start, strobe);
    s_m1in5   <=     (algo_in(383 downto 352), sValid, start, strobe);

    -- algo 192-383 mux
    mux1_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   =>  '0',
            in0     =>  s_m1in0,    -- frame 0   -> algo 192-223
            in1     =>  s_m1in1,    -- frame 1   -> algo 224-255
            in2     =>  s_m1in2,    -- frame 2   -> algo 256-287
            in3     =>  s_m1in3,    -- frame 3   -> algo 288-319
            in4     =>  s_m1in4,    -- frame 4   -> algo 320-351
            in5     =>  s_m1in5,    -- frame 5   -> algo 352-383
            mux_out =>  lane_out(1)
        );


    s_m2in0   <=     (algo_in(415 downto 384), sValid, start, strobe);
    s_m2in1   <=     (algo_in(447 downto 416), sValid, start, strobe);
    s_m2in2   <=     (algo_in(479 downto 448), sValid, start, strobe);
    s_m2in3   <=     (algo_in(511 downto 480), sValid, start, strobe);
    s_m2in4   <=     ("0000000000000000000000000000000" & finor_in, sValid, start, strobe);
    s_m2in5   <=     ((others => '0'), sValid, start, strobe);

    -- algo 384-511 + finor mux
    mux2_i: entity work.mux
        port map
        (
            clk     =>  clk240,
            res     =>  lhc_rst,
            bcres   => '0',
            in0     =>  s_m2in0,    -- frame 0   -> algo 384-415
            in1     =>  s_m2in1,    -- frame 1   -> algo 416-447
            in2     =>  s_m2in2,    -- frame 2   -> algo 448-479
            in3     =>  s_m2in3,    -- frame 3   -> algo 480-511
            in4     =>  s_m2in4,    -- frame 4   -> finor
            in5     =>  s_m2in5,    -- frame 5   -> free
            mux_out =>  lane_out(2)
        );

end architecture;



