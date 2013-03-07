use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=20;
Prime::init_crible(30);
my($prime)=0;
my($big_number)=1;
while($prime<=$max)
{
	$prime=Prime::next_prime();
	my($power)=1;
	while($power<=$max)
	{
		$power*=$prime;
	}
	$big_number*=$power/$prime;
}

print $big_number;