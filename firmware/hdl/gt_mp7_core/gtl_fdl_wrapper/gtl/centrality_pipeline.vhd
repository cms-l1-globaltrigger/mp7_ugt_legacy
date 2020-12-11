-- Description:
-- Module for centrality pipeline delay process.

-- Version-history:
-- HB 2020-09-08: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity centrality_pipeline is
    port(
        lhc_clk : in std_logic;
        centrality_bx_p2_i : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_p1_i : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_0_i : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_m1_i : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_m2_i : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        cent0_bx_p2_o : out std_logic;
        cent1_bx_p2_o : out std_logic;
        cent2_bx_p2_o : out std_logic;
        cent3_bx_p2_o : out std_logic;
        cent4_bx_p2_o : out std_logic;
        cent5_bx_p2_o : out std_logic;
        cent6_bx_p2_o : out std_logic;
        cent7_bx_p2_o : out std_logic;
        cent0_bx_p1_o : out std_logic;
        cent1_bx_p1_o : out std_logic;
        cent2_bx_p1_o : out std_logic;
        cent3_bx_p1_o : out std_logic;
        cent4_bx_p1_o : out std_logic;
        cent5_bx_p1_o : out std_logic;
        cent6_bx_p1_o : out std_logic;
        cent7_bx_p1_o : out std_logic;
        cent0_bx_0_o : out std_logic;
        cent1_bx_0_o : out std_logic;
        cent2_bx_0_o : out std_logic;
        cent3_bx_0_o : out std_logic;
        cent4_bx_0_o : out std_logic;
        cent5_bx_0_o : out std_logic;
        cent6_bx_0_o : out std_logic;
        cent7_bx_0_o : out std_logic;
        cent0_bx_m1_o : out std_logic;
        cent1_bx_m1_o : out std_logic;
        cent2_bx_m1_o : out std_logic;
        cent3_bx_m1_o : out std_logic;
        cent4_bx_m1_o : out std_logic;
        cent5_bx_m1_o : out std_logic;
        cent6_bx_m1_o : out std_logic;
        cent7_bx_m1_o : out std_logic;
        cent0_bx_m2_o : out std_logic;
        cent1_bx_m2_o : out std_logic;
        cent2_bx_m2_o : out std_logic;
        cent3_bx_m2_o : out std_logic;
        cent4_bx_m2_o : out std_logic;
        cent5_bx_m2_o : out std_logic;
        cent6_bx_m2_o : out std_logic;
        cent7_bx_m2_o : out std_logic
    );
end centrality_pipeline;

architecture rtl of centrality_pipeline is

    constant centrality_bits_pipeline_stages: natural := 2; -- pipeline stages for "Centrality" to get same pipeline to algos as conditions

    signal centrality_bx_p2, centrality_bx_p1, centrality_bx_0, centrality_bx_m1, centrality_bx_m2 : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);

begin

    -- Parameterized pipeline stages for Centrality bits, actually 2 stages (fixed) in conditions, see "constant centrality_bits_pipeline_stages ..."

    centrality_pipe_p: process(lhc_clk, centrality_bx_p2_i, centrality_bx_p1_i, centrality_bx_0_i, centrality_bx_m1_i, centrality_bx_m2_i)
        type centrality_pipe_array is array (0 to centrality_bits_pipeline_stages+1) of std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        variable centrality_bx_p2_pipe_temp : centrality_pipe_array := (others => (others => '0'));
        variable centrality_bx_p1_pipe_temp : centrality_pipe_array := (others => (others => '0'));
        variable centrality_bx_0_pipe_temp : centrality_pipe_array := (others => (others => '0'));
        variable centrality_bx_m1_pipe_temp : centrality_pipe_array := (others => (others => '0'));
        variable centrality_bx_m2_pipe_temp : centrality_pipe_array := (others => (others => '0'));
        begin
            centrality_bx_p2_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_p2_i;
            centrality_bx_p1_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_p1_i;
            centrality_bx_0_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_0_i;
            centrality_bx_m1_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_m1_i;
            centrality_bx_m2_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_m2_i;
            if (centrality_bits_pipeline_stages > 0) then 
                if (lhc_clk'event and (lhc_clk = '1') ) then
                    centrality_bx_p2_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_p2_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                    centrality_bx_p1_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_p1_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                    centrality_bx_0_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_0_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                    centrality_bx_m1_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_m1_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                    centrality_bx_m2_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_m2_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                end if;
            end if;
            centrality_bx_p2 <= centrality_bx_p2_pipe_temp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
            centrality_bx_p1 <= centrality_bx_p1_pipe_temp(1);
            centrality_bx_0 <= centrality_bx_0_pipe_temp(1);
            centrality_bx_m1 <= centrality_bx_m1_pipe_temp(1);
            centrality_bx_m2 <= centrality_bx_m2_pipe_temp(1);
    end process;

    -- Centrality bit assignment
    cent0_bx_p2_o <= centrality_bx_p2(0);
    cent1_bx_p2_o <= centrality_bx_p2(1);
    cent2_bx_p2_o <= centrality_bx_p2(2);
    cent3_bx_p2_o <= centrality_bx_p2(3);
    cent4_bx_p2_o <= centrality_bx_p2(4);
    cent5_bx_p2_o <= centrality_bx_p2(5);
    cent6_bx_p2_o <= centrality_bx_p2(6);
    cent7_bx_p2_o <= centrality_bx_p2(7);
    cent0_bx_p1_o <= centrality_bx_p1(0);
    cent1_bx_p1_o <= centrality_bx_p1(1);
    cent2_bx_p1_o <= centrality_bx_p1(2);
    cent3_bx_p1_o <= centrality_bx_p1(3);
    cent4_bx_p1_o <= centrality_bx_p1(4);
    cent5_bx_p1_o <= centrality_bx_p1(5);
    cent6_bx_p1_o <= centrality_bx_p1(6);
    cent7_bx_p1_o <= centrality_bx_p1(7);
    cent0_bx_0_o <= centrality_bx_0(0);
    cent1_bx_0_o <= centrality_bx_0(1);
    cent2_bx_0_o <= centrality_bx_0(2);
    cent3_bx_0_o <= centrality_bx_0(3);
    cent4_bx_0_o <= centrality_bx_0(4);
    cent5_bx_0_o <= centrality_bx_0(5);
    cent6_bx_0_o <= centrality_bx_0(6);
    cent7_bx_0_o <= centrality_bx_0(7);
    cent0_bx_m1_o <= centrality_bx_m1(0);
    cent1_bx_m1_o <= centrality_bx_m1(1);
    cent2_bx_m1_o <= centrality_bx_m1(2);
    cent3_bx_m1_o <= centrality_bx_m1(3);
    cent4_bx_m1_o <= centrality_bx_m1(4);
    cent5_bx_m1_o <= centrality_bx_m1(5);
    cent6_bx_m1_o <= centrality_bx_m1(6);
    cent7_bx_m1_o <= centrality_bx_m1(7);
    cent0_bx_m2_o <= centrality_bx_m2(0);
    cent1_bx_m2_o <= centrality_bx_m2(1);
    cent2_bx_m2_o <= centrality_bx_m2(2);
    cent3_bx_m2_o <= centrality_bx_m2(3);
    cent4_bx_m2_o <= centrality_bx_m2(4);
    cent5_bx_m2_o <= centrality_bx_m2(5);
    cent6_bx_m2_o <= centrality_bx_m2(6);
    cent7_bx_m2_o <= centrality_bx_m2(7);

end architecture rtl;
