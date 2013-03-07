use strict;
use warnings;
use Data::Dumper;
use Pythagoriciens;
use Hashtools;

my($max)=1500000;

my($r_pythas)=Pythagoriciens::primitive_triplets_from_perimeter($max);


my($maximum)=0;
my($argmax)=0;
my(%perimeter_hash)=();
for(my($k)=0;$k<= $#$r_pythas;$k++)
{
    my($perimeter)=Pythagoriciens::value_perimeter(@{$$r_pythas[$k]});
    my($limit_k)=$max/$perimeter;
    if( exists($perimeter_hash{$perimeter}) && $perimeter_hash{$perimeter} >= 2)
    {
	next; #pas la peine, tous ses multiples sont deja a 2
    }
    else
    {
	Hashtools::increment(\%perimeter_hash,$perimeter);
    }

    for(my($lamb)=2;$lamb<=$limit_k;$lamb++)
    {
	Hashtools::increment(\%perimeter_hash,$perimeter*$lamb);
    }
}
my($k);
my( $count )=0;
foreach $k (keys(%perimeter_hash))
{
	
    if($perimeter_hash{$k}==1)
    {
	$count++;
    }
    
}
print $count;
