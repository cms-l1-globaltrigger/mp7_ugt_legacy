
-- Description:
-- LUTs of deta, dphi, cosh_deta and cos_dphi.

-- Version history:
-- HB 2021-04-19: renamed.
-- HB 2021-02-17: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity deta_dphi_cosh_cos_luts is
     generic(
        calo_calo_deta_lut: calo_calo_diff_eta_lut_array := (others => 0);
        calo_calo_dphi_lut: calo_calo_diff_phi_lut_array := (others => 0);
        calo_muon_deta_lut: calo_muon_diff_eta_lut_array := (others => 0);
        calo_muon_dphi_lut: calo_muon_diff_phi_lut_array := (others => 0);
        muon_muon_deta_lut: muon_muon_diff_eta_lut_array := (others => 0);
        muon_muon_dphi_lut: muon_muon_diff_phi_lut_array := (others => 0);
        calo_calo_cosh_deta_lut: calo_calo_cosh_deta_lut_array := (others => 0);
        calo_calo_cos_dphi_lut: calo_calo_cos_dphi_lut_array := (others => 0);
        calo_muon_cosh_deta_lut: calo_muon_cosh_deta_lut_array := (others => 0);
        calo_muon_cos_dphi_lut: calo_muon_cos_dphi_lut_array := (others => 0);
        muon_muon_cosh_deta_lut: muon_muon_cosh_deta_lut_array := (others => 0);
        muon_muon_cos_dphi_lut: muon_muon_cos_dphi_lut_array := (others => 0);
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;
        deta_dphi_sel: boolean := false;
        cosh_cos_vector_width: natural := EG_EG_COSH_COS_VECTOR_WIDTH;
        cosh_deta_cos_dphi_sel: boolean := false
    );
    port(
        deta_integer: in integer := 0;
        dphi_integer: in integer := 0;
        deta_vector: out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        dphi_vector: out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        cosh_deta_vector: out std_logic_vector(COMMON_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0');
        cos_dphi_vector: out std_logic_vector(COMMON_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0')
    );
end deta_dphi_cosh_cos_luts;

architecture rtl of deta_dphi_cosh_cos_luts is

begin

    calo_calo_i: if type_obj1 /= MU_TYPE and (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE) generate
        deta_dphi_sel_i: if deta_dphi_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(calo_calo_deta_lut(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_calo_dphi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_dphi_sel_i;
        cosh_deta_cos_dphi_sel_i: if cosh_deta_cos_dphi_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cosh_deta_lut(deta_integer), cosh_cos_vector_width);
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cosh_deta_cos_dphi_sel_i;
    end generate calo_calo_i;
    calo_esums_i: if type_obj1 /= MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
        deta_dphi_sel_i: if deta_dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_calo_dphi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_dphi_sel_i;
        cosh_deta_cos_dphi_sel_i: if cosh_deta_cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_calo_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cosh_deta_cos_dphi_sel_i;
    end generate calo_esums_i;
    calo_muon_i: if type_obj1 /= MU_TYPE and type_obj2 = MU_TYPE generate
        deta_dphi_sel_i: if deta_dphi_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(calo_muon_deta_lut(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_muon_dphi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_dphi_sel_i;
        cosh_deta_cos_dphi_sel_i: if cosh_deta_cos_dphi_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cosh_deta_lut(deta_integer), cosh_cos_vector_width);
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cosh_deta_cos_dphi_sel_i;
    end generate calo_muon_i;
    muon_esums_i: if type_obj1 = MU_TYPE and not (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE or type_obj2 = MU_TYPE) generate
        deta_dphi_sel_i: if deta_dphi_sel generate
            dphi_vector <= CONV_STD_LOGIC_VECTOR(calo_muon_dphi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_dphi_sel_i;
        cosh_deta_cos_dphi_sel_i: if cosh_deta_cos_dphi_sel generate
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(calo_muon_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cosh_deta_cos_dphi_sel_i;
    end generate muon_esums_i;
    muon_muon_i: if type_obj1 = MU_TYPE and type_obj2 = MU_TYPE generate
        deta_dphi_sel_i: if deta_dphi_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(muon_muon_deta_lut(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
            dphi_vector <= CONV_STD_LOGIC_VECTOR(muon_muon_dphi_lut(dphi_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_dphi_sel_i;
        cosh_deta_cos_dphi_sel_i: if cosh_deta_cos_dphi_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(muon_muon_cosh_deta_lut(deta_integer), cosh_cos_vector_width);
            cos_dphi_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(muon_muon_cos_dphi_lut(dphi_integer), cosh_cos_vector_width);
        end generate cosh_deta_cos_dphi_sel_i;
    end generate muon_muon_i;

end architecture rtl;
