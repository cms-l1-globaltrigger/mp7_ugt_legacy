
-- Description:
-- LUTs of deta and cosh_deta.

-- Version history:
-- HB 2022-09-06: cleaned up.
-- HB 2021-05-18: added use clause gtl_luts_pkg. Changed slice parameter.
-- HB 2021-02-27: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

use work.gtl_pkg.all;
use work.gtl_luts_pkg.all;

entity deta_cosh_deta_luts is
     generic(
        nr_obj1: natural := NR_EG_OBJECTS;
        type_obj1: natural := EG_TYPE;
        nr_obj2: natural := NR_EG_OBJECTS;
        type_obj2: natural := EG_TYPE;
        deta_sel: boolean := false;
        cosh_cos_vector_width: natural := CALO_CALO_COSH_COS_VECTOR_WIDTH;
        cosh_deta_sel: boolean := false
    );
    port(
        deta_integer: in integer := 0;
        deta_vector: out std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) := (others => '0');
        cosh_deta_vector: out std_logic_vector(COMMON_COSH_COS_VECTOR_WIDTH-1 downto 0) := (others => '0')
    );
end deta_cosh_deta_luts;

architecture rtl of deta_cosh_deta_luts is

begin

    calo_calo_i: if type_obj1 /= MU_TYPE and (type_obj2 = EG_TYPE or type_obj2 = JET_TYPE or type_obj2 = TAU_TYPE) generate
        deta_sel_i: if deta_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_ETA_LUT(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_sel_i;
        cosh_deta_sel_i: if cosh_deta_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(deta_integer), cosh_cos_vector_width);
        end generate cosh_deta_sel_i;
    end generate calo_calo_i;
    calo_muon_i: if type_obj1 /= MU_TYPE and type_obj2 = MU_TYPE generate
        deta_sel_i: if deta_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_ETA_LUT(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_sel_i;
        cosh_deta_sel_i: if cosh_deta_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_DETA_LUT(deta_integer), cosh_cos_vector_width);
        end generate cosh_deta_sel_i;
    end generate calo_muon_i;
    muon_muon_i: if type_obj1 = MU_TYPE and type_obj2 = MU_TYPE generate
        deta_sel_i: if deta_sel generate
            deta_vector <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(deta_integer),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate deta_sel_i;
        cosh_deta_sel_i: if cosh_deta_sel generate
            cosh_deta_vector(cosh_cos_vector_width-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(deta_integer), cosh_cos_vector_width);
        end generate cosh_deta_sel_i;
    end generate muon_muon_i;

end architecture rtl;
