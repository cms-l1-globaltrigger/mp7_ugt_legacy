--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 14.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL:  $
-- $Date:  $
-- $Author: Wittmann $
-- $Revision: 0.1  $
--------------------------------------------------------------------------------
--
-- JW 2015-09-17: started development of bgo_sync to synchronize the bgos with 40MHz and avoid timing conflicts
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.mp7_brd_decl.all;
use work.mp7_ttc_decl.all;
use work.top_decl.all;

entity bgo_sync is
    port(
        clk_payload: in std_logic;
        rst_payload: in std_logic;
        ttc_in:      in ttc_cmd_t;
        ec0_out:     out std_logic;
        oc0_out:     out std_logic;
        resync_out:  out std_logic
    );
end bgo_sync;

architecture rtl of bgo_sync is
    signal ec0_in            : std_logic;
    signal resync_in         : std_logic;
    signal oc0_in            : std_logic;
begin

    ec0_in     <= '1' when ttc_in = TTC_BCMD_EC0 else '0';
    resync_in  <= '1' when ttc_in = TTC_BCMD_RESYNC else '0';
    oc0_in     <= '1' when ttc_in = TTC_BCMD_OC0 else '0';

    sync_bgos_p: process(clk_payload, rst_payload, ttc_in)
        begin
        if (rst_payload = '1') then
            ec0_out <= '0';
            oc0_out <= '0';
            resync_out <= '0';
        elsif (clk_payload'event and clk_payload = '1') then
            ec0_out <= ec0_in;
            oc0_out <= oc0_in;
            resync_out <= resync_in;
        end if;
    end process;

end rtl;