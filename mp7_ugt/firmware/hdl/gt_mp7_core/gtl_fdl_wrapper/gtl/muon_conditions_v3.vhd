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
-- Condition module for muon objects.
-- All condition types ("single", "double", "double_wsc", "triple" and "quad") are implemented in this module,
-- selected by nr_templates and double_wsc.
-- No registers for "pt" and "quality", not need anymore.
-- Charge correlation selection implemented with "LS" and "OS" (charge correlation calculated in muon_charge_correlations.vhd)

-- Version history:
-- HB 2015-11-05: based on muon_conditions_v2.vhd, but removed "Double-wsc" condition type
-- HB 2015-09-24: renamed to "muon_conditions_v2" for removing "nr_objects" and "d_s_i" from generic. These constants used directly from gtl.pkg now.
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances
-- HB 2014-11-20: bug fixed at qual_luts(j) and iso_luts(j) at instantition of muon_comparators

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity muon_conditions_v3 is
    generic (
        nr_templates: positive;
--         double_wsc: boolean;
        pt_ge_mode : boolean;
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
        requested_charge_correlation: string(1 to 2)
--         diff_eta_upper_limit: natural;
--         diff_eta_lower_limit: natural;
--         diff_phi_upper_limit: natural;
--         diff_phi_lower_limit: natural
    );
    port(
        lhc_clk : in std_logic;
        data_i : in muon_objects_array;
        ls_charcorr_double: in muon_charcorr_double_array;
        os_charcorr_double: in muon_charcorr_double_array;
        ls_charcorr_triple: in muon_charcorr_triple_array;
        os_charcorr_triple: in muon_charcorr_triple_array;
        ls_charcorr_quad: in muon_charcorr_quad_array;
        os_charcorr_quad: in muon_charcorr_quad_array;
--         diff_eta : in diff_2dim_integer_array;
--         diff_phi : in diff_2dim_integer_array;
        condition_o : out std_logic
    );
end muon_conditions_v3;

architecture rtl of muon_conditions_v3 is

-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type object_vs_template_array is array (0 to NR_MUON_OBJECTS-1, 1 to nr_templates) of std_logic;
    type diff_comp_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic;

    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;

--***************************************************************
-- signals for charge correlation comparison:
-- charge correlation inputs are compared with requested charge (given by TME)
    signal charge_comp_double : muon_charcorr_double_array := (others => (others => '0'));
    signal charge_comp_double_pipe : muon_charcorr_double_array;
    signal charge_comp_triple : muon_charcorr_triple_array := (others => (others => (others => '0')));
    signal charge_comp_triple_pipe : muon_charcorr_triple_array;
    signal charge_comp_quad : muon_charcorr_quad_array := (others => (others => (others => (others => '0'))));
    signal charge_comp_quad_pipe : muon_charcorr_quad_array;
--***************************************************************

    signal diff_eta_comp : diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : diff_comp_array;
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array;
    signal condition_and_or : std_logic;

begin

