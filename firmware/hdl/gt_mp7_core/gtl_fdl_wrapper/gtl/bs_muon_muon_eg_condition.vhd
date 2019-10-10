
-- Desription:
-- Correlation Condition with DR between egamma (calo1) and two muons each, DR between jet (calo2) and a muon, where jet is "opposite" of egamma (DPHI).

-- Version history:
-- HB 2017-08-23: improved dr_muon_muon loops
-- HB 2017-08-22: added "constant vector_length" to handle matrix flexible (depending on objects ranges)
-- HB 2017-08-18: styling: replaced tabs with spaces
-- HB 2017-08-14: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity bs_muon_muon_eg_condition is
     generic(

        calo1_object_low: natural;
        calo1_object_high: natural;
        et_ge_mode_calo1: boolean;
        obj_type_calo1: natural := EG_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo1: boolean;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo1: boolean;
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1: boolean;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1: boolean;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        calo2_object_low: natural;
        calo2_object_high: natural;
        et_ge_mode_calo2: boolean;
        obj_type_calo2: natural := JET_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_full_range_calo2: boolean;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_ignore_calo2: boolean;
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2: boolean;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2: boolean;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        muon_object_low: natural;
        muon_object_high: natural;
        pt_ge_mode_muon: boolean;
        pt_thresholds_muon: muon_templates_array;
        eta_full_range_muon: muon_templates_boolean_array;
        eta_w1_upper_limits_muon: muon_templates_array;
        eta_w1_lower_limits_muon: muon_templates_array;
        eta_w2_ignore_muon: muon_templates_boolean_array;
        eta_w2_upper_limits_muon: muon_templates_array;
        eta_w2_lower_limits_muon: muon_templates_array;
        phi_full_range_muon: muon_templates_boolean_array;
        phi_w1_upper_limits_muon: muon_templates_array;
        phi_w1_lower_limits_muon: muon_templates_array;
        phi_w2_ignore_muon: muon_templates_boolean_array;
        phi_w2_upper_limits_muon: muon_templates_array;
        phi_w2_lower_limits_muon: muon_templates_array;
        requested_charges_muon: muon_templates_string_array;
        qual_luts_muon: muon_templates_quality_array;
        iso_luts_muon: muon_templates_iso_array;
--         requested_charge_correlation_muon: string(1 to 2);

        DETA_DPHI_VECTOR_WIDTH_ALL: positive;
        dr_upper_limit_calo1_muon: dr_squared_range_real;
        dr_lower_limit_calo1_muon: dr_squared_range_real;
        DETA_DPHI_PRECISION_calo1_muon: positive;
        dr_upper_limit_muon_muon: dr_squared_range_real;
        dr_lower_limit_muon_muon: dr_squared_range_real;
        DETA_DPHI_PRECISION_muon_muon: positive;
        dr_upper_limit_calo2_muon: dr_squared_range_real;
        dr_lower_limit_calo2_muon: dr_squared_range_real;
        DETA_DPHI_PRECISION_calo2_muon: positive;
        diff_phi_upper_limit_calo1_calo2: diff_phi_range_real;
        diff_phi_lower_limit_calo1_calo2: diff_phi_range_real;
        DETA_DPHI_PRECISION_calo1_calo2: positive

    );
    port(
        lhc_clk: in std_logic;
        calo1_data_i: in calo_objects_array;
        muon_data_i: in muon_objects_array;
        calo2_data_i: in calo_objects_array;
        diff_eta_calo1_muon: in deta_dphi_vector_array;
        diff_phi_calo1_muon: in deta_dphi_vector_array;
        diff_eta_muon_muon: in deta_dphi_vector_array;
        diff_phi_muon_muon: in deta_dphi_vector_array;
        diff_eta_calo2_muon: in deta_dphi_vector_array;
        diff_phi_calo2_muon: in deta_dphi_vector_array;
        diff_phi_calo1_calo2: in deta_dphi_vector_array;
        condition_o: out std_logic
    );
end bs_muon_muon_eg_condition; 

