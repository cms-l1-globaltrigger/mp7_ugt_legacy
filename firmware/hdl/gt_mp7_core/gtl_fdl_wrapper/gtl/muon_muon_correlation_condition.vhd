
-- Desription:
-- Correlation Condition module for muon objects.

-- Version history:
-- HB 2020-12-21: changed names.
-- HB 2020-12-14: changed "phi cuts", used "nr_phi_windows" now. New order in generic.
-- HB 2020-11-26: updated default parameters.
-- HB 2020-10-16: removed parameters from generic.
-- HB 2020-10-09: added parameter for invariant mass div by delta R comparison. Changed names for mass limits.
-- HB 2020-08-27: implemented invariant mass div by delta R comparison.
-- HB 2020-08-10: inserted "twobody unconstraint pt".
-- HB 2020-06-09: implemented new muon structure with "unconstraint pt" and "impact parameter".
-- HB 2019-06-17: updated for "five eta cuts".
-- HB 2019-05-06: updated instances.
-- HB 2019-05-06: renamed from muon_muon_correlation_condition_v4 to muon_muon_correlation_condition.
-- HB 2017-10-02: based on muon_muon_correlation_condition_v3 - used limit vectors for correlation cuts.
-- HB 2017-09-06: inserted port muon2_data_i again - bug fix.
-- HB 2017-09-05: removed port muon2_data_i, used muon1_data_i instead in logic.
-- HB 2017-08-18: improved cuts_instances loops.
-- HB 2017-07-03: changed to muon_muon_correlation_condition_v3 for correct use of different object slices.
-- HB 2017-06-28: charge correlation comparison inserted for different bx data (bug fix).
-- HB 2017-03-29: updated for one "sin_cos_width" in mass_cuts.
-- HB 2017-03-28: updated to provide all combinations of cuts (eg.: MASS and DR). Using integer for cos and sin phi inputs.
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations only for one half of permutations, second half by assignment of "mirrored" indices
-- HB 2017-02-07: used dr_calculator_v2.
-- HB 2017-02-01: used "muon_object_low" and "muon_object_high" for object ranges.
-- HB 2017-01-20: used only "pt_width" generic parameter instead of "pt_width_1" and "pt_width_2".
-- HB 2017-01-18: updated "mass_cuts".
-- HB 2017-01-18: first design of version 2 - replaced "invariant_mass" with "mass_cuts".

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_muon_correlation_condition is
     generic(
     
        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1: natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj1: natural := 0;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj1: std_logic_vector(2**(MUON_ISO_HIGH-MUON_ISO_LOW+1)-1 downto 0) := (others => '1');
        requested_charge_obj1: string(1 to 3) := "ign";
        qual_lut_obj1: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj1 : boolean := false;
        upt_upper_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj1: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

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
        upt_cut_obj2 : boolean := false;
        upt_upper_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj2: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        requested_charge_correlation: string(1 to 2) := "ig";

        deta_cut: boolean := false;
        deta_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        deta_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dphi_cut: boolean := false;
        dphi_upper_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dphi_lower_limit_vector: std_logic_vector(MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR-1 downto 0) := (others => '0');

        dr_cut: boolean := false;
        dr_upper_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        dr_lower_limit_vector: std_logic_vector(MAX_WIDTH_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');

        pt1_width: positive := MU_PT_VECTOR_WIDTH; 
        pt2_width: positive := MU_PT_VECTOR_WIDTH; 

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_div_dr_vector_width: positive := MU_MU_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := MU_MU_COSH_COS_PRECISION;
        cosh_cos_width: positive := MU_MU_COSH_COS_VECTOR_WIDTH;

        twobody_pt_cut: boolean := false;
        pt_width: positive := MU_PT_VECTOR_WIDTH; 
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        twobody_upt_cut: boolean := false;
        upt_width: positive := MU_UPT_VECTOR_WIDTH; 
        upt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;
        
        same_bx: boolean 
    );
    port(
        lhc_clk: in std_logic;
        muon1_data_i: in muon_objects_array;
        muon2_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        deta: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        upt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        upt2 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        cosh_deta : in common_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        cos_dphi : in common_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        mass_div_dr : in mass_div_dr_vector_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end muon_muon_correlation_condition; 

architecture rtl of muon_muon_correlation_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type muon1_object_vs_template_array is array (slice_low_obj1 to slice_high_obj1, 1 to 1) of std_logic;
    type muon2_object_vs_template_array is array (slice_low_obj2 to slice_high_obj2, 1 to 1) of std_logic;

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--***************************************************************

    signal muon1_obj_vs_templ : muon1_object_vs_template_array;
    signal muon1_obj_vs_templ_pipe : muon1_object_vs_template_array;
    signal muon2_obj_vs_templ : muon2_object_vs_template_array;
    signal muon2_obj_vs_templ_pipe : muon2_object_vs_template_array;
-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal deta_comp, deta_comp_temp, deta_comp_pipe, 
        dphi_comp, dphi_comp_temp, dphi_comp_pipe, 
        dr_comp,   dr_comp_temp, dr_comp_pipe, 
        mass_comp, mass_comp_temp, mass_comp_pipe, 
        twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe, 
        twobody_upt_comp, twobody_upt_comp_temp, twobody_upt_comp_pipe : 
        std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) :=
        (others => (others => '1'));

    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : 
        std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) :=
        (others => (others => '1'));

    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************

    -- Comparison with limits.
    delta_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
        delta_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
            same_bx_same_range_i: if same_bx and (slice_low_obj1 = slice_low_obj2) and (slice_high_obj1 = slice_high_obj2) generate
