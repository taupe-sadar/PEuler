use strict;
use warnings;
use Data::Dumper;
use Prime;

my($number)=2000000;
my($sum)=0;
my($prime)=0;
Prime::init_crible(2000200);
while($prime<$number)
{
	$sum+=$prime;
	$prime=Prime::next_prime();
	
}

print $sum;
