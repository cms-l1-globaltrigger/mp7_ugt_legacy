
-- Description:
-- Trigger on a given object number and threshold (equal for all objects)
-- "... like 6 jets with pT > 15 GeV or 8-10 jets with no pT requirement" - mail from Efe Ygitbasi (2024-05-08)

-- Version history:
-- HB 2024-05-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity calo_comp_pt_obj_nr_condition is
    generic	(
        obj_nr : natural := 5;
        pt_width : natural := JET_ET_BITS;
        pt_threshold: std_logic_vector
    );
    port(
        clk : in std_logic;
        data_i: in calo_objects_array(0 to 11);
        condition_o : out std_logic
    );
end calo_comp_pt_obj_nr_condition;

architecture rtl of calo_comp_pt_obj_nr_condition is

    signal pt : std_logic_vector(pt_width-1 downto 0) := (others => '0');
    signal comp : std_logic;
    signal comp_v, comp_v_o : std_logic_vector(0 downto 0);

begin

    pt <= data_i(obj_nr)(pt_width-1 downto 0);

    comp <= '1' when pt >= pt_threshold else '0';

    comp_v(0) <= comp;

    out_pipe_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => 1,
            STAGES => CALO_X_OBJ_STAGES
        )
        port map(
            clk, comp_v, comp_v_o
        );

    condition_o <= comp_v_o(0);

end architecture rtl;
