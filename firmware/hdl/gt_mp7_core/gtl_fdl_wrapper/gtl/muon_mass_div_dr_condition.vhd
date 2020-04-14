
-- Description:
-- Condition for invariant mass divided by deltaR.

-- Version history:
-- HB 2020-03-30: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_mass_div_dr_condition is
     generic(

        muon1_object_low: natural;
        muon1_object_high: natural;
        pt_ge_mode_muon1: boolean;
        pt_threshold_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
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
        phi_full_range_muon1: boolean;
        phi_w1_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon1: boolean;
        phi_w2_upper_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon1: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon1: string(1 to 3);
        qual_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon1: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

        muon2_object_low: natural;
        muon2_object_high: natural;
        pt_ge_mode_muon2: boolean;
        pt_threshold_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
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
        phi_full_range_muon2: boolean;
        phi_w1_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_muon2: boolean;
        phi_w2_upper_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_muon2: std_logic_vector(MAX_MUON_TEMPLATES_BITS-1 downto 0);
        requested_charge_muon2: string(1 to 3);
        qual_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.qual_high-D_S_I_MUON_V2.qual_low+1)-1 downto 0);
        iso_lut_muon2: std_logic_vector(2**(D_S_I_MUON_V2.iso_high-D_S_I_MUON_V2.iso_low+1)-1 downto 0);

        requested_charge_correlation: string(1 to 2);

        mass_div_dr_upper_limit: real;
        mass_div_dr_lower_limit: real

    );
    port(
        lhc_clk: in std_logic;
        muon_data_i: in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        pt : in diff_integer_inputs_array;
        diff_eta: in diff_2dim_integer_array;
        diff_phi: in diff_2dim_integer_array;        
        cosh_deta : in diff_2dim_integer_array;
        cos_dphi : in diff_2dim_integer_array;
        condition_o: out std_logic
    );
end muon_mass_div_dr_condition; 

architecture rtl of muon_mass_div_dr_condition is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type muon1_object_vs_template_array is array (muon1_object_low to muon1_object_high, 1 to 1) of std_logic;
    type muon2_object_vs_template_array is array (muon2_object_low to muon2_object_high, 1 to 1) of std_logic;

--***************************************************************
-- signals for charge correlation comparison:
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
--***************************************************************

    signal muon1_obj_vs_templ, muon1_obj_vs_templ_pipe : muon1_object_vs_template_array;
    signal muon2_obj_vs_templ, muon2_obj_vs_templ_pipe : muon2_object_vs_template_array;
-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal mass_div_dr_comp_t, mass_div_dr_comp, mass_div_dr_comp_pipe : 
        std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));

    signal condition_and_or : std_logic;

begin

    -- *** section: CUTs - begin ***************************************************************************************

    -- Comparison with limits.
    mass_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        mass_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            mass_calc_l: if j>i generate
                invmass_div_dr_calculator_i: entity work.invmass_div_dr_calculator
                    generic map(
                        MUON_PT_PRECISION, MUON_MUON_DETA_DPHI_PRECISION, MUON_MUON_COSH_COS_PRECISION, 
                        MU_PT_INT_DIGITS, MU_DETA_INT_DIGITS, MU_DPHI_INT_DIGITS, MU_COSH_DETA_INT_DIGITS, FRACT_DIGITS,
                        mass_div_dr_upper_limit, mass_div_dr_lower_limit, MU_PT_MAX_VALUE, MU_COSH_DETA_MAX_VALUE
                    )
                    port map(
                        pt(i), pt(j),
                        diff_eta(i,j), diff_phi(i,j), 
                        cosh_deta(i,j), cos_dphi(i,j),
                        mass_div_dr_comp_t(i,j)
                    );
                mass_div_dr_comp(i,j) <= mass_div_dr_comp_t(i,j);
                mass_div_dr_comp(j,i) <= mass_div_dr_comp_t(i,j);
            end generate mass_calc_l;
        end generate mass_l_2;
    end generate mass_l_1;

    -- *** section: CUTs - end ***************************************************************************************

    obj_templ1_l: for i in muon1_object_low to muon1_object_high generate
        obj_templ1_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon1,
                pt_threshold_muon1(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
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
                phi_full_range_muon1,
                phi_w1_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon1,
                phi_w2_upper_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon1(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon1,
                qual_lut_muon1,
                iso_lut_muon1
            )
            port map(muon_data_i(i), muon1_obj_vs_templ(i,1));
    end generate obj_templ1_l;

    obj_templ2_l_l: for i in muon2_object_low to muon2_object_high generate
        obj_templ2_comp_i: entity work.muon_comparators
            generic map(pt_ge_mode_muon2,
                pt_threshold_muon2(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low downto 0),
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
                phi_full_range_muon2,
                phi_w1_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w1_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_ignore_muon2,
                phi_w2_upper_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                phi_w2_lower_limit_muon2(D_S_I_MUON_V2.phi_high-D_S_I_MUON_V2.phi_low downto 0),
                requested_charge_muon2,
                qual_lut_muon2,
                iso_lut_muon2
            )
            port map(muon_data_i(i), muon2_obj_vs_templ(i,1));
    end generate obj_templ2_l_l;

    -- Charge correlation comparison
    charge_double_l_1: for i in muon1_object_low to muon1_object_high generate 
        charge_double_l_2: for j in muon2_object_low to muon2_object_high generate
            charge_double_if: if j/=i generate
                charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                        '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                        '1' when requested_charge_correlation = "ig" else
                                        '0';
            end generate charge_double_if;
        end generate charge_double_l_2;
    end generate charge_double_l_1;

    -- Pipeline stage for obj_vs_templ and mass_div_dr_comp
    pipeline_p: process(lhc_clk, muon1_obj_vs_templ, muon2_obj_vs_templ, mass_div_dr_comp, charge_comp_double)
        begin
        if obj_vs_templ_pipeline_stage = false then 
            muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
            muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
            mass_div_dr_comp_pipe <= mass_div_dr_comp;
            charge_comp_double_pipe <= charge_comp_double;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                muon1_obj_vs_templ_pipe <= muon1_obj_vs_templ;
                muon2_obj_vs_templ_pipe <= muon2_obj_vs_templ;
                mass_div_dr_comp_pipe <= mass_div_dr_comp;
                charge_comp_double_pipe <= charge_comp_double;
            end if;
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.
    matrix_p: process(muon1_obj_vs_templ_pipe, muon2_obj_vs_templ_pipe, charge_comp_double_pipe, mass_div_dr_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((muon1_object_high-muon1_object_low+1)*(muon2_object_high-muon2_object_low+1) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in muon1_object_low to muon1_object_high loop 
            for j in muon2_object_low to muon2_object_high loop
                if j/=i then
                    index := index + 1;
                    obj_vs_templ_vec(index) := muon1_obj_vs_templ_pipe(i,1) and muon2_obj_vs_templ_pipe(j,1) and charge_comp_double_pipe(i,j) and mass_div_dr_comp_pipe(i,j);
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
    
    
    
    
    
    
    
    
    
    
