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
-- $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/firmware/uGT_fw_integration/trunk/uGT_algos/firmware/hdl/gt_mp7_core/gtl_fdl_wrapper/gtl/gtl_lib.vhd $
-- $Date: 2015-06-16 11:48:44 +0200 (Tue, 16 Jun 2015) $
-- $Author: wittmann $
-- $Revision: 4043 $
--------------------------------------------------------------------------------

-- Desription:
-- Package for constant and type definitions of gtl (GTU)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

package gtl_lib is

component gtl_module
    port(
        lhc_clk : in std_logic;
        eg_data : in calo_objects_array(0 to NR_EG_OBJECTS-1);
        jet_data : in calo_objects_array(0 to NR_JET_OBJECTS-1);
        tau_data : in calo_objects_array(0 to NR_TAU_OBJECTS-1);
        ett_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        muon_data : in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        external_conditions : in std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end component gtl_module;

-- component delta_r_condition
--     generic (
--         NR_OBJ_1 : natural;
--         NR_OBJ_2 : natural;
--         THRESHOLD_HIGH: natural;
--         THRESHOLD_LOW: natural
--     );
--     port(
--         clk: in std_logic;
--         diff_eta : in diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1);
--         diff_phi : in diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1);
--         cond_o : out std_logic
--     );
-- end component delta_r_condition;
-- 
-- component delta_r_squared_calculator
--     generic (
--         THRESHOLD_HIGH: natural;
--         THRESHOLD_LOW: natural
--     );
--     port(
--         diff_eta : in natural;
--         diff_phi : in natural;
--         calc_o : out std_logic
--     );
-- end component delta_r_squared_calculator;
-- 
component muon_conditions
    generic (
        nr_objects: positive;
        nr_templates: positive;
        double_wsc: boolean;
        pt_ge_mode : boolean;
        d_s_i: d_s_i_muon_record;
        pt_thresholds: muon_templates_array;
        eta_full_range : muon_templates_boolean_array;
        eta_w1_upper_limits: muon_templates_array;
        eta_w1_lower_limits: muon_templates_array;
        eta_w2_ignore : muon_templates_boolean_array;
        eta_w2_upper_limits: muon_templates_array;
        eta_w2_lower_limits: muon_templates_array;
        phi_full_range : muon_templates_boolean_array;
        phi_w1_upper_limits: muon_templates_array;
        phi_w1_lower_limits: muon_templates_array;
        phi_w2_ignore : muon_templates_boolean_array;
        phi_w2_upper_limits: muon_templates_array;
        phi_w2_lower_limits: muon_templates_array;
        requested_charges: muon_templates_string_array;
        qual_luts: muon_templates_quality_array;
        iso_luts: muon_templates_iso_array;
        requested_charge_correlation: string(1 to 2);
        diff_eta_upper_limit: natural;
        diff_eta_lower_limit: natural;
        diff_phi_upper_limit: natural;
        diff_phi_lower_limit: natural
    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
-- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
--         pos_charge_single : in muon_charge_1_array;
--         neg_charge_single : in muon_charge_1_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        ls_charcorr_triple: in muon_charcorr_triple_array;
        os_charcorr_triple: in muon_charcorr_triple_array;
        ls_charcorr_quad: in muon_charcorr_quad_array;
        os_charcorr_quad: in muon_charcorr_quad_array;
        diff_eta : in diff_2dim_integer_array;
        diff_phi : in diff_2dim_integer_array;
        condition_o : out std_logic
    );
end component muon_conditions;

component muon_comparators
	generic	(
        d_s_i: d_s_i_muon_record;
        pt_ge_mode : boolean;
        pt_threshold: std_logic_vector;
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        requested_charge: string(1 to 3);
        qual_lut : std_logic_vector;
        iso_lut : std_logic_vector
    );
    port(
        data_i : in std_logic_vector;
        comp_o : out std_logic
    );
end component muon_comparators;

component muon_charge_correlations
    port(
        data: in muon_objects_array(0 to NR_MUON_OBJECTS-1);
-- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
--         positive_charge: out muon_charge_1_array;
--         negative_charge: out muon_charge_1_array;
        ls_charcorr_double: out muon_charcorr_double_array;
        os_charcorr_double: out muon_charcorr_double_array;
        ls_charcorr_triple: out muon_charcorr_triple_array;
        os_charcorr_triple: out muon_charcorr_triple_array;
        ls_charcorr_quad: out muon_charcorr_quad_array;
        os_charcorr_quad: out muon_charcorr_quad_array
    );
end component muon_charge_correlations;

component calo_conditions
     generic(
        nr_objects: positive;
        nr_templates: positive;
        double_wsc: boolean;
        et_ge_mode: boolean;
        d_s_i: d_s_i_calo_record;
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        diff_eta_upper_limit: natural;
        diff_eta_lower_limit: natural;
        diff_phi_upper_limit: natural;
        diff_phi_lower_limit: natural
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        diff_eta: in diff_2dim_integer_array;
        diff_phi: in diff_2dim_integer_array;
        condition_o: out std_logic
    );
