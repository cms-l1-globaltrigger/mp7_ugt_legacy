-- Description:
-- Module for external condition pipeline delay process.

-- Version-history:
-- HB 2020-09-08: first design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity ext_cond_pipeline is
    port(
        lhc_clk : in std_logic;
        ext_cond_bx_p2_i : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p1_i : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_0_i : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m1_i : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m2_i : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p2 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p1 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_0 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m1 : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m2 : out std_logic_vector(nr_external_conditions-1 downto 0)
    );
end ext_cond_pipeline;

architecture rtl of ext_cond_pipeline is

    constant external_conditions_pipeline_stages: natural := 2; -- pipeline stages for "External conditions" to get same pipeline to algos as conditions

begin

    ext_cond_pipe_p: process(lhc_clk, ext_cond_bx_p2_i, ext_cond_bx_p1_i, ext_cond_bx_0_i, ext_cond_bx_m1_i, ext_cond_bx_m2_i)
        type ext_cond_pipe_array is array (0 to external_conditions_pipeline_stages+1) of std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
        variable ext_cond_bx_p2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
        variable ext_cond_bx_p1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
        variable ext_cond_bx_0_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
        variable ext_cond_bx_m1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
        variable ext_cond_bx_m2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
        begin
            ext_cond_bx_p2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p2_i;
            ext_cond_bx_p1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p1_i;
            ext_cond_bx_0_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_0_i;
            ext_cond_bx_m1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m1_i;
            ext_cond_bx_m2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m2_i;
            if (external_conditions_pipeline_stages > 0) then 
                if (lhc_clk'event and (lhc_clk = '1') ) then
                    ext_cond_bx_p2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p2_pipe_temp(1 to external_conditions_pipeline_stages+1);
                    ext_cond_bx_p1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                    ext_cond_bx_0_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_0_pipe_temp(1 to external_conditions_pipeline_stages+1);
                    ext_cond_bx_m1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                    ext_cond_bx_m2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m2_pipe_temp(1 to external_conditions_pipeline_stages+1);
                end if;
            end if;
            ext_cond_bx_p2 <= ext_cond_bx_p2_pipe_temp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
            ext_cond_bx_p1 <= ext_cond_bx_p1_pipe_temp(1);
            ext_cond_bx_0 <= ext_cond_bx_0_pipe_temp(1);
            ext_cond_bx_m1 <= ext_cond_bx_m1_pipe_temp(1);
            ext_cond_bx_m2 <= ext_cond_bx_m2_pipe_temp(1);
    end process;

end architecture rtl;
