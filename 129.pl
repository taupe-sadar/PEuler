use strict;
use warnings;
use Data::Dumper;
use Prime;
use Repunit;
use POSIX qw/floor ceil/;

my( $max ) = 10**6;

my( $max_for_simple_candidate ) = $max + floor( ( 1 +sqrt( 1 + 4*$max ) )/2 );
my($result)=0;
for( my($candidate)=$max+1; $candidate< $max_for_simple_candidate; $candidate +=2 )
{
  next unless( Prime::fast_is_prime( $candidate ) );
  if( Repunit::group_unity_order( $candidate ) > $max )
  {
    $result = $candidate;
    last;
  }
}

print $result;
