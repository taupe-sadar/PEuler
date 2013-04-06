use strict;
use warnings;
use Data::Dumper;
use BlockCounting;

my($size)=50;

my( $red_blue_green_sequence) = BlockCounting::sequence_blocksize_min_max(2,4);

print $red_blue_green_sequence->calc($size);
