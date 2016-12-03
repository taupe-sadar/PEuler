use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=10**10;
Prime::init_crible(10**6);
my($prime_counter)=1;
my($p)=Prime::next_prime();#Flushing 2 always ...
my($remainder)=2;
while($remainder <= $max )
{
  # Skipping even values of prime_counter, leading to
  # a remainder = 2
  $p=Prime::next_prime();
  $p=Prime::next_prime();
  $prime_counter+=2;
   
  $remainder=2*$prime_counter*$p;
}

print $prime_counter;
