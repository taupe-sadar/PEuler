#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/floor/;

# The function f(x)= 2^( C - x^2 )  ( C = 30.403243784 - log2(10^9) =~ 0.5059 = log2(1.42) )
#     has only one fixed point x_0 in [sqrt(C) ; 1], value is around 0.855255964
#
# but  | un+1 - x_0 | = | 2^( C - x_0^2 ))* ( -1 + 2^( x_0^2 - un^2 )) |
#                                               = x_0 * | 2*ln(2)* x_0 * ( un - x_0) | + o(un - x_0)
# and x_0^2 * 2 * ln(2) =~ 1.014 > 1, x_0 is not stable
#
# With g(x) = f(f(x)), the fixed points for g(x) are : 
#      x_1 < x_0 < x_2,
#      x_1 = 0.681176
#      x_2 = 1.02946
#  and f(x_1) = x_2
#  and f(x_2) = x_1
#
#  So its an alternative sequence, and one can verify that it converge quickly

my($un_odd,$un_even)=(0,-1);
my($coeff)=30.403243784;
my($scale)=10**9;

while(1)
{
  my($odd)=f($un_even);
  my($even)=f($odd);
  last if($odd == $un_odd && $un_even == $even);
  ($un_odd,$un_even)=($odd,$even);
}

print ($un_odd+$un_even);

sub f
{
  my($x)=@_;
  return floor(2**($coeff-$x*$x))/$scale;
}