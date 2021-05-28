
-- Description:
-- LUTs for mode sequences

-- Version-history:
-- HB 2019-06-12: first design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package algo_pre_scaler_fractional_pkg is
-- HB 2019-06-12: inserted for fractional prescaler mode sequence length (valid values: 10, 20 or 100 for fractional and 1 for integer [less resources])
  constant PRESCALER_MODE_SEQ_LEN : natural := 10;

-- Mode sequence LUTs
-- prescale value precision 2, steps 0.05
  constant max_mode_len_20 : natural := 20;
  constant mode_seq_lut_len_20 : natural := max_mode_len_20;
  
  type mode_record_20 is record
      length : natural;
      mode : std_logic_vector(0 to max_mode_len_20-1);
  end record mode_record_20;
  type mode_seq_lut_20_array is array (0 to mode_seq_lut_len_20-1) of mode_record_20;

  constant MODE_SEQ_LUT_20 : mode_seq_lut_20_array := (
    (  1, X"80000"), -- .00
    ( 20, X"7ffff"), -- .05
--     (100, X"7feffdffbff7feffdffbff7ff"), -- .10  ??????
    ( 20, X"7feff"), -- .10 truncated mode sequence for tests
    ( 20, X"7dfbf"), -- .15
    (  5, X"78000"), -- .20
    (  4, X"70000"), -- .25
    ( 10, X"6dc00"), -- .30
    ( 20, X"5b6db"), -- .35
    (  5, X"58000"), -- .40
    ( 20, X"556ab"), -- .45
    (  2, X"40000"), -- .50
    ( 20, X"2a955"), -- .55
    (  5, X"28000"), -- .60
    ( 20, X"24925"), -- .65
    ( 10, X"12400"), -- .70
    (  4, X"10000"), -- .75
    (  5, X"08000"), -- .80
    ( 20, X"02041"), -- .85
    ( 10, X"00400"), -- .90
    ( 20, X"00001")  -- .95
  );

-- prescale value precision 1, steps 0.1
  constant max_mode_len_10 : natural := 10;
  constant mode_seq_lut_len_10 : natural := max_mode_len_10;
  
  type mode_record_10 is record
      length : natural;
      mode : std_logic_vector(0 to max_mode_len_10-1);
  end record mode_record_10;
  type mode_seq_lut_10_array is array (0 to mode_seq_lut_len_10-1) of mode_record_10;

  constant MODE_SEQ_LUT_10 : mode_seq_lut_10_array:= (
    ( 1, "1000000000"), -- .0
    (10, "0111111111"), -- .1
    ( 5, "0111100000"), -- .2
    (10, "0110110111"), -- .3
    ( 5, "0101100000"), -- .4
    ( 2, "0100000000"), -- .5
    ( 5, "0010100000"), -- .6
    (10, "0001001001"), -- .7
    ( 5, "0000100000"), -- .8
    (10, "0000000001")  -- .9
  );

