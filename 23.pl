use strict;
use warnings;
use Data::Dumper;
use Divisors;

my($max)=28123;
my($sum)=0;


Divisors::calc_all_until($max);
my($i,$j);
my(@BIGTAB);
my(@crible);
for($i=1;$i<$max;$i++)
{
	my($ab)=Divisors::get_sum_prop_div($i);
	if($ab>$i)
	{
		push(@BIGTAB,$i);
		for($j=0;$j<=$#BIGTAB;$j++)
		{
			my($s)=$BIGTAB[$j]+$i;
			if($s>=$max)
			{
				last;
			}
			$crible[$BIGTAB[$j]+$i]=1;
		}
	}
}
for($i=0;$i<$max;$i++)
{
	if(!defined($crible[$i]))
	{
		$sum+=$i;
	}
}

print $sum;
