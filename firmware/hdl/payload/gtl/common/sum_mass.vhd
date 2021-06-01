
-- Description:
-- Summary of 3 body mass

-- Version history:
-- HB 2021-02-11: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity sum_mass is
     generic(
        slice_low_obj1: natural;
        slice_high_obj1: natural;
        slice_low_obj2: natural;
        slice_high_obj2: natural;
        slice_low_obj3: natural;
        slice_high_obj3: natural;

        mass_upper_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_lower_limit_vector: std_logic_vector(MAX_WIDTH_MASS_LIMIT_VECTOR-1 downto 0) := (others => '0');
        mass_vector_width: positive;

        nr_obj1: natural := NR_EG_OBJECTS
    );
    port(
        lhc_clk: in std_logic;
        invariant_mass: in mass_dim2_array(0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')));
        mass_3_obj_comp_pipe: out std_logic_3dim_array(0 to nr_obj1-1, 0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')))
    );
end sum_mass;

architecture rtl of sum_mass is

    type sum_mass_array is array(0 to nr_obj1-1, 0 to nr_obj1-1, 0 to nr_obj1-1) of std_logic_vector(mass_vector_width+1 downto 0);
    signal sum_mass, sum_mass_temp : sum_mass_array := (others => (others => (others => (others => '0'))));
    signal mass_3_obj_comp : std_logic_3dim_array(0 to nr_obj1-1, 0 to nr_obj1-1, 0 to nr_obj1-1) := (others => (others => (others => '0')));

begin

    l1_sum: for i in 0 to nr_obj1-1 generate
        l2_sum: for j in 0 to nr_obj1-1 generate
            l3_sum: for k in 0 to nr_obj1-1 generate
                sum_mass_l: if j>i and k>i and k>j generate
                    sum_mass_calc_i: entity work.sum_mass_calc
                        generic map(mass_vector_width)
                        port map(
                            invariant_mass(i,j)(mass_vector_width-1 DOWNTO 0),
                            invariant_mass(i,k)(mass_vector_width-1 DOWNTO 0),
                            invariant_mass(j,k)(mass_vector_width-1 DOWNTO 0),
                            sum_mass_temp(i,j,k)
                        );
                    sum_mass(i,j,k) <= sum_mass_temp(i,j,k);
                    sum_mass(i,k,j) <= sum_mass_temp(i,j,k);
                    sum_mass(j,i,k) <= sum_mass_temp(i,j,k);
                    sum_mass(j,k,i) <= sum_mass_temp(i,j,k);
                    sum_mass(k,i,j) <= sum_mass_temp(i,j,k);
                    sum_mass(k,j,i) <= sum_mass_temp(i,j,k);
                end generate sum_mass_l;
            end generate l3_sum;
        end generate l2_sum;
    end generate l1_sum;

    l1_comp: for i in slice_low_obj1 to slice_high_obj1 generate
        l2_comp: for j in slice_low_obj2 to slice_high_obj2 generate
            l3_comp: for k in slice_low_obj3 to slice_high_obj3 generate
                mass_3_obj_comp(i,j,k) <= '1' when sum_mass(i,j,k)(mass_vector_width-1 downto 0) >= mass_lower_limit_vector(mass_vector_width-1 downto 0) and sum_mass(i,j,k)(mass_vector_width-1 downto 0) <= mass_upper_limit_vector(mass_vector_width-1 downto 0) else '0';
            end generate l3_comp;
        end generate l2_comp;
    end generate l1_comp;

    pipeline_p: process(lhc_clk, mass_3_obj_comp)
        begin
        if INTERMEDIATE_PIPELINE = false then
            mass_3_obj_comp_pipe <= mass_3_obj_comp;
        else
            if (lhc_clk'event and lhc_clk = '1') then
                mass_3_obj_comp_pipe <= mass_3_obj_comp;
            end if;
        end if;
    end process;

end architecture rtl;
