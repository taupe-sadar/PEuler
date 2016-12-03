use strict;
use warnings;
use Data::Dumper;
use IntegerPartition;

my($needed)=5000;
my($nb_partitions )=0;
my( $integer )=1;
while( $nb_partitions < $needed )
{
    $integer++;
    $nb_partitions = IntegerPartition::prime_partition($integer) - 1;

}

print $integer;
