use strict;
use warnings;
use Data::Dumper;
use Prime;

# If (a) is a cathetus, a^2 + b^2 = c^2
#
#   a^2 = (c - b) (c+b), with d1 = c+b, d2 = c-b
#
# this gives a solution for(c,b) iff d1,d2 are both even, or both odd, and d1 > d2
# if b = prod(pi^ki), b^2 = prod(pi^2*ki).
#
# The numbers of solutions are : 
#  - if all factors are odd, then (prod(2*ki + 1) - 1)/2
#  - if 2 is part of factors, then (prod(2*ki + 1) - 1)/2 - prod(2*k2 + 1)*2 
#                                = (prod(2*ki + 1)* (2*k2 + 1) - 1)/2
#
# Then all we need is associate larger exposants to smaller primes numbers, for having the smaller solution


my($num_cathetus)=47547;

Prime::init_crible(100000);
my(%dec)=Prime::decompose(2*$num_cathetus+1);
Prime::init_crible(100000);

my($prod)=1;
foreach my $p (sort( {$b <=> $a} keys(%dec)))
{
  for(my($a)=0;$a<$dec{$p};$a++)
  {
    my($prime)=Prime::next_prime();
    my($exp) = ($prime == 2)?(($p+1)/2):(($p-1)/2);
    $prod *= $prime**$exp;
  }
}

print $prod;

