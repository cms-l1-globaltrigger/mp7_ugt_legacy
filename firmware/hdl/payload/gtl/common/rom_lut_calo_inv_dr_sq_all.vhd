
-- Description:
-- Wrapper for ROMs (4x8192 addresses) with LUTs values of 1/DR^2 for calos.

-- Version history:
-- HB 2021-09-09: changed ROMs structure.
-- HB 2021-08-30: added sync for deta and dphi msb.
-- HB 2021-08-24: updated for new ROMs structure.
-- HB 2020-05-15: bug fixed for rom_lut_calo_inv_dr_sq_9 address.
-- HB 2020-05-12: first design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.VComponents.all;

use work.gtl_pkg.all;

entity rom_lut_calo_inv_dr_sq_all is
    generic(
        deta_width : positive := 8;
        dphi_width : positive := 8
    );
    port(
        clk : in std_logic;
        deta : in STD_LOGIC_VECTOR(deta_width-1 DOWNTO 0);
        dphi : in STD_LOGIC_VECTOR(dphi_width-1 DOWNTO 0);
        dout : out STD_LOGIC_VECTOR(CALO_CALO_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0')
    );
end rom_lut_calo_inv_dr_sq_all;

architecture rtl of rom_lut_calo_inv_dr_sq_all is

    constant addr_width : positive := 12; -- ROM size: 4096

    constant dout1_width : positive := 26; -- CALO_CALO_INV_DR_SQ_VECTOR_WIDTH
    constant dout2_width : positive := 14;
    constant dout3_width : positive := 12;
    constant dout4_width : positive := 11;
    constant dout5_width : positive := 14;

    constant zero_vec : STD_LOGIC_VECTOR(CALO_CALO_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0');

    COMPONENT rom_lut_calo_inv_dr_sq_1
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout1_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_2
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout2_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_3
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout3_width-1 DOWNTO 0)
    );
    END COMPONENT;

    COMPONENT rom_lut_calo_inv_dr_sq_4
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout4_width-1 DOWNTO 0)
    );
    END COMPONENT;
    
    COMPONENT rom_lut_calo_inv_dr_sq_5
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(dout5_width-1 DOWNTO 0)
    );
    END COMPONENT;

    signal addr_lsb, addr_lsb_5 : STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);

    signal dout1, dout2, dout3, dout4, dout5 : STD_LOGIC_VECTOR(CALO_CALO_INV_DR_SQ_VECTOR_WIDTH-1 DOWNTO 0) := (others => '0');

    signal addr_msb : STD_LOGIC_VECTOR(2 DOWNTO 0);

    signal deta_msb : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal dphi_msb : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

    addr_lsb <= deta(5 downto 0) & dphi(5 downto 0);
    addr_lsb_5 <= deta(7 downto 0) & dphi(3 downto 0);

    lut1_i : rom_lut_calo_inv_dr_sq_1
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout1(dout1_width-1 DOWNTO 0)
        );

    lut2_i : rom_lut_calo_inv_dr_sq_2
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout2(dout2_width-1 DOWNTO 0)
        );

    lut3_i : rom_lut_calo_inv_dr_sq_3
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout3(dout3_width-1 DOWNTO 0)
        );

    lut4_i : rom_lut_calo_inv_dr_sq_4
        port map (
            clka => clk,
            addra => addr_lsb,
            douta => dout4(dout4_width-1 DOWNTO 0)
        );

    lut5_i : rom_lut_calo_inv_dr_sq_5
        port map (
            clka => clk,
            addra => addr_lsb_5,
            douta => dout5(dout5_width-1 DOWNTO 0)
        );

    sync_msb_p: process(clk, deta(7 downto 6), dphi(7 downto 4))
        begin
        if (clk'event and clk = '1') then
            deta_msb <= deta(7 downto 6);
            dphi_msb <= dphi(7 downto 4);
        end if;
    end process;
    
    mux_p: process(deta_msb, dphi_msb, dout1, dout2, dout3, dout4, dout5)
        begin
        if dphi_msb(3 downto 2) = "00" then
            if deta_msb = "00" then
                dout <= dout1;
            elsif deta_msb = "01" then
                dout <= dout2;
            elsif deta_msb = "10" then
                dout <= dout3;
            elsif deta_msb = "11" then
                dout <= dout4;
            end if;
        elsif dphi_msb(3 downto 0) = "0100" then
            dout <= dout5;
        end if;
    end process;
        
end rtl;
