#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use EulerTotient;

# First, instead of counting the reflexions, we duplicate the triangles in order
# to represent the reflexions of points A,B,C
#  (y) / \ / \ / \ / \ /
#     A---B---C---A---B---
#    / \ / \ / \ / \ /
#   B---C---A---B---C---
#  / \ / \ / \ / \ /
# C---A---B---C---A---   (x)
#
# The number of reflexions from (0,0) to (x,y) is 
#   S = 2*x + 2*y - 3
# The point (x,y) is a C reflexion if and only if x - y = 0 mod 3, x = 3k + y for some k
#   S = 6*k + 4*y - 3
#   n = (S + 3)/2 = 3*k + 2*y
# It is also a valid reflexion only if pgcd(x,y)=1
#
# let b =-1/0/1 if( p%3 = 1/2/0 ) (if b=0, then x,y are both multiple of 3, so there are no solutions)
# and a = (S - 2b)/3
# The valid points are then :
#   y = b + 3w
#   (k = a - 2w)
#   x = b + 3(a-w)
# We are interested in the number of valid w, such that x>0 and y>0
# depending on b :      b=-1 [a-1,1], b=1 [a,0]
# so the num_values m : b=-1   (a-1), b=1   (a+1)
#
# We must then substract all values which are multiple of a single prime,
# But then re-add all values which are multiple of factior of 2 primes,
# And so on ...
# 
# Then we have
#   m = (sum_(d|n) last(d) - first(d) + 1)/3
# where first(d) and last(d) are the first/last multiple of d of the form b + 3w
# in all 4 cases {d%3 =1 or 2 }x{b = -1 or 1}, we have
#   last(d) - first(d) = n/d - 3d + b*(d3) (d3 = -1/1 if d%3=1/2)
# so : 
#   m = (sum_(d|n) mu(d) * (n/d + b*(d3)))/3, mu(d) being the moebius function, sumed from all divisors of n
#   m = (phi(n) + b * sum_(d|n) mu(d)*d3)/3
#
# The second term sum, can calculated with the 3-congruence of all dinstinct primes of n.
# Lets say, n  has (k) primes 1%3, and (l) primes 2%3
#   sum_(d|n) mu(d)*d3 = sum_i C_ki (-1)^i * sum_j C_lj (-1)^j * (-1)^j
#                      = (2^l) if k = 0, (0) otherwise

# my($S)=11;
# my($S)=1000001;
my($S)=12017639147;

my($n)=($S+3)/2;

my($parity)=$n%3;

my($count)=0;
if( $parity != 0 )
{
  my(%dec)=Prime::decompose($n);
  my($num_1mod3)=0;
  my($num_2mod3)=0;
  foreach my $p (keys(%dec))
  {
    if($p%3==1)
    {
      $num_1mod3 ++;
    }
    else
    {
      $num_2mod3 ++;
    }
  }
  my($extra)=($num_1mod3==0)?(1<<$num_2mod3):0;
  $count= 1/3*(EulerTotient::phi($n) + ($parity==1?(-1):1)*($extra));
}

print $count;
