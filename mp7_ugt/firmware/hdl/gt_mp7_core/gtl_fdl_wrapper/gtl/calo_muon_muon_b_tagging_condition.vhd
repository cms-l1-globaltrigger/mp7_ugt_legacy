
-- Desription:
-- Correlation Condition module for "b-tagging" (jet-mu-mu).

-- Version history:
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-03: first design with dr_cut only

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_muon_muon_b_tagging_condition is
    generic(

        dr_cut: boolean := true;

        calo_object_low: natural;
        calo_object_high: natural;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := EG_TYPE;
        et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo: natural;
        eta_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo: boolean;
        phi_w1_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo: boolean;
        phi_w2_upper_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        muon_object_low: natural;
        muon_object_high: natural;
        pt_ge_mode_muon_1: boolean;
        pt_threshold_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_muon1: natural;
        eta_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon_1: boolean;
        phi_w1_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon_1: boolean;
        phi_w2_upper_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon_1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon_1: string(1 to 3);
        qual_lut_muon_1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon_1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

        pt_ge_mode_muon_2: boolean;
        pt_threshold_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_muon2: natural;
        eta_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon_2: boolean;
        phi_w1_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon_2: boolean;
        phi_w2_upper_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon_2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon_2: string(1 to 3);
        qual_lut_muon_2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon_2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

        dr_upper_limit: dr_squared_range_real;
        dr_lower_limit: dr_squared_range_real;

        DETA_DPHI_VECTOR_WIDTH: positive ;
        DETA_DPHI_PRECISION: positive

    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        muon_data_i: in muon_objects_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        condition_o: out std_logic
    );
end calo_muon_muon_b_tagging_condition; 

architecture rtl of calo_muon_muon_b_tagging_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type calo_object_vs_template_array is array (calo_object_low to calo_object_high, 1 to 1) of std_logic;
    type muon_object_vs_template_array is array (muon_object_low to muon_object_high, 1 to 2) of std_logic;
    type diff_comp_array is array (calo_object_low to calo_object_high, muon_object_low to muon_object_high) of std_logic;

    signal calo_obj_vs_templ : calo_object_vs_template_array := (others => (others => '0'));
    signal calo_obj_vs_templ_pipe : calo_object_vs_template_array := (others => (others => '0'));
    signal muon_obj_vs_templ : muon_object_vs_template_array := (others => (others => '0'));
    signal muon_obj_vs_templ_pipe : muon_object_vs_template_array := (others => (others => '0'));
    signal dr_comp : diff_comp_array;
    signal dr_comp_pipe : diff_comp_array := (others => (others => '0'));

    signal condition_and_or : std_logic;

begin

-- HB 2017-01-25: failure if charges are not pos. and neg.
    assert ((requested_charge_muon_1 = "pos" and requested_charge_muon_2 = "neg") or (requested_charge_muon_1 = "neg" and requested_charge_muon_2 = "pos")) report 
	"requested charges are not 'positve' [pos] and 'negative' [neg] (see requested_charge_muon_1 and requested_charge_muon_2)" severity failure;

-- Comparison of DR with limits.
    delta_l_1: for i in calo_object_low to calo_object_high generate 
	delta_l_2: for j in muon_object_low to muon_object_high generate
	    dr_i: if dr_cut = true generate
		dr_calculator_i: entity work.dr_calculator
		    generic map(
			upper_limit => dr_upper_limit,
			lower_limit => dr_lower_limit,
			DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH,
			DETA_DPHI_PRECISION => DETA_DPHI_PRECISION
		    )
		    port map(
			diff_eta => diff_eta(i,j),
			diff_phi => diff_phi(i,j),
			dr_comp => dr_comp(i,j)
		    );
	    end generate dr_i;
        end generate delta_l_2;
    end generate delta_l_1;

-- Pipeline stage for dr_comp
    diff_pipeline_p: process(lhc_clk, dr_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                if dr_cut = true then
                    dr_comp_pipe <= dr_comp;
                end if;
           else
                if (lhc_clk'event and lhc_clk = '1') then
                    if dr_cut = true then
                        dr_comp_pipe <= dr_comp;
                    end if;
                end if;
            end if;
    end process;

-- Instance of comparators for calorimeter objects.
    calo_obj_l: for i in calo_object_low to calo_object_high generate
	calo_comp_i: entity work.calo_comparators
	    generic map(et_ge_mode_calo, obj_type_calo,
                et_threshold_calo,
                nr_eta_windows_calo,
                eta_w1_upper_limit_calo,
                eta_w1_lower_limit_calo,
                eta_w2_upper_limit_calo,
                eta_w2_lower_limit_calo,
                eta_w3_upper_limit_calo,
                eta_w3_lower_limit_calo,
                eta_w4_upper_limit_calo,
                eta_w4_lower_limit_calo,
                eta_w5_upper_limit_calo,
                eta_w5_lower_limit_calo,
                phi_full_range_calo,
                phi_w1_upper_limit_calo,
                phi_w1_lower_limit_calo,
                phi_w2_ignore_calo,
                phi_w2_upper_limit_calo,
                phi_w2_lower_limit_calo,
                iso_lut_calo
            )
            port map(calo_data_i(i), calo_obj_vs_templ(i,1));
    end generate calo_obj_l;

-- Instance of comparators for muon objects.
    muon_obj_1_l: for i in muon_object_low to muon_object_high generate
        muon_1_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon_1,
                pt_threshold_muon_1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon1,
                eta_w1_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon1(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon_1,
                phi_w1_upper_limit_muon_1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon_1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon_1,
                phi_w2_upper_limit_muon_1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon_1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon_1,
                qual_lut_muon_1,
                iso_lut_muon_1
                )
            port map(muon_data_i(i), muon_obj_vs_templ(i,1));
     end generate muon_obj_1_l;

    muon_obj_2_l: for i in muon_object_low to muon_object_high generate
        muon_2_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon_2,
                pt_threshold_muon_2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon2,
                eta_w1_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon2(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon_2,
                phi_w1_upper_limit_muon_2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon_2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon_2,
                phi_w2_upper_limit_muon_2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon_2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon_2,
                qual_lut_muon_2,
                iso_lut_muon_2
                )
            port map(muon_data_i(i), muon_obj_vs_templ(i,2));
     end generate muon_obj_2_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo_obj_vs_templ, muon_obj_vs_templ)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
                muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    calo_obj_vs_templ_pipe <= calo_obj_vs_templ;
                    muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
                end if;
            end if;
    end process;
    
-- "Matrix" of permutations in an and-or-structure.

    matrix_deta_dphi_dr_p: process(calo_obj_vs_templ_pipe, muon_obj_vs_templ_pipe, dr_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((calo_object_high-calo_object_low+1)*(muon_object_high-muon_object_low+1)*(muon_object_high-muon_object_low+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop 
            for j in muon_object_low to muon_object_high loop
		for k in muon_object_low to muon_object_high loop
                    if k/=j then
                        if dr_cut = true then
                            index := index + 1;
			    obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and muon_obj_vs_templ_pipe(k,2) and dr_comp_pipe(i,j) and dr_comp_pipe(i,k);
			end if;
		    end if;
		end loop;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_deta_dphi_dr_p;

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
    
