
-- Description:
-- Correlation Condition module for:
-- 1. two muon objects.
-- 2. mass for 3 objects.
-- 3. muon esums.

-- Version history:
-- HB 2020-02-02: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.math_pkg.all;
use work.gtl_pkg.all;

entity correlation_conditions_muon is
     generic(

        slice_low_obj1: natural := 0;
        slice_high_obj1: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj1: boolean := true;
        pt_threshold_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj1 : natural := 0;
        eta_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj1: natural := 0;
        phi_w1_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj1: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');
        requested_charge_obj1: string(1 to 3) := "ign";
        qual_lut_obj1: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj1: boolean := false;
        upt_upper_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj1: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj1: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        slice_low_obj2: natural := 0;
        slice_high_obj2: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj2: boolean := true;
        pt_threshold_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj2 : natural := 0;
        eta_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj2: natural := 0;
        phi_w1_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj2: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');
        requested_charge_obj2: string(1 to 3) := "ign";
        qual_lut_obj2: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj2: boolean := false;
        upt_upper_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj2: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj2: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        slice_low_obj3: natural := 0;
        slice_high_obj3: natural := NR_MU_OBJECTS-1;
        pt_ge_mode_obj3: boolean := true;
        pt_threshold_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_eta_windows_obj3 : natural := 0;
        eta_w1_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w1_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w2_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w3_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w4_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        eta_w5_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_obj3: natural := 0;
        phi_w1_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        iso_lut_obj3: std_logic_vector(2**MAX_ISO_BITS-1 downto 0) := (others => '1');
        requested_charge_obj3: string(1 to 3) := "ign";
        qual_lut_obj3: std_logic_vector(2**(MUON_QUAL_HIGH-MUON_QUAL_LOW+1)-1 downto 0) := (others => '1');
        upt_cut_obj3: boolean := false;
        upt_upper_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        upt_lower_limit_obj3: std_logic_vector(MAX_TEMPLATES_BITS-1 downto 0) := (others => '0');
        ip_lut_obj3: std_logic_vector(2**(MUON_IP_HIGH-MUON_IP_LOW+1)-1 downto 0) := (others => '1');

        sel_esums: boolean := false;
        obj_type_esums: natural := ETM_TYPE;
        et_ge_mode_esums: boolean := true;
        et_threshold_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        nr_phi_windows_esums: natural := 0;
        phi_w1_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w1_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_upper_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');
        phi_w2_lower_limit_esums: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0) := (others => '0');

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
        upt1_width: positive := MU_UPT_VECTOR_WIDTH;
        upt2_width: positive := MU_UPT_VECTOR_WIDTH;

        mass_cut: boolean := false;
        mass_type : natural := INVARIANT_MASS_TYPE;
        mass_div_dr_vector_width: positive := MU_MU_MASS_DIV_DR_VECTOR_WIDTH;
        mass_div_dr_threshold: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_cosh_cos_precision: positive := MU_MU_COSH_COS_PRECISION;
        cosh_cos_width: positive := MU_MU_COSH_COS_VECTOR_WIDTH;

        twobody_pt_cut: boolean := false;
        pt_sq_threshold_vector: std_logic_vector(MAX_WIDTH_TBPT_LIMIT_VECTOR-1 downto 0) := (others => '0');
        sin_cos_width: positive := MUON_SIN_COS_VECTOR_WIDTH;
        pt_sq_sin_cos_precision : positive := MU_MU_SIN_COS_PRECISION;

        nr_obj2: natural := NR_MU_OBJECTS;

        mass_3_obj: boolean := false;
        same_bx: boolean := false

    );
    port(
        lhc_clk: in std_logic;
        obj1: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        obj2: in muon_objects_array(0 to nr_obj2-1) := (others => (others => '0'));
        obj3: in muon_objects_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        esums: in std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
        ls_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        os_charcorr_double: in muon_charcorr_double_array := (others => (others => '0'));
        ls_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        os_charcorr_triple: in muon_charcorr_triple_array := (others => (others => (others => '0')));
        deta: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        dphi: in deta_dphi_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        pt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        pt2 : in diff_inputs_array(0 to nr_obj2-1) := (others => (others => '0'));
        upt1 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        upt2 : in diff_inputs_array(0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        cosh_deta : in muon_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi : in muon_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        cos_dphi_esums : in calo_muon_cosh_cos_vector_array(0 to NR_MU_OBJECTS-1, 0 to 0) := (others => (others => (others => '0')));
        cos_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        cos_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        sin_phi_1_integer : in sin_cos_integer_array(0 to NR_MU_OBJECTS-1) := (others => 0);
        sin_phi_2_integer : in sin_cos_integer_array(0 to nr_obj2-1) := (others => 0);
        mass_div_dr : in mass_div_dr_vector_array(0 to NR_MU_OBJECTS-1, 0 to nr_obj2-1) := (others => (others => (others => '0')));
        condition_o: out std_logic
    );
end correlation_conditions_muon;

architecture rtl of correlation_conditions_muon is

-- fixed pipeline structure
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double, charge_comp_double_pipe : muon_charcorr_double_array := (others => (others => '1'));
    signal charge_comp_triple, charge_comp_triple_pipe : muon_charcorr_triple_array := (others => (others => (others => '1')));
--***************************************************************

    constant mass_vector_width: positive := pt1_width+pt1_width+cosh_cos_width;
    type sum_mass_array is array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) of std_logic_vector(mass_vector_width+1 downto 0);
    signal sum_mass, sum_mass_temp : sum_mass_array := (others => (others => (others => (others => '0'))));

    signal obj1_vs_templ, obj1_vs_templ_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, 1 to 1) := (others => (others => '0'));
    signal obj2_vs_templ, obj2_vs_templ_pipe : std_logic_2dim_array(slice_low_obj2 to slice_high_obj2, 1 to 1) := (others => (others => '0'));
