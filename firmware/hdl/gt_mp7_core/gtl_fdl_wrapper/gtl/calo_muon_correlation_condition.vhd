
-- Desription:
-- Correlation Condition module for calorimeter object types (eg, jet and tau) and muon.

-- Version history:
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New order in generic.
-- HB 2020-11-26: updated default parameters.
-- HB 2020-10-09: added parameter for invariant mass div by delta R comparison. Changed names for mass limits.
-- HB 2020-08-27: implemented invariant mass div by delta R comparison.
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" and "impact parameter".
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

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_EG_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1 : natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj1: natural := 0;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0) := (others => '1');

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2: natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj2: natural := 0;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj2: std_logic_vector(2**(MUON_ISO_HIGH-MUON_ISO_LOW+1)-1 downto 0) := (others => '1');
        requested_charge_obj2: string(1 to 3) := "ign";
        qual_lut_obj2: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_muon: boolean := false;
        upt_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj2: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        deta_cut: boolean := false;
        diff_eta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        diff_eta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean:= false;
        diff_phi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        diff_phi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean:= false;
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        pt1_width: positive := EG_PT_VECTOR_WIDTH; 
        pt2_width: positive := MU_PT_VECTOR_WIDTH; 

        mass_cut: boolean := false;
        mass_type: natural := INVARIANT_MASS_TYPE;
        mass_div_dr_vector_width: positive := MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := EG_MU_COSH_COS_PRECISION;
        cosh_cos_width: positive := EG_MU_COSH_COS_VECTOR_WIDTH;

        twobody_pt_cut: boolean := false;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision: positive := EG_MU_SIN_COS_PRECISION;

        type_obj1: natural := EG_TYPE;
        nr_calo_objects: natural := NR_EG_OBJECTS
        
    );
    port(
        lhc_clk: in std_logic;
        calo_data_i: in calo_objects_array;
        muon_data_i: in muon_objects_array;
        diff_eta: in deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        diff_phi: in deta_dphi_vector_array(0 to nr_calo_objects-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to nr_calo_objects-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        cosh_deta : in calo_muon_cosh_cos_vector_array(0 to nr_calo_objects-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        cos_dphi : in calo_muon_cosh_cos_vector_array(0 to nr_calo_objects-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to nr_calo_objects-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        mass_div_dr : in mass_div_dr_vector_array(0 to nr_calo_objects-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end calo_muon_correlation_condition; 

architecture rtl of calo_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

-- fixed to 1 for current implementation of correlation conditions
    constant nr_templates: positive := 1;  

    type calo_object_vs_template_array is array (slice_low_obj1 to slice_high_obj1, 1 to nr_templates) of std_logic;
    type muon_object_vs_template_array is array (slice_low_obj2 to slice_high_obj2, 1 to nr_templates) of std_logic;

    signal calo_obj_vs_templ : calo_object_vs_template_array;
    signal calo_obj_vs_templ_pipe : calo_object_vs_template_array;
    signal muon_obj_vs_templ : muon_object_vs_template_array;
    signal muon_obj_vs_templ_pipe : muon_object_vs_template_array;
-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal diff_eta_comp, diff_eta_comp_pipe, diff_phi_comp, diff_phi_comp_pipe, dr_comp, dr_comp_pipe, mass_comp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_pipe : 
        std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));

    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) :=
    (others => (others => '1'));

    signal condition_and_or : std_logic;

begin

-- Comparison with limits.
    delta_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
        delta_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
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
                    mass_upper_limit_vector => mass_upper_limit,
                    mass_lower_limit_vector => mass_lower_limit,
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

-- HB 2020-08-27: comparison for invariant mass divided by delta R.
    mass_div_dr_sel: if mass_cut and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
        mass_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
            mass_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                comp_i: entity work.mass_div_dr_comp
                    generic map(
                        mass_div_dr_vector_width,
                        mass_div_dr_threshold 
                    )
                    port map(
                        mass_div_dr(i,j)(mass_div_dr_vector_width-1 downto 0),
                        mass_div_dr_comp_pipe(i,j)
                    );
            end generate mass_l_2;
        end generate mass_l_1;
    end generate mass_div_dr_sel;
    
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
    calo_obj_l: for i in slice_low_obj1 to slice_high_obj1 generate
        calo_comp_i: entity work.calo_comparators
            generic map(pt_ge_mode_obj1, type_obj1,
                pt_threshold_obj1,
                nr_eta_windows_obj1,
                eta_w1_upper_limit_obj1,
                eta_w1_lower_limit_obj1,
                eta_w2_upper_limit_obj1,
                eta_w2_lower_limit_obj1,
                eta_w3_upper_limit_obj1,
                eta_w3_lower_limit_obj1,
                eta_w4_upper_limit_obj1,
                eta_w4_lower_limit_obj1,
                eta_w5_upper_limit_obj1,
                eta_w5_lower_limit_obj1,
                nr_phi_windows_obj1,
                phi_w1_upper_limit_obj1,
                phi_w1_lower_limit_obj1,
                phi_w2_upper_limit_obj1,
                phi_w2_lower_limit_obj1,
                iso_lut_obj1
            )
            port map(calo_data_i(i), calo_obj_vs_templ(i,1));
    end generate calo_obj_l;

-- Instance of comparators for muon objects.
    muon_obj_l: for i in slice_low_obj2 to slice_high_obj2 generate
        muon_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_obj2,
                pt_threshold_obj2,
                nr_eta_windows_obj2,
                eta_w1_upper_limit_obj2,
                eta_w1_lower_limit_obj2,
                eta_w2_upper_limit_obj2,
                eta_w2_lower_limit_obj2,
                eta_w3_upper_limit_obj2,
                eta_w3_lower_limit_obj2,
                eta_w4_upper_limit_obj2,
                eta_w4_lower_limit_obj2,
                eta_w5_upper_limit_obj2,
                eta_w5_lower_limit_obj2,
                nr_phi_windows_obj2,
                phi_w1_upper_limit_obj2,
                phi_w1_lower_limit_obj2,
                phi_w2_upper_limit_obj2,
                phi_w2_lower_limit_obj2,
                requested_charge_obj2,
                qual_lut_obj2,
                iso_lut_obj2,
                upt_cut_obj2,
                upt_upper_limit_obj2,
                upt_lower_limit_obj2,
                ip_lut_obj2
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

    matrix_deta_dphi_dr_p: process(calo_obj_vs_templ_pipe, muon_obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe, dr_comp_pipe, mass_comp_pipe, mass_div_dr_comp_pipe, twobody_pt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in slice_low_obj1 to slice_high_obj1 loop 
            for j in slice_low_obj2 to slice_high_obj2 loop
                index := index + 1;
               obj_vs_templ_vec(index) := calo_obj_vs_templ_pipe(i,1) and muon_obj_vs_templ_pipe(j,1) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j) and 
                                          dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and mass_div_dr_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j);
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
