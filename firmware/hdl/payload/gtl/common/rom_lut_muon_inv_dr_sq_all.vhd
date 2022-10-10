
-- Description:
-- Wrapper for ROMs (6x8192 addresses) with LUTs values of 1/DR^2 for muons.

-- Version history:
-- HB 2022-09-06: cleaned up.
-- HB 2021-09-09: changed ROMs structure.
-- HB 2021-08-30: added sync for deta and dphi msb.
-- HB 2021-08-24: updated for new data width of ROMs.
-- HB 2020-05-18: first design.

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.VComponents.all;

use work.gtl_pkg.all;

entity rom_lut_muon_inv_dr_sq_all is
    generic(
        deta_width : positive := 8;
        dphi_width : positive := 8
    );
    port(
        clk : in std_logic;
        deta : in STD_LOGIC_VECTOR(deta_width-1 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(dphi_width-1 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(MU_MU_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0')
    );
end rom_lut_muon_inv_dr_sq_all;

architecture rtl of rom_lut_muon_inv_dr_sq_all is

    constant addr_width : positive := 13; -- ROM size: 8192

    constant dout1_width : positive := 28; -- MU_MU_INV_DR_SQ_VECTOR_WIDTH
    constant dout2_width : positive := 14;
    constant dout3_width : positive := 16;
    constant dout4_width : positive := 14;
    constant dout5_width : positive := 14;
    constant dout6_width : positive := 13;

    constant zero_vec : STD_LOGIC_VECTOR(MU_MU_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0');

    COMPONENT rom_lut_muon_inv_dr_sq_1
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout1_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_2
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout2_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_3
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout3_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_4
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout4_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_5
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout5_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_6
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout6_width-1 DOWNTO 0)
    );
    END COMPONENT;

    signal addr_lsb : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);

    signal dout1, dout2, dout3, dout4, dout5, dout6 : STD_LOGIC_VECTOR(MU_MU_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0');

    signal addr_msb : STD_LOGIC_VECTOR(2 DOWNTO 0);

begin

    addr_lsb <= deta(6 downto 0) & dphi(5 downto 0);

    lut1_i : rom_lut_muon_inv_dr_sq_1
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout1(dout1_width-1 DOWNTO 0)
        );

    lut2_i : rom_lut_muon_inv_dr_sq_2
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout2(dout2_width-1 DOWNTO 0)
        );

    lut3_i : rom_lut_muon_inv_dr_sq_3
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout3(dout3_width-1 DOWNTO 0)
        );

    lut4_i : rom_lut_muon_inv_dr_sq_4
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout4(dout4_width-1 DOWNTO 0)
        );

    lut5_i : rom_lut_muon_inv_dr_sq_5
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout5(dout5_width-1 DOWNTO 0)
        );

    lut6_i : rom_lut_muon_inv_dr_sq_6
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout6(dout6_width-1 DOWNTO 0)
        );

    sync_msb_p: process(clk, deta(7 downto 7), dphi(7 downto 6))
        begin
        if (clk'event and clk = '1') then
            addr_msb <= deta(7 downto 7) & dphi(7 downto 6);
        end if;
    end process;

    dout <=
        dout1 when addr_msb = "000" else
        dout2 when addr_msb = "100" else
        dout3 when addr_msb = "001" else
        dout4 when addr_msb = "101" else
        dout5 when addr_msb = "010" else
        dout6 when addr_msb = "110" else
        zero_vec;

end rtl;