architecture rtl of bs_muon_muon_eg_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal diff_phi_upper_limit_calo1_calo2_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    signal diff_phi_lower_limit_calo1_calo2_int : std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);
    
    type calo1_object_vs_template_array is array (calo1_object_low to calo1_object_high, 1 to 1) of std_logic;
    type calo2_object_vs_template_array is array (calo2_object_low to calo2_object_high, 1 to 1) of std_logic;
    type muon_object_vs_template_array is array (muon_object_low to muon_object_high, 1 to 3) of std_logic;
    type diff_comp_array_calo1_muon is array (calo1_object_low to calo1_object_high, muon_object_low to muon_object_high) of std_logic;
    type diff_comp_array_calo2_muon is array (calo2_object_low to calo2_object_high, muon_object_low to muon_object_high) of std_logic;
    type diff_comp_array_muon_muon is array (muon_object_low to muon_object_high, muon_object_low to muon_object_high) of std_logic;
    type diff_comp_array_calo1_calo2 is array (calo1_object_low to calo1_object_high, calo2_object_low to calo2_object_high) of std_logic;

    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : calo1_object_vs_template_array := (others => (others => '0'));
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : calo2_object_vs_template_array := (others => (others => '0'));
    signal muon_obj_vs_templ, muon_obj_vs_templ_pipe : muon_object_vs_template_array := (others => (others => '0'));
    signal dr_comp_calo1_muon, dr_comp_calo1_muon_pipe : diff_comp_array_calo1_muon := (others => (others => '1'));
    signal dr_comp_calo2_muon, dr_comp_calo2_muon_pipe : diff_comp_array_calo2_muon := (others => (others => '1'));
    signal dr_comp_muon_muon_temp, dr_comp_muon_muon, dr_comp_muon_muon_pipe : diff_comp_array_muon_muon := (others => (others => '1'));
    signal diff_phi_comp_calo1_calo2, diff_phi_comp_calo1_calo2_pipe : diff_comp_array_calo1_calo2 := (others => (others => '1'));

    signal condition_and_or : std_logic;

    constant calo1_object_range : natural := calo1_object_high-calo1_object_low+1;
    constant calo2_object_range : natural := calo2_object_high-calo2_object_low+1;
    constant muon_object_range : natural := muon_object_high-muon_object_low+1;

-- HB 2017-08-22: added constant vector_length to handle matrix flexible (depending on objects ranges)
--     constant vector_length : natural := integer(real(calo1_object_range*calo2_object_range*muon_object_range*(muon_object_range-1))*0.5);
    constant vector_length : natural := calo2_object_range*muon_object_range*(muon_object_range-1)*(muon_object_range-2);

    signal obj_vs_templ_vec_sig1: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig2: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig3: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig4: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig5: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig6: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig7: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig8: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig9: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig10: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig11: std_logic_vector(vector_length-1 downto 0) := (others => '0');
    signal obj_vs_templ_vec_sig12: std_logic_vector(vector_length-1 downto 0) := (others => '0');

    signal condition_and_or_sig1: std_logic;
    signal condition_and_or_sig2: std_logic;
    signal condition_and_or_sig3: std_logic;
    signal condition_and_or_sig4: std_logic;
    signal condition_and_or_sig5: std_logic;
    signal condition_and_or_sig6: std_logic;
    signal condition_and_or_sig7: std_logic;
    signal condition_and_or_sig8: std_logic;
    signal condition_and_or_sig9: std_logic;
    signal condition_and_or_sig10: std_logic;
    signal condition_and_or_sig11: std_logic;
    signal condition_and_or_sig12: std_logic;

    attribute keep: boolean;    
    attribute keep of obj_vs_templ_vec_sig1  : signal is true;
    attribute keep of obj_vs_templ_vec_sig2  : signal is true;
    attribute keep of obj_vs_templ_vec_sig3  : signal is true;
    attribute keep of obj_vs_templ_vec_sig4  : signal is true;
    attribute keep of obj_vs_templ_vec_sig5  : signal is true;
    attribute keep of obj_vs_templ_vec_sig6  : signal is true;
    attribute keep of obj_vs_templ_vec_sig7  : signal is true;
    attribute keep of obj_vs_templ_vec_sig8  : signal is true;
    attribute keep of obj_vs_templ_vec_sig9  : signal is true;
    attribute keep of obj_vs_templ_vec_sig10 : signal is true;
    attribute keep of obj_vs_templ_vec_sig11 : signal is true;
    attribute keep of obj_vs_templ_vec_sig12 : signal is true;

    attribute keep of condition_and_or_sig1  : signal is true;
    attribute keep of condition_and_or_sig2  : signal is true;
    attribute keep of condition_and_or_sig3  : signal is true;
    attribute keep of condition_and_or_sig4  : signal is true;
    attribute keep of condition_and_or_sig5  : signal is true;
    attribute keep of condition_and_or_sig6  : signal is true;
    attribute keep of condition_and_or_sig7  : signal is true;
    attribute keep of condition_and_or_sig8  : signal is true;
    attribute keep of condition_and_or_sig9  : signal is true;
    attribute keep of condition_and_or_sig10 : signal is true;
    attribute keep of condition_and_or_sig11 : signal is true;
    attribute keep of condition_and_or_sig12 : signal is true;

