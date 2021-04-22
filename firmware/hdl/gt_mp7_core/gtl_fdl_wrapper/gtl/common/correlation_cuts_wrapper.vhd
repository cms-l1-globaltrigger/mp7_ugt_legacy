
-- Description:
-- Wrapper for correlation cuts comparator

-- Version history:
-- HB 2021-04-09: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity correlation_cuts_wrapper is
     generic(

        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_EG_OBJECTS-1;

        deta_cut: boolean := false;
        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean := false;
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_vector_width : natural := EG_PT_VECTOR_WIDTH+EG_PT_VECTOR_WIDTH+CALO_CALO_COSH_COS_VECTOR_WIDTH;
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_div_dr_vector_width: positive := CALO_CALO_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        tbpt_cut: boolean := false;
        tbpt_vector_width : natural := 2+EG_PT_VECTOR_WIDTH+EG_PT_VECTOR_WIDTH+CALO_SIN_COS_VECTOR_WIDTH+CALO_SIN_COS_VECTOR_WIDTH;
        tbpt_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');

        same_bx: boolean := false
   );
    port(
        lhc_clk: in std_logic;
        deta: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dr: in dr_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_pt: in mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_inv_upt : in mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_trans: in mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_div_dr: in mass_div_dr_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbpt: in tbpt_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        deta_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dphi_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        dr_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        mass_div_dr_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
        tbpt_comp_o: out std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'))
    );
end correlation_cuts_wrapper;

architecture rtl of correlation_cuts_wrapper is

-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of AND-OR matrix
    signal deta_comp_temp, dphi_comp_temp, dr_comp_temp, mass_comp_temp, mass_div_dr_comp_temp, tbpt_comp_temp :
    std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));
    signal deta_comp, dphi_comp, dr_comp, mass_comp, mass_div_dr_comp, tbpt_comp :
    std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));