-- prescale value precision 2, steps 0.01
  constant max_mode_len_100 : natural := 100;
  constant mode_seq_lut_len_100 : natural := max_mode_len_100;
  
  type mode_record_100 is record
      length : natural;
      mode : std_logic_vector(0 to max_mode_len_100-1);
  end record mode_record_100;
  type mode_seq_lut_100_array is array (0 to mode_seq_lut_len_100-1) of mode_record_100;

  constant MODE_SEQ_LUT_100 : mode_seq_lut_100_array := (
    (  1, X"8000000000000000000000000"), -- .00
    (100, X"7ffffffffffffffffffffffff"), -- .01
    (100, X"7ffffffffffffffffffffffff"), -- .02
    (100, X"7fffffffbfffffffdffffffff"), -- .03
    ( 25, X"7fffff8000000000000000000"), -- .04
    ( 20, X"7ffff00000000000000000000"), -- .05
    ( 20, X"7ffff00000000000000000000"), -- .06
    (100, X"7ffdfff7ffdfffbffefffbfff"), -- .07
    ( 25, X"7ff7ff8000000000000000000"), -- .08
    (100, X"7feffdffbff7feffdffbff7ff"), -- .09
    (100, X"7feffdffbff7feffdffbff7ff"), -- .10
    (100, X"7fbfdfeff7fbfdfeff7fbfdff"), -- .11
    ( 25, X"7f7f7f8000000000000000000"), -- .12
    (100, X"7efefefdfdfdfbfbfbf7f7f7f"), -- .13
    ( 50, X"7efdfbf7efdfc000000000000"), -- .14
    ( 20, X"7dfbf00000000000000000000"), -- .15
    ( 25, X"7df7df8000000000000000000"), -- .16
    (100, X"7befbefbefbef7df7df7df7df"), -- .17
    ( 50, X"7bef7defbdf7c000000000000"), -- .18
    (100, X"7bdefbdef7def7bef7bdf7bdf"), -- .19
    (  5, X"7800000000000000000000000"), -- .20
    (100, X"77bdeef7bddef7bbdef77bdef"), -- .21
    ( 50, X"77bbddeef77bc000000000000"), -- .22
    (100, X"777bbbdddeeef777bbbdddeef"), -- .23
    ( 25, X"7777778000000000000000000"), -- .24
    (  4, X"7000000000000000000000000"), -- .25
    ( 50, X"6eeeeeddddddc000000000000"), -- .26
    (100, X"6eedddbbbb776eeddddbbb777"), -- .27
    ( 25, X"6eddbb8000000000000000000"), -- .28
    (100, X"6ddbb76edbb76eddb76eddbb7"), -- .29
    ( 10, X"6dc0000000000000000000000"), -- .30
    (100, X"6db76dbb6dbb6ddb6ddb6edb7"), -- .31
    ( 25, X"6db6db8000000000000000000"), -- .32
    (100, X"6db6db6db6db6db6db6db6db7"), -- .33
    ( 50, X"5b6db6db6db6c000000000000"), -- .34
    ( 20, X"5b6db00000000000000000000"), -- .35
    ( 25, X"5b6b6d8000000000000000000"), -- .36
    (100, X"5b5b5b6b6b6b6d6d6d6dadadb"), -- .37
    ( 50, X"5adadad6d6d6c000000000000"), -- .38
    (100, X"5ad6b6b5adad6b5b5ad6d6b5b"), -- .39
    (  5, X"5800000000000000000000000"), -- .40
    (100, X"56b5ab5ad6ad6b56b5ad5ad6b"), -- .41
    ( 50, X"56ad6ad5ad5ac000000000000"), -- .42
    (100, X"55ab56ad5ab56ad5ab56ad5ab"), -- .43
    ( 25, X"55aad58000000000000000000"), -- .44
    ( 20, X"556ab00000000000000000000"), -- .45
    ( 50, X"555aaad556aac000000000000"), -- .46
    (100, X"5555aaaad5556aaab5555aaab"), -- .47
    ( 25, X"5555558000000000000000000"), -- .48
    (100, X"5555555555556aaaaaaaaaaab"), -- .49
    (  2, X"4000000000000000000000000"), -- .50
    (100, X"2aaaaaaaaaaa9555555555555"), -- .51
    ( 25, X"2aaaaa8000000000000000000"), -- .52
    (100, X"2aaa55552aaa95554aaaa5555"), -- .53
    ( 50, X"2aa5552aa9554000000000000"), -- .54
    ( 20, X"2a95500000000000000000000"), -- .55
    ( 25, X"2a552a8000000000000000000"), -- .56
    (100, X"2a54a952a54a952a54a952a55"), -- .57
    ( 50, X"2952952a52a54000000000000"), -- .58
    (100, X"294a54a5295294a94a52a5295"), -- .59
    (  5, X"2800000000000000000000000"), -- .60
    (100, X"2529494a525294a4a529294a5"), -- .61
    ( 50, X"2525252929294000000000000"), -- .62
    (100, X"24a4a49494949292929252525"), -- .63
    ( 25, X"2494928000000000000000000"), -- .64
    ( 20, X"2492500000000000000000000"), -- .65
    ( 50, X"2492492492494000000000000"), -- .66
    (100, X"1249249249249249249249249"), -- .67
    ( 25, X"1249248000000000000000000"), -- .68
    (100, X"1248924492449224922491249"), -- .69
    ( 10, X"1240000000000000000000000"), -- .70
    (100, X"1224489124489122489122449"), -- .71
    ( 25, X"1122448000000000000000000"), -- .72
    (100, X"1112224444889112222444889"), -- .73
    ( 50, X"1111112222224000000000000"), -- .74
    (  4, X"1000000000000000000000000"), -- .75
    ( 25, X"0888888000000000000000000"), -- .76
    (100, X"0884442221110888444222111"), -- .77
    ( 50, X"0844221108844000000000000"), -- .78
    (100, X"0842110842210844210884211"), -- .79
    (  5, X"0800000000000000000000000"), -- .80
    (100, X"0421042108210841084208421"), -- .81
    ( 50, X"0410821042084000000000000"), -- .82
    (100, X"0410410410410820820820821"), -- .83
    ( 25, X"0208208000000000000000000"), -- .84
    ( 20, X"0204100000000000000000000"), -- .85
    ( 50, X"0102040810204000000000000"), -- .86
    (100, X"0101010202020404040808081"), -- .87
    ( 25, X"0080808000000000000000000"), -- .88
    (100, X"0040201008040201008040201"), -- .89
    ( 10, X"0040000000000000000000000"), -- .90
    (100, X"0010020040080100200400801"), -- .91
    ( 25, X"0008008000000000000000000"), -- .92
    (100, X"0002000800200040010004001"), -- .93
    ( 50, X"0000800040004000000000000"), -- .94
    ( 20, X"0000100000000000000000000"), -- .95
    ( 25, X"0000008000000000000000000"), -- .96
    (100, X"0000000040000000200000001"), -- .97
    ( 50, X"0000000000004000000000000"), -- .98
    (100, X"0000000000000000000000001")  -- .99
  );

end package;
