use strict;
use warnings;
use Data::Dumper;
use Sums;

my($max)= 1000;

my($sol)= Sums::int_square_sum( $max) - 4 -1 - ( Sums::int_sum( $max) - 2 - 1 + 2*Sums::int_sum( $max/2) -2 );

print $sol;
