use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=10**10;
Prime::init_crible(10**6);
my($prime_counter)=1;
my($p)=Prime::next_prime();#Flushing 2 always ...
my($reminder)=2;
while($reminder <= $max )
{
  $p=Prime::next_prime();
  $prime_counter++;
  $reminder=2*$prime_counter*$p;
}

print $prime_counter;