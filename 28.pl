use strict;
use warnings;
use Data::Dumper;
use Sums;

my($side)=1001;

#Easy one :)
my($midside)=int(($side-1)/2);
my($formule)=16*Sums::int_square_sum($midside)+4*($midside+1)+4*Sums::int_sum($midside)-3;
print $formule;