-- Instance of comparators for muon objects. All permutations between objects and thresholds.
obj_l: for i in 0 to NR_MUON_OBJECTS-1 generate
    templ_l: for j in 1 to nr_templates generate        
        comp_i: entity work.muon_comparators_v2
            generic map(pt_ge_mode,
                        pt_thresholds(j)(D_S_I_MUON.pt_high-D_S_I_MUON.pt_low downto 0),
                        eta_full_range(j),
                        eta_w1_upper_limits(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                        eta_w1_lower_limits(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                        eta_w2_ignore(j),
                        eta_w2_upper_limits(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                        eta_w2_lower_limits(j)(D_S_I_MUON.eta_high-D_S_I_MUON.eta_low downto 0),
                        phi_full_range(j),
                        phi_w1_upper_limits(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                        phi_w1_lower_limits(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                        phi_w2_ignore(j),
                        phi_w2_upper_limits(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                        phi_w2_lower_limits(j)(D_S_I_MUON.phi_high-D_S_I_MUON.phi_low downto 0),
                        requested_charges(j),
                        qual_luts(j),
                        iso_luts(j)
                        )
            port map(data_i(i), obj_vs_templ(i,j));
    end generate templ_l;
end generate obj_l;

-- Pipeline stage for obj_vs_templ
obj_vs_templ_pipeline_p: process(lhc_clk, obj_vs_templ)
    begin
        if obj_vs_templ_pipeline_stage = false then 
            obj_vs_templ_pipe <= obj_vs_templ;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                obj_vs_templ_pipe <= obj_vs_templ;
            end if;
        end if;
end process;

--************************************************************
-- Charge correlation comparison
-- The definition of requested_charge_correlation has to be checked.

charge_double_i: if nr_templates = 2 generate
    charge_double_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        charge_double_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            charge_double_if: if j/=i generate
                charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                                           '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                                           '1' when requested_charge_correlation = "ig" else
                                           '0';
            end generate charge_double_if;
        end generate charge_double_l_2;
    end generate charge_double_l_1;

-- Pipeline stage for charge_comp_2
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
end generate charge_double_i;

charge_triple_i: if nr_templates = 3 generate
    charge_triple_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        charge_triple_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            charge_triple_l_3: for k in 0 to NR_MUON_OBJECTS-1 generate
                charge_triple_if: if (j/=i and k/=i and k/=j) generate
                    charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                                                 '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                                                 '1' when requested_charge_correlation = "ig" else
                                                 '0';
                end generate charge_triple_if;
            end generate charge_triple_l_3;
        end generate charge_triple_l_2;
    end generate charge_triple_l_1;

-- Pipeline stage for charge_comp_2
    charge_comp_3_pipeline_p: process(lhc_clk, charge_comp_triple)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                charge_comp_triple_pipe <= charge_comp_triple;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    charge_comp_triple_pipe <= charge_comp_triple;
                end if;
            end if;
    end process;
end generate charge_triple_i;

charge_quad_i: if nr_templates = 3 generate
    charge_quad_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
        charge_quad_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
            charge_quad_l_3: for k in 0 to NR_MUON_OBJECTS-1 generate
                charge_quad_l_4: for l in 0 to NR_MUON_OBJECTS-1 generate
                    charge_quad_if: if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) generate
                        charge_comp_quad(i,j,k,l) <= '1' when ls_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "ls" else
                                                     '1' when os_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "os" else
                                                     '1' when requested_charge_correlation = "ig" else
                                                     '0';
                    end generate charge_quad_if;
                end generate charge_quad_l_4;
            end generate charge_quad_l_3;
        end generate charge_quad_l_2;
    end generate charge_quad_l_1;

-- Pipeline stage for charge_comp_2
    charge_comp_4_pipeline_p: process(lhc_clk, charge_comp_quad)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                charge_comp_quad_pipe <= charge_comp_quad;
            else
                if (lhc_clk'event and lhc_clk = '1') then
                    charge_comp_quad_pipe <= charge_comp_quad;
                end if;
            end if;
    end process;
end generate charge_quad_i;

--************************************************************

-- -- HB, 18-07-2013: changed to windows comparators and added one pipeline stage
-- diff_double_wsc_i: if (nr_templates = 2 and double_wsc = true) generate
--     delta_l_1: for i in 0 to NR_MUON_OBJECTS-1 generate 
--         delta_l_2: for j in 0 to NR_MUON_OBJECTS-1 generate
--             delta_if: if j/=i generate
--                     -- "windows"-comparator for difference in eta and phi for all object combinations
--                     -- differences are interpreted as unsigned values
--                     diff_eta_comp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit and diff_eta(i,j) <= diff_eta_upper_limit else '0';
--                     diff_phi_comp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit and diff_phi(i,j) <= diff_phi_upper_limit else '0';
--             end generate delta_if;
--         end generate delta_l_2;
--     end generate delta_l_1;
-- 
-- -- Pipeline stage for diff_eta_comp and diff_phi_comp
--     diff_pipeline_p: process(lhc_clk, diff_eta_comp, diff_phi_comp)
--         begin
--             if obj_vs_templ_pipeline_stage = false then 
--                 diff_eta_comp_pipe <= diff_eta_comp;
--                 diff_phi_comp_pipe <= diff_phi_comp;
--             else
--                 if (lhc_clk'event and lhc_clk = '1') then
--                     diff_eta_comp_pipe <= diff_eta_comp;
--                     diff_phi_comp_pipe <= diff_phi_comp;
--                 end if;
--             end if;
--     end process;
-- 
-- end generate diff_double_wsc_i;
--*************************************************************************

-- "Matrix" of permutations in an and-or-structure.
-- Selection of muon condition types ("single", "double", "double_wsc", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "single".
matrix_single_i: if nr_templates = 1 generate
--    matrix_single_p: process(obj_vs_templ_pipe, charge_comp_single_pipe)
-- HB 2014-04-15: charge correlation for single conditions not used anymore, does not make sense
    matrix_single_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector(NR_MUON_OBJECTS downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to NR_MUON_OBJECTS-1 loop 
            index := index + 1;
            obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1);
        end loop;
        for i in 1 to index loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_single_p;
end generate matrix_single_i;

-- Condition type: "double".
-- matrix_double_i: if (nr_templates = 2 and double_wsc = false) generate
matrix_double_i: if nr_templates = 2 generate
    matrix_double_p: process(obj_vs_templ_pipe, charge_comp_double_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((NR_MUON_OBJECTS*(NR_MUON_OBJECTS-1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to NR_MUON_OBJECTS-1 loop 
            for j in 0 to NR_MUON_OBJECTS-1 loop
                if j/=i then
                    index := index + 1;
--                     obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2);
                    obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and charge_comp_double_pipe(i,j);
                end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_double_p;
end generate matrix_double_i;

-- -- Condition type: "double_wsc".
-- matrix_double_wsc_i: if (nr_templates = 2 and double_wsc = true) generate
--     matrix_double_wsc_p: process(obj_vs_templ_pipe, charge_comp_double_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe)
--         variable index : integer := 0;
--         variable obj_vs_templ_vec : std_logic_vector((NR_MUON_OBJECTS*(NR_MUON_OBJECTS-1)) downto 1) := (others => '0');
--         variable condition_and_or_tmp : std_logic := '0';
--     begin
--         index := 0;
--         obj_vs_templ_vec := (others => '0');
--         condition_and_or_tmp := '0';
--         for i in 0 to NR_MUON_OBJECTS-1 loop 
--             for j in 0 to NR_MUON_OBJECTS-1 loop
--                 if j/=i then
--                     index := index + 1;
--                     -- AND equations for matrix
--                     obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and charge_comp_double_pipe(i,j) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j);
--                 end if;
--             end loop;
--         end loop;
--         for i in 1 to index loop 
--             -- ORs for matrix
--             condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
--         end loop;
--         condition_and_or <= condition_and_or_tmp;
--     end process matrix_double_wsc_p;
-- end generate matrix_double_wsc_i;
-- 
-- Condition type: "triple".
matrix_triple_i: if nr_templates = 3 generate
    matrix_triple_p: process(obj_vs_templ_pipe, charge_comp_triple_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((NR_MUON_OBJECTS*(NR_MUON_OBJECTS-1)*(NR_MUON_OBJECTS-2)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to NR_MUON_OBJECTS-1 loop 
            for j in 0 to NR_MUON_OBJECTS-1 loop
                for k in 0 to NR_MUON_OBJECTS-1 loop 
                    if (j/=i and k/=i and k/=j) then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and charge_comp_triple_pipe(i,j,k);
                    end if;
                end loop;
            end loop;
        end loop;
        for i in 1 to index loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_triple_p;
end generate matrix_triple_i;

-- Condition type: "quad".
matrix_quad_i: if nr_templates = 4 generate
    matrix_quad_p: process(obj_vs_templ_pipe, charge_comp_quad_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((NR_MUON_OBJECTS*(NR_MUON_OBJECTS-1)*(NR_MUON_OBJECTS-2)*(NR_MUON_OBJECTS-3)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to NR_MUON_OBJECTS-1 loop 
            for j in 0 to NR_MUON_OBJECTS-1 loop
                for k in 0 to NR_MUON_OBJECTS-1 loop 
                    for l in 0 to NR_MUON_OBJECTS-1 loop
                        if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4) and charge_comp_quad_pipe(i,j,k,l);
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
        for i in 1 to index loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_quad_p;
end generate matrix_quad_i;

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
