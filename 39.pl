use strict;
use warnings;
use Data::Dumper;
use Pythagoriciens;
use Hashtools;

my($max)=1000;

my($r_pythas)=Pythagoriciens::primitive_triplets_from_perimeter($max);

my($maximum)=0;
my($argmax)=0;
my(%perimeter_hash)=();
for(my($k)=0;$k<= $#$r_pythas;$k++)
{
    my($perimeter)=Pythagoriciens::value_perimeter(@{$$r_pythas[$k]});
    my($limit_k)=$max/$perimeter;
    for(my($lamb)=1;$lamb<=$limit_k;$lamb++)
    {
	Hashtools::increment(\%perimeter_hash,$perimeter*$lamb);
    }
}
my($k);
foreach $k (keys(%perimeter_hash))
{
	
    if($perimeter_hash{$k}>$maximum)
    {
	$maximum=$perimeter_hash{$k};
	$argmax=$k;
    }
    
}
print $argmax;
