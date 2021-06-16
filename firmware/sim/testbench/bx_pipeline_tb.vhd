
-- Description:
-- Testbench for simulation of bx_pipeline

-- Version history:
-- HB 2021-06-10: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.fixed_pkg.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline_tb is
end bx_pipeline_tb;

architecture beh of bx_pipeline_tb is

    signal lhc_clk : std_logic;

    constant LHC_CLK_PERIOD  : time :=  25 ns;

    signal gtl_data : gtl_data_record;
    signal bx_data : bx_data_record;


--*********************************Main Body of Code**********************************
begin

    -- Clock
    process
    begin
        lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
        lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        wait for LHC_CLK_PERIOD;
            gtl_data.mu <= (others => (others => '0'));
            gtl_data.eg <= (others => (others => '0'));
            gtl_data.jet <= (others => (others => '0'));
            gtl_data.tau <= (others => (others => '0'));
            gtl_data.ett <= (others => '0');
            gtl_data.htt <= (others => '0');
            gtl_data.etm <= (others => '0');
            gtl_data.htm <= (others => '0');
            gtl_data.ettem <= (others => '0');
            gtl_data.etmhf <= (others => '0');
            gtl_data.htmhf <= (others => '0');
            gtl_data.mbt1hfp <= (others => '0');
            gtl_data.mbt1hfm <= (others => '0');
            gtl_data.mbt0hfp <= (others => '0');
            gtl_data.mbt0hfm <= (others => '0');
            gtl_data.asymet <= (others => '0');
            gtl_data.asymht <= (others => '0');
            gtl_data.asymethf <= (others => '0');
            gtl_data.asymhthf <= (others => '0');
            gtl_data.towercount <= (others => '0');
            gtl_data.centrality <= (others => '0');
            gtl_data.ext_cond <= (others => '0');
        wait for 3*LHC_CLK_PERIOD;
            gtl_data.mu <= (X"2000000000000000", X"0000000000000000", X"2000000000000000", X"0000000000000000", X"2000000000000000", X"0000000000000000", X"2000000000000000", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
            gtl_data.mu <= (others => (others => '0'));
        wait for 10*LHC_CLK_PERIOD;
            gtl_data.mu <= (X"2000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"2000000000000000", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
            gtl_data.mu <= (others => (others => '0'));
        wait for 10*LHC_CLK_PERIOD;
            gtl_data.mu <= (X"0000000000000000", X"0000000000000000", X"2000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", X"0000000000000000", others => X"0000000000000000");
        wait for LHC_CLK_PERIOD;
            gtl_data.mu <= (others => (others => '0'));
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------


dut: entity work.bx_pipeline
    port map(
        clk => lhc_clk,
        gtl_data => gtl_data,
        bx_data => bx_data
    );

end beh;

