use strict;
use warnings;
use Prime;
use Data::Dumper;

# Which are n,p, with p prime, n integer such that 
# n^2 * ( n + p ) is a cube ?
# The firsy thing to note is that n must be a cube.
# This may be proven considering any p-valuation of n.
# Then we have n = n'^3, 
# c^3 = n^2 * ( n + p )
# c'^3 = c^3/ n'^6 = n'^3 + p 
# we mus thave c' = n' +1, else p cannot be prime.
# Then the possible p are the 3*a^2 + 3*a + 1, a integer.

my($max)=10**6;

Prime::init_crible(50000);
my($count)=0;

my($cubic_root_n)=1;
my($p)=3*$cubic_root_n**2 + 3*$cubic_root_n + 1 ;

while( $p < $max )
{
  if( Prime::fast_is_prime( $p ))
  {
    $count ++;
  }

   
  $p += 6*( $cubic_root_n + 1 );
  $cubic_root_n++;
  
}

print $count;
