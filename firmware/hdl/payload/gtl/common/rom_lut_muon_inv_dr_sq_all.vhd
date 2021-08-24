
-- Description:
-- Wrapper for all 9 ROM segments for LUTs with muon inv_dr_sq values with reduced bin width (8 bits) for muon deta [226] and muon dphi [144] (half resolution)

-- Version history:
-- HB 2021-08-24: updated for new data width of ROMs.
-- HB 2020-05-18: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

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

    constant addr_width : positive := 12;

    constant dout1_width : positive := 33; -- MU_MU_INV_DR_SQ_VECTOR_WIDTH
    constant dout2_width : positive := 19;
    constant dout3_width : positive := 17;
    constant dout4_width : positive := 16;
    constant dout5_width : positive := 21;
    constant dout6_width : positive := 19;
    constant dout7_width : positive := 17;
    constant dout8_width : positive := 16;
    constant dout9_width : positive := 19;

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

    COMPONENT rom_lut_muon_inv_dr_sq_7
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout7_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_8
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout8_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_muon_inv_dr_sq_9
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout9_width-1 DOWNTO 0)
    );
    END COMPONENT;

    signal addr_lsb : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
    signal addr_lsb_9 : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);

    signal dout1, dout2, dout3, dout4, dout5, dout6, dout7, dout8, dout9 : STD_LOGIC_VECTOR(MU_MU_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0');

begin

    addr_lsb <= deta(5 downto 0) & dphi(5 downto 0);
    addr_lsb_9 <= deta(7 downto 0) & dphi(3 downto 0);

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

    lut7_i : rom_lut_muon_inv_dr_sq_7
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout7(dout7_width-1 DOWNTO 0)
        );

    lut8_i : rom_lut_muon_inv_dr_sq_8
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout8(dout8_width-1 DOWNTO 0)
        );

    lut9_i : rom_lut_muon_inv_dr_sq_9
        port map (
            clka => clk,
            addra => addr_lsb_9,
            douta => dout9(dout9_width-1 DOWNTO 0)
        );

    dout <=
        dout1 when deta(7 downto 6) = "00" and dphi(7 downto 6) = "00" else
        dout2 when deta(7 downto 6) = "01" and dphi(7 downto 6) = "00" else
        dout3 when deta(7 downto 6) = "10" and dphi(7 downto 6) = "00" else
        dout4 when deta(7 downto 6) = "11" and dphi(7 downto 6) = "00" else
        dout5 when deta(7 downto 6) = "00" and dphi(7 downto 6) = "01" else
        dout6 when deta(7 downto 6) = "01" and dphi(7 downto 6) = "01" else
        dout7 when deta(7 downto 6) = "10" and dphi(7 downto 6) = "01" else
        dout8 when deta(7 downto 6) = "11" and dphi(7 downto 6) = "01" else
        dout9 when dphi(7 downto 4) = "1000" else
        zero_vec;

end rtl;