-- HB 2017-03-27: default values of cut comps -> '1' because of AND in formular of obj_vs_templ_vec
    signal deta_comp, deta_comp_temp, deta_comp_pipe, dphi_comp, dphi_comp_temp, dphi_comp_pipe, dr_comp, dr_comp_temp, dr_comp_pipe, mass_comp, mass_comp_temp, mass_comp_pipe, twobody_pt_comp, twobody_pt_comp_temp, twobody_pt_comp_pipe : std_logic_2dim_array(slice_low_obj1 to slice_high_obj1, slice_low_obj2 to slice_high_obj2) := (others => (others => '1'));

    signal condition_and_or : std_logic;

begin

    obj1_l: for i in slice_low_obj1 to slice_high_obj1 generate
        comp_i: entity work.muon_comparators
            generic map(
                pt_ge_mode_obj1,
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
            port map(obj1(i), obj1_vs_templ(i,1));
    end generate obj1_l;

    pipeline_p: process(lhc_clk, obj1_vs_templ, obj2_vs_templ, obj3_vs_templ, esums_comp, deta_comp, dphi_comp, dr_comp, mass_comp, twobody_pt_comp, charge_comp_double, charge_comp_triple)
        begin
        if obj_vs_templ_pipeline_stage = false then
            obj1_vs_templ_pipe <= obj1_vs_templ;
            obj2_vs_templ_pipe <= obj2_vs_templ;
            obj3_vs_templ_pipe <= obj3_vs_templ;
            esums_comp_pipe <= esums_comp;
            deta_comp_pipe <= deta_comp;
            dphi_comp_pipe <= dphi_comp;
            dr_comp_pipe <= dr_comp;
            mass_comp_pipe <= mass_comp;
            twobody_pt_comp_pipe <= twobody_pt_comp;
            charge_comp_double_pipe <= charge_comp_double;
            charge_comp_triple_pipe <= charge_comp_triple;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                obj1_vs_templ_pipe <= obj1_vs_templ;
                obj2_vs_templ_pipe <= obj2_vs_templ;
                obj3_vs_templ_pipe <= obj3_vs_templ;
                esums_comp_pipe <= esums_comp;
                deta_comp_pipe <= deta_comp;
                dphi_comp_pipe <= dphi_comp;
                dr_comp_pipe <= dr_comp;
                mass_comp_pipe <= mass_comp;
                twobody_pt_comp_pipe <= twobody_pt_comp;
                charge_comp_double_pipe <= charge_comp_double;
                charge_comp_triple_pipe <= charge_comp_triple;
            end if;
        end if;
    end process;

    obj2_l: for i in slice_low_obj2 to slice_high_obj2 generate
        comp_i: entity work.muon_comparators
            generic map(
                pt_ge_mode_obj2,
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
            port map(obj2(i), obj2_vs_templ(i,1));
    end generate obj2_l;

    cuts_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
        cuts_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
            same_obj_bx_range_i: if same_bx and (slice_low_obj1 = slice_low_obj2) and (slice_high_obj1 = slice_high_obj2) generate
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
                            deta_upper_limit_vector => deta_upper_limit_vector,
                            deta_lower_limit_vector => deta_lower_limit_vector,
                            dphi_upper_limit_vector => dphi_upper_limit_vector,
                            dphi_lower_limit_vector => dphi_lower_limit_vector,
                            dr_upper_limit_vector => dr_upper_limit_vector,
                            dr_lower_limit_vector => dr_lower_limit_vector,
                            mass_upper_limit_vector => mass_upper_limit_vector,
                            mass_lower_limit_vector => mass_lower_limit_vector,
                            pt1_width => pt1_width,
                            pt2_width => pt2_width,
                            upt1_width => upt1_width,
                            upt2_width => upt2_width,
                            cosh_cos_precision => mass_cosh_cos_precision,
                            cosh_cos_width => cosh_cos_width,
                            pt_sq_threshold_vector => pt_sq_threshold_vector,
                            sin_cos_width => sin_cos_width,
                            pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                        )
                        port map(
                            deta => deta(i,j),
                            dphi => dphi(i,j),
                            pt1 => pt1(i),
                            pt2 => pt2(j),
                            upt1 => upt1(i),
                            upt2 => upt2(j),
                            cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                            cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
                            cos_phi_1_integer => cos_phi_1_integer(i),
                            cos_phi_2_integer => cos_phi_2_integer(j),
                            sin_phi_1_integer => sin_phi_1_integer(i),
                            sin_phi_2_integer => sin_phi_2_integer(j),
                            deta_comp => deta_comp_temp(i,j),
                            dphi_comp => dphi_comp_temp(i,j),
                            dr_comp => dr_comp_temp(i,j),
                            mass_comp => mass_comp_temp(i,j),
                            invariant_mass => invariant_mass_temp(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0),
                            twobody_pt_comp => twobody_pt_comp_temp(i,j)
                        );
                    deta_comp(i,j) <= deta_comp_temp(i,j);
                    deta_comp(j,i) <= deta_comp_temp(i,j);
                    dphi_comp(i,j) <= dphi_comp_temp(i,j);
                    dphi_comp(j,i) <= dphi_comp_temp(i,j);
                    dr_comp(i,j) <= dr_comp_temp(i,j);
                    dr_comp(j,i) <= dr_comp_temp(i,j);
                    mass_comp(i,j) <= mass_comp_temp(i,j);
                    mass_comp(j,i) <= mass_comp_temp(i,j);
                    invariant_mass(i,j) <= invariant_mass_temp(i,j);
                    invariant_mass(j,i) <= invariant_mass_temp(i,j);
                    twobody_pt_comp(i,j) <= twobody_pt_comp_temp(i,j);
                    twobody_pt_comp(j,i) <= twobody_pt_comp_temp(i,j);
                end generate if_j_gr_i;
            end generate same_obj_bx_range_i;

            diffrent_obj_bx_range_i: if not same_bx or (slice_low_obj1 /= slice_low_obj2) or (slice_high_obj1 /= slice_high_obj2) generate
                cuts_instances_i: entity work.cuts_instances
                    generic map(
                        deta_cut => deta_cut,
                        dphi_cut => dphi_cut,
                        dr_cut => dr_cut,
                        mass_cut => mass_cut,
                        mass_type => mass_type,
                        twobody_pt_cut => twobody_pt_cut,
                        deta_upper_limit_vector => deta_upper_limit_vector,
                        deta_lower_limit_vector => deta_lower_limit_vector,
                        dphi_upper_limit_vector => dphi_upper_limit_vector,
                        dphi_lower_limit_vector => dphi_lower_limit_vector,
                        dr_upper_limit_vector => dr_upper_limit_vector,
                        dr_lower_limit_vector => dr_lower_limit_vector,
                        mass_upper_limit_vector => mass_upper_limit_vector,
                        mass_lower_limit_vector => mass_lower_limit_vector,
                        pt1_width => pt1_width,
                        pt2_width => pt2_width,
                        upt1_width => upt1_width,
                        upt2_width => upt2_width,
                        cosh_cos_precision => mass_cosh_cos_precision,
                        cosh_cos_width => cosh_cos_width,
                        pt_sq_threshold_vector => pt_sq_threshold_vector,
                        sin_cos_width => sin_cos_width,
                        pt_sq_sin_cos_precision => pt_sq_sin_cos_precision
                    )
                    port map(
                        deta => deta(i,j),
                        dphi => dphi(i,j),
                        pt1 => pt1(i),
                        pt2 => pt2(j),
                        upt1 => upt1(i),
                        upt2 => upt2(j),
                        cosh_deta => cosh_deta(i,j)(cosh_cos_width-1 downto 0),
                        cos_dphi => cos_dphi(i,j)(cosh_cos_width-1 downto 0),
                        cos_phi_1_integer => cos_phi_1_integer(i),
                        cos_phi_2_integer => cos_phi_2_integer(j),
                        sin_phi_1_integer => sin_phi_1_integer(i),
                        sin_phi_2_integer => sin_phi_2_integer(j),
                        deta_comp => deta_comp(i,j),
                        dphi_comp => dphi_comp(i,j),
                        dr_comp => dr_comp(i,j),
                        mass_comp => mass_comp(i,j),
                        invariant_mass => invariant_mass(i,j)(pt1_width+pt2_width+cosh_cos_width-1 downto 0),
                        twobody_pt_comp => twobody_pt_comp(i,j)
                    );
            end generate diffrent_obj_bx_range_i;
        end generate cuts_l_2;
    end generate cuts_l_1;

    charge_double_i: if requested_charge_correlation /= "ig" generate
    -- Charge correlation comparison
        charge_double_l_1: for i in slice_low_obj1 to slice_high_obj1 generate
            charge_double_l_2: for j in slice_low_obj2 to slice_high_obj2 generate
                obj_same_bx_l: if same_bx = true generate
                    charge_double_if: if j/=i generate
                        charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                            '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                            '1' when requested_charge_correlation = "ig" else '0';
                    end generate charge_double_if;
                end generate obj_same_bx_l;
                obj_different_bx_l: if same_bx = false generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                        '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                        '1' when requested_charge_correlation = "ig" else '0';
                end generate obj_different_bx_l;
            end generate charge_double_l_2;
        end generate charge_double_l_1;
    end generate charge_double_i;

    matrix_and_or_p: process(obj1_vs_templ_pipe, obj2_vs_templ_pipe, deta_comp_pipe, dphi_comp_pipe, dr_comp_pipe, mass_comp_pipe, mass_div_dr_comp_pipe, twobody_pt_comp_pipe, charge_comp_double_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((slice_high_obj1-slice_low_obj1+1)*(slice_high_obj2-slice_low_obj2+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in slice_low_obj1 to slice_high_obj1 loop
            for j in slice_low_obj2 to slice_high_obj2 loop
                if same_bx then
                    if j/=i then
                    index := index + 1;
                    obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j) and charge_comp_double_pipe(i,j);
                    end if;
                else
                    index := index + 1;
                    obj_vs_templ_vec(index) := obj1_vs_templ_pipe(i,1) and obj2_vs_templ_pipe(j,1) and deta_comp_pipe(i,j) and dphi_comp_pipe(i,j) and dr_comp_pipe(i,j) and mass_comp_pipe(i,j) and twobody_pt_comp_pipe(i,j) and charge_comp_double_pipe(i,j);
                end if;
            end loop;
        end loop;
        for i in 1 to index loop
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process;

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
