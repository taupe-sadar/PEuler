use strict;
use warnings;
use Data::Dumper;
use Prime;
use Sums;

# Storing n primes (p_i) until sqrt(max) : thats n*(n+1)/2 semiprimes
# Then, for each pi, there is prime bound (q_j) such that 
#    q_j * p_i < max, and q_(j+1) * p_i > max
#    that counts for i+1 *(number of primes in [q-j-1 , q_j]

my($max)=10**8;
Prime::init_crible($max+1000);
my(@primes)=();
my($p)=0;
my($middle)=sqrt($max);
while(($p=Prime::next_prime()) < $middle)
{
  push(@primes,$p);
}

my($count)=Sums::int_sum($#primes+1);
my($current_idx)=$#primes;

while($current_idx>=0)
{
  my($next_bound)=$max/$primes[$current_idx];
  while( $p < $next_bound)
  {
    $count += $current_idx+1;
    $p = Prime::next_prime();
  }
  
  $current_idx--;
}

print $count;
