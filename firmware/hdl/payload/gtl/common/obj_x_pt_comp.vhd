
-- Description:
-- Trigger on a given object number and threshold (equal for all objects)
-- "... like 6 jets with pT > 15 GeV or 8-10 jets with no pT requirement" - mail from Efe Ygitbasi (2024-05-08)

-- Version history:
-- HB 2024-05-08: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity obj_x_pt_comp is
    generic	(
        obj_nr : natural := 5;
        pt_width : natural := JET_ET_BITS;
        pt_threshold: std_logic_vector
    );
    port(
        data_i: in calo_objects_array;
        pt_comp_o : out std_logic
    );
end obj_x_pt_comp;

architecture rtl of obj_x_pt_comp is

    signal pt : std_logic_vector(JET_ET_BITS-1 downto 0) := (others => '0')

begin

    pt <= data_i(obj_nr)(JET_ET_BITS-1 downto 0);

    pt_comp_o <= '1' when pt >= pt_threshold(JET_ET_BITS-1 downto 0) else '0';

end architecture rtl;
