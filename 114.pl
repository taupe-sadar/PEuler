use strict;
use warnings;
use Data::Dumper;
use BlockCounting;

my( $sequence) = BlockCounting::sequence_blocksize_min(4);

print $sequence->calc(51);