-- HB 2017-02-21: optimisation of LUTs and DSP resources: calculations of cuts only for one half of permutations, second half by assignment of "mirrored" indices.
                if_j_gr_i: if j > i generate
                    cuts_instances_i: entity work.cuts_instances
                        generic map(
                            deta_cut => deta_cut,
                            dphi_cut => dphi_cut,
                            dr_cut => dr_cut,
                            mass_cut => mass_cut,
                            mass_type => mass_type,
                            twobody_pt_cut => twobody_pt_cut,
                            twobody_upt_cut => twobody_upt_cut,
                            deta_upper_limit_vector => deta_upper_limit_vector,
                            deta_lower_limit_vector => deta_lower_limit_vector,
                            dphi_upper_limit_vector => dphi_upper_limit_vector,
                            dphi_lower_limit_vector => dphi_lower_limit_vector,
                            dr_upper_limit_vector => dr_upper_limit_vector,
                            dr_lower_limit_vector => dr_lower_limit_vector,
                            mass_upper_limit_vector => mass_upper_limit_vector,
                            mass_lower_limit_vector => mass_lower_limit_vector,
                            pt1_width => MU_PT_VECTOR_WIDTH, 
                            pt2_width => MU_PT_VECTOR_WIDTH, 
                            upt1_width => MU_UPT_VECTOR_WIDTH, 
                            upt2_width => MU_UPT_VECTOR_WIDTH, 
                            cosh_cos_precision => MU_MU_COSH_COS_PRECISION,
                            cosh_cos_width => MU_MU_COSH_COS_VECTOR_WIDTH,
                            pt_sq_threshold_vector => pt_sq_threshold_vector,
                            upt_sq_threshold_vector => upt_sq_threshold_vector,
                            sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
                            pt_sq_sin_cos_precision => MU_MU_SIN_COS_PRECISION
                        )
                        port map(
                            deta => deta(i,j),
                            dphi => dphi(i,j),
                            pt1 => pt1(i),
                            pt2 => pt2(j),
                            upt1 => upt1(i),
                            upt2 => upt2(j),
                            cosh_deta => cosh_deta(i,j),
                            cos_dphi => cos_dphi(i,j),
                            cos_phi_1_integer => cos_phi_1_integer(i),
                            cos_phi_2_integer => cos_phi_2_integer(j),
                            sin_phi_1_integer => sin_phi_1_integer(i),
                            sin_phi_2_integer => sin_phi_2_integer(j),
                            deta_comp => deta_comp_temp(i,j),
                            dphi_comp => dphi_comp_temp(i,j),
                            dr_comp => dr_comp_temp(i,j),
                            mass_comp => mass_comp_temp(i,j),
                            twobody_pt_comp => twobody_pt_comp_temp(i,j),
                            twobody_upt_comp => twobody_upt_comp_temp(i,j)
                        );
                    deta_comp(i,j) <= deta_comp_temp(i,j);
                    deta_comp(j,i) <= deta_comp_temp(i,j);
                    dphi_comp(i,j) <= dphi_comp_temp(i,j);
                    dphi_comp(j,i) <= dphi_comp_temp(i,j);
                    dr_comp(i,j) <= dr_comp_temp(i,j);
                    dr_comp(j,i) <= dr_comp_temp(i,j);
                    mass_comp(i,j) <= mass_comp_temp(i,j);
                    mass_comp(j,i) <= mass_comp_temp(i,j);
                    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
                    twobody_upt_comp(i,j) <= twobody_upt_comp_temp(i,j);
                    twobody_upt_comp(j,i) <= twobody_upt_comp_temp(i,j);
                end generate if_j_gr_i;
            end generate same_bx_same_range_i;
            different_bx_different_range_i: if not same_bx or (slice_low_obj1 /= slice_low_obj2) or (slice_high_obj1 /= slice_high_obj2) generate
                cuts_instances_i: entity work.cuts_instances
                    generic map(
                        deta_cut => deta_cut,
                        dphi_cut => dphi_cut,
                        dr_cut => dr_cut,
                        mass_cut => mass_cut,
                        mass_type => mass_type,
                        twobody_pt_cut => twobody_pt_cut,
                        twobody_upt_cut => twobody_upt_cut,
                        deta_upper_limit_vector => deta_upper_limit_vector,
                        deta_lower_limit_vector => deta_lower_limit_vector,
                        dphi_upper_limit_vector => dphi_upper_limit_vector,
                        dphi_lower_limit_vector => dphi_lower_limit_vector,
                        dr_upper_limit_vector => dr_upper_limit_vector,
                        dr_lower_limit_vector => dr_lower_limit_vector,
                        mass_upper_limit_vector => mass_upper_limit_vector,
                        mass_lower_limit_vector => mass_lower_limit_vector,
                        pt1_width => MU_PT_VECTOR_WIDTH, 
                        pt2_width => MU_PT_VECTOR_WIDTH, 
                        upt1_width => MU_UPT_VECTOR_WIDTH, 
                        upt2_width => MU_UPT_VECTOR_WIDTH, 
                        cosh_cos_precision => MU_MU_COSH_COS_PRECISION,
                        cosh_cos_width => MU_MU_COSH_COS_VECTOR_WIDTH,
                        pt_sq_threshold_vector => pt_sq_threshold_vector,
                        upt_sq_threshold_vector => upt_sq_threshold_vector,
                        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
                        pt_sq_sin_cos_precision => MU_MU_SIN_COS_PRECISION
                    )
                    port map(
                        deta => deta(i,j),
                        dphi => dphi(i,j),
                        pt1 => pt1(i),
                        pt2 => pt2(j),
                        upt1 => upt1(i),
                        upt2 => upt2(j),
                        cosh_deta => cosh_deta(i,j),
                        cos_dphi => cos_dphi(i,j),
                        cos_phi_1_integer => cos_phi_1_integer(i),
                        cos_phi_2_integer => cos_phi_2_integer(j),
                        sin_phi_1_integer => sin_phi_1_integer(i),
                        sin_phi_2_integer => sin_phi_2_integer(j),
                        deta_comp => deta_comp(i,j),
                        dphi_comp => dphi_comp(i,j),
                        dr_comp => dr_comp(i,j),
                        mass_comp => mass_comp(i,j),
                        twobody_pt_comp => twobody_pt_comp(i,j),
                        twobody_upt_comp => twobody_upt_comp(i,j)
                    );
            end generate different_bx_different_range_i;
        end generate delta_l_2;
    end generate delta_l_1;

