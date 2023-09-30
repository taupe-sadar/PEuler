#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor ceil/;

# Instead of counting all number with no square until (n),
# we count all numbers containing square divisors (m^2). Counting all (m) until sqrt(n)
# If m = p is prime, there is floor(n/p^2) numbers multiple of p^2
# But considering m = (p1 and p2), primes there are floor(n/p1^2) + floor(n/p1^2) - floor(n/p1^2)
# that are multiple of p1 or p2
# More generally we must consider all integers in [1;floor(sqrt(n))], which are square free, ie
# m = p1* ..* pk
# And count (-1)^(k+1) * floor(n/m^2)
#
# For knowing that value (-1)^(k+1) we use crible whiche values are : 
# -1 : its a square dont use it
#  0 : its a prime : increment all its multiples
#  k : its a number divisible by k non square primes
#
# Note : there is an optimisation : the crible contains only numbers of the form 6*n +1 and 6*n+5
# It speeds up the algorithms. Multiples of 2 3 6, are treated seperately

my($max)=2**50;
my($max_sq2)=floor(sqrt($max));

my($crible_size)=ceil(($max_sq2+1)/6)*2;
my(@crible)=(0)x$crible_size;

my($num_squared)=0;

my($p)=5;
for(my($i)=1;$i<$crible_size;$i++)
{
  if( $crible[$i] == -1)
  {
    $p+=($i%2==0)?4:2;
    next;
  }
  
  my($p2)=$p*$p;
  if( $crible[$i] == 0)
  {
    #remove squares
    
    for(my($square_idx)=($p2-1)/3;$square_idx<=$#crible;$square_idx+=2*$p2)
    {
      $crible[$square_idx]=-1;
    }
    
    for(my($square_idx)=(5*$p2-2)/3;$square_idx<=$#crible;$square_idx+=2*$p2)
    {
      $crible[$square_idx]=-1;
    }

    #remember p multiples
    my($doublep)=2*$p;
    my($modp)=$p%3;
    for(my($pidx)=($p - $modp)/3;$pidx<=$#crible;$pidx+=$doublep)
    {
      $crible[$pidx]++ if( $crible[$pidx] != -1);
    }
    for(my($pidx)=(5*$p + $modp)/3 - 1;$pidx<=$#crible;$pidx+=$doublep)
    {
      $crible[$pidx]++ if( $crible[$pidx] != -1);
    }
  }

  #count squared
  my($sign)=(($crible[$i]%2==0)?-1:1);
  $num_squared += $sign*floor($max/$p2);
  $num_squared -= $sign*floor($max/$p2/4);
  $num_squared -= $sign*floor($max/$p2/9);
  $num_squared += $sign*floor($max/$p2/36);

  $p+=($i%2==0)?4:2;
}
$num_squared += floor($max/4);
$num_squared += floor($max/9);
$num_squared -= floor($max/36);

print ($max - $num_squared);
