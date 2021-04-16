
-- Description:
-- Calculation of cosh deta and cos dphi for mass

-- Version history:
-- HB 2021-02-18: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity cosh_deta_cos_dphi is
     generic(
        calo_calo_cosh_deta_lut: calo_calo_cosh_deta_lut_array := (others => 0);
        calo_calo_cos_dphi_lut: calo_calo_cos_dphi_lut_array := (others => 0);
        calo_muon_cosh_deta_lut: calo_muon_cosh_deta_lut_array := (others => 0);
        calo_muon_cos_dphi_lut: calo_muon_cos_dphi_lut_array := (others => 0);
        muon_muon_cosh_deta_lut: muon_muon_cosh_deta_lut_array := (others => 0);
        muon_muon_cos_dphi_lut: muon_muon_cos_dphi_lut_array := (others => 0);
        cosh_cos_vector_width: natural := EG_EG_COSH_COS_VECTOR_WIDTH;
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE
    );
    port(
        dphi_integer: in dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        deta_integer: in dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        cosh_deta_vector: out common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi_vector: out common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end cosh_deta_cos_dphi;

architecture rtl of cosh_deta_cos_dphi is

begin

    cosh_cos_l1: for i in 0 to nr_obj1-1 generate
        cosh_cos_l2: for j in 0 to nr_obj2-1 generate
            deta_dphi_vector_i: entity work.deta_dphi_vector
                generic map(
                    calo_calo_cosh_deta_lut => calo_calo_cosh_deta_lut, calo_calo_cos_dphi_lut => calo_calo_cos_dphi_lut,
                    calo_muon_cosh_deta_lut => calo_muon_cosh_deta_lut, calo_muon_cos_dphi_lut => calo_muon_cos_dphi_lut,
                    muon_muon_cosh_deta_lut => muon_muon_cosh_deta_lut, muon_muon_cos_dphi_lut => muon_muon_cos_dphi_lut,
                    nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                    nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                    cosh_cos_vector_width => cosh_cos_vector_width, cosh_deta_cos_dphi_sel => true
                )
                port map(deta_integer => deta_integer(i,j), dphi_integer => dphi_integer(i,j),
                    cosh_deta_vector => cosh_deta_vector(i,j), cos_dphi_vector => cos_dphi_vector(i,j)
                );
        end generate cosh_cos_l2;
    end generate cosh_cos_l1;

end architecture rtl;
