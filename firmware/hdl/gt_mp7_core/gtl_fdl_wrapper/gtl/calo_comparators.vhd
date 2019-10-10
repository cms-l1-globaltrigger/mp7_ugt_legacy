
-- Desription:
-- Comparators for energy, pseudorapidity, azimuth angle and isolation of calo objects

-- Version history:
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
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        iso_lut: std_logic_vector
    );
    port(
        data_i : in std_logic_vector;
        comp_o : out std_logic
    );
end calo_comparators;

architecture rtl of calo_comparators is

    constant ZERO : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');

    signal et : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal eta : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal phi : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal iso : std_logic_vector(MAX_CALO_BITS-1 downto 0) := (others => '0');
    signal et_comp : std_logic;
    signal eta_comp : std_logic;
    signal phi_comp : std_logic;
    signal iso_comp : std_logic;

    signal no_calo : std_logic;

begin

-- HB 2015-04-27: used integer for obj_type
-- eg_obj_type=0
-- jet_obj_type=1
-- tau_obj_type=2

-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
    no_calo <= '1' when data_i = ZERO else '0';
    
-- HB 2015-04-27: selection of calo object types
    eg_sel: if obj_type=0 generate
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
            phi_full_range => phi_full_range,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_ignore => phi_w2_ignore,
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_EG_V2.phi_high-D_S_I_EG_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_EG_V2.phi_high downto D_S_I_EG_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate eg_sel;

    jet_sel: if obj_type=1 generate
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
            phi_full_range => phi_full_range,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low downto 0),
            phi_w2_ignore => phi_w2_ignore,
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_JET_V2.phi_high-D_S_I_JET_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_JET_V2.phi_high downto D_S_I_JET_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate jet_sel;

    tau_sel: if obj_type=2 generate
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
            phi_full_range => phi_full_range,
            phi_w1_upper_limit => phi_w1_upper_limit(D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low downto 0),
            phi_w1_lower_limit => phi_w1_lower_limit(D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low downto 0),
            phi_w2_ignore => phi_w2_ignore,
            phi_w2_upper_limit => phi_w2_upper_limit(D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low downto 0),
            phi_w2_lower_limit => phi_w2_lower_limit(D_S_I_TAU_V2.phi_high-D_S_I_TAU_V2.phi_low downto 0)
        )
        port map(
            phi => data_i(D_S_I_TAU_V2.phi_high downto D_S_I_TAU_V2.phi_low),
            phi_comp_o => phi_comp
        );

    end generate tau_sel;

    -- Comparator for energy (et)
    et_comp <= '1' when et >= et_threshold and et_ge_mode else            
               '1' when et = et_threshold and not et_ge_mode else '0'; 
           
-- HB 2015-04-27: comparators out for eg and tau
    comp_o_eg_tau_i: if obj_type=0 or obj_type=2 generate
-- HB 2015-04-24: comparator for isolation bits with LUT
        iso_comp <= iso_lut(CONV_INTEGER(iso));
-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
        comp_o <= et_comp and eta_comp and phi_comp and iso_comp and not no_calo;
    end generate comp_o_eg_tau_i;
        
-- HB 2015-04-27: comparators out for jet
    comp_o_jet_i: if obj_type=1 generate
-- HB 2015-08-28: inserted "no calo" (all object parameters = 0)
        comp_o <= et_comp and eta_comp and phi_comp and not no_calo;
    end generate comp_o_jet_i;
        
end architecture rtl;
