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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/firmware/gt_mp7/branches/hb_algo_2_buffer/src/gt_mp7_core/gtl_fdl_wrapper/gtl/calo_conditions_v2.vhd $
-- $Date: 2015-06-12 12:26:03 +0200 (Fre, 12 Jun 2015) $
-- $Author: bergauer $
-- $Revision: 4032 $
--------------------------------------------------------------------------------

-- Desription:
-- Condition module for calorimeter object types (eg, jet and tau).
-- All condition types ("single", "double", "double_wsc", "triple" and "quad") are implemented in this module,
-- selected by nr_templates and double_wsc.
-- No registers for "et", not need anymore.

-- Version history:
-- HB 2015-05-29: removed "use work.gtl_lib.all;" - using "entity work.xxx" for instances
-- HB 2015-04-28: used integer for obj_type.
-- HB 2015-04-24: comparison for isolation bits implemented.
-- HB 2015-04-23: design with different comparator modules for calo object types.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

use work.gtl_pkg.all;

entity calo_conditions_v2 is
     generic(
        nr_objects: positive;
        nr_templates: positive;
        double_wsc: boolean;
        et_ge_mode: boolean;
	obj_type : natural := EG_TYPE; -- eg=0, jet=1, tau=2
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
end calo_conditions_v2;

architecture rtl of calo_conditions_v2 is
-- fixed pipeline structure, 2 stages total
    constant obj_vs_templ_pipeline_stage: boolean := true; -- pipeline stage for obj_vs_templ (intermediate flip-flop)
    constant conditions_pipeline_stage: boolean := true; -- pipeline stage for condition output 

    type object_vs_template_array is array (0 to nr_objects-1, 1 to nr_templates) of std_logic;
    type diff_comp_array is array (0 to nr_objects-1, 0 to nr_objects-1) of std_logic;

    signal obj_vs_templ : object_vs_template_array;
    signal obj_vs_templ_pipe : object_vs_template_array;
    signal diff_eta_comp : diff_comp_array := (others => (others => '0'));
    signal diff_eta_comp_pipe : diff_comp_array;
    signal diff_phi_comp : diff_comp_array := (others => (others => '0'));
    signal diff_phi_comp_pipe : diff_comp_array;
    signal condition_and_or : std_logic;

begin

-- Instance of comparators for calorimeter objects. All permutations between objects and thresholds/luts.
obj_l: for i in 0 to nr_objects-1 generate
    templ_l: for j in 1 to nr_templates generate        
        comp_i: entity work.calo_comparators_v2
            generic map(et_ge_mode, obj_type,
                 et_thresholds(j),
                 eta_full_range(j),
                 eta_w1_upper_limits(j),
                 eta_w1_lower_limits(j),
                 eta_w2_ignore(j),
                 eta_w2_upper_limits(j),
                 eta_w2_lower_limits(j),
                 phi_full_range(j),
                 phi_w1_upper_limits(j),
                 phi_w1_lower_limits(j),
                 phi_w2_ignore(j),
                 phi_w2_upper_limits(j),
                 phi_w2_lower_limits(j),
                 iso_luts(j)
                 )
            port map(data_i(i), obj_vs_templ(i,j));
    end generate templ_l;
end generate obj_l;

-- Pipeline stage for obj_vs_templ
obj_vs_templ_pipeline_p: process(clk, obj_vs_templ)
    begin
        if obj_vs_templ_pipeline_stage = false then 
            obj_vs_templ_pipe <= obj_vs_templ;
        else
            if (clk'event and clk = '1') then
                obj_vs_templ_pipe <= obj_vs_templ;
            end if;
        end if;
end process;

-- HB, 18-07-2013: changed to windows comparators and added one pipeline stage
diff_double_wsc_i: if (nr_templates = 2 and double_wsc = true) generate
    delta_l_1: for i in 0 to nr_objects-1 generate 
        delta_l_2: for j in 0 to nr_objects-1 generate
            delta_if: if j/=i generate
                -- "windows"-comparator for difference in eta and phi for all object combinations
                -- differences are interpreted as unsigned values
                diff_eta_comp(i,j) <= '1' when diff_eta(i,j) >= diff_eta_lower_limit and diff_eta(i,j) <= diff_eta_upper_limit else '0';
                diff_phi_comp(i,j) <= '1' when diff_phi(i,j) >= diff_phi_lower_limit and diff_phi(i,j) <= diff_phi_upper_limit else '0';
            end generate delta_if;
        end generate delta_l_2;
    end generate delta_l_1;

-- Pipeline stage for diff_eta_comp and diff_phi_comp
    diff_pipeline_p: process(clk, diff_eta_comp, diff_phi_comp)
        begin
            if obj_vs_templ_pipeline_stage = false then 
                diff_eta_comp_pipe <= diff_eta_comp;
                diff_phi_comp_pipe <= diff_phi_comp;
            else
                if (clk'event and clk = '1') then
                    diff_eta_comp_pipe <= diff_eta_comp;
                    diff_phi_comp_pipe <= diff_phi_comp;
                end if;
            end if;
    end process;

end generate diff_double_wsc_i;

-- "Matrix" of permutations in an and-or-structure.
-- Selection of calorimeter condition types ("single", "double", "double_wsc", "triple" and "quad") by 'nr_templates' and 'double_wsc'.

-- Condition type: "single".
matrix_single_i: if nr_templates = 1 generate
    matrix_single_p: process(obj_vs_templ_pipe)
        variable condition_and_or_tmp : std_logic := '0';
    begin
        condition_and_or_tmp := '0';
        for i in 0 to nr_objects-1 loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_pipe(i,1);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_single_p;
end generate matrix_single_i;

-- Condition type: "double".
matrix_double_i: if (nr_templates = 2 and double_wsc = false) generate
    matrix_double_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects*(nr_objects-1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_objects-1 loop 
            for j in 0 to nr_objects-1 loop
                if j/=i then
                    index := index + 1;
                    obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2);
                end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_double_p;
end generate matrix_double_i;

-- Condition type: "double_wsc".
matrix_double_wsc_i: if (nr_templates = 2 and double_wsc = true) generate
    matrix_double_wsc_p: process(obj_vs_templ_pipe, diff_eta_comp_pipe, diff_phi_comp_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects*(nr_objects-1)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_objects-1 loop 
            for j in 0 to nr_objects-1 loop
                if j/=i then
                    index := index + 1;
                    -- AND equations for matrix
                    obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and diff_eta_comp_pipe(i,j) and diff_phi_comp_pipe(i,j);
                end if;
            end loop;
        end loop;
        for i in 1 to index loop 
            -- ORs for matrix
            condition_and_or_tmp := condition_and_or_tmp or obj_vs_templ_vec(i);
        end loop;
        condition_and_or <= condition_and_or_tmp;
    end process matrix_double_wsc_p;
end generate matrix_double_wsc_i;

-- Condition type: "triple".
matrix_triple_i: if nr_templates = 3 generate
    matrix_triple_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects*(nr_objects-1)*(nr_objects-2)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_objects-1 loop 
            for j in 0 to nr_objects-1 loop
                for k in 0 to nr_objects-1 loop 
                    if (j/=i and k/=i and k/=j) then
                        index := index + 1;
                        obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3);
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
    matrix_quad_p: process(obj_vs_templ_pipe)
        variable index : integer := 0;
        variable obj_vs_templ_vec : std_logic_vector((nr_objects*(nr_objects-1)*(nr_objects-2)*(nr_objects-3)) downto 1) := (others => '0');
        variable condition_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        obj_vs_templ_vec := (others => '0');
        condition_and_or_tmp := '0';
        for i in 0 to nr_objects-1 loop 
            for j in 0 to nr_objects-1 loop
                for k in 0 to nr_objects-1 loop 
                    for l in 0 to nr_objects-1 loop
                        if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                            index := index + 1;
                            obj_vs_templ_vec(index) := obj_vs_templ_pipe(i,1) and obj_vs_templ_pipe(j,2) and obj_vs_templ_pipe(k,3) and obj_vs_templ_pipe(l,4);
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
condition_o_pipeline_p: process(clk, condition_and_or)
    begin
        if conditions_pipeline_stage = false then 
            condition_o <= condition_and_or;
        else
            if (clk'event and clk = '1') then
                condition_o <= condition_and_or;
            end if;
        end if;
end process;

end architecture rtl;