begin

        comp_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
            comp_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                same_type_bx_sel: if (type_obj1 = type_obj2) and (same_bx = true) and j>i generate
                -- with same type and bx => half matrix has to be calculated, only - less resources used!
                    deta_sel: if deta_cut generate
                        deta_comp_i: entity work.correlation_cut_comp
                            generic map(false, deta_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), deta_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                            port map(deta(i,j), deta_comp_temp(i,j));
                    end generate deta_sel;
                    dphi_sel: if dphi_cut generate
                        dphi_comp_i: entity work.correlation_cut_comp
                            generic map(false, dphi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), dphi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                            port map(dphi(i,j), dphi_comp_temp(i,j));
                    end generate dphi_sel;
                    dr_sel: if dr_cut generate
                        dr_comp_i: entity work.correlation_cut_comp
                            generic map(false, dr_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0), dr_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0))
                            port map(dr(i,j), dr_comp_temp(i,j));
                    end generate dr_sel;
                    mass_type_inv_pt: if mass_cut and mass_type = INVARIANT_MASS_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_inv_pt(i,j), mass_comp_temp(i,j));
                    end generate mass_type_inv_pt;
                    mass_type_inv_upt: if mass_cut and mass_type = INVARIANT_MASS_UPT_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_inv_upt(i,j), mass_comp_temp(i,j));
                    end generate mass_type_inv_upt;
                    mass_type_trans: if mass_cut and mass_type = TRANSVERSE_MASS_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_trans(i,j), mass_comp_temp(i,j));
                    end generate mass_type_trans;
                    mass_dr_sel: if mass_cut and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
                        mass_dr_comp_i: entity work.correlation_cut_comp
                            generic map(true, mass_div_dr_threshold(mass_div_dr_vector_width-1 downto 0), mass_div_dr_threshold(mass_div_dr_vector_width-1 downto 0))
                            port map(mass_div_dr(i,j), mass_div_dr_comp_temp(i,j));
                    end generate mass_dr_sel;
                    tbpt_sel: if tbpt_cut generate
                        tbpt_comp_i: entity work.correlation_cut_comp
                            generic map(true, tbpt_threshold_vector(tbpt_vector_width-1 downto 0), tbpt_threshold_vector(tbpt_vector_width-1 downto 0))
                            port map(tbpt(i,j), tbpt_comp_temp(i,j));
                    end generate tbpt_sel;
                    deta_comp(i,j) <= deta_comp_temp(i,j);
                    deta_comp(j,i) <= deta_comp_temp(i,j);
                    dphi_comp(i,j) <= dphi_comp_temp(i,j);
                    dphi_comp(j,i) <= dphi_comp_temp(i,j);
                    dr_comp(i,j) <= dr_comp_temp(i,j);
                    dr_comp(j,i) <= dr_comp_temp(i,j);
                    mass_comp(i,j) <= mass_comp_temp(i,j);
                    mass_comp(j,i) <= mass_comp_temp(i,j);
                    mass_div_dr_comp(i,j) <= mass_div_dr_comp_temp(i,j);
                    mass_div_dr_comp(j,i) <= mass_div_dr_comp_temp(i,j);
                    tbpt_comp(i,j) <= tbpt_comp_temp(i,j);
                    tbpt_comp(j,i) <= tbpt_comp_temp(i,j);
                end generate same_type_bx_sel;
                diff_type_bx_sel: if (type_obj1 /= type_obj2) or (same_bx = false) generate
                    deta_sel: if deta_cut generate
                        deta_comp_i: entity work.correlation_cut_comp
                            generic map(false, deta_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), deta_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                            port map(deta(i,j), deta_comp(i,j));
                     end generate deta_sel;
                    dphi_sel: if dphi_cut generate
                        dphi_comp_i: entity work.correlation_cut_comp
                            generic map(false, dphi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0), dphi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0))
                            port map(dphi(i,j), dphi_comp(i,j));
                    end generate dphi_sel;
                    dr_sel: if dr_cut generate
                        dr_comp_i: entity work.correlation_cut_comp
                            generic map(false, dr_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0), dr_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0))
                            port map(dr(i,j), dr_comp(i,j));
                    end generate dr_sel;
                    mass_type_inv_pt: if mass_cut and mass_type = INVARIANT_MASS_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_inv_pt(i,j), mass_comp(i,j));
                    end generate mass_type_inv_pt;
                    mass_type_inv_upt: if mass_cut and mass_type = INVARIANT_MASS_UPT_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_inv_upt(i,j), mass_comp(i,j));
                    end generate mass_type_inv_upt;
                    mass_type_trans: if mass_cut and mass_type = TRANSVERSE_MASS_TYPE generate
                        mass_comp_i: entity work.correlation_cut_comp
                            generic map(false, mass_upper_limit_vector(mass_vector_width-1 downto 0), mass_lower_limit_vector(mass_vector_width-1 downto 0))
                            port map(mass_trans(i,j), mass_comp(i,j));
                    end generate mass_type_trans;
                    mass_dr_sel: if mass_cut and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
                        mass_dr_comp_i: entity work.correlation_cut_comp
                            generic map(true, mass_div_dr_threshold(mass_div_dr_vector_width-1 downto 0), mass_div_dr_threshold(mass_div_dr_vector_width-1 downto 0))
                            port map(mass_div_dr(i,j), mass_div_dr_comp(i,j));
                    end generate mass_dr_sel;
                    tbpt_sel: if tbpt_cut generate
                        tbpt_comp_i: entity work.correlation_cut_comp
                            generic map(true, tbpt_threshold_vector(tbpt_vector_width-1 downto 0), tbpt_threshold_vector(tbpt_vector_width-1 downto 0))
                            port map(tbpt(i,j), tbpt_comp(i,j));
                    end generate tbpt_sel;
                end generate diff_type_bx_sel;
            end generate comp_l_2;
        end generate comp_l_1;

        pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_comp, tbpt_comp)
            begin
            if not INTERMEDIATE_PIPELINE then
                deta_comp_o <= deta_comp;
                dphi_comp_o <= dphi_comp;
                dr_comp_o <= dr_comp;
                mass_comp_o <= mass_comp;
                mass_div_dr_comp_o <= mass_div_dr_comp;
                tbpt_comp_o <= tbpt_comp;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    deta_comp_o <= deta_comp;
                    dphi_comp_o <= dphi_comp;
                    dr_comp_o <= dr_comp;
                    mass_comp_o <= mass_comp;
                    mass_div_dr_comp_o <= mass_div_dr_comp;
                    tbpt_comp_o <= tbpt_comp;
                end if;
            end if;
        end process;

end architecture rtl;
