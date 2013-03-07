use strict;
use warnings;
use Data::Dumper;
use Sums;

my($n)=1000-1;
#quotient_of_multiple_of_k_below_1000
my($k3)=int($n/3);
my($k5)=int($n/5);
my($k15)=int($n/15);

my($result)=(3*Sums::int_sum($k3)) + (5*Sums::int_sum($k5)) - (15*Sums::int_sum($k15));
print "$result";
