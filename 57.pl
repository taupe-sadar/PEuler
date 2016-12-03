use strict;
use warnings;
use Data::Dumper;
use bigint;

my($max)=1000;
my($a)=1;
my($b)=1;
my($count)=0;
for(my($i)=1;$i<=$max;$i++)
{
    $b+=$a;
    $a=2*$b-$a;
    if(length($a)>length($b))
    {
	$count++;
    }
    
}

print $count;
