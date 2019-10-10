
-- HEPHY 2015-06-01: ipbus_rst (sys_rst) is high active, therefore changed in processes

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.gt_mp7_core_pkg.all;

entity slow_cd_reset is
  generic (
    RST_DELAY     : integer := 5;
    SYNC_STAGES   : integer := 2
  );
  port (
    sys_rst     : in  std_logic;
    sys_clk     : in  std_logic;
    slow_clk    : in  std_logic;
    slow_rst    : out std_logic
  );
end slow_cd_reset;

architecture beh of slow_cd_reset is
  subtype rst_counter_t is integer range 0 to RST_DELAY-1;
  type rstflag_cdc_t is array (SYNC_STAGES-1 downto 0) of std_logic;


  signal rc, rcin            : rst_counter_t;
  signal rstack              : std_logic;
  signal rstreq, rstreq_in   : std_logic;

  signal rstreq_slow        : rstflag_cdc_t;
  signal rstack_sys         : rstflag_cdc_t;

begin

  comb_slow: process(rc, rstreq_slow) is
    variable v      : rst_counter_t;
  begin
    v := rc;

    rstack <= '0';
    slow_rst <= RST_ACT;

    if rstreq_slow(SYNC_STAGES-1) = '1'
    then
      v := RST_DELAY-1;
      rstack <= '1';
    elsif v /= 0
    then
      v := rc - 1;
    end if;

    if rc = 0
    then
      slow_rst <= not RST_ACT;
    end if;

    rcin <= v;
  end process;

  sync_slow : process(slow_clk, rstreq) is
  begin
    if rising_edge(slow_clk)
    then
      rc <= rcin;

      -- sync signals from sys clock domain
      rstreq_slow(0) <= rstreq;
      for i in 1 to SYNC_STAGES-1
      loop
        rstreq_slow(i) <= rstreq_slow(i-1);
      end loop;
    end if;
  end process;


  sync_sys : process(sys_clk, rstack, rstack_sys, sys_rst) is
  begin
    if rising_edge(sys_clk)
    then
--      if sys_rst = RST_ACT then
      if sys_rst = '1' then
        rstreq_in <= '1';
        rstack_sys <= (others => '0');
      else
        rstreq <= rstreq_in;

        if rstack_sys(SYNC_STAGES-1) = '1'
        then
          rstreq_in  <= '0';
        end if;

        -- sync signals from slow clock domain
        rstack_sys(0) <= rstack;
        for i in 1 to SYNC_STAGES-1
        loop
          rstack_sys(i) <= rstack_sys(i-1);
        end loop;
      end if;
    end if;
  end process;

end beh;
