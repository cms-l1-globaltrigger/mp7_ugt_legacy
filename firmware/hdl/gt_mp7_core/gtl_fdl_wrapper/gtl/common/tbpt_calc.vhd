
-- Desription:
-- Calculation of "twobody_pt" (pt**2) based on LUTs.

-- Version history:
-- HB 2021-04-13: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity tbpt_calc is
    generic (
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        upt1_width: positive := 12;
        upt2_width: positive := 12;
        sin_cos_width: positive := 11;
        sin_cos_precision : positive := 3
    );
    port(
        pt1 : in std_logic_vector(pt1_width-1 downto 0) := (others => '0');
        pt2 : in std_logic_vector(pt2_width-1 downto 0) := (others => '0');
        upt1 : in std_logic_vector(upt1_width-1 downto 0) := (others => '0');
        upt2 : in std_logic_vector(upt2_width-1 downto 0) := (others => '0');
        cos_phi_1_integer : in integer;
        cos_phi_2_integer : in integer;
        sin_phi_1_integer : in integer;
        sin_phi_2_integer : in integer;
        tbpt : out std_logic_vector(2+pt1_width+pt2_width+sin_cos_width+sin_cos_width-1 downto 0) := (others => '0');
        tbupt : out std_logic_vector(2+upt1_width+upt2_width+sin_cos_width+sin_cos_width-1 downto 0) := (others => '0')
    );
end tbpt_calc;

architecture rtl of tbpt_calc is

-- HB 2017-03-23: calculation of twobody_pt with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- PT_SQ_VECTOR_WIDTH based on formular for pt**2 [2+... because of ...+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))]
    constant PT_SQ_VECTOR_WIDTH : positive := 2+pt1_width+pt2_width+sin_cos_width+sin_cos_width;
    signal pt1_square : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);
    signal pt2_square : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);

    signal cos_plus_sin_integer : integer;
    signal cos_plus_sin_vec_temp : std_logic_vector(sin_cos_width+sin_cos_width-1 downto 0);
    signal cos_plus_sin_vec : std_logic_vector(sin_cos_width+sin_cos_width-1 downto 0);
    signal pt1_x_pt2_x_cos_plus_sin_temp : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);
    signal pt1_x_pt2_x_cos_plus_sin : std_logic_vector(PT_SQ_VECTOR_WIDTH-1 downto 0);

    constant UPT_SQ_VECTOR_WIDTH : positive := 2+upt1_width+upt2_width+sin_cos_width+sin_cos_width;
    signal upt1_square : std_logic_vector(UPT_SQ_VECTOR_WIDTH-1 downto 0);
    signal upt2_square : std_logic_vector(UPT_SQ_VECTOR_WIDTH-1 downto 0);

    signal upt1_x_upt2_x_cos_plus_sin_temp : std_logic_vector(UPT_SQ_VECTOR_WIDTH-1 downto 0);
    signal upt1_x_upt2_x_cos_plus_sin : std_logic_vector(UPT_SQ_VECTOR_WIDTH-1 downto 0);

-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead attribute
    attribute use_dsp : string;
    attribute use_dsp of cos_plus_sin_integer : signal is "yes";
    attribute use_dsp of pt1_x_pt2_x_cos_plus_sin_temp : signal is "yes";
    attribute use_dsp of upt1_x_upt2_x_cos_plus_sin_temp : signal is "yes";
--     attribute use_dsp of pt_square : signal is "yes";

begin

-- HB 2017-03-23: calculation of pt**2 with formular => pt**2 = pt1**2+pt2**2+2*pt1*pt2*(cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
-- in VHDL used: cos_plus_sin_integer = (cos(phi1)*cos(phi2)+sin(phi1)*sin(phi2))
--               conversion cos_plus_sin_integer to cos_plus_sin_vec, depending on pos. or neg. value of cos_plus_sin_integer
--               pt_square = pt1**2+pt2**2+2*pt1*pt2*cos_plus_sin_vec

-- calculation tbpt
    pt1_square <= pt1 * pt1 * conv_std_logic_vector(10**(sin_cos_precision*2), PT_SQ_VECTOR_WIDTH-pt1_width*2);
    pt2_square <= pt2 * pt2 * conv_std_logic_vector(10**(sin_cos_precision*2), PT_SQ_VECTOR_WIDTH-pt2_width*2);
--     pt1_square <= pt1 * pt1;
--     pt2_square <= pt2 * pt2;

    cos_plus_sin_integer <= (cos_phi_1_integer * cos_phi_2_integer) + (sin_phi_1_integer * sin_phi_2_integer);

    cos_plus_sin_vec_temp <= CONV_STD_LOGIC_VECTOR(cos_plus_sin_integer, sin_cos_width+sin_cos_width);

-- HB 2017-03-22: use two's complement when cos_plus_sin_vec_temp is negative
    cos_plus_sin_vec <= cos_plus_sin_vec_temp when cos_plus_sin_vec_temp(cos_plus_sin_vec_temp'high) = '0' else (not(cos_plus_sin_vec_temp)+1);

    pt1_x_pt2_x_cos_plus_sin_temp <= conv_std_logic_vector(2,2) * pt1 * pt2 * cos_plus_sin_vec;
-- HB 2017-03-22: use two's complement for pt1_x_pt2_x_cos_plus_sin when cos_plus_sin_vec_temp is negative
    pt1_x_pt2_x_cos_plus_sin <= pt1_x_pt2_x_cos_plus_sin_temp when cos_plus_sin_vec_temp(cos_plus_sin_vec_temp'high) = '0' else (not(pt1_x_pt2_x_cos_plus_sin_temp)+1);

    tbpt <= pt1_square + pt2_square + pt1_x_pt2_x_cos_plus_sin;

-- calculation tbupt
    upt1_square <= upt1 * upt1 * conv_std_logic_vector(10**(sin_cos_precision*2), UPT_SQ_VECTOR_WIDTH-upt1_width*2);
    upt2_square <= upt2 * upt2 * conv_std_logic_vector(10**(sin_cos_precision*2), UPT_SQ_VECTOR_WIDTH-upt2_width*2);
--     upt1_square <= upt1 * upt1;
--     upt2_square <= upt2 * upt2;

    upt1_x_upt2_x_cos_plus_sin_temp <= conv_std_logic_vector(2,2) * upt1 * upt2 * cos_plus_sin_vec;
-- HB 2017-03-22: use two's complement for pt1_x_pt2_x_cos_plus_sin when cos_plus_sin_vec_temp is negative
    upt1_x_upt2_x_cos_plus_sin <= upt1_x_upt2_x_cos_plus_sin_temp when cos_plus_sin_vec_temp(cos_plus_sin_vec_temp'high) = '0' else (not(upt1_x_upt2_x_cos_plus_sin_temp)+1);

    tbupt <= upt1_square + upt2_square + upt1_x_upt2_x_cos_plus_sin;

end architecture rtl;
