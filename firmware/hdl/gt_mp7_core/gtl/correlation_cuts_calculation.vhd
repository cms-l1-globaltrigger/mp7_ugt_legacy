
-- Description:
-- Instances for correlation cuts calculations

-- Version history:
-- HB 2021-04-27: used deta_cosh_deta_luts.vhd and dphi_cos_dphi_luts.vhd separately for resource values.
-- HB 2021-04-20: added logic for mass over deltaR.
-- HB 2021-04-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity correlation_cuts_calculation is
     generic(
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;
        deta_cut: boolean := false;
        dphi_cut: boolean := false;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type: natural := INVARIANT_MASS_TYPE;
        pt1_width: positive := EG_PT_VECTOR_WIDTH;
        pt2_width: positive := EG_PT_VECTOR_WIDTH;
        upt1_width: positive := MU_UPT_VECTOR_WIDTH;
        upt2_width: positive := MU_UPT_VECTOR_WIDTH;
        cosh_cos_precision: positive := CALO_CALO_COSH_COS_PRECISION;
        cosh_cos_width: positive := CALO_CALO_COSH_COS_VECTOR_WIDTH;
        tbpt_cut: boolean := false;
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        sin_cos_precision: positive := CALO_SIN_COS_PRECISION;
        mass_over_dr_cut: boolean := false;
        rom_sel : natural := CALO_CALO_ROM;
        deta_bins_width : natural := CALO_DETA_BINS_WIDTH;
        dphi_bins_width : natural := CALO_DPHI_BINS_WIDTH;
        inverted_dr_sq_width: positive := CALO_CALO_INV_DR_SQ_VECTOR_WIDTH
    );
    port(
        lhc_clk: in std_logic := '0';
        deta_integer: in dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        dphi_integer: in dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        pt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        pt2: in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        upt1: in diff_inputs_array(0 to nr_obj1-1) := (others => (others => '0'));
        upt2: in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        inv_mass_pt_in: in mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_phi_integer1: in integer_array(0 to nr_obj1-1) := (others => 0);
        cos_phi_integer2: in integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_integer1: in integer_array(0 to nr_obj1-1) := (others => 0);
        sin_phi_integer2: in integer_array(0 to nr_obj2-1) := (others => 0);
        deta: out deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: out deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dr: out dr_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        inv_mass_pt: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        inv_mass_upt: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        trans_mass: out mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        mass_over_dr: out mass_div_dr_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbpt: out tbpt_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        tbupt: out tbpt_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end correlation_cuts_calculation;

architecture rtl of correlation_cuts_calculation is

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

    constant mass_vector_width : positive := pt1_width+pt2_width+cosh_cos_width;
    constant mass_upt_vector_width : positive := upt1_width+upt2_width+cosh_cos_width;
    constant tbpt_vector_width : positive := 2+pt1_width+pt2_width+sin_cos_width+sin_cos_width;
    constant tbupt_vector_width : positive := 2+upt1_width+upt2_width+sin_cos_width+sin_cos_width;

    signal deta_i: deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
    signal dphi_i: deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));

    signal cosh_deta: common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
    signal cos_dphi: common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));

    signal deta_bin : common_deta_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
    signal dphi_bin : common_dphi_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));

    type inverted_dr_sq_array is array(0 to nr_obj1-1, 0 to nr_obj2-1) of std_logic_vector(inverted_dr_sq_width-1 downto 0);
    signal inverted_dr_sq : inverted_dr_sq_array;

    signal inv_mass_pt_in_p: mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));

