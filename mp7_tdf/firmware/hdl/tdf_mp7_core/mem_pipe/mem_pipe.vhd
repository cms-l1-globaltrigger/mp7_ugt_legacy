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
use IEEE.numeric_std.all;

library work;
use work.mp7_data_types.all;
use work.tdf_mp7_core_pkg.all;
use work.lhc_data_pkg.all;
use work.tdf_mp7_core_pkg.all;


entity mem_pipe is
        generic(
        addr_width : natural := 31
        );
        port
        (
            clk    : in std_logic;
            pipe_in : in std_logic_vector(addr_width downto 0);
            pipe_out : out std_logic_vector(addr_width downto 0)
        );
end mem_pipe;

architecture arch of mem_pipe is
begin
    -- memory_pipeline
    mem_pipe_p: process (clk, pipe_in)
    begin
        if (clk'event and clk = '1') then
           pipe_out <= pipe_in;
        end if;
--      end if;
    end process mem_pipe_p;
end architecture;