
-- Description:
-- Collection of cuts for correlations

-- Version history:
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
        mass_type: natural := INVARIANT_MASS_TYPE;
        twobody_pt_cut: boolean := false;

        object1_low: natural;
        object1_high: natural;

        object2_low: natural;
        object2_high: natural;

        diff_eta_upper_limit: diff_eta_range_real;
        diff_eta_lower_limit: diff_eta_range_real;

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;

	deta_dphi_vector_width: positive;
	deta_dphi_precision: positive;

        mass_upper_limit: real;
        mass_lower_limit: real;
        
        mass_precision: positive;
	pt1_width: positive; 
	pt2_width: positive; 
	cosh_cos_precision : positive;
	cosh_cos_width: positive;
	
	pt_sq_threshold: real;
	sin_cos_width: positive;
	pt_precision : positive;
	pt_sq_sin_cos_precision : positive

    );
    port(
        diff_eta: in std_logic_vector(deta_dphi_vector_width-1 downto 0);
        diff_phi: in std_logic_vector(deta_dphi_vector_width-1 downto 0);
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

    signal diff_eta_upper_limit_int : std_logic_vector(deta_dphi_vector_width-1 downto 0);
    signal diff_eta_lower_limit_int : std_logic_vector(deta_dphi_vector_width-1 downto 0);
    
    signal diff_phi_upper_limit_int : std_logic_vector(deta_dphi_vector_width-1 downto 0);
    signal diff_phi_lower_limit_int : std_logic_vector(deta_dphi_vector_width-1 downto 0);
    
begin

    -- *** section: CUTs - begin ***************************************************************************************
    -- Conversion of limits to std_logic_vector.
    diff_eta_upper_limit_int <= conv_std_logic_vector(integer(diff_eta_upper_limit*real(10**deta_dphi_precision)),DETA_DPHI_VECTOR_WIDTH);
    diff_eta_lower_limit_int <= conv_std_logic_vector(integer(diff_eta_lower_limit*real(10**deta_dphi_precision)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_upper_limit_int <= conv_std_logic_vector(integer(diff_phi_upper_limit*real(10**deta_dphi_precision)),DETA_DPHI_VECTOR_WIDTH);
    diff_phi_lower_limit_int <= conv_std_logic_vector(integer(diff_phi_lower_limit*real(10**deta_dphi_precision)),DETA_DPHI_VECTOR_WIDTH);

    deta_diff_i: if deta_cut = true generate
	diff_eta_comp <= '1' when diff_eta >= diff_eta_lower_limit_int and diff_eta <= diff_eta_upper_limit_int else '0';
    end generate deta_diff_i;
    dphi_diff_i: if dphi_cut = true generate
	diff_phi_comp <= '1' when diff_phi >= diff_phi_lower_limit_int and diff_phi <= diff_phi_upper_limit_int else '0';
    end generate dphi_diff_i;
    dr_i: if dr_cut = true generate
	dr_calculator_i: entity work.dr_calculator_v2
	    generic map(
		upper_limit => dr_upper_limit,
		lower_limit => dr_lower_limit,
		DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH,
		deta_dphi_precision => deta_dphi_precision
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
		mass_upper_limit => mass_upper_limit,
		mass_lower_limit => mass_lower_limit,
		pt1_width => pt1_width, 
		pt2_width => pt2_width, 
		cosh_cos_width => cosh_cos_width,
		mass_precision => mass_precision,
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
		pt_sq_threshold => pt_sq_threshold,
		sin_cos_width => sin_cos_width,
		pt_precision => pt_precision,
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
    
    
    
    
    
    
    
    
    
    