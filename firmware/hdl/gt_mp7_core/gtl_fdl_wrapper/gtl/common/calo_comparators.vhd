
-- Description:
-- Comparators for energy, pseudorapidity, azimuth angle and isolation of calo objects

-- Version history:
-- HB 2021-02-24: removed "no_calo".
-- HB 2021-02-19: added output register (with selection).
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now.
-- HB 2019-06-14: updated for "five eta cuts".
-- HB 2019-05-03: changed name from  calo_comparators_v2 to calo_comparators.
-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for et and phi comparators

use work.gtl_pkg.all;

entity calo_comparators is
    generic(
        et_ge_mode : boolean;
        obj_type : natural;
        et_threshold : std_logic_vector;
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
        nr_phi_windows : natural;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        iso_lut: std_logic_vector
    );
    port(
        lhc_clk : in std_logic;
        data_i : in std_logic_vector;
        comp_o : out std_logic
    );
end calo_comparators;

architecture rtl of calo_comparators is

    signal et : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal eta : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal phi : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal iso : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal et_comp : std_logic := '1';
    signal eta_comp : std_logic := '1';
    signal phi_comp : std_logic := '1';
    signal iso_comp : std_logic := '1';
    signal comp_int : std_logic;

begin

-- ************************************************
-- DEFINITION of calo_comparators:
-- Pt greater/equal pt_threshold
-- AND
-- Eta in range
-- AND
-- Phi in range
-- AND
-- ISO LUT (for eg and tau)
-- ************************************************

-- HB 2015-04-27: selection of calo object types
    eg_sel: if obj_type=EG_TYPE generate
    et(D_S_I_EG_V2.et_high-D_S_I_EG_V2.et_low downto 0) <= data_i(D_S_I_EG_V2.et_high downto D_S_I_EG_V2.et_low);
    eta(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0) <= data_i(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low);
    phi(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0) <= data_i(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low);
    iso(D_S_I_EG_V2.iso_high-D_S_I_EG_V2.iso_low downto 0) <= data_i(D_S_I_EG_V2.iso_high downto D_S_I_EG_V2.iso_low);

-- HB 2015-04-23: implemented eta_windows_comp for better modularity
-- HB 2019-06-14: updated for "five eta cuts".
    eg_eta_windows_comp_i: entity work.eta_windows_comp
        generic map(
            nr_eta_windows,
            eta_w1_upper_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w1_lower_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w2_upper_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w2_lower_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w3_upper_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w3_lower_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w4_upper_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w4_lower_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w5_upper_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_w5_lower_limit(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0)
        )
        port map(
            eta => eta(D_S_I_EG_V2.eta_high-D_S_I_EG_V2.eta_low downto 0),
            eta_comp_o => eta_comp
        );

-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    eg_phi_windows_comp_i: entity work.phi_windows_comp
        generic map(
            nr_phi_windows => nr_phi_windows,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate eg_sel;

    jet_sel: if obj_type=JET_TYPE generate
    et(D_S_I_JET_V2.et_high-D_S_I_JET_V2.et_low downto 0) <= data_i(D_S_I_JET_V2.et_high downto D_S_I_JET_V2.et_low);
    eta(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0) <= data_i(D_S_I_JET_V2.eta_high downto D_S_I_JET_V2.eta_low);
    phi(D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low downto 0) <= data_i(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low);

    -- HB 2015-04-23: implemented eta_windows_comp for better modularity
    jet_eta_windows_comp_i: entity work.eta_windows_comp
        generic map(
            nr_eta_windows,
            eta_w1_upper_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w1_lower_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w2_upper_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w2_lower_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w3_upper_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w3_lower_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w4_upper_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w4_lower_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w5_upper_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_w5_lower_limit(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0)
        )
        port map(
            eta => eta(D_S_I_JET_V2.eta_high-D_S_I_JET_V2.eta_low downto 0),
            eta_comp_o => eta_comp
        );

-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    jet_phi_windows_comp_i: entity work.phi_windows_comp
        generic map(
            nr_phi_windows => nr_phi_windows,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate jet_sel;

    tau_sel: if obj_type=TAU_TYPE generate
    et(D_S_I_TAU_V2.et_high-D_S_I_TAU_V2.et_low downto 0) <= data_i(D_S_I_TAU_V2.et_high downto D_S_I_TAU_V2.et_low);
    eta(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0) <= data_i(D_S_I_TAU_V2.eta_high downto D_S_I_TAU_V2.eta_low);
    phi(D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low downto 0) <= data_i(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low);
    iso(D_S_I_TAU_V2.iso_high-D_S_I_TAU_V2.iso_low downto 0) <= data_i(D_S_I_TAU_V2.iso_high downto D_S_I_TAU_V2.iso_low);

    -- HB 2015-04-23: implemented eta_windows_comp for better modularity
    tau_eta_windows_comp_i: entity work.eta_windows_comp
        generic map(
            nr_eta_windows,
            eta_w1_upper_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w1_lower_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w2_upper_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w2_lower_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w3_upper_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w3_lower_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w4_upper_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w4_lower_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w5_upper_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_w5_lower_limit(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0)
        )
        port map(
            eta => eta(D_S_I_TAU_V2.eta_high-D_S_I_TAU_V2.eta_low downto 0),
            eta_comp_o => eta_comp
        );

-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    tau_phi_windows_comp_i: entity work.phi_windows_comp
        generic map(
            nr_phi_windows => nr_phi_windows,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate tau_sel;

    -- Comparator for energy (et)
-- HB 2021-03-08: implemented pt_comp for better modularity
    et_comp_i: entity work.pt_comp
        generic map(
            et_ge_mode,
            et_threshold
        )
        port map(
            et,
            et_comp
        );

-- HB 2015-04-27: comparators out for eg and tau
    comp_int_eg_tau_i: if obj_type=EG_TYPE or obj_type=TAU_TYPE generate
-- HB 2021-03-08: implemented lut_comp for better modularity
        iso_comp_i: entity work.lut_comp
            generic map(
                iso_lut
            )
            port map(
                iso,
                iso_comp
            );
        comp_int <= et_comp and eta_comp and phi_comp and iso_comp;
    end generate comp_int_eg_tau_i;

-- HB 2015-04-27: comparators out for jet
    comp_int_jet_i: if obj_type=JET_TYPE generate
        comp_int <= et_comp and eta_comp and phi_comp;
    end generate comp_int_jet_i;

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
