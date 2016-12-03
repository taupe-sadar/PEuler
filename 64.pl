use strict;
use warnings;
use Data::Dumper;
use Hashtools;
use ContinueFraction;

my($max)=10000;

my(%hash_square)=();
my(%sum_of_squares)=();
my($n)=1;
my($square)=1;
while($square<=$max)
{
    Hashtools::increment(\%hash_square,$square);
    $n++;
    $square=$n**2;
}
my(@keys)= sort({$a<=>$b} (keys %hash_square));

for(my($i)=0;$i<=$#keys;$i++)
{
    for(my($j)=$i;$j<=$#keys;$j++)
    {
	my($sum)=$keys[$i]+$keys[$j];
	if($sum > $max)
	{
	    last;
	}
	if(exists($hash_square{$sum}))
	{
	    next;
	}
	Hashtools::increment(\%sum_of_squares,$sum);
    }
}

my($key);
my($count)=0;
foreach $key (keys(%sum_of_squares))
{
    my($period)=ContinueFraction::period_frac_cont($key);
    if($period%2)
    {
	$count++;
    }
    
}

print $count;

