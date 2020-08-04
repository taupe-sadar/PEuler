use strict;
use warnings;
use Data::Dumper;
use Prime;

my($number)=10001;
my($count)=0;
my($prime)=1;
Prime::init_crible(5000);
while($count<$number)
{
  $prime=Prime::next_prime();
  $count++;
}

print $prime;
