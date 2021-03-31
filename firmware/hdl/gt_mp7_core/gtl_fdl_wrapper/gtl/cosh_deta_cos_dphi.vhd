
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
        deta_bins_width: natural := EG_EG_DETA_BINS_WIDTH;
        dphi_bins_width: natural := EG_EG_DPHI_BINS_WIDTH;
        cosh_cos_vector_width: natural := EG_EG_COSH_COS_VECTOR_WIDTH;
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE
    );
    port(
        dphi_integer: in dim2_max_phi_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        deta_integer: in dim2_max_eta_range_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => 0));
        deta_bin_vector: out common_deta_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi_bin_vector: out common_dphi_bin_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cosh_deta_vector: out common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi_vector: out common_cosh_cos_vector_array(0 to nr_obj1-1, 0 to nr_obj2-1) := (others => (others => (others => '0')))
    );
end cosh_deta_cos_dphi;

architecture rtl of cosh_deta_cos_dphi is

begin

    cosh_cos_l1: for i in 0 to nr_obj1-1 generate
        cosh_cos_l2: for j in 0 to nr_obj2-1 generate
            calo_calo_i: if type_obj1 /= MU_TYPE and (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE) generate
                cosh_deta_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cosh_deta_lut(deta_integer(i,j)), cosh_cos_vector_width);
                cos_dphi_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer(i,j)), cosh_cos_vector_width);
            end generate calo_calo_i;
            calo_esums_i: if type_obj1 /= MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
                cos_dphi_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer(i,j)), cosh_cos_vector_width);
            end generate calo_esums_i;
            calo_muon_i: if type_obj1 /= MU_TYPE and type_obj2 = MU_TYPE generate
                cosh_deta_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cosh_deta_lut(deta_integer(i,j)), cosh_cos_vector_width);
                cos_dphi_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer(i,j)), cosh_cos_vector_width);
            end generate calo_muon_i;
            muon_esums_i: if type_obj1 = MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
                cos_dphi_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer(i,j)), cosh_cos_vector_width);
            end generate muon_esums_i;
            muon_muon_i: if type_obj1 = MU_TYPE and type_obj2 = MU_TYPE generate
                cosh_deta_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(muon_muon_cosh_deta_lut(deta_integer(i,j)), cosh_cos_vector_width);
                cos_dphi_vector(i,j)(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(muon_muon_cos_dphi_lut(dphi_integer(i,j)), cosh_cos_vector_width);
            end generate muon_muon_i;
            deta_bin_vector(i,j)(deta_bins_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(deta_integer(i,j), deta_bins_width);
            dphi_bin_vector(i,j)(dphi_bins_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(dphi_integer(i,j), dphi_bins_width);
        end generate cosh_cos_l2;
    end generate cosh_cos_l1;

end architecture rtl;
