
-- Description:
-- Calculation of differences in eta [deta] and phi [dphi]

-- Version history:
-- HB 2021-02-17: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity deta_dphi_calculations is
     generic(
        phi_half_range: natural := CALO_PHI_HALF_RANGE_BINS;
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1 : natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2 : natural := EG_TYPE
    );
    port(
        eta_integer_obj1: in integer_array(0 to nr_obj1-1) := (others => 0);
        phi_integer_obj1: in integer_array(0 to nr_obj1-1) := (others => 0);
        eta_integer_obj2: in integer_array(0 to nr_obj2-1) := (others => 0);
        phi_integer_obj2: in integer_array(0 to nr_obj2-1) := (others => 0);
        deta_integer: out dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        dphi_integer: out dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0))
    );
end deta_dphi_calculations;

architecture rtl of deta_dphi_calculations is

    signal deta_integer_int: dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
    signal dphi_integer_int: dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));

begin

    not_esums_i: if type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE generate
        deta_i: entity work.deta_calc
            generic map(nr_obj1, nr_obj2)
            port map(eta_integer_obj1, eta_integer_obj2, deta_integer);
    end generate not_esums_i;
    dphi_i: entity work.dphi_calc
        generic map(nr_obj1, nr_obj2, phi_half_range)
        port map(phi_integer_obj1, phi_integer_obj2, dphi_integer);

end architecture rtl;
