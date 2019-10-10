
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dualclock_synchronizer is
   generic
   (
      DATA_WIDTH : integer := 8;
      RST_ACTIVE_LHC : std_logic := '1';
      RST_ACTIVE_ROP :std_logic  := '0'
   );
   port
   (
      wr_clk   : in  std_logic;
      wr_rst   : in  std_logic;
      rd_clk   : in  std_logic;
      rd_rst   : in  std_logic;

      din      : in  std_logic_vector (DATA_WIDTH-1 downto 0);
      din_set  : in  std_logic;
      din_busy : out std_logic;

      dout     : out std_logic_vector (DATA_WIDTH-1 downto 0);
      dout_ch  : out std_logic
   );
end dualclock_synchronizer;

architecture behavioral of dualclock_synchronizer is

   signal busy_int : std_logic := '0';

   signal in_reg     : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
   signal in_reg_en  : std_logic := '0';

   signal out_reg_en : std_logic := '0';

begin

   flag_sync: entity work.flag_synchronizer
   generic map
   (
      RST_ACTIVE_LHC => RST_ACTIVE_LHC,
      RST_ACTIVE_ROP => RST_ACTIVE_ROP
   )
   port map
   (
      wr_clk => wr_clk,
      wr_rst => wr_rst,
      rd_clk => rd_clk,
      rd_rst => rd_rst,

      flagi  => din_set,
      busy   => busy_int,

      flago  => out_reg_en
   );

   in_reg_en <= din_set and not busy_int;
   din_busy  <= busy_int;

   process(wr_clk,wr_rst)
   begin

      if wr_rst = RST_ACTIVE_LHC then
         in_reg <= (others => '0');
      elsif rising_edge(wr_clk) and in_reg_en = '1' then
         in_reg <= din;
      end if;

   end process;

   process(rd_clk,rd_rst)
   begin

      if rd_rst = RST_ACTIVE_ROP then
         dout <= (others => '0');
         dout_ch <= '0';
      elsif rising_edge(rd_clk) then
         dout_ch <= out_reg_en;
         if out_reg_en = '1' then
            dout <= in_reg;
         end if;
      end if;

   end process;

end behavioral;

