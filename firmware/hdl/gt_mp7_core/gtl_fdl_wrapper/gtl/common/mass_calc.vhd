
-- Description:
-- Calculation of invariant mass or transverse mass based on LUTs.

-- Version history:
-- HB 2021-04-06: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity mass_calc is
    generic (
        mass_type : natural;
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        upt1_width: positive := 12;
        upt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        cosh_cos_precision : positive := 3
    );
    port(
        pt1 : in std_logic_vector(pt1_width-1 downto 0);
        pt2 : in std_logic_vector(pt2_width-1 downto 0);
        upt1 : in std_logic_vector(upt1_width-1 downto 0) := (others => '0');
        upt2 : in std_logic_vector(upt2_width-1 downto 0) := (others => '0');
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0) := (others => '0');
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        inv_mass_pt : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0) := (others => '0');
        inv_mass_upt : out std_logic_vector(upt1_width+upt2_width+cosh_cos_width-1 downto 0) := (others => '0');
        trans_mass : out std_logic_vector(pt1_width+pt2_width+cosh_cos_width-1 downto 0) := (others => '0')
    );
end mass_calc;

architecture rtl of mass_calc is

-- HB 2015-10-21: length of std_logic_vector for invariant mass (invariant_mass_sq_div2) and limits.
    constant MASS_PT_VECTOR_WIDTH : positive := pt1_width+pt2_width+cosh_cos_width;
    constant MASS_UPT_VECTOR_WIDTH : positive := upt1_width+upt2_width+cosh_cos_width;

    signal inv_mass_pt_sq_div2 : std_logic_vector(MASS_PT_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal inv_mass_upt_sq_div2 : std_logic_vector(MASS_UPT_VECTOR_WIDTH-1 downto 0) := (others => '0');
    signal trans_mass_sq_div2 : std_logic_vector(MASS_PT_VECTOR_WIDTH-1 downto 0) := (others => '0');

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of inv_mass_pt_sq_div2 : signal is "yes";
    attribute use_dsp of inv_mass_upt_sq_div2 : signal is "yes";
    attribute use_dsp of trans_mass_sq_div2 : signal is "yes";

begin

    invariant_mass_sel: if mass_type = INVARIANT_MASS_TYPE generate
    -- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
        inv_mass_pt_sq_div2 <= pt1 * pt2 * (cosh_deta - cos_dphi);
        inv_mass_pt <= inv_mass_pt_sq_div2;
    end generate invariant_mass_sel;
    invariant_mass_upt_sel: if mass_type = INVARIANT_MASS_UPT_TYPE generate
        inv_mass_upt_sq_div2 <= upt1 * upt2 * (cosh_deta - cos_dphi);
        inv_mass_upt <= inv_mass_upt_sq_div2;
    end generate invariant_mass_upt_sel;
    transverse_mass_sel: if mass_type = TRANSVERSE_MASS_TYPE generate
    -- HB 2016-12-12: calculation of transverse mass with formular M**2/2=pt1*pt2*(1-cos(phi1-phi2))
    --                "conv_std_logic_vector((10**cosh_cos_precision), cosh_cos_width)" means 1 multiplied with 10**cosh_cos_precision,
    --                converted to std_logic_vector with cosh_cos_width
        trans_mass_sq_div2 <= pt1 * pt2 * ((conv_std_logic_vector((10**cosh_cos_precision), cosh_cos_width)) - cos_dphi);
        trans_mass <= trans_mass_sq_div2;
    end generate transverse_mass_sel;

end architecture rtl;
