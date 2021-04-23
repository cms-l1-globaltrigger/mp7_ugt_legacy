-- Description:
-- Matrix of charge correlation

-- Version history:
-- HB 2021-04-15: minor update. Changed name.
-- HB 2021-02-19: updated intermediate pipelines.
-- HB 2019-04-30: first version.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.gtl_pkg.all;

entity matrix_muon_charge_corr is
     generic(
        muon_object_slice_1_low: natural;
        muon_object_slice_1_high: natural;
        muon_object_slice_2_low: natural;
        muon_object_slice_2_high: natural;
        muon_object_slice_3_low: natural;
        muon_object_slice_3_high: natural;
        muon_object_slice_4_low: natural;
        muon_object_slice_4_high: natural;
        nr_templates: positive;
        requested_charge_correlation: string(1 to 2)
    );
    port(
        clk: in std_logic;
        ls_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        os_charcorr_double: in std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
        ls_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        os_charcorr_triple: in std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
        ls_charcorr_quad: in std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
        os_charcorr_quad: in std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));
        charge_comp_double_pipe: out std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        charge_comp_triple_pipe: out std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
        charge_comp_quad_pipe: out std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1)
    );

end matrix_muon_charge_corr;

architecture Behavioral of matrix_muon_charge_corr is

    signal charge_comp_double : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => '0'));
    signal charge_comp_triple : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => '0')));
    signal charge_comp_quad : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1) := (others => (others => (others => (others => '0'))));

begin

    -- Charge correlation comparison
    -- The definition of requested_charge_correlation has to be checked.

    charge_double_i: if nr_templates = 2 generate
        charge_double_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
            charge_double_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
                charge_double_if: if j/=i generate
                    charge_comp_double(i,j) <= '1' when ls_charcorr_double(i,j) = '1' and requested_charge_correlation = "ls" else
                        '1' when os_charcorr_double(i,j) = '1' and requested_charge_correlation = "os" else
                        '1' when requested_charge_correlation = "ig" else '0';
                end generate charge_double_if;
            end generate charge_double_l_2;
        end generate charge_double_l_1;

    -- Pipeline stage for charge_comp_2
        charge_comp_2_pipeline_p: process(clk, charge_comp_double)
            begin
                if not INTERMEDIATE_PIPELINE then
                    charge_comp_double_pipe <= charge_comp_double;
                else
                    if (clk'event and clk = '1') then
                        charge_comp_double_pipe <= charge_comp_double;
                    end if;
                end if;
        end process;
    end generate charge_double_i;

    charge_triple_i: if nr_templates = 3 generate
        charge_triple_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
            charge_triple_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
                charge_triple_l_3: for k in muon_object_slice_3_low to muon_object_slice_3_high generate
                    charge_triple_if: if (j/=i and k/=i and k/=j) generate
                        charge_comp_triple(i,j,k) <= '1' when ls_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "ls" else
                            '1' when os_charcorr_triple(i,j,k) = '1' and requested_charge_correlation = "os" else
                            '1' when requested_charge_correlation = "ig" else '0';
                    end generate charge_triple_if;
                end generate charge_triple_l_3;
            end generate charge_triple_l_2;
        end generate charge_triple_l_1;

    -- Pipeline stage for charge_comp_2
        charge_comp_3_pipeline_p: process(clk, charge_comp_triple)
            begin
                if not INTERMEDIATE_PIPELINE then
                    charge_comp_triple_pipe <= charge_comp_triple;
                else
                    if (clk'event and clk = '1') then
                        charge_comp_triple_pipe <= charge_comp_triple;
                    end if;
                end if;
        end process;
    end generate charge_triple_i;

    charge_quad_i: if nr_templates = 4 generate
        charge_quad_l_1: for i in muon_object_slice_1_low to muon_object_slice_1_high generate
            charge_quad_l_2: for j in muon_object_slice_2_low to muon_object_slice_2_high generate
                charge_quad_l_3: for k in muon_object_slice_3_low to muon_object_slice_3_high generate
                    charge_quad_l_4: for l in muon_object_slice_4_low to muon_object_slice_4_high generate
                        charge_quad_if: if (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) generate
                            charge_comp_quad(i,j,k,l) <= '1' when ls_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "ls" else
                                '1' when os_charcorr_quad(i,j,k,l) = '1' and requested_charge_correlation = "os" else
                                '1' when requested_charge_correlation = "ig" else '0';
                        end generate charge_quad_if;
                    end generate charge_quad_l_4;
                end generate charge_quad_l_3;
            end generate charge_quad_l_2;
        end generate charge_quad_l_1;

    -- Pipeline stage for charge_comp_2
        charge_comp_4_pipeline_p: process(clk, charge_comp_quad)
            begin
                if not INTERMEDIATE_PIPELINE then
                    charge_comp_quad_pipe <= charge_comp_quad;
                else
                    if (clk'event and clk = '1') then
                        charge_comp_quad_pipe <= charge_comp_quad;
                    end if;
                end if;
        end process;
    end generate charge_quad_i;

end Behavioral;
