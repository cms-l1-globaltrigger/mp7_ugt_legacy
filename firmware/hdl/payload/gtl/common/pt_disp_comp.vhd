
-- Description:
-- Comparator for transverse momentum (pt)

-- Version history:
-- HB 2021-10-19: first design.

library ieee;
use ieee.std_logic_1164.all;

-- use work.gtl_pkg.all;

entity pt_disp_comp is
	generic	(
        pt_ge_mode : boolean;
        pt_threshold: std_logic_vector;
        disp_cut: boolean := false
    );
    port(
        pt : in std_logic_vector;
        disp : in std_logic;
        pt_comp_o : out std_logic
    );
end pt_disp_comp;

architecture rtl of pt_disp_comp is

    signal pt_comp_int : std_logic;

begin

    pt_comp_int <= '1' when pt >= pt_threshold and pt_ge_mode else
                   '1' when pt = pt_threshold and not pt_ge_mode else '0';

    pt_comp_o <= '1' when pt_comp_int = '1' and not disp_cut else
                 '1' when pt_comp_int = '1' and disp_cut and disp = '1' else
                 '0' when pt_comp_int = '1' and disp_cut and disp = '0' else
                 '0' when pt_comp_int = '0' else

end architecture rtl;
