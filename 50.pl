use strict;
use warnings;
use Data::Dumper;
use Prime;

my($max)=1000000;

#Determine max number of terms;
Prime::init_crible(20000);
my($sum)=0;
my($max_primes)=0;
while($sum<$max)
{
    $sum+=Prime::next_prime();
    $max_primes++;
}
my($terms);
for($terms=$max_primes-1;$terms>0;$terms--)
{
    if($terms%2)
    {
	Prime::reset_prime_index(0);
	Prime::reset_prime_index(1);
	Prime::next_prime(0);
	Prime::next_prime(1);#on elimine 2
	$sum=0;
	#On remplit la somme une premiere fois
	for(my($b)=0;$b<$terms;$b++)
	{
	    my($p)=Prime::next_prime(0);
	    $sum+=$p;
	}
	my($stop)=0;
	while($sum<$max)
	{
	    if(Prime::fast_is_prime($sum))
	    {
		$stop=1;
		last;
	    }
	    my($p1,$p2)=(Prime::next_prime(0),Prime::next_prime(1));
	    $sum+=$p1-$p2;
	    
	}
	if($stop)
	{
	    last;
	}
    }
    else
    {
	Prime::reset_prime_index(0);
	$sum=0;
	for(my($b)=0;$b<$terms;$b++)
	{
	    $sum+=Prime::next_prime(0);
	}
	if(Prime::fast_is_prime($sum))
	{
	   last; 
	}
    }
    
}

print "$sum";
