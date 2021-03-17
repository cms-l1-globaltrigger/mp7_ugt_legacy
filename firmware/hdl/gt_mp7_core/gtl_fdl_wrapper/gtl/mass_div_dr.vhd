
-- Description:
-- Invariant mass divided by deltaR based on LUTs (ROMs).

-- Version history:
-- HB 2021-03-17: implemented instance "mass_div_dr_calc".
-- HB 2021-02-24: added loops for all combinations of objects. Changed module name.
-- HB 2020-05-29: moved comparison to mass_div_dr_comp.vhd.
-- HB 2020-05-14: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_div_dr is
    generic (
        nr_obj1 : natural;
        nr_obj2 : natural;
        rom_sel : natural := CALO_CALO_ROM;
        deta_bins_width : natural := 8;
        dphi_bins_width : natural := 8;
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        inv_dr_sq_width: positive := 26
    );
    port(
        clk : in std_logic := '0';
        deta_bin : in common_deta_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_bin : in common_dphi_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        cosh_deta : in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi : in common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_div_dr : out mass_div_dr_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end mass_div_dr;

architecture rtl of mass_div_dr is

    COMPONENT rom_lut_calo_inv_dr_sq_all
    PORT (
        clk : IN STD_LOGIC;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(25 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_all
    PORT (
        clk : IN STD_LOGIC;
        deta : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(7 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(27 DOWNTO 0)
    );
    END COMPONENT;

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant mass_vector_width : positive := pt1_width+pt2_width+cosh_cos_width;
    constant mass_div_dr_vector_width : positive := mass_vector_width+inv_dr_sq_width;

    signal invariant_mass_sq_div2 : mass_dim2_array(0 to nr_obj1, 0 to nr_obj2) := (others => (others => (others => '0')));
--     signal invariant_mass_sq_div2 : std_logic_vector(mass_vector_width-1 downto 0) := (others => '0');

    constant max_mass_div_dr : std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '1');

    type inv_dr_sq_array is array(0 to nr_obj1-1, 0 to nr_obj2-1) of std_logic_vector(inv_dr_sq_width-1 downto 0);
    signal inv_dr_sq : inv_dr_sq_array;
--     signal inv_dr_sq : std_logic_vector(inv_dr_sq_width-1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";
    attribute use_dsp of mass_div_dr : signal is "yes";

begin

-- LUT value for deta=0 and dphi=0 (dR=0, 1/dR=undefined) => 0, which means mass_div_dr is on it's maximum
-- mass_div_dr <= (invariant_mass_sq_div2 * inv_dr_sq) when (inv_dr_sq > 0) else max_mass_div_dr;

    l1: for i in 0 to nr_obj1-1 generate
        l2: for j in 0 to nr_obj2-1 generate
        -- one clk for ROM
            rom_lut_calo_sel: if rom_sel = CALO_CALO_ROM generate
                rom_lut_i : rom_lut_calo_inv_dr_sq_all
                    port map (
                        clk => clk,
                        deta => deta_bin(i,j)(deta_bins_width-1 downto 0),
                        dphi => dphi_bin(i,j)(dphi_bins_width-1 downto 0),
                        dout => inv_dr_sq(i,j)
                    );
            end generate rom_lut_calo_sel;

            rom_lut_muon_sel: if rom_sel = MU_MU_ROM generate
                rom_lut_i : rom_lut_muon_inv_dr_sq_all
                    port map (
                        clk => clk,
                        deta => deta_bin(i,j)(deta_bins_width-1 downto 0),
                        dphi => dphi_bin(i,j)(dphi_bins_width-1 downto 0),
                        dout => inv_dr_sq(i,j)
                    );
            end generate rom_lut_muon_sel;

            mass_div_dr_calc_i: entity work.mass_div_dr_calc
                generic map(
                    pt1_width,
                    pt2_width,
                    cosh_cos_width,
                    inv_dr_sq_width
                )
                port map(
                    pt1(i)(pt1_width-1 downto 0),
                    pt2(j)(pt2_width-1 downto 0),
                    cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                    cos_dphi(i,j)(cosh_cos_width-1 downto 0),
                    inv_dr_sq(i,j)(inv_dr_sq_width-1 downto 0),
                    mass_div_dr(i,j)
                );

        end generate l2;
    end generate l1;

end architecture rtl;
