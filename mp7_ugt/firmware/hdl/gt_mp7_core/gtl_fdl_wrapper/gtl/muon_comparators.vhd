
-- Desription:
-- Comparators for transverse momentum, pseudorapidity, azimuth angle, quality and isolation of muon objects

-- Version history:
-- HB 2019-06-14: updated for "five eta cuts". Used phi_windows_comp.
-- HB 2019-05-06: renamed from muon_comparators_v2 to muon_comparators.
-- HB 2015-09-24: renamed to "muon_comparators_v2" for removing "d_s_i" from generic. These constants used directly from gtl.pkg now.
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

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
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        requested_charge: string(1 to 3);
        qual_lut : std_logic_vector;
        iso_lut : std_logic_vector
    );
    port(
        data_i : in std_logic_vector;
        comp_o : out std_logic
    );
end muon_comparators;

architecture rtl of muon_comparators is

    constant ZERO : std_logic_vector(MAX_MUON_BITS-1 downto 0) := (others => '0');

    signal pt : std_logic_vector(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low);
    signal eta : std_logic_vector(D_S_I_MUON.eta_high downto D_S_I_MUON.eta_low);
    signal phi : std_logic_vector(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low);
    signal qual : std_logic_vector(D_S_I_MUON.qual_high downto D_S_I_MUON.qual_low);
    signal iso : std_logic_vector(D_S_I_MUON.iso_high downto D_S_I_MUON.iso_low);
    signal charge : std_logic_vector(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low);

    signal pt_comp : std_logic;
    signal eta_comp : std_logic;
    signal phi_comp : std_logic;
    signal qual_comp : std_logic;
    signal iso_comp : std_logic;
    signal charge_comp : std_logic;
    
    signal no_muon : std_logic;

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

    pt  <= data_i(D_S_I_MUON.pt_high downto D_S_I_MUON.pt_low);
    eta <= data_i(D_S_I_MUON.eta_high downto D_S_I_MUON.eta_low);
    phi <= data_i(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low);
    qual <= data_i(D_S_I_MUON.qual_high downto D_S_I_MUON.qual_low);
    iso <= data_i(D_S_I_MUON.iso_high downto D_S_I_MUON.iso_low);
    charge <= data_i(D_S_I_MUON.charge_high downto D_S_I_MUON.charge_low);
    
-- HB 2015-08-28: inserted check for "no muon" (all object parameters = 0)
    no_muon <= '1' when data_i = ZERO else '0';

    pt_comp <= '1' when ((pt >= pt_threshold and pt_ge_mode=true) or (pt = pt_threshold and pt_ge_mode=false)) else '0';

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
            eta_w1_upper_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w1_lower_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w2_upper_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w2_lower_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w3_upper_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w3_lower_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w4_upper_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w4_lower_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w5_upper_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta_w5_lower_limit(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0)
        )
        port map(
--             eta => eta(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
            eta => eta(D_S_I_MUON.eta_high downto D_S_I_MUON.eta_low),
            eta_comp_o => eta_comp
        );

-- HB 2015-04-23: implemented phi_windows_comp for better modularity
    phi_windows_comp_i: entity work.phi_windows_comp
        generic map(
            phi_full_range => phi_full_range,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
            phi_w2_ignore => phi_w2_ignore,
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_MUON.phi_high downto D_S_I_MUON.phi_low),
            phi_comp_o => phi_comp
        );

-- Comparator for requested charge
-- charge_high = charge valid, charge_low = charge sign (positive or negative), 
    charge_comp <= '1' when charge = "10" and requested_charge = "pos" else -- charge sign = '0' => positive
                   '1' when charge = "11" and requested_charge = "neg" else -- charge sign = '1' => negative
                   '1' when requested_charge = "ign" else '0';

-- Comparator for quality bits with LUT
    qual_comp <= qual_lut(CONV_INTEGER(qual)); -- 16 bit LUT for quality, because of 4 bit quality

-- Comparator for ISO bits with LUT
    iso_comp <= iso_lut(CONV_INTEGER(iso)); -- 4 bit LUT for isolation, because of 2 bits isolation

-- Comparators AND
    comp_o <= pt_comp and eta_comp and phi_comp and qual_comp and iso_comp and charge_comp and not no_muon;

end architecture rtl;