-- HB 2020-08-27: comparison for invariant mass divided by delta R.
    mass_div_dr_sel: if mass_cut and mass_type = INVARIANT_MASS_DIV_DR_TYPE generate
        mass_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
            mass_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                mass_comp_l1: if same_bx = true and j>i generate
                    comp_i: entity work.mass_div_dr_comp
                        generic map(
                            MU_MU_MASS_DIV_DR_VECTOR_WIDTH,
                            mass_div_dr_threshold 
                        )
                        port map(
                            mass_div_dr(i,j)(MU_MU_MASS_DIV_DR_VECTOR_WIDTH-1 downto 0),
                            mass_div_dr_comp_t(i,j)
                        );
                    mass_div_dr_comp_pipe(i,j) <= mass_div_dr_comp_t(i,j);
                    mass_div_dr_comp_pipe(j,i) <= mass_div_dr_comp_t(i,j);
                end generate mass_comp_l1;
                mass_comp_l2: if same_bx = false generate
                    comp_i: entity work.mass_div_dr_comp
                        generic map(
                            MU_MU_MASS_DIV_DR_VECTOR_WIDTH,
                            mass_div_dr_threshold 
                        )
                        port map(
                            mass_div_dr(i,j)(MU_MU_MASS_DIV_DR_VECTOR_WIDTH-1 downto 0),
                            mass_div_dr_comp_pipe(i,j)
                        );
                end generate mass_comp_l2;
            end generate mass_l_2;
        end generate mass_l_1;
    end generate mass_div_dr_sel;
    
    -- Pipeline stage for cut comps
    diff_pipeline_p: process(lhc_clk, deta_comp, dphi_comp, dr_comp, mass_comp, twobody_pt_comp, twobody_upt_comp)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
            twobody_upt_comp_pipe <= twobody_upt_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                deta_comp_pipe <= deta_comp;
                dphi_comp_pipe <= dphi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
                twobody_upt_comp_pipe <= twobody_upt_comp;
            end if;
        end if;
    end process;
    -- *** section: CUTs - end ***************************************************************************************

    obj_templ1_l: for i in slice_low_obj1 to slice_high_obj1 generate
        obj_templ1_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_obj1,
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
                requested_charge_obj1,
                qual_lut_obj1,
                iso_lut_obj1,
                upt_cut_obj1,
                upt_upper_limit_obj1,
                upt_lower_limit_obj1,
                ip_lut_obj1
            )
            port map(muon1_data_i(i), muon1_obj_vs_templ(i,1));
    end generate obj_templ1_l;

    obj_templ2_l_l: for i in slice_low_obj2 to slice_high_obj2 generate
        obj_templ2_comp_i: entity work.muon_comparators
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
            port map(muon2_data_i(i), muon2_obj_vs_templ(i,1));
    end generate obj_templ2_l_l;

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
    charge_double_l_1: for i in slice_low_obj1 to slice_high_obj1 generate 
        charge_double_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
            obj_same_bx_l: if same_bx = true generate
                charge_double_if: if j/=i generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                               '1' when requested_charge_correlation = "ig" else
                                               '0';
                end generate charge_double_if;
            end generate obj_same_bx_l;
            obj_different_bx_l: if same_bx = false generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                               '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                               '1' when requested_charge_correlation = "ig" else
                                               '0';
            end generate obj_different_bx_l;
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
    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, charge_comp_double_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_comp_pipe, mass_div_dr_comp_pipe, twobody_pt_comp_pipe, twobody_upt_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in slice_low_obj1 to slice_high_obj1 loop 
            for j in slice_low_obj2 to slice_high_obj2 loop
                if same_bx = true then
                    if j/=i then
                        index := index + 1;
                        obj_vs_templ_vec(index) := 
                            muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and  
                            charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and 
                            dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and 
                            mass_div_dr_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j) and twobody_upt_comp_pipe(i,j);
                    end if;
                else
                    index := index + 1;
                    obj_vs_templ_vec(index) := 
                        muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and 
                        charge_comp_double_pipe(i,j) and deta_comp_pipe(i,j) and
                        dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and 
                        mass_div_dr_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j) and twobody_upt_comp_pipe(i,j);
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
    
    
    
    
    
    
    
    
    
    