begin

-- HB 2017-08-17: check calo object types
    assert (obj_type_calo1 = EG_TYPE and obj_type_calo2 = JET_TYPE) report 
        "wrong object types for calos (only EG and JET make sense)!" severity failure;

-- HB 2017-08-22: muon_object_range
    assert (muon_object_range > 2) report 
        "too few muon objects (min. muon objects = 3)" severity failure;

-- HB 2017-08-22: check object lengths
    assert (calo1_object_range <= 12) and (calo2_object_range <= 12) and (muon_object_range <= 8) report 
        "objects ranges exceeded (reduce objects to max. 12 EG, 12 JET and 8 muon objects)" severity failure;

    dr_calo1_muon_l_1: for i in calo1_object_low to calo1_object_high generate 
        dr_calo1_muon_l_2: for j in muon_object_low to muon_object_high generate
            dr_calculator_i: entity work.dr_calculator_v2
                generic map(
                    upper_limit => dr_upper_limit_calo1_muon,
                    lower_limit => dr_lower_limit_calo1_muon,
                    DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
                    DETA_DPHI_PRECISION => DETA_DPHI_PRECISION_calo1_muon
                )
                port map(
                    diff_eta => diff_eta_calo1_muon(i,j),
                    diff_phi => diff_phi_calo1_muon(i,j),
                    dr_comp => dr_comp_calo1_muon(i,j)
                );
        end generate dr_calo1_muon_l_2;
    end generate dr_calo1_muon_l_1;

    dr_muon_muon_l_1: for i in muon_object_low to muon_object_high generate 
        dr_muon_muon_l_2: for j in muon_object_low to muon_object_high generate
            if_j_gr_i: if j > i generate
                dr_calculator_i: entity work.dr_calculator_v2
                    generic map(
                        upper_limit => dr_upper_limit_muon_muon,
                        lower_limit => dr_lower_limit_muon_muon,
                        DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
                        DETA_DPHI_PRECISION => DETA_DPHI_PRECISION_muon_muon
                    )
                    port map(
                        diff_eta => diff_eta_muon_muon(i,j),
                        diff_phi => diff_phi_muon_muon(i,j),
                        dr_comp => dr_comp_muon_muon_temp(i,j)
                    );
                dr_comp_muon_muon(i,j) <= dr_comp_muon_muon_temp(i,j);
                dr_comp_muon_muon(j,i) <= dr_comp_muon_muon_temp(i,j);
            end generate if_j_gr_i;
        end generate dr_muon_muon_l_2;
    end generate dr_muon_muon_l_1;

    dr_calo2_muon_l_1: for i in calo2_object_low to calo2_object_high generate 
        dr_calo2_muon_l_2: for j in muon_object_low to muon_object_high generate
            dr_calculator_i: entity work.dr_calculator_v2
                generic map(
                    upper_limit => dr_upper_limit_calo2_muon,
                    lower_limit => dr_lower_limit_calo2_muon,
                    DETA_DPHI_VECTOR_WIDTH => DETA_DPHI_VECTOR_WIDTH_ALL,
                    DETA_DPHI_PRECISION => DETA_DPHI_PRECISION_calo2_muon
                )
                port map(
                    diff_eta => diff_eta_calo2_muon(i,j),
                    diff_phi => diff_phi_calo2_muon(i,j),
                    dr_comp => dr_comp_calo2_muon(i,j)
                );
        end generate dr_calo2_muon_l_2;
    end generate dr_calo2_muon_l_1;

    diff_phi_upper_limit_calo1_calo2_int <= conv_std_logic_vector(integer(diff_phi_upper_limit_calo1_calo2*real(10**DETA_DPHI_PRECISION_calo1_calo2)),DETA_DPHI_VECTOR_WIDTH_ALL);
    diff_phi_lower_limit_calo1_calo2_int <= conv_std_logic_vector(integer(diff_phi_lower_limit_calo1_calo2*real(10**DETA_DPHI_PRECISION_calo1_calo2)),DETA_DPHI_VECTOR_WIDTH_ALL);

    dphi_calo1_calo2_l_1: for i in calo1_object_low to calo1_object_high generate 
        dphi_calo1_calo2_l_2: for j in calo2_object_low to calo2_object_high generate
            diff_phi_comp_calo1_calo2(i,j) <= '1' when diff_phi_calo1_calo2(i,j) >= diff_phi_lower_limit_calo1_calo2_int and diff_phi_calo1_calo2(i,j) <= diff_phi_upper_limit_calo1_calo2_int else '0';
        end generate dphi_calo1_calo2_l_2;
    end generate dphi_calo1_calo2_l_1;