begin

    cuts_l_1: for i in 0 to nr_obj1-1 generate
        cuts_l_2: for j in 0 to nr_obj2-1 generate
            deta_sel: if deta_cut or dr_cut generate
                deta_inst: entity work.deta_cosh_deta_luts
                    generic map(
                        nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                        nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                        deta_sel => true
                    )
                    port map(
                        deta_integer => deta_integer(i,j), deta_vector => deta_i(i,j)
                    );
                deta(i,j) <= deta_i(i,j);
            end generate deta_sel;

            dphi_sel: if dphi_cut or dr_cut generate
                dphi_inst: entity work.dphi_cos_dphi_luts
                    generic map(
                        nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                        nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                        dphi_sel => true
                    )
                    port map(
                        dphi_integer => dphi_integer(i,j), dphi_vector => dphi_i(i,j)
                    );
                dphi(i,j) <= dphi_i(i,j);
            end generate dphi_sel;

            dr_sel: if dr_cut generate
                dr_calc_i: entity work.dr_calc
                    port map(
                        deta => deta_i(i,j),
                        dphi => dphi_i(i,j),
                        dr => dr(i,j)(DETA_DPHI_VECTOR_WIDTH_ALL*2-1 downto 0)
                    );
            end generate dr_sel;

            cosh_deta_sel: if mass_cut and not (mass_type = TRANSVERSE_MASS_TYPE) generate
                cosh_deta_i: entity work.deta_cosh_deta_luts
                    generic map(
                        nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                        nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                        cosh_cos_vector_width => cosh_cos_width, cosh_deta_sel => true
                    )
                    port map(
                        deta_integer => deta_integer(i,j), cosh_deta_vector => cosh_deta(i,j)
                    );
            end generate cosh_deta_sel;

            cos_dphi_sel: if mass_cut generate
                cos_dphi_i: entity work.dphi_cos_dphi_luts
                    generic map(
                        nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                        nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                        cosh_cos_vector_width => cosh_cos_width, cos_dphi_sel => true
                    )
                    port map(
                        dphi_integer => dphi_integer(i,j), cos_dphi_vector => cos_dphi(i,j)
                    );
            end generate cos_dphi_sel;

            mass_sel: if mass_cut generate
                mass_calc_i: entity work.mass_calc
                    generic map(
                        mass_type => mass_type,
                        pt1_width => pt1_width,
                        pt2_width => pt2_width,
                        upt1_width => upt1_width,
                        upt2_width => upt2_width,
                        cosh_cos_width => cosh_cos_width,
                        cosh_cos_precision => cosh_cos_precision
                    )
                    port map(
                        pt1 => pt1(i)(pt1_width-1 downto 0),
                        pt2 => pt2(j)(pt2_width-1 downto 0),
                        upt1 => upt1(i)(upt1_width-1 downto 0),
                        upt2 => upt2(j)(upt2_width-1 downto 0),
                        cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                        cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
                        inv_mass_pt => inv_mass_pt(i,j)(mass_vector_width-1 downto 0),
                        inv_mass_upt => inv_mass_upt(i,j)(mass_upt_vector_width-1 downto 0),
                        trans_mass => trans_mass(i,j)(mass_vector_width-1 downto 0)
                    );
            end generate mass_sel;

            mass_over_dr_sel: if mass_over_dr_cut generate
                deta_bin(i,j)(deta_bins_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(deta_integer(i,j), deta_bins_width);
                dphi_bin(i,j)(dphi_bins_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(dphi_integer(i,j), dphi_bins_width);
                -- one clk for ROM
                rom_lut_calo_sel: if rom_sel = CALO_CALO_ROM generate
                    rom_lut_i : rom_lut_calo_inv_dr_sq_all
                        port map (
                            clk => lhc_clk,
                            deta => deta_bin(i,j)(deta_bins_width-1 downto 0),
                            dphi => dphi_bin(i,j)(dphi_bins_width-1 downto 0),
                            dout => inverted_dr_sq(i,j)
                        );
                end generate rom_lut_calo_sel;
                rom_lut_muon_sel: if rom_sel = MU_MU_ROM generate
                    rom_lut_i : rom_lut_muon_inv_dr_sq_all
                        port map (
                            clk => lhc_clk,
                            deta => deta_bin(i,j)(deta_bins_width-1 downto 0),
                            dphi => dphi_bin(i,j)(dphi_bins_width-1 downto 0),
                            dout => inverted_dr_sq(i,j)
                        );
                end generate rom_lut_muon_sel;
                pipeline_p: process(lhc_clk, inv_mass_pt_in)
                    begin
                        if (lhc_clk'event and lhc_clk = '1') then
                            inv_mass_pt_in_p <= inv_mass_pt_in;
                        end if;
                end process;
                mass_over_dr_calc_i: entity work.mass_over_dr_calc
                    generic map(
                        mass_vector_width,
                        inverted_dr_sq_width
                    )
                    port map(
                        inv_mass_pt_in_p(i,j)(mass_vector_width-1 downto 0),
                        inverted_dr_sq(i,j)(inverted_dr_sq_width-1 downto 0),
                        mass_over_dr(i,j)
                    );
            end generate mass_over_dr_sel;

            tbpt_sel: if tbpt_cut generate
                twobody_pt_calc_i: entity work.tbpt_calc
                    generic map(
                        pt1_width => pt1_width,
                        pt2_width => pt2_width,
                        upt1_width => upt1_width,
                        upt2_width => upt2_width,
                        sin_cos_width => sin_cos_width,
                        sin_cos_precision => sin_cos_precision
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
                        tbpt => tbpt(i,j)(tbpt_vector_width-1 downto 0),
                        tbupt => tbupt(i,j)(tbupt_vector_width-1 downto 0)
                );
            end generate tbpt_sel;
        end generate cuts_l_2;
    end generate cuts_l_1;

end architecture rtl;
