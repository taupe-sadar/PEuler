use strict;
use warnings;
use Data::Dumper;
use Sequence;

my( $seq ) = Sequence->new([1,1],[1,0]);

print $seq->calc(100);