-- Pipeline stage for dr_comp
    diff_pipeline_p: process(lhc_clk, dr_comp_calo1_muon, dr_comp_muon_muon, dr_comp_calo2_muon, diff_phi_comp_calo1_calo2)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                dr_comp_calo1_muon_pipe <= dr_comp_calo1_muon;
                dr_comp_muon_muon_pipe <= dr_comp_muon_muon;
                dr_comp_calo2_muon_pipe <= dr_comp_calo2_muon;
                diff_phi_comp_calo1_calo2_pipe <= diff_phi_comp_calo1_calo2;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    dr_comp_calo1_muon_pipe <= dr_comp_calo1_muon;
                    dr_comp_muon_muon_pipe <= dr_comp_muon_muon;
                    dr_comp_calo2_muon_pipe <= dr_comp_calo2_muon;
                    diff_phi_comp_calo1_calo2_pipe <= diff_phi_comp_calo1_calo2;
                end if;
            end if;
    end process;

-- Instance of comparators for calorimeter objects.
    calo1_obj_l: for i in calo1_object_low to calo1_object_high generate
        calo1_comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode_calo1, obj_type_calo1,
                et_threshold_calo1,
                eta_full_range_calo1,
                eta_w1_upper_limit_calo1,
                eta_w1_lower_limit_calo1,
                eta_w2_ignore_calo1,
                eta_w2_upper_limit_calo1,
                eta_w2_lower_limit_calo1,
                phi_full_range_calo1,
                phi_w1_upper_limit_calo1,
                phi_w1_lower_limit_calo1,
                phi_w2_ignore_calo1,
                phi_w2_upper_limit_calo1,
                phi_w2_lower_limit_calo1,
                iso_lut_calo1
            )
            port map(calo1_data_i(i), calo1_obj_vs_templ(i,1));
    end generate calo1_obj_l;

    calo2_obj_l: for i in calo2_object_low to calo2_object_high generate
        calo2_comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode_calo2, obj_type_calo2,
                et_threshold_calo2,
                eta_full_range_calo2,
                eta_w1_upper_limit_calo2,
                eta_w1_lower_limit_calo2,
                eta_w2_ignore_calo2,
                eta_w2_upper_limit_calo2,
                eta_w2_lower_limit_calo2,
                phi_full_range_calo2,
                phi_w1_upper_limit_calo2,
                phi_w1_lower_limit_calo2,
                phi_w2_ignore_calo2,
                phi_w2_upper_limit_calo2,
                phi_w2_lower_limit_calo2,
                iso_lut_calo2
            )
            port map(calo2_data_i(i), calo2_obj_vs_templ(i,1));
    end generate calo2_obj_l;

