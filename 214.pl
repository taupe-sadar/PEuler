#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Prime;

# for each number n = prod( p_i^k_i ) we can observe that during 
# the successive iterations of u_k = phi(u_k-1) (u_0 = n), the 
# "quantity of twos" will be decrease by 1
#
# the "generating of 2 function" can be defined as : 
# g(n)= sum( k_i ) * g(phi(p_i)) if n > 2
# g(2) = 1
#
# So the totient chain length until 2 will be 
# ch(n)= 1 + g(n) if n is odd because no decaying of 2 until next step
# ch(n) = g(n)    if n is even since the power of 2 will decay
#
# And the totien chain length until 1 is ch(n) + 1
#
# We use a loop over pows algorithm. It starts looping over powers of 2, then numbers with powers
# of 2 and 3, ... and so on with all powers of primes.
# At each number we store the "generating of 2" function
# At each prime number p, the totient chain length can be found in the array stored in 
# at (p-1)

my($n)=40000000;
my($chain_target)=25;
my(@generated_2)=(0)x($n+1);

my($genrated_2_factor)=0;
my($current_generated_2)=0;
my($sum_generated2)=0;

Prime::pow_loop($n,\&init_generated2,\&incr_generated,\&count_generated);
print $sum_generated2;

sub init_generated2
{
  my($p)=@_;
  $genrated_2_factor = ($p == 2)?1:$generated_2[$p-1];
  $current_generated_2 = $genrated_2_factor;
  
  if( $genrated_2_factor == $chain_target - 2 )
  {
    $sum_generated2 += $p ;
  }
}

sub incr_generated
{
  $current_generated_2 += $genrated_2_factor;
}

sub count_generated
{
  my($nb,$prev,$max_elem)=@_;
  my($generated)=$generated_2[$prev] + $current_generated_2;
  
  $generated_2[$nb] = $generated;
}
