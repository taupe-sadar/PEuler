use strict;
use warnings;
use Data::Dumper;
use Gcd;

my($limit)= 10**12;
my($a,$b,$r);

for( $b = 1; $b<100; $b++ )
{
  my($b2)= $b**2;
  for( $a = $b2 + 1; $a < 10000; $a++ )
  {
    $r =1 ;
    my($a3)=$a**3;
    my($nn2);
    while(1)
    {
      my($r2)=$r**2;
      my($n2) = $a3 * $r2 + $b2;
      
      $nn2 = $n2*$b2*$r2;
      last if( $nn2 > $limit);
      if( !(sqrt($n2) =~m/\./ ) )
      {
        my($n)= $b*$r*sqrt( $n2);
        my($r0)= $r2*$b2*$b2;
        my($q)= ( $a * $r0 ) / $b2;
        my($d) = ( $q * $a ) / $b2;
        print "b : $b, a : $a, r : $r -> $n^2 = $r0 + $q * $d \n";
        
      }
      $r++;    
    }
  }
}