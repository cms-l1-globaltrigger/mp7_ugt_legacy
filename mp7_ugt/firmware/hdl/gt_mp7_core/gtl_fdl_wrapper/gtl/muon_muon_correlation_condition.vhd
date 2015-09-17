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

        nr_muon_objects: positive;
        pt_ge_mode_muon: boolean;
        pt_threshold_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_full_range_muon : boolean;
        eta_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_muon : boolean;
        eta_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon : boolean;
        phi_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon : boolean;
        phi_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon: string(1 to 3);
        qual_lut_muon: std_logic_vector(15 downto 0);
        iso_lut_muon: std_logic_vector(3 downto 0);

        diff_eta_upper_limit: diff_eta_range_real;
        diff_eta_lower_limit: diff_eta_range_real;

        diff_phi_upper_limit: diff_phi_range_real;
        diff_phi_lower_limit: diff_phi_range_real;

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real
    );
    port(
        clk: in std_logic;
        muon_data_i: in muon_objects_array;
        diff_eta: in diff_2dim_integer_array;
        diff_phi: in diff_2dim_integer_array;
        condition_o: out std_logic
    );
end muon_muon_correlation_condition; 

architecture rtl of muon_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

-- fixed to 1 for current implementation of correlation conditions
    constant nr_templates: positive := 1;  

    type muon_object_vs_template_array is array (0 to nr_muon_objects-1, 1 to nr_templates) of std_logic;
    type diff_comp_array is array (0 to nr_calo_objects-1, 0 to nr_muon_objects-1) of std_logic;

    signal diff_eta_upper_limit_int : integer;
    signal diff_eta_lower_limit_int : integer;
    
    signal diff_phi_upper_limit_int : integer;
    signal diff_phi_lower_limit_int : integer;
    
    signal muon_obj_vs_templ : muon_object_vs_template_array;
    signal muon_obj_vs_templ_pipe : muon_object_vs_template_array;
    signal diff_eta_comp : diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array := (others => (others => '0'));
    signal dr_comp : diff_comp_array;
    signal dr_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal condition_and_or : std_logic;

begin

-- Instance of comparators for muon objects. All permutations between objects and requirements..
    muon_obj_l: for i in 0 to nr_muon_objects-1 generate
        muon_comp_i: entity work.muon_comparators
           generic map(d_s_i_muon, pt_ge_mode_muon,
               pt_threshold_muon(d_s_i_muon.pt_high-d_s_i_muon.pt_low downto 0),
               eta_full_range_muon,
               eta_w1_upper_limit_muon(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0),
               eta_w1_lower_limit_muon(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0),
               eta_w2_ignore_muon,
               eta_w2_upper_limit_muon(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0),
               eta_w2_lower_limit_muon(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0),
               phi_full_range_muon,
               phi_w1_upper_limit_muon(d_s_i_muon.phi_high-d_s_i_muon.phi_low downto 0),
               phi_w1_lower_limit_muon(d_s_i_muon.phi_high-d_s_i_muon.phi_low downto 0),
               phi_w2_ignore_muon,
               phi_w2_upper_limit_muon(d_s_i_muon.phi_high-d_s_i_muon.phi_low downto 0),
               phi_w2_lower_limit_muon(d_s_i_muon.phi_high-d_s_i_muon.phi_low downto 0),
               requested_charge_muon,
               qual_lut_muon,
               iso_lut_muon
               )
           port map(muon_data_i(i), muon_obj_vs_templ(i,1));
     end generate muon_obj_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(clk, muon_obj_vs_templ)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
            else
                if (clk'event and clk = '1') then
                    muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
                end if;
            end if;
    end process;
    
    diff_eta_upper_limit_int <= integer(diff_eta_upper_limit*real(10**POSITION_FINAL_PRECISION));
    diff_eta_lower_limit_int <= integer(diff_eta_lower_limit*real(10**POSITION_FINAL_PRECISION));
    diff_phi_upper_limit_int <= integer(diff_phi_upper_limit*real(10**POSITION_FINAL_PRECISION));
    diff_phi_lower_limit_int <= integer(diff_phi_lower_limit*real(10**POSITION_FINAL_PRECISION));

    delta_l: for i in 0 to nr_muon_objects-1 generate 
	delta_l_2: for j in 0 to nr_muon_objects-1 generate
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
			    dr_lower_limit => dr_lower_limit
			    )
			port map(
			    diff_eta => diff_eta(i,j),
			    diff_phi => diff_phi(i,j),
			    dr_comp => dr_comp(i,j)
			);
		end generate dr_i;
	    end generate delta_if;
        end generate delta_l_2;
    end generate delta_l_1;

-- Pipeline stage for diff_eta_comp, diff_phi_comp and dr_comp
    diff_pipeline_p: process(clk, diff_eta_comp, diff_phi_comp, dr_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                if deta_cut = true and dphi_cut = false and dr_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                elsif deta_cut = false and dphi_cut = true and dr_cut = false then
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = true and dphi_cut = true and dr_cut = false then
                    diff_eta_comp_pipe <= diff_eta_comp;
                    diff_phi_comp_pipe <= diff_phi_comp;
                elsif deta_cut = false and dphi_cut = false and dr_cut = true then
                    dr_comp_pipe <= dr_comp;
                end if;
            else
                if (clk'event and clk = '1') then
                    if deta_cut = true and dphi_cut = false and dr_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                    elsif deta_cut = false and dphi_cut = true and dr_cut = false then
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = true and dphi_cut = true and dr_cut = false then
                        diff_eta_comp_pipe <= diff_eta_comp;
                        diff_phi_comp_pipe <= diff_phi_comp;
                    elsif deta_cut = false and dphi_cut = false and dr_cut = true then
                        dr_comp_pipe <= dr_comp;
                    end if;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.

    matrix_deta_dphi_dr_p: process(calo_obj_vs_templ_pipe, muon_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_calo_objects*nr_muon_objects) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_muon_objects-1 loop 
            for j in 0 to nr_muon_objects-1 loop
		if j/=i then
		    if deta_cut = true and dphi_cut = false and dr_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j);
		    elsif deta_cut = false and dphi_cut = true and dr_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and diff_phi_comp_pipe(i,j);
		    elsif deta_cut = false and dphi_cut = false and dr_cut = true then
			index := index + 1;
			obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and dr_comp_pipe(i,j);
		    elsif deta_cut = true and dphi_cut = true and dr_cut = false then
			index := index + 1;
			obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j);
		    end if;
		end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_deta_dphi_dr_p;

-- Pipeline stage for condition output.
    condition_o_pipeline_p: process(clk, condition_and_or)
        begin
            if conditions_pipeline_stage = false then 
                condition_o <= condition_and_or;
            else
                if (clk'event and clk = '1') then
                    condition_o <= condition_and_or;
                end if;
            end if;
    end process;
    
end architecture rtl;
    
    
    
    
    
    
    
    
    
    