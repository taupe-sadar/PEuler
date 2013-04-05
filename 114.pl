use strict;
use warnings;
use Data::Dumper;
use Sequence;


my( $sequence) = Sequence->new([2,-1,0,1],[1,1,1,1]);

print $sequence->calc(51);

