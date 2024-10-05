#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;
use List::Util qw/sum/;

# We consider all the numbers that have same number of digits(n), and same sum of number of digits (s)
#     na(n,s) ( numbers whose first digit is in [0;9] )
#     nz(n,s) ( numbers whose first digit is in [1;9] )
# We have, recursively : 
#     na(n,s) = sum_(d=0..9) na(n-1,s - d)
#     nz(n,s) = sum_(d=1..9) na(n-1,s - d)
#
# Also if we consider the sum of numbers having same numbers of digits (n), and same sum of number of digits (s)
#     sa(n,s) ( numbers whose first digit is in [0;9] )
#     sz(n,s) ( numbers whose first digit is in [0;9] )
# We have, recursively : 
#     sa(n,s) = sum_(d=0..9) d*10^(n-1) * na(n-1,s - d) + sa(n-1,s - d)
#     sz(n,s) = sum_(d=1..9) d*10^(n-1) * na(n-1,s - d) + sa(n-1,s - d)
#
# Then the sum balanced numbers, having n numbers can be calculated
#   if n = 2*m if even
#      b(n) = sz(m,s) * na(m,s) * 10^m
#             + sa(m,s) * nz(m,s)
#   if n = 2*m+1 if odd
#      b(n) = sz(m,s) * 10 * na(m,s) * 10^(m+1)
#             + nz(m,s) * 45 * na(m,s) * 10^(m) 
#             + nz(m,s) * 10 * sa(m,s) 

my($n)=47;
my($modulo)=3**15;

my($num_all_numbers)=[1];
my($num_nzero_numbers)=[0];

my($sum_all_numbers)=[0];
my($sum_nzero_numbers)=[0];

my($half)=floor($n/2);

my(@pows_10)=(1);
for(my($i)=1;$i<=($half+1);$i++)
{
  push(@pows_10,10*$pows_10[-1]%$modulo);
}

my(@all_sums)=(0,45);

for(my($ndigits)=1;$ndigits<=$half;$ndigits++)
{
  my(@c_num_all_numbers)=(0)x($#$num_all_numbers+1+9);
  my(@c_num_nzero_numbers)=(0)x($#$num_nzero_numbers+1+9);

  my(@c_sum_all_numbers)=(0)x($#$sum_all_numbers+1+9);
  my(@c_sum_nzero_numbers)=(0)x($#$sum_nzero_numbers+1+9);

  for(my($sum)=0;$sum<=$#$num_all_numbers;$sum++)
  {
    for(my($digit)=0;$digit<=9;$digit++)
    {
      my($digit_sum)=$sum + $digit;
      $c_num_all_numbers[$digit_sum] =   ($c_num_all_numbers[$digit_sum]   + $$num_all_numbers[$sum]) % $modulo;
      $c_num_nzero_numbers[$digit_sum] = ($c_num_nzero_numbers[$digit_sum] + $$num_all_numbers[$sum]) % $modulo if($digit > 0);

      $c_sum_all_numbers[$digit_sum] =   ($c_sum_all_numbers[$digit_sum] + $$sum_all_numbers[$sum]  + $digit*$pows_10[$ndigits-1]*$$num_all_numbers[$sum]) % $modulo;
      $c_sum_nzero_numbers[$digit_sum] = ($c_sum_nzero_numbers[$digit_sum] + $$sum_all_numbers[$sum] + $digit*$pows_10[$ndigits-1]*$$num_all_numbers[$sum]) % $modulo if($digit > 0);
    }
  }

  my($odd_sum)=0;
  my($even_sum)=0;
  
  for(my($sum)=0;$sum <=$#c_num_all_numbers;$sum++)
  {
    my($sum_high)= ($c_sum_nzero_numbers[$sum]* $c_num_all_numbers[$sum])%$modulo;
    my($sum_middle) = ($c_num_nzero_numbers[$sum]* $c_num_all_numbers[$sum])%$modulo;
    my($sum_low) = ($c_num_nzero_numbers[$sum] * $c_sum_all_numbers[$sum])%$modulo;
    
    $odd_sum = ($odd_sum + $sum_high* 10 * $pows_10[$ndigits + 1] + 45*$sum_middle * $pows_10[$ndigits] + $sum_low * 10)%$modulo;
    $even_sum = ($even_sum + $sum_high * $pows_10[$ndigits ] + $sum_low)%$modulo;
  }
  push(@all_sums,$even_sum,$odd_sum);
  
  $num_all_numbers = \@c_num_all_numbers;
  $num_nzero_numbers = \@c_num_nzero_numbers;

  $sum_all_numbers = \@c_sum_all_numbers;
  $sum_nzero_numbers = \@c_sum_nzero_numbers;
}

my($total)=sum(@all_sums[1..47])%$modulo;
print $total;