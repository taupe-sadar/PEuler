use strict;
use warnings;
use Data::Dumper;
use Permutations;

my($max)=100;
my($too_big)=1000000;

my($lowers)=0;
for(my($n)=0;$n<=$max;$n++)
{
    my($middle)=int(($n+1)/2);
    for(my($k)=0;$k<=$middle;$k++)
    {
	my($number)=Permutations::cnk($n,$k);
	if($number>$too_big)
	{
	    $lowers+=2*$k;
	    last;
	}
	elsif($k==$middle)
	{
	    $lowers+=$n+1;
	}
    }  
}
my($biggers)=($max+1)*($max+2)/2-$lowers;
print $biggers;
