--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL$
-- $Date$
-- $Author$
-- $Revision$
--------------------------------------------------------------------------------

-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and muon.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_correlation_condition is
     generic(
        deta_cut: boolean := true;
        dphi_cut: boolean := true;
        dr_cut: boolean := false;
        inv_mass_cut: boolean := false;

        pt_ge_mode_muon1: boolean;
        pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon1: boolean;
        eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon1: boolean;
        eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon1: boolean;
        phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon1: boolean;
        phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon1: string(1 to 3);
        qual_lut_muon1: std_logic_vector(15 downto 0);
        iso_lut_muon1: std_logic_vector(3 downto 0);
        
        pt_ge_mode_muon2: boolean;
        pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon2: boolean;
        eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon2: boolean;
        eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon2: boolean;
        phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon2: boolean;
        phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon2: string(1 to 3);
        qual_lut_muon2: std_logic_vector(15 downto 0);
        iso_lut_muon2: std_logic_vector(3 downto 0);
        
        requested_charge_correlation: string(1 to 2);

        diff_eta_upper_limit: diff_eta_range_real;
        diff_eta_lower_limit: diff_eta_range_real;

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

        deta_dphi_limits_precision: positive;

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;
        
        dr_limits_precision: positive;

        inv_mass_upper_limit: real;
        inv_mass_lower_limit: real;

        INV_MASS_PRECISION: positive;
	INV_MASS_PT_PRECISION : positive;
	pt_width: positive; 
	INV_MASS_COSH_COS_PRECISION : positive;
	cosh_cos_width: positive	
    );
    port(
        lhc_clk: in std_logic;
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        diff_eta: in diff_2dim_integer_array;
        diff_phi: in diff_2dim_integer_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
	cosh_deta : in muon_cosh_cos_vector_array;
        cos_dphi : in muon_cosh_cos_vector_array;
        condition_o: out std_logic
    );
end muon_muon_correlation_condition; 

architecture rtl of muon_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

-- fixed for current implementation of correlation conditions
    constant nr_templates: positive := 1;  

    type muon_object_vs_template_array is array (0 to NR_MUON_OBJECTS-1, 1 to nr_templates) of std_logic;
    type diff_comp_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic;

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--***************************************************************

    signal diff_eta_upper_limit_int : integer;
    signal diff_eta_lower_limit_int : integer;
    
    signal diff_phi_upper_limit_int : integer;
    signal diff_phi_lower_limit_int : integer;
    
    signal muon1_obj_vs_templ : muon_object_vs_template_array;
    signal muon1_obj_vs_templ_pipe : muon_object_vs_template_array;
    signal muon2_obj_vs_templ : muon_object_vs_template_array;
    signal muon2_obj_vs_templ_pipe : muon_object_vs_template_array;
    signal diff_eta_comp : diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal dr_comp : diff_comp_array;
    signal dr_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal inv_mass_comp : diff_comp_array := (others => (others => '0'));
    signal inv_mass_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal condition_and_or : std_logic;

begin

    diff_eta_upper_limit_int <= integer(diff_eta_upper_limit*real(10**deta_dphi_limits_precision));
    diff_eta_lower_limit_int <= integer(diff_eta_lower_limit*real(10**deta_dphi_limits_precision));
    diff_phi_upper_limit_int <= integer(diff_phi_upper_limit*real(10**deta_dphi_limits_precision));
    diff_phi_lower_limit_int <= integer(diff_phi_lower_limit*real(10**deta_dphi_limits_precision));

    delta_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
	delta_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
	    delta_if: if j/=i generate
		deta_diff_i: if deta_cut = true generate
		    diff_eta_comp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit_int and diff_eta(i,j) <= diff_eta_upper_limit_int else '0';
		end generate deta_diff_i;
		dphi_diff_i: if dphi_cut = true generate
		    diff_phi_comp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit_int and diff_phi(i,j) <= diff_phi_upper_limit_int else '0';
		end generate dphi_diff_i;
		dr_i: if dr_cut = true generate
		    dr_calculator_i: entity work.dr_calculator
			generic map(
			    dr_upper_limit => dr_upper_limit,
			    dr_lower_limit => dr_lower_limit,
			    dr_limits_precision => dr_limits_precision
			)
			port map(
			    diff_eta => diff_eta(i,j),
			    diff_phi => diff_phi(i,j),
			    dr_comp => dr_comp(i,j)
			);
		end generate dr_i;
		inv_mass_i: if inv_mass_cut = true generate
		    inv_mass_calculator_i: entity work.invariant_mass
			generic map(
			    upper_limit => inv_mass_upper_limit,
			    lower_limit => inv_mass_lower_limit,
			    pt1_width => pt_width, 
			    pt2_width => pt_width, 
			    cosh_cos_width => cosh_cos_width,
			    INV_MASS_PRECISION => INV_MASS_PRECISION,
			    INV_MASS_PT_PRECISION => INV_MASS_PT_PRECISION,
			    INV_MASS_COSH_COS_PRECISION => INV_MASS_COSH_COS_PRECISION
			)
			port map(
			    pt1 => pt1(i)(pt_width-1 downto 0),
			    pt2 => pt2(j)(pt_width-1 downto 0),
			    cosh_deta => cosh_deta(i,j),
			    cos_dphi => cos_dphi(i,j),
			    inv_mass_comp => inv_mass_comp(i,j)
			);
		 end generate inv_mass_i;
	    end generate delta_if;
        end generate delta_l_2;
    end generate delta_l_1;

