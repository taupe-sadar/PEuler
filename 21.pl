use strict;
use warnings;
use Data::Dumper;
use Divisors;


my($max)=10000;
Divisors::calc_all_until($max);
my($n);
my($sum)=0;
for($n=2;$n<$max;$n++)
{
	my($amicable)=Divisors::get_sum_prop_div($n);
	if( $amicable >= $max)
	{
	    next;
	}
	my($ami)=Divisors::get_sum_prop_div($amicable);
	if(($ami==$n) && ($n!=$amicable))
	{
		$sum+=$n;
	}
	
}

print $sum;
