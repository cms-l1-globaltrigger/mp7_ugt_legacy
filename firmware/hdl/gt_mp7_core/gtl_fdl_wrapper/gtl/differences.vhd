
-- Description:
-- Calculation of differences for eta [deta] and phi [dphi]

-- Version history:
-- HB 2021-02-17: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity differences is
     generic(
        calo_calo_deta_lut: calo_calo_diff_eta_lut_array := (others => 0);
        calo_calo_dphi_lut: calo_calo_diff_phi_lut_array := (others => 0);
        calo_muon_deta_lut: calo_muon_diff_eta_lut_array := (others => 0);
        calo_muon_dphi_lut: calo_muon_diff_phi_lut_array := (others => 0);
        muon_muon_deta_lut: muon_muon_diff_eta_lut_array := (others => 0);
        muon_muon_dphi_lut: muon_muon_diff_phi_lut_array := (others => 0);
        phi_half_range: natural := CALO_PHI_HALF_RANGE_BINS;
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1 : natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2 : natural := EG_TYPE
    );
    port(
        eta_integer_obj1: in diff_integer_inputs_array(0 to nr_obj1-1) := (others => 0);
        phi_integer_obj1: in diff_integer_inputs_array(0 to nr_obj1-1) := (others => 0);
        eta_integer_obj2: in diff_integer_inputs_array(0 to nr_obj2-1) := (others => 0);
        phi_integer_obj2: in diff_integer_inputs_array(0 to nr_obj2-1) := (others => 0);
        deta_integer: out dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        deta_vector: out deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_integer: out dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        dphi_vector: out deta_dphi_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end differences;

architecture rtl of differences is

    signal deta_integer_int: dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
    signal dphi_integer_int: dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));

begin

    not_esums_i: if type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE generate
        deta_i: entity work.sub_eta_integer_obj_vs_obj
            generic map(nr_obj1, nr_obj2)
            port map(eta_integer_obj1, eta_integer_obj2, deta_integer_int);
    end generate not_esums_i;
    dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(nr_obj1, nr_obj2, phi_half_range)
        port map(phi_integer_obj1, phi_integer_obj2, dphi_integer_int);
    l1: for i in 0 to nr_obj1-1 generate
        l2: for j in 0 to nr_obj2-1 generate
--             not_esums_i: if type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE generate
--                 deta_i: entity work.deta_calc
--                     port map(eta_integer_obj1(i), eta_integer_obj2(j), deta_integer_int(i,j));
--             end generate not_esums_i;
--             dphi_i: entity work.dphi_calc
--                 generic map(phi_half_range)
--                 port map(phi_integer_obj1(i), phi_integer_obj2(j), dphi_integer_int(i,j));
            deta_dphi_vector_i: entity work.deta_dphi_vector
                generic map(
                    calo_calo_deta_lut => calo_calo_deta_lut, calo_calo_dphi_lut => calo_calo_dphi_lut,
                    calo_muon_deta_lut => calo_muon_deta_lut, calo_muon_dphi_lut => calo_muon_dphi_lut,
                    muon_muon_deta_lut => muon_muon_deta_lut, muon_muon_dphi_lut => muon_muon_dphi_lut,
                    nr_obj1 => nr_obj1, type_obj1 => type_obj1,
                    nr_obj2 => nr_obj2, type_obj2 => type_obj2,
                    deta_dphi_sel => true
                )
                port map(deta_integer => deta_integer_int(i,j), dphi_integer => dphi_integer_int(i,j),
                    deta_vector => deta_vector(i,j), dphi_vector => dphi_vector(i,j)
                );
        end generate l2;
    end generate l1;

    deta_integer <= deta_integer_int;
    dphi_integer <= dphi_integer_int;

end architecture rtl;