-- Pipeline stage for diff_eta_comp, diff_phi_comp, dr_comp and inv_mass_comp
    diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp, dr_comp, inv_mass_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                if deta_cut = true and dphi_cut = false and dr_cut = false and inv_mass_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                elsif deta_cut = false and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = true and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = false and dphi_cut = false and dr_cut = true and inv_mass_cut = false then
                    dr_comp_pipe <= dr_comp;
                elsif deta_cut = false and dphi_cut = false and dr_cut = false and inv_mass_cut = true then
                    inv_mass_comp_pipe <= inv_mass_comp;
                end if;
           else
                if (lhc_clk'event and lhc_clk = '1') then
                    if deta_cut = true and dphi_cut = false and dr_cut = false and inv_mass_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                    elsif deta_cut = false and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = true and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = false and dphi_cut = false and dr_cut = true and inv_mass_cut = false then
                        dr_comp_pipe <= dr_comp;
                    elsif deta_cut = false and dphi_cut = false and dr_cut = false and inv_mass_cut = true then
                        inv_mass_comp_pipe <= inv_mass_comp;
                    end if;
                end if;
            end if;
    end process;

-- Instance of comparators for muon objects. All permutations between objects and thresholds.
    muon1_obj_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        muon2_comp_i: entity work.muon_comparators_v2
            generic map(pt_ge_mode_muon1,
                pt_threshold_muon1(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
                eta_full_range_muon1,
                eta_w1_upper_limit_muon1(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w1_lower_limit_muon1(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w2_ignore_muon1,
                eta_w2_upper_limit_muon1(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w2_lower_limit_muon1(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                phi_full_range_muon1,
                phi_w1_upper_limit_muon1(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w1_lower_limit_muon1(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w2_ignore_muon1,
                phi_w2_upper_limit_muon1(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w2_lower_limit_muon1(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                requested_charge_muon1,
                qual_lut_muon1,
                iso_lut_muon1
	    )
            port map(muon1_data_i(i), muon1_obj_vs_templ(i,1));
    end generate muon1_obj_l;

    muon2_obj_l: for i in 0 to NR_MUON_OBJECTS-1 generate
        muon2_comp_i: entity work.muon_comparators_v2
            generic map(pt_ge_mode_muon2,
                pt_threshold_muon2(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
                eta_full_range_muon2,
                eta_w1_upper_limit_muon2(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w1_lower_limit_muon2(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w2_ignore_muon2,
                eta_w2_upper_limit_muon2(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                eta_w2_lower_limit_muon2(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                phi_full_range_muon2,
                phi_w1_upper_limit_muon2(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w1_lower_limit_muon2(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w2_ignore_muon2,
                phi_w2_upper_limit_muon2(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                phi_w2_lower_limit_muon2(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                requested_charge_muon2,
                qual_lut_muon2,
                iso_lut_muon2
	    )
            port map(muon2_data_i(i), muon2_obj_vs_templ(i,1));
    end generate muon2_obj_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, muon1_obj_vs_templ, muon2_obj_vs_templ)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
            muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
                muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
            end if;
        end if;
    end process;
    
-- Charge correlation comparison
    charge_double_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        charge_double_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            charge_double_if: if j/=i generate
                charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                           '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                           '1' when requested_charge_correlation = "ig" else
                                           '0';
            end generate charge_double_if;
        end generate charge_double_l_2;
    end generate charge_double_l_1;

-- Pipeline stage for charge correlation comparison
    charge_comp_2_pipeline_p: process(lhc_clk, charge_comp_double)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                charge_comp_double_pipe <= charge_comp_double;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    charge_comp_double_pipe <= charge_comp_double;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.

    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, charge_comp_double_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, inv_mass_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((NR_MUON_OBJECTS*(NR_MUON_OBJECTS)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to NR_MUON_OBJECTS-1 loop 
            for j in 0 to NR_MUON_OBJECTS-1 loop
                if j/=i then
		    if deta_cut = true and dphi_cut = false and dr_cut = false and inv_mass_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and diff_eta_comp_pipe(i,j);
		    elsif deta_cut = false and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and diff_phi_comp_pipe(i,j);
		    elsif deta_cut = false and dphi_cut = false and dr_cut = true and inv_mass_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and dr_comp_pipe(i,j);
		    elsif deta_cut = false and dphi_cut = false and dr_cut = false and inv_mass_cut = true then
			index := index + 1;
			obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and inv_mass_comp_pipe(i,j);
		    elsif deta_cut = true and dphi_cut = true and dr_cut = false and inv_mass_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j);
		    end if;
		end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_p;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(lhc_clk, condition_and_or)
        begin
            if conditions_pipeline_stage = false then 
                condition_o <= condition_and_or;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;
    
end architecture rtl;
    
    
    
    
    
    
    
    
    
    