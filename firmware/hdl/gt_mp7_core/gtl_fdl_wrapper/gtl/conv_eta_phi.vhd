
-- Description:
-- Eta and phi conversion to muon scale (for calo-muon and muon-esums correlation conditions)

-- Version history:
-- HB 2021-02-17: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

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
            eta_conv(i) <= EG_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low)));
            phi_conv(i) <= EG_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low)));
        end generate eg_i;
        jet_i: if type_obj = JET_TYPE generate
            eta_conv(i) <= JET_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low)));
            phi_conv(i) <= JET_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low)));
        end generate jet_i;
        tau_i: if type_obj = TAU_TYPE generate
            eta_conv(i) <= TAU_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(calo(i)(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low)));
            phi_conv(i) <= TAU_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(calo(i)(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low)));
        end generate tau_i;
    end generate conv_l;

    etm_i: if type_obj = ETM_TYPE generate
        phi_conv(0) <= ETM_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(D_S_I_ETM_V2.phi_high downto D_S_I_ETM_V2.phi_low)));
    end generate etm_i;
    htm_i: if type_obj = HTM_TYPE generate
        phi_conv(0) <= HTM_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(D_S_I_HTM_V2.phi_high downto D_S_I_HTM_V2.phi_low)));
    end generate htm_i;
    etmhf_i: if type_obj = ETMHF_TYPE generate
        phi_conv(0) <= ETMHF_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(D_S_I_ETMHF_V2.phi_high downto D_S_I_ETMHF_V2.phi_low)));
    end generate etmhf_i;
    htmhf_i: if type_obj = HTMHF_TYPE generate
        phi_conv(0) <= HTMHF_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(esums(D_S_I_HTMHF_V2.phi_high downto D_S_I_HTMHF_V2.phi_low)));
    end generate htmhf_i;

end architecture rtl;
