
-- Description:
-- Eta and phi conversion to muon scale (for calo-muon and muon-esums correlation conditions)

-- Version history:
-- HB 2022-09-05: cleaned up.
-- HB 2021-05-18: added use clause gtl_luts_pkg. Changed slice parameter.
-- HB 2021-02-17: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.gtl_luts_pkg.all;

entity conv_eta_phi is
     generic(
        nr_obj: natural := NR_EG_OBJECTS;
        type_obj : natural := EG_TYPE
    );
    port(
        calo: in calo_objects_array(0 to nr_obj-1) := (others => (others => '0'));
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        eta_conv: out integer_array(0 to nr_obj-1) := (others => 0);
        phi_conv: out integer_array(0 to nr_obj-1) := (others => 0)
    );
end conv_eta_phi;

architecture rtl of conv_eta_phi is

begin

    conv_l: for i in 0 to nr_obj-1 generate
        eg_i: if type_obj = EG_TYPE generate
            eta_conv(i) <= EG_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(EG_ETA_HIGH downto EG_ETA_LOW)));
            phi_conv(i) <= EG_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(EG_PHI_HIGH downto EG_PHI_LOW)));
        end generate eg_i;
        jet_i: if type_obj = JET_TYPE generate
            eta_conv(i) <= JET_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(JET_ETA_HIGH downto JET_ETA_LOW)));
            phi_conv(i) <= JET_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(JET_PHI_HIGH downto JET_PHI_LOW)));
        end generate jet_i;
        tau_i: if type_obj = TAU_TYPE generate
            eta_conv(i) <= TAU_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(TAU_ETA_HIGH downto TAU_ETA_LOW)));
            phi_conv(i) <= TAU_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(TAU_PHI_HIGH downto TAU_PHI_LOW)));
        end generate tau_i;
    end generate conv_l;

    etm_i: if type_obj = ETM_TYPE generate
        phi_conv(0) <= ETM_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(ETM_PHI_HIGH downto ETM_PHI_LOW)));
    end generate etm_i;
    htm_i: if type_obj = HTM_TYPE generate
        phi_conv(0) <= HTM_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(HTM_PHI_HIGH downto HTM_PHI_LOW)));
    end generate htm_i;
    etmhf_i: if type_obj = ETMHF_TYPE generate
        phi_conv(0) <= ETMHF_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(ETMHF_PHI_HIGH downto ETMHF_PHI_LOW)));
    end generate etmhf_i;
    htmhf_i: if type_obj = HTMHF_TYPE generate
        phi_conv(0) <= HTMHF_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(HTMHF_PHI_HIGH downto HTMHF_PHI_LOW)));
    end generate htmhf_i;

end architecture rtl;
