use strict;
use warnings;
use Data::Dumper;
use Prime;
use Gcd;
use Repunit;
use POSIX qw/floor ceil/;

# The number k = A(n), which is the first k such that n | R( k )
# is in reality the order of 10 in the unity group Z/9nZ.
# if n = 3^k * P (with p without 3 factors ), the order becomes :
# ppcm( order of 10 in Z/PZ, order of 10 in Z/3^(k+2)Z )
# and order of 10 in Z/3^(k+2)Z = 3^k.

my( $max ) = 10**6;

my( $max_for_simple_candidate ) = $max + floor( ( 1 +sqrt( 1 + 4*$max ) )/2 );
my($result)=0;
for( my($candidate)=$max+1; $candidate< $max_for_simple_candidate; $candidate +=2 )
{
  my($factor_3)=1;
  my($num)= $candidate;
  while( $num %3 == 0 )
  {
    $num/=3;
    $factor_3*=3;
  }

  next unless( Prime::fast_is_prime( $candidate/$factor_3 ) );
  if( Gcd::ppcm(Repunit::group_unity_order( $candidate/$factor_3 ),$factor_3)  > $max )
  {
    $result = $candidate;
    last;
  }
}

print $result;
