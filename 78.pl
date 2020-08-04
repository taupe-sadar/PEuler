use strict;
use warnings;
use Data::Dumper;
use IntegerPartition;

my($solution)=1;
my($n)=0;

while($solution > 0)
{
  $n++;
  $solution  = IntegerPartition::partition($n,1000000 );
}
print $n;
