
-- Description:
-- Invariant mass divided by deltaR condition for calos (eg, jet and tau).

-- Version history:
-- HB 2020-05-29: changed instance of mass_div_dr_calculator to mass_div_dr_comp.
-- HB 2020-05-14: updated for mass_div_dr_calculator.vhd, removed use clause work.delta_r_lut_pkg.all.
-- HB 2020-03-06: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity calo_calo_mass_div_dr_condition is
    generic(

        same_bx: boolean; 

        mass_div_dr_vector_width : positive;

        nr_objects_calo1: natural;
        calo1_object_low: natural;
        calo1_object_high: natural;
        et_ge_mode_calo1: boolean;
        obj_type_calo1: natural := EG_TYPE;
        et_threshold_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo1 : natural;
        eta_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo1: boolean;
        phi_w1_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo1: boolean;
        phi_w2_upper_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo1: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo1: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        nr_objects_calo2: natural;
        calo2_object_low: natural;
        calo2_object_high: natural;
        et_ge_mode_calo2: boolean;
        obj_type_calo2: natural := JET_TYPE;
        et_threshold_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        nr_eta_windows_calo2 : natural;
        eta_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w3_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w4_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        eta_w5_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_full_range_calo2: boolean;
        phi_w1_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w1_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_ignore_calo2: boolean;
        phi_w2_upper_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        phi_w2_lower_limit_calo2: std_logic_vector(MAX_CALO_TEMPLATES_BITS-1 downto 0);
        iso_lut_calo2: std_logic_vector(2**MAX_CALO_ISO_BITS-1 downto 0);

        mass_div_dr_upper_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0);
        mass_div_dr_lower_limit: std_logic_vector(MAX_WIDTH_MASS_DIV_DR_LIMIT_VECTOR-1 downto 0)
        
    );
    port(
        lhc_clk: in std_logic;
        calo1_data_i: in calo_objects_array;
        calo2_data_i: in calo_objects_array;
        mass_div_dr : in mass_div_dr_vector_array;
        condition_o: out std_logic
    );
end calo_calo_mass_div_dr_condition; 

architecture rtl of calo_calo_mass_div_dr_condition is

-- fixed pipeline structure, 2 stages total
--     constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
-- obj_vs_templ_pipeline_stage not used, because of 1 bx pipeline of ROMs (for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd)

    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    signal calo1_obj_vs_templ, calo1_obj_vs_templ_pipe : std_logic_2dim_array(calo1_object_low to calo1_object_high, 1 to 1);
    signal calo2_obj_vs_templ, calo2_obj_vs_templ_pipe : std_logic_2dim_array(calo2_object_low to calo2_object_high, 1 to 1);

-- HB 2017-03-28: changed default values to provide all combinations of cuts (eg.: MASS and DR).
    signal mass_div_dr_comp_t, mass_div_dr_comp_pipe : std_logic_2dim_array(0 to nr_objects_calo1-1, 0 to nr_objects_calo2-1) :=
    (others => (others => '1'));

    signal condition_and_or : std_logic;
    
begin

    -- *** section: mass divided by deltaR cut - begin ***************************************************************************************

    -- Comparison with limits.
    mass_l_1: for i in 0 to nr_objects_calo1-1 generate 
        mass_l_2: for j in 0 to nr_objects_calo2-1 generate
            mass_comp_l1: if (obj_type_calo1 = obj_type_calo2) and (same_bx = true) and j>i generate
                comp_i: entity work.mass_div_dr_comp
                    generic map(
                        mass_div_dr_vector_width,
                        mass_div_dr_upper_limit, mass_div_dr_lower_limit 
                    )
                    port map(
                        mass_div_dr(i,j)(mass_div_dr_vector_width-1 downto 0),
                        mass_div_dr_comp_t(i,j)
                    );
                mass_div_dr_comp_pipe(i,j) <= mass_div_dr_comp_t(i,j);
                mass_div_dr_comp_pipe(j,i) <= mass_div_dr_comp_t(i,j);
            end generate mass_comp_l1;
            mass_comp_l2: if (obj_type_calo1 /= obj_type_calo2) or (same_bx = false) generate
                comp_i: entity work.mass_div_dr_comp
                    generic map(
                        mass_div_dr_vector_width,
                        mass_div_dr_upper_limit, mass_div_dr_lower_limit 
                    )
                    port map(
                        mass_div_dr(i,j)(mass_div_dr_vector_width-1 downto 0),
                        mass_div_dr_comp_pipe(i,j)
                    );
            end generate mass_comp_l2;
        end generate mass_l_2;
    end generate mass_l_1;
    
    -- *** section: mass divided by deltaR cut - end ***************************************************************************************

    -- Instance of comparators for calorimeter objects.
    calo1_obj_l: for i in calo1_object_low to calo1_object_high generate
        calo1_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo1, obj_type_calo1,
                et_threshold_calo1,
                nr_eta_windows_calo1,
                eta_w1_upper_limit_calo1,
                eta_w1_lower_limit_calo1,
                eta_w2_upper_limit_calo1,
                eta_w2_lower_limit_calo1,
                eta_w3_upper_limit_calo1,
                eta_w3_lower_limit_calo1,
                eta_w4_upper_limit_calo1,
                eta_w4_lower_limit_calo1,
                eta_w5_upper_limit_calo1,
                eta_w5_lower_limit_calo1,
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
        calo2_comp_i: entity work.calo_comparators
            generic map(et_ge_mode_calo2, obj_type_calo2,
                et_threshold_calo2,
                nr_eta_windows_calo2,
                eta_w1_upper_limit_calo2,
                eta_w1_lower_limit_calo2,
                eta_w2_upper_limit_calo2,
                eta_w2_lower_limit_calo2,
                eta_w3_upper_limit_calo2,
                eta_w3_lower_limit_calo2,
                eta_w4_upper_limit_calo2,
                eta_w4_lower_limit_calo2,
                eta_w5_upper_limit_calo2,
                eta_w5_lower_limit_calo2,
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

    -- Pipeline stage for obj_vs_templ
    obj_vs_templ_pipeline_p: process(lhc_clk, calo1_obj_vs_templ, calo2_obj_vs_templ)
        begin
        if (lhc_clk'event and lhc_clk = '1') then
            calo1_obj_vs_templ_pipe <= calo1_obj_vs_templ;
            calo2_obj_vs_templ_pipe <= calo2_obj_vs_templ;
-- mass_div_dr_comp_pipe: 1 bx pipeline done with ROMs for LUTs of inv_dr_sq values in mass_div_dr_comp.vhd
        end if;
    end process;

    -- "Matrix" of permutations in an and-or-structure.

    matrix_deta_dphi_dr_p: process(calo1_obj_vs_templ_pipe, calo2_obj_vs_templ_pipe, mass_div_dr_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(((calo1_object_high-calo1_object_low+1)*(calo2_object_high-calo2_object_low+1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in calo1_object_low to calo1_object_high loop 
            for j in calo2_object_low to calo2_object_high loop
            if (obj_type_calo1 = obj_type_calo2) and (same_bx = true) then
                if j/=i then
                index := index + 1;
                obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and mass_div_dr_comp_pipe(i,j);
                end if;
            else
                index := index + 1;
                obj_vs_templ_vec(index) := calo1_obj_vs_templ_pipe(i,1) and calo2_obj_vs_templ_pipe(j,1) and mass_div_dr_comp_pipe(i,j);
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
