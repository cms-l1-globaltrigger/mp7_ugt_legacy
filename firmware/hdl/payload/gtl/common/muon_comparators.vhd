
-- Description:
-- Comparators for transverse momentum, pseudorapidity, azimuth angle, quality and isolation of muon objects

-- Version history:
-- HB 2023-02-14: inserted cut for index bits.
-- HB 2022-09-06: cleaned up.
-- HB 2021-05-18: changed slice parameter.
-- HB 2021-03-06: removed "invalid_muon".
-- HB 2021-02-24: changed "no_muon" to "invalid_muon".
-- HB 2021-02-19: added output register (with selection).
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now.
-- HB 2020-06-08: inserted comparators for "unconstraint pt" [upt] and "impact parameter" [ip] of new muon structure.
-- HB 2019-06-14: updated for "five eta cuts". Used phi_windows_comp.
-- HB 2019-06-14: updated for "five eta cuts". Used phi_windows_comp.
-- HB 2019-05-06: renamed from muon_comparators_v2 to muon_comparators.
-- HB 2015-09-24: renamed to "muon_comparators_v2" for removing "d_s_i" from generic. These constants used directly from gtl.pkg now.
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity muon_comparators is
	generic	(
        pt_ge_mode : boolean;
        pt_threshold: std_logic_vector;
        nr_eta_windows : natural;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        eta_w3_upper_limit : std_logic_vector;
        eta_w3_lower_limit : std_logic_vector;
        eta_w4_upper_limit : std_logic_vector;
        eta_w4_lower_limit : std_logic_vector;
        eta_w5_upper_limit : std_logic_vector;
        eta_w5_lower_limit : std_logic_vector;
        nr_idx_windows : natural;
        idx_w1_upper_limit : std_logic_vector;
        idx_w1_lower_limit : std_logic_vector;
        idx_w2_upper_limit : std_logic_vector;
        idx_w2_lower_limit : std_logic_vector;
        idx_w3_upper_limit : std_logic_vector;
        idx_w3_lower_limit : std_logic_vector;
        idx_w4_upper_limit : std_logic_vector;
        idx_w4_lower_limit : std_logic_vector;
        idx_w5_upper_limit : std_logic_vector;
        idx_w5_lower_limit : std_logic_vector;
        nr_phi_windows : natural;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        requested_charge: string(1 to 3);
        qual_lut : std_logic_vector;
        iso_lut : std_logic_vector;
        upt_cut : boolean;
        upt_upper_limit : std_logic_vector;
        upt_lower_limit : std_logic_vector;
        ip_lut : std_logic_vector
    );
    port(
        lhc_clk : in std_logic;
        data_i : in std_logic_vector;
        comp_o : out std_logic
    );
end muon_comparators;

architecture rtl of muon_comparators is

    signal pt : std_logic_vector(MUON_PT_HIGH downto MUON_PT_LOW);
    signal eta : std_logic_vector(MUON_ETA_HIGH downto MUON_ETA_LOW);
    signal phi : std_logic_vector(MUON_PHI_HIGH downto MUON_PHI_LOW);
    signal qual : std_logic_vector(MUON_QUAL_HIGH downto MUON_QUAL_LOW);
    signal iso : std_logic_vector(MUON_ISO_HIGH downto MUON_ISO_LOW);
    signal charge : std_logic_vector(MUON_CHARGE_HIGH downto MUON_CHARGE_LOW);
    signal upt : std_logic_vector(MUON_UPT_HIGH downto MUON_UPT_LOW);
    signal ip : std_logic_vector(MUON_IP_HIGH downto MUON_IP_LOW);
    signal idx : std_logic_vector(MUON_IDX_BITS_HIGH downto MUON_IDX_BITS_LOW);

    signal pt_comp : std_logic := '1';
    signal eta_comp : std_logic := '1';
    signal phi_comp : std_logic := '1';
    signal qual_comp : std_logic := '1';
    signal iso_comp : std_logic := '1';
    signal ch_comp : std_logic := '1';
    signal upt_comp : std_logic := '1';
    signal ip_comp : std_logic := '1';
    signal idx_comp : std_logic := '1';

    signal comp_int : std_logic;

begin

-- HB 2014-04-14
-- DEFINITION of charge:
-- charge valid = '1' => valid
-- charge sign = '0' => positive, charge sign = '1' => negative

-- ************************************************
-- HB 2014-04-14
-- DEFINITION of muon_comparators:
-- Pt greater/equal pt_threshold
-- AND
-- Eta in range
-- AND
-- Phi in range
-- AND
-- Requested charge
-- AND
-- Quality LUT
-- AND
-- ISO LUT
-- ************************************************
-- HB 2020-06-08
-- AND
-- Pt unconstraint in range
-- AND
-- IP (impact parameter) LUT

    pt  <= data_i(MUON_PT_HIGH downto MUON_PT_LOW);
    eta <= data_i(MUON_ETA_HIGH downto MUON_ETA_LOW);
    phi <= data_i(MUON_PHI_HIGH downto MUON_PHI_LOW);
    qual <= data_i(MUON_QUAL_HIGH downto MUON_QUAL_LOW);
    iso <= data_i(MUON_ISO_HIGH downto MUON_ISO_LOW);
    charge <= data_i(MUON_CHARGE_HIGH downto MUON_CHARGE_LOW);
    upt <= data_i(MUON_UPT_HIGH downto MUON_UPT_LOW);
    ip <= data_i(MUON_IP_HIGH downto MUON_IP_LOW);
    idx <= data_i(MUON_IDX_BITS_HIGH downto MUON_IDX_BITS_LOW);

