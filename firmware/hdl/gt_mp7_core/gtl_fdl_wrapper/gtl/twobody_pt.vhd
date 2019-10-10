
-- Desription:
-- Module for calculation of all twobody_pt.

-- Version history:
-- HB 2019-05-02: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity twobody_pt is
     generic(
        calo_object_slice_1_low: natural;
        calo_object_slice_1_high: natural;
        calo_object_slice_2_low: natural;
        calo_object_slice_2_high: natural;
        nr_templates: positive;
        
        twobody_pt_cut: boolean := false;
        pt_width: positive := 1; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := 1;
        pt_sq_sin_cos_precision : positive := 1
    );
    port(
        pt : in diff_inputs_array(0 to MAX_CALO_OBJECTS) := (others => (others => '0'));
        cos_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0);
        sin_phi_integer : in sin_cos_integer_array(0 to MAX_CALO_OBJECTS) := (others => 0);
        twobody_pt_comp : out std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high) := (others => (others => '1'))
    );
end twobody_pt;

architecture rtl of twobody_pt is
        
    signal twobody_pt_comp_temp : std_logic_2dim_array(calo_object_slice_1_low to calo_object_slice_1_high, calo_object_slice_2_low to calo_object_slice_2_high);

begin

    twobody_pt_l_1: for i in calo_object_slice_1_low to calo_object_slice_1_high generate 
        twobody_pt_l_2: for j in calo_object_slice_2_low to calo_object_slice_2_high generate
            if_j_gr_i: if j > i generate
                twobody_pt_calculator_i: entity work.twobody_pt_calculator
                    generic map(
                        pt1_width => pt_width, 
                        pt2_width => pt_width, 
                        pt_sq_threshold_vector => pt_sq_threshold_vector,
                        sin_cos_width => sin_cos_width,
                        pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                    )
                    port map(
                        pt1 => pt(i)(pt_width-1 downto 0),
                        pt2 => pt(j)(pt_width-1 downto 0),
                        cos_phi_1_integer => cos_phi_integer(i),
                        cos_phi_2_integer => cos_phi_integer(j),
                        sin_phi_1_integer => sin_phi_integer(i),
                        sin_phi_2_integer => sin_phi_integer(j),
                        pt_square_comp => twobody_pt_comp_temp(i,j)
                );
                twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
            end generate if_j_gr_i;
        end generate twobody_pt_l_2;
    end generate twobody_pt_l_1;

end architecture rtl;