-- Instance of comparators for muon objects.
    muon_obj_l: for i in muon_object_low to muon_object_high generate
        templ_l: for j in 1 to 3 generate
            comp_i: entity work.muon_comparators_v2
                generic map(pt_ge_mode_muon,
                            pt_thresholds_muon(j)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
                            eta_full_range_muon(j),
                            eta_w1_upper_limits_muon(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                            eta_w1_lower_limits_muon(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                            eta_w2_ignore_muon(j),
                            eta_w2_upper_limits_muon(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                            eta_w2_lower_limits_muon(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                            phi_full_range_muon(j),
                            phi_w1_upper_limits_muon(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                            phi_w1_lower_limits_muon(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                            phi_w2_ignore_muon(j),
                            phi_w2_upper_limits_muon(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                            phi_w2_lower_limits_muon(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                            requested_charges_muon(j),
                            qual_luts_muon(j),
                            iso_luts_muon(j)
                            )
                port map(muon_data_i(i), muon_obj_vs_templ(i,j));
        end generate templ_l;
    end generate muon_obj_l;

-- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, muon_obj_vs_templ, calo2_obj_vs_templ)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
                calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
                    muon_obj_vs_templ_pipe <= muon_obj_vs_templ;
                    calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
                end if;
            end if;
    end process;

-- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, muon_obj_vs_templ_pipe, dr_comp_calo1_muon_pipe, dr_comp_calo2_muon_pipe, diff_phi_comp_calo1_calo2_pipe, dr_comp_muon_muon_pipe)
        variable index : integer := 0;
        variable index2 : integer := 0;
        variable test_index : integer := 0;
        variable obj_vs_templ_vec1  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec2  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec3  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec4  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec5  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec6  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec7  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec8  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec9  : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec10 : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec11 : std_logic_vector(vector_length-1 downto 0) := (others => '0');
        variable obj_vs_templ_vec12 : std_logic_vector(vector_length-1 downto 0) := (others => '0');
    begin
        index := 0;
        index2 := 0;
        test_index := 0;
        obj_vs_templ_vec1  := (others => '0');
        obj_vs_templ_vec2  := (others => '0');
        obj_vs_templ_vec3  := (others => '0');
        obj_vs_templ_vec4  := (others => '0');
        obj_vs_templ_vec5  := (others => '0');
        obj_vs_templ_vec6  := (others => '0');
        obj_vs_templ_vec7  := (others => '0');
        obj_vs_templ_vec8  := (others => '0');
        obj_vs_templ_vec9  := (others => '0');
        obj_vs_templ_vec10 := (others => '0');
        obj_vs_templ_vec11 := (others => '0');
        obj_vs_templ_vec12 := (others => '0');
        for i in calo1_object_low to calo1_object_high loop 
            for j in calo2_object_low to calo2_object_high loop
                for k in muon_object_low to muon_object_high loop
                    for l in muon_object_low to muon_object_high loop
                        for m in muon_object_low to muon_object_high loop
                            if l/=k and m/=k and m/=l then
                                if((index mod vector_length) = 0) then
                                    if(index /= 0) then
                                        index2 := 0;
                                        test_index := test_index + 1;
                                    end if;
                                end if;
                                if(test_index = 0) then
                                    obj_vs_templ_vec1(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 1) then
                                    obj_vs_templ_vec2(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 2) then
                                    obj_vs_templ_vec3(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 3) then
                                    obj_vs_templ_vec4(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 4) then
                                    obj_vs_templ_vec5(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 5) then
                                    obj_vs_templ_vec6(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 6) then
                                    obj_vs_templ_vec7(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 7) then
                                    obj_vs_templ_vec8(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 8) then
                                    obj_vs_templ_vec9(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 9) then
                                    obj_vs_templ_vec10(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 10) then
                                    obj_vs_templ_vec11(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                elsif(test_index = 11) then
                                    obj_vs_templ_vec12(index2) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and 
                                                                 muon_obj_vs_templ_pipe(k,1) and muon_obj_vs_templ_pipe(l,2) and muon_obj_vs_templ_pipe(m,3) and 
                                                                 dr_comp_calo1_muon_pipe(i,k) and dr_comp_calo1_muon_pipe(i,l) and dr_comp_muon_muon_pipe(k,l) and
                                                                 dr_comp_calo2_muon_pipe(j,m) and diff_phi_comp_calo1_calo2_pipe(i,j);
                                end if;
                                index := index + 1;
                                index2 := index2 +1;
                            end if;
                        end loop;
                    end loop;
                end loop;
            end loop;
        end loop;
        obj_vs_templ_vec_sig1 <= obj_vs_templ_vec1;
        obj_vs_templ_vec_sig2 <= obj_vs_templ_vec2;
        obj_vs_templ_vec_sig3 <= obj_vs_templ_vec3;
        obj_vs_templ_vec_sig4 <= obj_vs_templ_vec4;
        obj_vs_templ_vec_sig5 <= obj_vs_templ_vec5;
        obj_vs_templ_vec_sig6 <= obj_vs_templ_vec6;
        obj_vs_templ_vec_sig7 <= obj_vs_templ_vec7;
        obj_vs_templ_vec_sig8 <= obj_vs_templ_vec8;
        obj_vs_templ_vec_sig9 <= obj_vs_templ_vec9;
        obj_vs_templ_vec_sig10 <= obj_vs_templ_vec10;
        obj_vs_templ_vec_sig11 <= obj_vs_templ_vec11;
        obj_vs_templ_vec_sig12 <= obj_vs_templ_vec12;
    end process matrix_p;

    matrix_p_2: process(obj_vs_templ_vec_sig1, obj_vs_templ_vec_sig2, obj_vs_templ_vec_sig3, obj_vs_templ_vec_sig4, obj_vs_templ_vec_sig5, 
        obj_vs_templ_vec_sig6, obj_vs_templ_vec_sig7, obj_vs_templ_vec_sig8, obj_vs_templ_vec_sig9, obj_vs_templ_vec_sig10, obj_vs_templ_vec_sig11, obj_vs_templ_vec_sig12)
        variable condition_and_or_tmp1, condition_and_or_tmp2, condition_and_or_tmp3, condition_and_or_tmp4, condition_and_or_tmp5, condition_and_or_tmp6, 
        condition_and_or_tmp7, condition_and_or_tmp8, condition_and_or_tmp9, condition_and_or_tmp10, condition_and_or_tmp11, condition_and_or_tmp12 : std_logic := '0';
    begin
        condition_and_or_tmp1  := '0';
        condition_and_or_tmp2  := '0';
        condition_and_or_tmp3  := '0';
        condition_and_or_tmp4  := '0';
        condition_and_or_tmp5  := '0';
        condition_and_or_tmp6  := '0';
        condition_and_or_tmp7  := '0';
        condition_and_or_tmp8  := '0';
        condition_and_or_tmp9  := '0';
        condition_and_or_tmp10 := '0';
        condition_and_or_tmp11 := '0';
        condition_and_or_tmp12 := '0';
        for i in 0 to vector_length-1 loop
            condition_and_or_tmp1 := condition_and_or_tmp1 or obj_vs_templ_vec_sig1(i);
            condition_and_or_tmp2 := condition_and_or_tmp2 or obj_vs_templ_vec_sig2(i);
            condition_and_or_tmp3 := condition_and_or_tmp3 or obj_vs_templ_vec_sig3(i);
            condition_and_or_tmp4 := condition_and_or_tmp4 or obj_vs_templ_vec_sig4(i);
            condition_and_or_tmp5 := condition_and_or_tmp5 or obj_vs_templ_vec_sig5(i);
            condition_and_or_tmp6 := condition_and_or_tmp6 or obj_vs_templ_vec_sig6(i);
            condition_and_or_tmp7 := condition_and_or_tmp7 or obj_vs_templ_vec_sig7(i);
            condition_and_or_tmp8 := condition_and_or_tmp8 or obj_vs_templ_vec_sig8(i);
            condition_and_or_tmp9 := condition_and_or_tmp9 or obj_vs_templ_vec_sig9(i);
            condition_and_or_tmp10 := condition_and_or_tmp10 or obj_vs_templ_vec_sig10(i);
            condition_and_or_tmp11 := condition_and_or_tmp11 or obj_vs_templ_vec_sig11(i);
            condition_and_or_tmp12 := condition_and_or_tmp12 or obj_vs_templ_vec_sig12(i);
        end loop;
        condition_and_or_sig1 <= condition_and_or_tmp1;
        condition_and_or_sig2 <= condition_and_or_tmp2;
        condition_and_or_sig3 <= condition_and_or_tmp3;
        condition_and_or_sig4 <= condition_and_or_tmp4;
        condition_and_or_sig5 <= condition_and_or_tmp5;
        condition_and_or_sig6 <= condition_and_or_tmp6;
        condition_and_or_sig7 <= condition_and_or_tmp7;
        condition_and_or_sig8 <= condition_and_or_tmp8;
        condition_and_or_sig9 <= condition_and_or_tmp9;
        condition_and_or_sig10 <= condition_and_or_tmp10;
        condition_and_or_sig11 <= condition_and_or_tmp11;
        condition_and_or_sig12 <= condition_and_or_tmp12;
    end process matrix_p_2;
    condition_and_or <= condition_and_or_sig1 or condition_and_or_sig2 or condition_and_or_sig3 or condition_and_or_sig4 or condition_and_or_sig5 or 
        condition_and_or_sig6 or condition_and_or_sig7 or condition_and_or_sig8 or condition_and_or_sig9 or condition_and_or_sig10 or condition_and_or_sig11 or condition_and_or_sig12;

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
    