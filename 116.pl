use strict;
use warnings;
use Data::Dumper;
use BlockCounting;

my($size)=50;

my( $red_sequence) = BlockCounting::sequence_blocksize_min_max(2,2);
my( $green_sequence) = BlockCounting::sequence_blocksize_min_max(3,3);
my( $blue_sequence) = BlockCounting::sequence_blocksize_min_max(4,4);

#Removing the solutions with no blocks in the counting
print $red_sequence->calc($size) + $green_sequence->calc(50) + $blue_sequence->calc(50) - 3;