end component calo_conditions;

component calo_comparators
    generic (
        d_s_i: d_s_i_calo_record;
        et_ge_mode : boolean;
        et_threshold : std_logic_vector;
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector
    );
    port(
        data_i      : in std_logic_vector;
        comp_o      : out std_logic
    );
end component calo_comparators;

component calo_conditions_v2
     generic(
        nr_objects: positive;
        nr_templates: positive;
        double_wsc: boolean;
        et_ge_mode: boolean;
	obj_type : natural;
        et_thresholds: calo_templates_array;
        eta_full_range : calo_templates_boolean_array;
        eta_w1_upper_limits: calo_templates_array;
        eta_w1_lower_limits: calo_templates_array;
        eta_w2_ignore : calo_templates_boolean_array;
        eta_w2_upper_limits: calo_templates_array;
        eta_w2_lower_limits: calo_templates_array;
        phi_full_range : calo_templates_boolean_array;
        phi_w1_upper_limits: calo_templates_array;
        phi_w1_lower_limits: calo_templates_array;
        phi_w2_ignore : calo_templates_boolean_array;
        phi_w2_upper_limits: calo_templates_array;
        phi_w2_lower_limits: calo_templates_array;
        iso_luts: calo_templates_array;
        diff_eta_upper_limit: natural;
        diff_eta_lower_limit: natural;
        diff_phi_upper_limit: natural;
        diff_phi_lower_limit: natural
    );
    port(
        clk: in std_logic;
        data_i: in calo_objects_array;
        diff_eta: in diff_2dim_integer_array;
        diff_phi: in diff_2dim_integer_array;
        condition_o: out std_logic
    );
end component calo_conditions_v2;

component calo_comparators_v2
    generic	(
        et_ge_mode : boolean;
	obj_type : natural;
        et_threshold : std_logic_vector;
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector;
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector;
        iso_lut: std_logic_vector
    );
    port(
        data_i	  : in std_logic_vector;
        comp_o    : out std_logic
    );
end component calo_comparators_v2;

-- component eg_comparators
--     generic	(
--         d_s_i: d_s_i_eg_record;
--         et_ge_mode : boolean;
--         et_threshold : std_logic_vector;
--         eta_full_range : boolean;
--         eta_w1_upper_limit : std_logic_vector;
--         eta_w1_lower_limit : std_logic_vector;
--         eta_w2_ignore : boolean;
--         eta_w2_upper_limit : std_logic_vector;
--         eta_w2_lower_limit : std_logic_vector;
--         phi_full_range : boolean;
--         phi_w1_upper_limit : std_logic_vector;
--         phi_w1_lower_limit : std_logic_vector;
--         phi_w2_ignore : boolean;
--         phi_w2_upper_limit : std_logic_vector;
--         phi_w2_lower_limit : std_logic_vector
--     );
--     port(
--         data_i	    : in std_logic_vector;
--         comp_o     	: out std_logic
--     );
-- end component eg_comparators;
-- 
-- component jet_comparators
--     generic	(
--         d_s_i: d_s_i_jet_record;
--         et_ge_mode : boolean;
--         et_threshold : std_logic_vector;
--         eta_full_range : boolean;
--         eta_w1_upper_limit : std_logic_vector;
--         eta_w1_lower_limit : std_logic_vector;
--         eta_w2_ignore : boolean;
--         eta_w2_upper_limit : std_logic_vector;
--         eta_w2_lower_limit : std_logic_vector;
--         phi_full_range : boolean;
--         phi_w1_upper_limit : std_logic_vector;
--         phi_w1_lower_limit : std_logic_vector;
--         phi_w2_ignore : boolean;
--         phi_w2_upper_limit : std_logic_vector;
--         phi_w2_lower_limit : std_logic_vector
--     );
--     port(
--         data_i	    : in std_logic_vector;
--         comp_o     	: out std_logic
--     );
-- end component jet_comparators;
-- 
-- component tau_comparators
--     generic	(
--         d_s_i: d_s_i_tau_record;
--         et_ge_mode : boolean;
--         et_threshold : std_logic_vector;
--         eta_full_range : boolean;
--         eta_w1_upper_limit : std_logic_vector;
--         eta_w1_lower_limit : std_logic_vector;
--         eta_w2_ignore : boolean;
--         eta_w2_upper_limit : std_logic_vector;
--         eta_w2_lower_limit : std_logic_vector;
--         phi_full_range : boolean;
--         phi_w1_upper_limit : std_logic_vector;
--         phi_w1_lower_limit : std_logic_vector;
--         phi_w2_ignore : boolean;
--         phi_w2_upper_limit : std_logic_vector;
--         phi_w2_lower_limit : std_logic_vector
--     );
--     port(
--         data_i	    : in std_logic_vector;
--         comp_o     	: out std_logic
--     );
-- end component tau_comparators;
-- 
component eta_windows_comp
    generic	(
        eta_full_range : boolean;
        eta_w1_upper_limit : std_logic_vector;
        eta_w1_lower_limit : std_logic_vector;
        eta_w2_ignore : boolean;
        eta_w2_upper_limit : std_logic_vector;
        eta_w2_lower_limit : std_logic_vector
    );
    port(
        eta	    : in std_logic_vector;
        eta_comp_o  : out std_logic
    );
