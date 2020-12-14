
-- Description:
-- Collection of cuts for correlations

-- Version history:
-- HB 2020-12-14: changed names.
-- HB 2020-08-10: inserted cut for "twobody xunconstraint pt" of new muon structure.
-- HB 2020-06-15: inserted cuts for "unconstraint pt" [upt] of new muon structure.
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
        deta_cut: boolean := false;
        dphi_cut: boolean := false;
        dr_cut: boolean := false;
        mass_cut: boolean := false;
        mass_type: natural := 0;
        twobody_pt_cut: boolean := false;
        twobody_upt_cut: boolean := false;

        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');

        pt1_width: positive := 12; 
        pt2_width: positive := 12; 
        upt1_width: positive := 12; 
        upt2_width: positive := 12; 
        cosh_cos_precision : positive := EG_EG_COSH_COS_PRECISION;
        cosh_cos_width: positive := EG_EG_COSH_COS_VECTOR_WIDTH;

        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        upt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := CALO_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := EG_EG_SIN_COS_PRECISION

    );
    port(
        deta: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        dphi: in std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
        pt1 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        pt2 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0);
        upt1 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0) := (others => '0');
        upt2 : in std_logic_vector(MAX_DIFF_BITS-1 downto 0) := (others => '0');
        cosh_deta : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_dphi : in std_logic_vector(cosh_cos_width-1 downto 0);
        cos_phi_1_integer : in integer;
        cos_phi_2_integer : in integer;
        sin_phi_1_integer : in integer;
        sin_phi_2_integer : in integer;
        deta_comp: out std_logic := '1';
        dphi_comp: out std_logic := '1';
        dr_comp: out std_logic := '1';
        mass_comp: out std_logic := '1';
        twobody_pt_comp: out std_logic := '1';
        twobody_upt_comp: out std_logic := '1'
    );
end cuts_instances; 

architecture rtl of cuts_instances is

begin

    deta_i: if deta_cut = true generate
        deta_comp <= '1' when deta >= deta_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                         deta <= deta_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
    end generate deta_i;
    dphi_i: if dphi_cut = true generate
        dphi_comp <= '1' when dphi >= dphi_lower_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) and 
                         dphi <= dphi_upper_limit_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0) else '0';
    end generate dphi_i;
    dr_i: if dr_cut = true generate
        dr_calculator_i: entity work.dr_calculator
            generic map(
                upper_limit_vector => dr_upper_limit_vector,
                lower_limit_vector => dr_lower_limit_vector
            )
            port map(
                deta => deta,
                dphi => dphi,
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
                upt1_width => upt1_width, 
                upt2_width => upt2_width, 
                cosh_cos_width => cosh_cos_width,
                mass_cosh_cos_precision => cosh_cos_precision
            )
            port map(
                pt1 => pt1(pt1_width-1 downto 0),
                pt2 => pt2(pt2_width-1 downto 0),
                upt1 => upt1(upt1_width-1 downto 0),
                upt2 => upt2(upt2_width-1 downto 0),
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
    twobody_upt_i: if twobody_upt_cut = true generate
        twobody_upt_calculator_i: entity work.twobody_pt_calculator
            generic map(
                pt1_width => upt1_width, 
                pt2_width => upt2_width, 
                pt_sq_threshold_vector => upt_sq_threshold_vector,
                sin_cos_width => sin_cos_width,
                pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
            )
            port map(
                pt1 => upt1(upt1_width-1 downto 0),
                pt2 => upt2(upt2_width-1 downto 0),
                cos_phi_1_integer => cos_phi_1_integer,
                cos_phi_2_integer => cos_phi_2_integer,
                sin_phi_1_integer => sin_phi_1_integer,
                sin_phi_2_integer => sin_phi_2_integer,
                pt_square_comp => twobody_upt_comp
        );
    end generate twobody_upt_i;
    
end architecture rtl;
