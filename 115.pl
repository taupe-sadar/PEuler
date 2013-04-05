use strict;
use warnings;
use Data::Dumper;
use BlockCounting;


my($thresold)=10**6;

my( $sequence) = BlockCounting::sequence_blocksize_min( 51 );

my( $index ) = 51;

while( $sequence->calc($index) <= $thresold )
{
  $index++;
}

print ($index - 1 );
 
