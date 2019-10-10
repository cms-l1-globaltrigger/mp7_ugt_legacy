
-- Description:
-- Collection of cuts for correlations

-- Version history:
-- HB 2019-05-03: changed name from  cuts_instances_v2 to cuts_instances.
-- HB 2017-09-20: changed to cuts_instances_v2 - added limit_vectors.
-- HB 2017-09-19: used mass_calculator_v2 (instead of mass_calculator) for instance mass_calculator_i.
-- HB 2017-04-20: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity cuts_instances is
     generic(
        deta_cut: boolean;
        dphi_cut: boolean;
        dr_cut: boolean;
        mass_cut: boolean;
        mass_type: natural;
        twobody_pt_cut: boolean;

        diff_eta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_eta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        diff_phi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);
        diff_phi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0);

        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0);

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0);

        pt1_width: positive; 
        pt2_width: positive; 
        cosh_cos_precision : positive;
        cosh_cos_width: positive;

        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0);
        sin_cos_width: positive;
        pt_sq_sin_cos_precision : positive

    );
    port(
        diff_eta: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        diff_phi: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        pt1 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        pt2 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_phi_1_integer : in integer;
        cos_phi_2_integer : in integer;
        sin_phi_1_integer : in integer;
        sin_phi_2_integer : in integer;
        diff_eta_comp: out std_logic := '1';
        diff_phi_comp: out std_logic := '1';
        dr_comp: out std_logic := '1';
        mass_comp: out std_logic := '1';
        twobody_pt_comp: out std_logic := '1'
    );
end cuts_instances; 

architecture rtl of cuts_instances is

begin

    deta_diff_i: if deta_cut = true generate
        diff_eta_comp <= '1' when diff_eta >= diff_eta_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                         diff_eta <= diff_eta_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
    end generate deta_diff_i;
    dphi_diff_i: if dphi_cut = true generate
        diff_phi_comp <= '1' when diff_phi >= diff_phi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                         diff_phi <= diff_phi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
    end generate dphi_diff_i;
    dr_i: if dr_cut = true generate
        dr_calculator_i: entity work.dr_calculator
            generic map(
                upper_limit_vector => dr_upper_limit_vector,
                lower_limit_vector => dr_lower_limit_vector
            )
            port map(
                diff_eta => diff_eta,
                diff_phi => diff_phi,
                dr_comp => dr_comp
            );
    end generate dr_i;
    mass_i: if mass_cut = true generate
        mass_calculator_i: entity work.mass_calculator
            generic map(
                mass_type => mass_type,
                mass_upper_limit_vector => mass_upper_limit_vector,
                mass_lower_limit_vector => mass_lower_limit_vector,
                pt1_width => pt1_width, 
                pt2_width => pt2_width, 
                cosh_cos_width => cosh_cos_width,
                mass_cosh_cos_precision => cosh_cos_precision
            )
            port map(
                pt1 => pt1(pt1_width-1 downto 0),
                pt2 => pt2(pt2_width-1 downto 0),
                cosh_deta => cosh_deta,
                cos_dphi => cos_dphi,
                mass_comp => mass_comp
            );
    end generate mass_i;
    twobody_pt_i: if twobody_pt_cut = true generate
        twobody_pt_calculator_i: entity work.twobody_pt_calculator
            generic map(
                pt1_width => pt1_width, 
                pt2_width => pt2_width, 
                pt_sq_threshold_vector => pt_sq_threshold_vector,
                sin_cos_width => sin_cos_width,
                pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
            )
            port map(
                pt1 => pt1(pt1_width-1 downto 0),
                pt2 => pt2(pt2_width-1 downto 0),
                cos_phi_1_integer => cos_phi_1_integer,
                cos_phi_2_integer => cos_phi_2_integer,
                sin_phi_1_integer => sin_phi_1_integer,
                sin_phi_2_integer => sin_phi_2_integer,
                pt_square_comp => twobody_pt_comp
        );
    end generate twobody_pt_i;
    
end architecture rtl;