-- HB 2021-03-08: implemented pt_comp for better modularity
    pt_comp_i: entity work.pt_comp
        generic map(
            pt_ge_mode,
            pt_threshold
        )
        port map(
            pt,
            pt_comp
        );

-- Comparator for pseudorapidity (eta)
-- Eta scale is defined with Two's Complement notation values for HW index.
-- Therefore a comparison with "signed" is implemented, which needs ieee.std_logic_signed.all library.
-- The comparators for et and phi work unsigned, so a module for Eta comparators is instantiated,
-- in which ieee.std_logic_signed.all library is used.

-- HB 2015-04-23: implemented eta_windows_comp for better modularity
-- HB 2019-06-14: updated for "five eta cuts".
    eta_windows_comp_i: entity work.eta_windows_comp
        generic map(
            nr_eta_windows,
            eta_w1_upper_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w1_LOWer_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w2_upper_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w2_LOWer_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w3_upper_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w3_LOWer_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w4_upper_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w4_LOWer_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w5_upper_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0),
            eta_w5_LOWer_limit(MUON_ETA_HIGH-MUON_ETA_LOW downto 0)
        )
        port map(
            eta => eta(MUON_ETA_HIGH downto MUON_ETA_LOW),
            eta_comp_o => eta_comp
        );

-- HB 2023-04-15: inserted cut for index bits.
    idx_windows_comp_i: entity work.muon_index_windows_comp
        generic map(
            nr_idx_windows,
            idx_w1_upper_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w1_LOWer_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w2_upper_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w2_LOWer_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w3_upper_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w3_LOWer_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w4_upper_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w4_LOWer_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w5_upper_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0),
            idx_w5_LOWer_limit(MUON_IDX_BITS_HIGH-MUON_IDX_BITS_LOW downto 0)
        )
        port map(
            idx(MUON_IDX_BITS_HIGH downto MUON_IDX_BITS_LOW),
            idx_comp
        );

-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    phi_windows_comp_i: entity work.phi_windows_comp
        generic map(
            nr_phi_windows => nr_phi_windows,
            phi_w1_upper_limit => phi_w1_upper_limit(MUON_PHI_HIGH-MUON_PHI_LOW downto 0),
            phi_w1_LOWer_limit => phi_w1_LOWer_limit(MUON_PHI_HIGH-MUON_PHI_LOW downto 0),
            phi_w2_upper_limit => phi_w2_upper_limit(MUON_PHI_HIGH-MUON_PHI_LOW downto 0),
            phi_w2_LOWer_limit => phi_w2_LOWer_limit(MUON_PHI_HIGH-MUON_PHI_LOW downto 0)
        )
        port map(
            phi => phi(MUON_PHI_HIGH downto MUON_PHI_LOW),
            phi_comp_o => phi_comp
        );

-- Comparator for requested charge
-- HB 2021-03-08: implemented lut_comp for better modularity
    charge_comp_i: entity work.charge_comp
        generic map(
            requested_charge
        )
        port map(
            charge,
            ch_comp
        );

-- Comparator for quality bits with LUT
-- HB 2021-03-08: implemented lut_comp for better modularity
    qual_comp_i: entity work.lut_comp
        generic map(
            qual_lut
        )
        port map(
            qual,
            qual_comp
        );

-- Comparator for ISO bits with LUT
-- HB 2021-03-08: implemented lut_comp for better modularity
    iso_comp_i: entity work.lut_comp
        generic map(
            iso_lut
        )
        port map(
            iso,
            iso_comp
        );

-- Comparator for Pt unconstraint
-- HB 2021-03-08: implemented upt_comp for better modularity
    sel_upt_comp_i: if upt_cut generate
        upt_comp_i: entity work.upt_comp
            generic map(
                upt_upper_limit,
                upt_lower_limit
            )
            port map(
                upt,
                upt_comp
            );
    end generate sel_upt_comp_i;

-- Comparator for IP bits with LUT
-- HB 2021-03-08: implemented lut_comp for better modularity
    ip_comp_i: entity work.lut_comp
        generic map(
            ip_lut
        )
        port map(
            ip,
            ip_comp
        );

-- Comparators AND
    comp_int <= pt_comp and eta_comp and phi_comp and qual_comp and iso_comp and ch_comp and upt_comp and ip_comp and idx_comp;

    pipeline_p: process(lhc_clk, comp_int)
        begin
        if INTERMEDIATE_PIPELINE = false then
            comp_o <= comp_int;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                comp_o <= comp_int;
            end if;
        end if;
    end process;

end architecture rtl;
