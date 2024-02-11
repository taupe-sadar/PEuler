#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

# With x = 2^t, the equation is x^2 - x -k = 0
# The positive solution is x = (1+sqrt(1+4k))/2
# It is an integer only if k = n^2 + n, n >= 1, then x = n+1
#
# So the number of partitions p = n = x - 1 = floor((-1+sqrt(1+4k))/2)
# and will ahve the same value in range [k=n^2 + n; (n+1)^2 + (n+1) - 1]
#
# The partition is perfect if t, is an integer, that means x = n+1 = 2^t is a power of 2
# So the number of perfect partitions pf = t = log2(n+1)
# and will have the same values in the range [n+1 = 2^t ; 2^(t+1) - 1] (starts with t=1, n=1)
#
# First we must determine the first value of t such that pf/p < 1/M (M is an integer)
# This will be for the first partitioning p = 2^(t+1)-1 (last one having pf = t), 
# verifying pf/p < bound, ie, 2^(t+1)-1 >= t * M
#
# Next we can deduce that 
# for p = t * M, we will have pf/p = 1/M
# for p = t * M + 1, we will have pf/p < 1/M for the lowest integer k

my($min_denom)=12345;
my($n)=1;
while((2**($n+1) - 1) < $min_denom*$n)
{
  $n++;
}

my($pm)=$min_denom*$n+1;
my($k)=$pm*($pm+1);

print $k;

