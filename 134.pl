use strict;
use warnings;
use Data::Dumper;
use Bezout;
use Prime;
use SmartMult;
use Math::BigInt;

my($max)=10**6;

Prime::init_crible( $max+500 );
Prime::next_prime();# flushing 2


my($p1 ) = Prime::next_prime();# flushing 3; 
my($p2 ) = Prime::next_prime();

my($sum)=Math::BigInt->new(0);

while( $p1 <= $max )
{
  ( $p1,$p2 ) = ( $p2 , Prime::next_prime() );
  my( $decimal_exponent ) = length( $p1 );
  my( $inverse ) = Bezout::znz_inverse( 10**$decimal_exponent, $p2 );
  my( $first_digits ) = (-$p1* $inverse)% $p2;
  
  $sum+= "$first_digits$p1";
}
print $sum;
