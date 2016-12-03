use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use List::Util qw( sum );
use ContinueFraction;

my($max)=100;

my(@list)=(2);
for(my($i)=1;$i<$max;$i++)
{
    $list[$i]= (($i%3)==2)?(($i-2)/3*2+2):1;
}
my($hm1,$hm2) = ContinueFraction::get_reduites( @list );
my($somme)=sum(split(//,"$hm1"));

print $somme;
