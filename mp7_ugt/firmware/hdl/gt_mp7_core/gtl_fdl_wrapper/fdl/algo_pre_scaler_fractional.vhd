
-- Desription:
-- Prescalers for algorithms in FDL

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity algo_pre_scaler is
   generic( 
      COUNTER_WIDTH : integer := 24;
      FRACTION_WIDTH : integer := 4;
      PRESCALE_FACTOR_INIT : std_logic_vector(31 DOWNTO 0) := X"00000010" -- represents floting point notation of PRESCALE_FACTOR (=1.0)
   );
   port( 
      clk : in std_logic;
      sres_counter : in std_logic;
      algo_i : in std_logic;
      request_update_factor_pulse : in std_logic;
      update_factor_pulse : in std_logic;
      prescale_factor : in std_logic_vector (COUNTER_WIDTH+FRACTION_WIDTH-1 DOWNTO 0); -- why counter_width ???
      prescaled_algo_o : out std_logic;
      index_sim : out integer
   );
end algo_pre_scaler;

architecture rtl of algo_pre_scaler is

  type boolean_arr is array (0 to 9) of boolean;
  type mode_record is record
      length : natural;
      mode : boolean_arr;
  end record mode_record;
  type mode_seq_lut_array is array (0 to 9) of mode_record;
  constant MODE_SEQ_LUT : mode_seq_lut_array := (
    (1, (true, false, false, false, false, false, false, false, false, false)),
    (10, (false, true, true, true, true, true, true, true, true, true)),
    (5, (false, true, true, true, true, false, false, false, false, false)),
    (10, (false, true, true, false, true, true, false, true, true, true)),
    (5, (false, true, false, true, true, false, false, false, false, false)),
    (2, (false, true, false, false, false, false, false, false, false, false)),
    (5, (false, false, true, false, true, false, false, false, false, false)),
    (10, (false, false, false, true, false, false, true, false, false, true)),
    (5, (false, false, false, false, true, false, false, false, false, false)),
    (10, (false, false, false, false, false, false, false, false, false, true))
  );

   constant ZERO : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   
   constant PATTERN : std_logic_vector(19 downto 0) := X"00001";

   signal prescale_factor_int : std_logic_vector(COUNTER_WIDTH+FRACTION_WIDTH-1 downto 0) := PRESCALE_FACTOR_INIT(COUNTER_WIDTH+FRACTION_WIDTH-1 downto 0);
   signal counter : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   signal fraction : std_logic_vector(FRACTION_WIDTH-1 downto 0) := (others => '0');
   signal factor : std_logic_vector(COUNTER_WIDTH-1 downto 0) := (others => '0');
   signal limit : std_logic := '0';
   signal mode_seq : boolean_arr;
   signal mode_len : natural;
   signal mode_b_sel : boolean;

begin

    prescale_factor_update_i: entity work.update_process
    generic map(
        WIDTH => COUNTER_WIDTH+FRACTION_WIDTH,
        INIT_VALUE => PRESCALE_FACTOR_INIT
    )
    port map( 
        clk => clk,
        request_update_pulse => request_update_factor_pulse,
        update_pulse => update_factor_pulse,
        data_i => prescale_factor(COUNTER_WIDTH+FRACTION_WIDTH-1 downto 0),
        data_o => prescale_factor_int
    );
    
    fraction <= prescale_factor_int(FRACTION_WIDTH-1 downto 0);
    factor <= prescale_factor_int(COUNTER_WIDTH+FRACTION_WIDTH-1 downto 4);
    mode_seq <= MODE_SEQ_LUT(conv_integer(fraction)).mode;
    mode_len <= MODE_SEQ_LUT(conv_integer(fraction)).length;
    
    mode_sel_p: process (clk, sres_counter, update_factor_pulse, mode_seq, mode_len, algo_i, limit)
      variable index : integer := 0;
    begin
	
	if clk'event and clk = '1' then
	  if sres_counter = '1' or update_factor_pulse = '1' then
	    index := 0;
	  elsif (mode_len = index and limit = '1' and algo_i = '1') then
	    index := 0;
	    mode_b_sel <= mode_seq(index);
	    index := index + 1;
	  elsif (mode_len >= index and limit = '1' and algo_i = '1') then
	    mode_b_sel <= mode_seq(index);
	    index := index + 1;
	  end if;
	  index_sim <= index - 1;
	end if;
    end process mode_sel_p;
    
    counter_p: process (clk, sres_counter, update_factor_pulse, algo_i, limit)
    begin
      if clk'event and clk = '1' then
	if (limit = '1' and algo_i = '1') or (sres_counter = '1') or (update_factor_pulse = '1') then
	  counter <= (others => '0');
	elsif (limit = '0' and algo_i = '1') then
	  counter <= counter + 1;
	end if;
      end if;
    end process counter_p;
    
    compare_p: process (counter, factor)
    begin
      if (mode_b_sel and counter+1 = factor) then
	limit <= '1';
      elsif (not mode_b_sel and counter+1 = factor+1) then
	limit <= '1';
      else
	limit <= '0';
      end if;
    end process compare_p;

    prescaled_algo_p: process (clk, algo_i, limit, factor)
    begin
      if clk'event and clk = '0' then 
	if factor = ZERO then
	    prescaled_algo_o <= '0';
	elsif limit = '1' and algo_i = '1' then
	    prescaled_algo_o <= '1';
	else
	    prescaled_algo_o <= '0';
	end if;
      end if;
    end process prescaled_algo_p;   

end architecture rtl;

