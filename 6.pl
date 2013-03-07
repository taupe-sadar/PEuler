use strict;
use warnings;
use Data::Dumper;
use Sums;

my($max)=100;
my($sum)=Sums::int_sum($max);
print abs(Sums::int_square_sum($max) - $sum*$sum);