end component eta_windows_comp;

component eta_comp_signed
    generic (
        eta_upper_limit: std_logic_vector;
        eta_lower_limit: std_logic_vector
    );
    port(
        eta: in std_logic_vector;
        eta_comp: out std_logic
    );
end component eta_comp_signed;

component phi_windows_comp
    generic	(
        phi_full_range : boolean;
        phi_w1_upper_limit : std_logic_vector;
        phi_w1_lower_limit : std_logic_vector;
        phi_w2_ignore : boolean;
        phi_w2_upper_limit : std_logic_vector;
        phi_w2_lower_limit : std_logic_vector
    );
    port(
        phi	    : in std_logic_vector;
        phi_comp_o  : out std_logic
    );
end component phi_windows_comp;

component esums_conditions
    generic	(
        et_ge_mode : boolean;
	obj_type : natural;
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_full_range : boolean;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore : boolean;
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector;
        condition_o : out std_logic
    );
end component esums_conditions;

component esums_comparators
    generic	(
        et_ge_mode : boolean;
	obj_type : natural;
        et_threshold: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_full_range : boolean;
        phi_w1_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore : boolean;
        phi_w2_upper_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit: std_logic_vector(MAX_ESUMS_TEMPLATES_BITS-1 downto 0)
   );
    port(
        clk : in std_logic;
        data_i : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        comp_o : out std_logic
    );
end component esums_comparators;

component p_m_2_bx_pipeline
    port(
        clk          : in std_logic;
        muon_data    : in muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_p2  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_p1  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_0    : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_m1  : out muon_objects_array(0 to nr_muon_objects-1);
        muon_bx_m2  : out muon_objects_array(0 to nr_muon_objects-1);
        eg_data      : in calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p2    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_p1    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_0      : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m1    : out calo_objects_array(0 to nr_eg_objects-1);
        eg_bx_m2    : out calo_objects_array(0 to nr_eg_objects-1);
        jet_data     : in calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p2   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_p1   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_0     : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m1   : out calo_objects_array(0 to nr_jet_objects-1);
        jet_bx_m2   : out calo_objects_array(0 to nr_jet_objects-1);
        tau_data     : in calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p2   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_p1   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_0     : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m1   : out calo_objects_array(0 to nr_tau_objects-1);
        tau_bx_m2   : out calo_objects_array(0 to nr_tau_objects-1);
        ett_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ett_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        ht_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        etm_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_data     : in std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p2   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_p1   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_0     : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m1   : out std_logic_vector(max_esums_bits-1 downto 0);
        htm_bx_m2   : out std_logic_vector(max_esums_bits-1 downto 0);
        ext_cond_data     : in std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p2   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_p1   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_0     : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m1   : out std_logic_vector(nr_external_conditions-1 downto 0);
        ext_cond_bx_m2   : out std_logic_vector(nr_external_conditions-1 downto 0)
    );
end component p_m_2_bx_pipeline;

component sub_eta_obj_vs_obj
    generic (
        NR_OBJ_1 : positive;
        NR_OBJ_2 : positive;
        ETA_WIDTH : positive
    );
    port(
        in_1 : in diff_inputs_array(0 to NR_OBJ_1-1);
        in_2 : in diff_inputs_array(0 to NR_OBJ_2-1);
        diff : out diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end component sub_eta_obj_vs_obj;

component sub_phi_obj_vs_obj
    generic (
        NR_OBJ_1 : positive;
        NR_OBJ_2 : positive;
        PHI_WIDTH : positive;
        PHI_BINS_DIV2: positive
    );
    port(
        in_1 : in diff_inputs_array(0 to NR_OBJ_1-1);
        in_2 : in diff_inputs_array(0 to NR_OBJ_2-1);
        diff : out diff_2dim_integer_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end component sub_phi_obj_vs_obj;

component sub_signed_eta
    port(
        eta_1 : in std_logic_vector;
        eta_2 : in std_logic_vector;
        eta_diff_o : out natural
    );
end component sub_signed_eta;

component sub_unsigned_phi
    generic (
        PHI_BINS_DIV2: positive
    );
    port(
        phi_1 : in std_logic_vector;
        phi_2 : in std_logic_vector;
        phi_diff_o : out natural
    );
end component sub_unsigned_phi;

end package;
