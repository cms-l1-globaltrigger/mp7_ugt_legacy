
-- Description:
-- LUTs of dphi and cos_dphi.

-- Version history:
-- HB 2021-02-27: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity dphi_cos_dphi_luts is
     generic(
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;
        dphi_sel: boolean := false;
        cosh_cos_vector_width: natural := CALO_CALO_COSH_COS_VECTOR_WIDTH;
        cos_dphi_sel: boolean := false
    );
    port(
        dphi_integer: in integer := 0;
        dphi_vector: out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        cos_dphi_vector: out std_logic_vector(COMMON_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0')
    );
end dphi_cos_dphi_luts;

architecture rtl of dphi_cos_dphi_luts is

begin

    calo_calo_i: if type_obj1 /= MU_TYPE and (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE) generate
        dphi_sel_i: if dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_calo_diff_phi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate dphi_sel_i;
        cos_dphi_sel_i: if cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cos_dphi_sel_i;
    end generate calo_calo_i;
    calo_esums_i: if type_obj1 /= MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
        dphi_sel_i: if dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_calo_diff_phi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate dphi_sel_i;
        cos_dphi_sel_i: if cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cos_dphi_sel_i;
    end generate calo_esums_i;
    calo_muon_i: if type_obj1 /= MU_TYPE and type_obj2 = MU_TYPE generate
        dphi_sel_i: if dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_mu_diff_phi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate dphi_sel_i;
        cos_dphi_sel_i: if cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cos_dphi_sel_i;
    end generate calo_muon_i;
    muon_esums_i: if type_obj1 = MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
        dphi_sel_i: if dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_mu_diff_phi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate dphi_sel_i;
        cos_dphi_sel_i: if cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cos_dphi_sel_i;
    end generate muon_esums_i;
    muon_muon_i: if type_obj1 = MU_TYPE and type_obj2 = MU_TYPE generate
        dphi_sel_i: if dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(mu_mu_diff_phi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate dphi_sel_i;
        cos_dphi_sel_i: if cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(mu_mu_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cos_dphi_sel_i;
    end generate muon_muon_i;

end architecture rtl;
