
-- Description:
-- Correlation cuts for overlap removal

-- Version history:
-- HB 2021-04-16: used correlation_cut_comp.vhd for comparison.
-- HB 2021-02-11: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity orm_cuts is
     generic(
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_EG_OBJECTS-1;

        deta_orm_cut: boolean := false;
        deta_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_orm_cut: boolean := false;
        dphi_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_orm_cut: boolean := false;
        dr_orm_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_orm_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        nr_obj1: natural := NR_EG_OBJECTS;
        nr_obj2: natural := NR_EG_OBJECTS
    );
    port(
        lhc_clk: in std_logic;
        deta_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_orm: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dr_orm: in dr_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        deta_orm_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
        dphi_orm_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));
        dr_orm_comp_pipe: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'))
    );
end orm_cuts;

architecture rtl of orm_cuts is

    signal deta_orm_comp, dphi_orm_comp, dr_orm_comp : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '0'));

begin

    cuts_orm_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
        cuts_orm_l_2: for j in slice_low_obj2 to slice_high_obj2 generate

            deta_orm_cut_i: if deta_orm_cut generate
                comp_i: entity work.correlation_cut_comp
                    generic map(false, deta_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), deta_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                    port map(deta_orm(i,j)(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), deta_orm_comp(i,j));
            end generate deta_orm_cut_i;

            dphi_orm_cut_i: if dphi_orm_cut generate
                comp_i: entity work.correlation_cut_comp
                    generic map(false, dphi_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), dphi_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                    port map(dphi_orm(i,j)(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), dphi_orm_comp(i,j));
            end generate dphi_orm_cut_i;

            dr_orm_cut_i: if dr_orm_cut generate
                comp_i: entity work.correlation_cut_comp
                    generic map(false, dr_orm_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0), dr_orm_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0))
                    port map(dr_orm(i,j)(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0), dr_orm_comp(i,j));
            end generate dr_orm_cut_i;

        end generate cuts_orm_l_2;
    end generate cuts_orm_l_1;

    pipeline_p: process(lhc_clk, deta_orm_comp, dphi_orm_comp, dr_orm_comp)
        begin
        if not INTERMEDIATE_PIPELINE then
            deta_orm_comp_pipe <= deta_orm_comp;
            dphi_orm_comp_pipe <= dphi_orm_comp;
            dr_orm_comp_pipe <= dr_orm_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                deta_orm_comp_pipe <= deta_orm_comp;
                dphi_orm_comp_pipe <= dphi_orm_comp;
                dr_orm_comp_pipe <= dr_orm_comp;
            end if;
        end if;
    end process;

end architecture rtl;
