
-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and muon.

-- Version history:
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from calo_muon_correlation_condition_v3 to calo_muon_correlation_condition.
-- HB 2017-10-02: based on calo_muon_correlation_condition_v2 - used limit vectors for correlation cuts.
-- HB 2017-04-25: "twobody_pt" detached from "mass fixation". Used "mass_calculator.vhd" and "twobody_pt_calculator.vhd" in "cuts_instances" module.
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "xxx_object_low" and "xxx_object_high" for object ranges.
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2017-01-18: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_muon_correlation_condition is
     generic(
        deta_cut: boolean;
        dphi_cut: boolean;
        dr_cut: boolean;
        mass_cut: boolean;
        mass_type : natural;
        twobody_pt_cut: boolean;

        calo_object_low: natural;
        calo_object_high: natural;
        et_ge_mode_calo: boolean;
        obj_type_calo: natural := EG_TYPE;
        et_threshold_calo: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo : natural;
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
        pt_ge_mode_muon: boolean;
        pt_threshold_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_muon : natural;
        eta_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_full_range_muon : boolean;
        phi_w1_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon : boolean;
        phi_w2_upper_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon: string(1 to 3);
        qual_lut_muon: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

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
        mass_cosh_cos_precision : positive;
        cosh_cos_width: positive;

        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0);
        sin_cos_width: positive;
        pt_sq_sin_cos_precision : positive

    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        muon_data_i: in muon_objects_array;
        diff_eta: in deta_dphi_vector_array;
        diff_phi: in deta_dphi_vector_array;
        pt1 : in diff_inputs_array;
        pt2 : in diff_inputs_array;
        cosh_deta : in calo_muon_cosh_cos_vector_array;
        cos_dphi : in calo_muon_cosh_cos_vector_array;
        cos_phi_1_integer : in sin_cos_integer_array;
        cos_phi_2_integer : in sin_cos_integer_array;
        sin_phi_1_integer : in sin_cos_integer_array;
        sin_phi_2_integer : in sin_cos_integer_array;
        condition_o: out std_logic
    );
end calo_muon_correlation_condition; 

architecture rtl of calo_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

-- fixed to 1 for current implementation of correlation conditions
    constant nr_templates: positive := 1;  

    type calo_object_vs_template_array is array (calo_object_low to calo_object_high, 1 to nr_templates) of std_logic;
    type muon_object_vs_template_array is array (muon_object_low to muon_object_high, 1 to nr_templates) of std_logic;

    signal calo_obj_vs_templ : calo_object_vs_template_array;
    signal calo_obj_vs_templ_pipe : calo_object_vs_template_array;
    signal muon_obj_vs_templ : muon_object_vs_template_array;
    signal muon_obj_vs_templ_pipe : muon_object_vs_template_array;
-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal diff_eta_comp, diff_eta_comp_pipe, diff_phi_comp, diff_phi_comp_pipe, dr_comp, dr_comp_pipe, mass_comp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(calo_object_low to calo_object_high, muon_object_low to muon_object_high) := (others => (others => '1'));

    signal condition_and_or : std_logic;

begin

-- Comparison with limits.
    delta_l_1: for i in calo_object_low to calo_object_high generate 
        delta_l_2: for j in muon_object_low to muon_object_high generate
            cuts_instances_i: entity work.cuts_instances
                generic map(
                    deta_cut => deta_cut,
                    dphi_cut => dphi_cut,
                    dr_cut => dr_cut,
                    mass_cut => mass_cut,
                    mass_type => mass_type,
                    twobody_pt_cut => twobody_pt_cut,
                    diff_eta_upper_limit_vector => diff_eta_upper_limit_vector,
                    diff_eta_lower_limit_vector => diff_eta_lower_limit_vector,
                    diff_phi_upper_limit_vector => diff_phi_upper_limit_vector,
                    diff_phi_lower_limit_vector => diff_phi_lower_limit_vector,
                    dr_upper_limit_vector => dr_upper_limit_vector,
                    dr_lower_limit_vector => dr_lower_limit_vector,
                    mass_upper_limit_vector => mass_upper_limit_vector,
                    mass_lower_limit_vector => mass_lower_limit_vector,
                    pt1_width => pt1_width, 
                    pt2_width => pt2_width, 
                    cosh_cos_precision => mass_cosh_cos_precision,
                    cosh_cos_width => cosh_cos_width,
                    pt_sq_threshold_vector => pt_sq_threshold_vector,
                    sin_cos_width => sin_cos_width,
                    pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                )
                port map(
                    diff_eta => diff_eta(i,j),
                    diff_phi => diff_phi(i,j),
                    pt1 => pt1(i),
                    pt2 => pt2(j),
                    cosh_deta => cosh_deta(i,j),
                    cos_dphi => cos_dphi(i,j),
                    cos_phi_1_integer => cos_phi_1_integer(i),
                    cos_phi_2_integer => cos_phi_2_integer(j),
                    sin_phi_1_integer => sin_phi_1_integer(i),
                    sin_phi_2_integer => sin_phi_2_integer(j),
                    diff_eta_comp => diff_eta_comp(i,j),
                    diff_phi_comp => diff_phi_comp(i,j),
                    dr_comp => dr_comp(i,j),
                    mass_comp => mass_comp(i,j),
                    twobody_pt_comp => twobody_pt_comp(i,j)
                );
        end generate delta_l_2;
    end generate delta_l_1;

    -- Pipeline stage for cut comps
    diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp, dr_comp, mass_comp, twobody_pt_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            diff_eta_comp_pipe <= diff_eta_comp;
            diff_phi_comp_pipe <= diff_phi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                diff_eta_comp_pipe <= diff_eta_comp;
                diff_phi_comp_pipe <= diff_phi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
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
    muon_obj_l: for i in muon_object_low to muon_object_high generate
        muon_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon,
                pt_threshold_muon(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
                nr_eta_windows_muon,
                eta_w1_upper_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w1_lower_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_upper_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w2_lower_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_upper_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w3_lower_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_upper_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w4_lower_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_upper_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                eta_w5_lower_limit_muon(D_S_I_MUON_V2.eta_high-D_S_I_MUON_V2.eta_low downto 0),
                phi_full_range_muon,
                phi_w1_upper_limit_muon(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon,
                phi_w2_upper_limit_muon(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon,
                qual_lut_muon,
                iso_lut_muon
                )
            port map(muon_data_i(i), muon_obj_vs_templ(i,1));
     end generate muon_obj_l;

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

    matrix_deta_dphi_dr_p: process(calo_obj_vs_templ_pipe, muon_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, mass_comp_pipe, twobody_pt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((calo_object_high-calo_object_low+1)*(muon_object_high-muon_object_low+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo_object_low to calo_object_high loop 
            for j in muon_object_low to muon_object_high loop
                index := index + 1;
               obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j) and 
                                          dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
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
