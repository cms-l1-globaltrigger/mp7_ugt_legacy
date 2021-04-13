
-- Description:
-- Instances for correlation cuts calculations

-- Version history:
-- HB 2021-04-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity correlation_cuts_calculation is
     generic(
        nr_obj1: natural;
        nr_obj2: natural;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type: natural := INVARIANT_MASS_TYPE;
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        upt1_width: positive := 12;
        upt2_width: positive := 12;
        cosh_cos_precision: positive := EG_EG_COSH_COS_PRECISION;
        cosh_cos_width: positive := EG_EG_COSH_COS_VECTOR_WIDTH;
        tbpt_cut: boolean := false;
        sin_cos_width: positive := 11;
        pt_sq_sin_cos_precision: positive := 3
    );
    port(
        deta: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2: in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        upt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        upt2: in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        cosh_deta: in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi: in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_integer1: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_integer2: in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_integer1: in sin_cos_integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_integer2: in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        dr: out dr_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        inv_mass_pt: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        inv_mass_upt: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        trans_mass: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbpt: out tbpt_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbupt: out tbpt_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end correlation_cuts_calculation;

architecture rtl of correlation_cuts_calculation is

begin

    cuts_l_1: for i in 0 to nr_obj1-1 generate
        cuts_l_2: for j in 0 to nr_obj2-1 generate
            dr_sel: if dr_cut generate
                dr_calc_i: entity work.dr_calc
                    port map(
                        deta => deta(i,j),
                        dphi => dphi(i,j),
                        dr => dr(i,j)(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)
                    );
            end generate dr_sel;
            mass_sel: if mass_cut generate
                mass_calc_i: entity work.mass_instances_calc
                    generic map(
                        mass_type => mass_type,
                        pt1_width => pt1_width,
                        pt2_width => pt2_width,
                        upt1_width => upt1_width,
                        upt2_width => upt2_width,
                        cosh_cos_width => cosh_cos_width,
                        mass_cosh_cos_precision => cosh_cos_precision
                    )
                    port map(
                        pt1 => pt1(i)(pt1_width-1 downto 0),
                        pt2 => pt2(j)(pt2_width-1 downto 0),
                        upt1 => upt1(i)(upt1_width-1 downto 0),
                        upt2 => upt2(j)(upt2_width-1 downto 0),
                        cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                        cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
                        inv_mass_pt => inv_mass_pt(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0),
                        inv_mass_upt => inv_mass_upt(i,j)(upt1_width+upt2_width+cosh_cos_width-1 downto 0),
                        trans_mass => trans_mass(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0)
                    );
            end generate mass_sel;
            tbpt_sel: if tbpt_cut generate
                twobody_pt_calc_i: entity work.twobody_pt_calc
                    generic map(
                        pt1_width => pt1_width,
                        pt2_width => pt2_width,
                        upt1_width => upt1_width,
                        upt2_width => upt2_width,
                        sin_cos_width => sin_cos_width,
                        pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                    )
                    port map(
                        pt1 => pt1(i)(pt1_width-1 downto 0),
                        pt2 => pt2(j)(pt2_width-1 downto 0),
                        upt1 => upt1(i)(upt1_width-1 downto 0),
                        upt2 => upt2(j)(upt2_width-1 downto 0),
                        cos_phi_1_integer => cos_phi_integer1(i),
                        cos_phi_2_integer => cos_phi_integer2(j),
                        sin_phi_1_integer => sin_phi_integer1(i),
                        sin_phi_2_integer => sin_phi_integer2(j),
                        tbpt => tbpt(i,j),
                        tbupt => tbupt(i,j)
                );
            end generate tbpt_sel;
        end generate cuts_l_2;
    end generate cuts_l_1;

end architecture rtl;
