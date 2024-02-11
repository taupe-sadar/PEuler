#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

# The square number has 19 digits. So its root must have 9 digits.
# more precisely, with the strating number n = sum( a_i*10^i ) = [a0,..,a8]
#
# Easily, we can see than a0 = 0, because the lowest of the square is 0
# so we can focus ont the number n' = [a1,..,a8] which square must match (1_2_3_4_5_6_7_8_9)
#
# we have  10203*10^12 <= n'^2 < 19294*10^12
# so sqrt(10203)*10^6 <= n' < sqrt(19294) *10^6
# This gives low and high bounds for the high part of the number [a7,a8,a9]
#
# Then we can use a backtrack algorithm, looking for the numbers
# [a1,a2], checking if it's matching modulo 100, in range[0,99]
# [a1,..,a4] checking if it's matching modulo 10^4, with [a3,a4] in range[0,99]
# [a1,..,a6] checking if it's matching modulo 10^6, with [a5,a6] in range[0,99]
#
# on deepest iteration, we look if n' equal the asked the number
# but in the range for [a7,a8,a9] defined earlier

my(@incomplete_square)=reverse(split('',"1_2_3_4_5_6_7_8_9"));

my($num_digits)=(scalar(@incomplete_square)-1)/2;
my($min_last_number)=floor(sqrt(10203));
my($max_last_number)=ceil(sqrt(19294));
my(@sols)=try_number(0,0);
die "Not unique_solution ! " if($#sols!=0);
print $sols[0]*10;

sub try_number
{
  my($idx,$current)=@_;

  my(@solutions)=();
  my($pow)=10**$idx;
  if( $idx <= $num_digits-2)
  {
    my($unit_match)=$incomplete_square[$idx];
    my($modulo)=$pow*100;
    
    my($start)=($idx == $num_digits-2)?$min_last_number:0;
    my($end)=($idx == $num_digits-2)?$max_last_number:100;
    
    for(my($n)=$start;$n<$end;$n++)
    {
      my($current_val)=$current + $pow * $n;
      my($square_modulo)=($current_val*$current_val)%$modulo;
      my($couple_digits)=floor($square_modulo/$pow);
      my($t,$d)=(floor($couple_digits/10),$couple_digits%10);
      next if($d != $unit_match);

      push(@solutions,try_number($idx+2,$current_val));
    }
  }
  else
  {
    my($current_squared)=$current*$current;
    my($quotient)=floor($current_squared/$pow);
    my($ok)=1;
    for(my($i)=$idx;$i<=$#incomplete_square;$i+=2)
    {
      if( $incomplete_square[$i] != $quotient%10)
      {
        $ok=0;
        last;
      }
      $quotient = floor($quotient/100);
    }
    push(@solutions,$current) if($ok);
  }
  return @solutions;
}


