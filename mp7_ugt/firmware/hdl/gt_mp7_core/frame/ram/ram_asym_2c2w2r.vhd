-------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
---Description:RTL RAM design for ROP. It could be used for any design. It should be adjusted for changing the technology
-- $HeadURL: $
-- $Date:  $
-- $Author:  HEPHY$
-- $Revision: 0.1 $
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


-- synthesizeable block ram
-- CAUTION: Do not use widths > 32 --> the synthesis tool will otherwise not infer RAM blocks
-- 2 cycles read latency
entity ram_asym_2c2w2r is

  generic
  (
    WIDTHA      : integer := 1;--:= 32;
    SIZEA       : integer := 4096;--:= 512;
    ADDRWIDTHA  : integer := 12; --:= 9;
    WIDTHB      : integer := 32;--:= 128;
    SIZEB       : integer := 128;--:= 128;
    ADDRWIDTHB  : integer := 7--:= 7
  );
  port
  (
    a_clk   : in  std_logic;
    b_clk   : in  std_logic;
    a_en    : in  std_logic;
    b_en    : in  std_logic;
    a_we    : in  std_logic;
    b_we    : in  std_logic;
    a_addr  : in  std_logic_vector(ADDRWIDTHA-1 downto 0);
    b_addr  : in  std_logic_vector(ADDRWIDTHB-1 downto 0);
    a_wr_data    : in  std_logic_vector(WIDTHA-1 downto 0);
    b_wr_data    : in  std_logic_vector(WIDTHB-1 downto 0);
    a_rd_data    : out std_logic_vector(WIDTHA-1 downto 0);
    b_rd_data    : out std_logic_vector(WIDTHB-1 downto 0)
  );

end ram_asym_2c2w2r;

architecture behavioral of ram_asym_2c2w2r is

  function max(L, R: INTEGER) return INTEGER is
  begin
      if L > R then
          return L;
      else
          return R;
      end if;
  end;

  function min(L, R: INTEGER) return INTEGER is
  begin
      if L < R then
          return L;
      else
          return R;
      end if;
  end;

  function log2 (val: INTEGER) return natural is
    variable res : natural;
  begin
        for i in 0 to 31 loop
            if (val <= (2**i)) then
                res := i;
                exit;
            end if;
        end loop;
        return res;
  end function Log2;

  constant minWIDTH : integer := min(WIDTHA,WIDTHB);
  constant maxWIDTH : integer := max(WIDTHA,WIDTHB);
  constant maxSIZE  : integer := max(SIZEA,SIZEB);
  constant RATIO : integer := maxWIDTH / minWIDTH;

  -- An asymmetric RAM is modelled in a similar way as a symmetric RAM, with an
  -- array of array object. Its aspect ratio corresponds to the port with the
  -- lower data width (larger depth)
  type ramType is array (0 to maxSIZE-1) of std_logic_vector(minWIDTH-1 downto 0);

  -- You need to declare ram as a shared variable when :
  --   - the RAM has two write ports,
  --   - the RAM has only one write port whose data width is maxWIDTH
  -- In all other cases, ram can be a signal.
  shared variable ram : ramType := (others => (others => '0'));

  signal readA : std_logic_vector(WIDTHA-1 downto 0):= (others => '0');
  signal readB : std_logic_vector(WIDTHB-1 downto 0):= (others => '0');
  signal regA  : std_logic_vector(WIDTHA-1 downto 0):= (others => '0');
  signal regB  : std_logic_vector(WIDTHB-1 downto 0):= (others => '0');

begin

  process (a_clk)
  begin
    if rising_edge(a_clk) then
      if a_en = '1' then
        if a_we = '1' then
          ram(conv_integer(a_addr)) := a_wr_data;
          readA <= a_wr_data;
        else
		  readA <= ram(conv_integer(a_addr));
        end if;
      end if;
      regA <= readA;
    end if;
  end process;

  process (b_clk)
  begin
    if rising_edge(b_clk) then
      if b_en = '1' then
        for i in 0 to RATIO-1 loop
          if b_we = '1' then
            ram(conv_integer(b_addr & conv_std_logic_vector(i,log2(RATIO))))
	          := b_wr_data((i+1)*minWIDTH-1 downto i*minWIDTH);
          end if;
		  -- The read statement below is placed after the write statement on purpose
		  -- to ensure write-first synchronization through the variable mechanism
          readB((i+1)*minWIDTH-1 downto i*minWIDTH)
	        <= ram(conv_integer(b_addr & conv_std_logic_vector(i,log2(RATIO))));
        end loop;
      end if;
      regB <= readB;
    end if;
  end process;

  a_rd_data <= regA;
  b_rd_data <= regB;

end behavioral;


