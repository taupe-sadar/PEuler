#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;
use POSIX qw/floor/;
use Bezout;
use integer;

# We setup a crible over all integers < n, which values are initialized to 2*n^2 - 1.
# For each prime p, we will divide, all values that are susceptible to be divisible by p.
# Not all primes are dividing integers of the form x = 2*n^2 - 1.
# By trying to solve the modular (in Z/pZ) equation :
#   2*r^2 - 1 = 0 [p]
#   r^2 = 2^(-1) [p]
# Two possibilites : 
#  - 0 solutions and p cannot divide such integer
#  - 2 solutions r1 and r2 with r1 < p/2, r2 > p/2 and p1 + p2 = p ( or r2 = -r1 [p] )
# So in the crible we can divide by p all values whose indexes are (r1 + k*p, r2 + k*p)
#
# Now suppose we iterate along the crible array, founding an integer > 1, at index i.
# It is a product of at least 2 primes (p1 < p2), and i is their residual i = r1 < px/2 ,such that :
#   2*i^2 - 1 = p1 * p2 * k
# But 2*i^2 - 1 < 2*(p1/2)^2 - 1 = p1^2 / 2 - 1 < p1*p2/2 < p1*p2*k.
# So there can be only one new prime remaining.
# Also, if its the first time we visit this integer, it is a new prime.
#
# Optimization : when dividing by a prime p, we must also diving by possible p^n factors.
# It is costy to test a high divisibility by p, but we may anticipate.
# When dividing by p, we have : 
#   2*i^2 - 1 = p * f. 
# That means all integers of the form 
#   A = 2*(i + k*p)^2 - 1 = p*f + 4*i*k*p + k^2*p^2
# A is divisible by p^2 only if 
#   f + 4*i*k = 0 [p]
#   k = -f *(4*i)^-1 [p]
# This optimization should be done only for the lowest primes, as the modular inverse is costy (but done only once)

my($n)=50000000;
my(@crible_residuals)=(0)x($n+1);

my($count_seen_primes)=0;
for(my($i)=2;$i<=$n;$i++)
{

  if($crible_residuals[$i]!=1)
  {
    my($prime)=0;
    if($crible_residuals[$i]==0)
    {
      $count_seen_primes++;
      $prime = 2*($i*$i) - 1;
    }
    else
    {
      $prime = $crible_residuals[$i];
    }
    
    my($residual)=$i;
    # print "$prime : $i\n" if($i < 100);
    my($other_res)=$prime - $i;
    if( $other_res < $n )
    {
      
      if( $prime < $n/100 )
      {
        my($p2)=$prime*$prime;


        my($factor)=(2*($residual*$residual) - 1)/$prime;
        my($inv)=Bezout::znz_inverse(4*$residual,$prime);
        my($residual_steps)= $factor * $inv % $prime;
        $residual_steps = ($residual_steps==0)?0:($prime - $residual_steps);
        init_residuals_2(\@crible_residuals,$prime,$p2,$residual,$residual_steps);

        my($other_factor)= $factor + 2*$prime -4*$residual;
        my($residual_steps_other)= $other_factor * $inv %$prime;
        init_residuals_2(\@crible_residuals,$prime,$p2,$other_res,$residual_steps_other);
      }
      else
      {
        init_residuals(\@crible_residuals,$prime,$i + $prime);
        init_residuals(\@crible_residuals,$prime,$other_res);
      }
    }
  }
}
print $count_seen_primes;


sub init_residuals
{
  my($rcrible,$p,$residual)=@_;

  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
    
    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
}

sub init_residuals_2
{
  my($rcrible,$p,$p2,$residual,$residual_steps)=@_;
   
  for(my($nb)=$residual;$nb <= $#$rcrible;$nb+=$p )
  {
    $$rcrible[$nb] = (2*$nb*$nb - 1) if( $$rcrible[$nb] == 0 );
    $$rcrible[$nb]/=$p;
  }
  
  for(my($nb)=$residual + $residual_steps*$p;$nb <= $#$rcrible;$nb+=$p2 )
  {
    $$rcrible[$nb] /=$p;

    while( $$rcrible[$nb] %$p == 0)
    {
      $$rcrible[$nb] /=$p;
    }
  }
}
